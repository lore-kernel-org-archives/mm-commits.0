From: akpm@linux-foundation.org
Subject: + mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch added to -mm tree
Date: Tue, 06 Nov 2012 13:27:49 -0800
Message-ID: <20121106212749.D85C15C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:62443 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2KFV1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 16:27:53 -0500
Received: by mail-lb0-f202.google.com with SMTP id l12so66568lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 13:27:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
has been added to the -mm tree.  Its filename is
     mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB

There was some desire in large applications using MAP_HUGETLB/SHM_HUGETLB
to use 1GB huge pages on some mappings, and stay with 2MB on others.  This
is useful together with NUMA policy: use 2MB interleaving on some
mappings, but 1GB on local mappings.

This patch extends the IPC/SHM syscall interfaces slightly to allow
specifying the page size.

It borrows some upper bits in the existing flag arguments and allows
encoding the log of the desired page size in addition to the *_HUGETLB
flag.  When 0 is specified the default size is used, this makes the change
fully compatible.

Extending the internal hugetlb code to handle this is straight forward. 
Instead of a single mount it just keeps an array of them and selects the
right mount based on the specified page size.  When no page size is
specified it uses the mount of the default page size.

The change is not visible in /proc/mounts because internal mounts don't
appear there.  It also has very little overhead: the additional mounts
just consume a super block, but not more memory when not used.

I also exported the new flags to the user headers (they were previously
under __KERNEL__).  Right now only symbols for x86 and some other
architecture for 1GB and 2MB are defined.  The interface should already
work for all other architectures though.  Only architectures that define
multiple hugetlb sizes actually need it (that is currently x86, tile,
powerpc).  However tile and powerpc have user configurable hugetlb sizes,
so it's not easy to add defines.  A program on those architectures would
need to query sysfs and use the appropiate log2.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/mman.h     |    3 +
 fs/hugetlbfs/inode.c            |   66 +++++++++++++++++++++++-------
 include/linux/hugetlb.h         |    7 ++-
 include/linux/shm.h             |   19 ++++++++
 include/uapi/asm-generic/mman.h |   13 +++++
 ipc/shm.c                       |    3 -
 mm/mmap.c                       |    5 +-
 7 files changed, 97 insertions(+), 19 deletions(-)

diff -puN arch/x86/include/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7 arch/x86/include/asm/mman.h
--- a/arch/x86/include/asm/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7
+++ a/arch/x86/include/asm/mman.h
@@ -3,6 +3,9 @@
 
 #define MAP_32BIT	0x40		/* only give out 32bit addresses */
 
+#define MAP_HUGE_2MB    (21 << MAP_HUGE_SHIFT)
+#define MAP_HUGE_1GB    (30 << MAP_HUGE_SHIFT)
+
 #include <asm-generic/mman.h>
 
 #endif /* _ASM_X86_MMAN_H */
diff -puN fs/hugetlbfs/inode.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7 fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7
+++ a/fs/hugetlbfs/inode.c
@@ -923,7 +923,7 @@ static struct file_system_type hugetlbfs
 	.kill_sb	= kill_litter_super,
 };
 
-static struct vfsmount *hugetlbfs_vfsmount;
+static struct vfsmount *hugetlbfs_vfsmount[HUGE_MAX_HSTATE];
 
 static int can_do_hugetlb_shm(void)
 {
@@ -932,9 +932,22 @@ static int can_do_hugetlb_shm(void)
 	return capable(CAP_IPC_LOCK) || in_group_p(shm_group);
 }
 
+static int get_hstate_idx(int page_size_log)
+{
+	struct hstate *h;
+
+	if (!page_size_log)
+		return default_hstate_idx;
+	h = size_to_hstate(1 << page_size_log);
+	if (!h)
+		return -1;
+	return h - hstates;
+}
+
 struct file *hugetlb_file_setup(const char *name, unsigned long addr,
 				size_t size, vm_flags_t acctflag,
-				struct user_struct **user, int creat_flags)
+				struct user_struct **user,
+				int creat_flags, int page_size_log)
 {
 	int error = -ENOMEM;
 	struct file *file;
@@ -944,9 +957,14 @@ struct file *hugetlb_file_setup(const ch
 	struct qstr quick_string;
 	struct hstate *hstate;
 	unsigned long num_pages;
+	int hstate_idx;
+
+	hstate_idx = get_hstate_idx(page_size_log);
+	if (hstate_idx < 0)
+		return ERR_PTR(-ENODEV);
 
 	*user = NULL;
-	if (!hugetlbfs_vfsmount)
+	if (!hugetlbfs_vfsmount[hstate_idx])
 		return ERR_PTR(-ENOENT);
 
 	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
@@ -963,7 +981,7 @@ struct file *hugetlb_file_setup(const ch
 		}
 	}
 
-	root = hugetlbfs_vfsmount->mnt_root;
+	root = hugetlbfs_vfsmount[hstate_idx]->mnt_root;
 	quick_string.name = name;
 	quick_string.len = strlen(quick_string.name);
 	quick_string.hash = 0;
@@ -971,7 +989,7 @@ struct file *hugetlb_file_setup(const ch
 	if (!path.dentry)
 		goto out_shm_unlock;
 
-	path.mnt = mntget(hugetlbfs_vfsmount);
+	path.mnt = mntget(hugetlbfs_vfsmount[hstate_idx]);
 	error = -ENOSPC;
 	inode = hugetlbfs_get_inode(root->d_sb, NULL, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
@@ -1011,8 +1029,9 @@ out_shm_unlock:
 
 static int __init init_hugetlbfs_fs(void)
 {
+	struct hstate *h;
 	int error;
-	struct vfsmount *vfsmount;
+	int i;
 
 	error = bdi_init(&hugetlbfs_backing_dev_info);
 	if (error)
@@ -1029,14 +1048,27 @@ static int __init init_hugetlbfs_fs(void
 	if (error)
 		goto out;
 
-	vfsmount = kern_mount(&hugetlbfs_fs_type);
-
-	if (!IS_ERR(vfsmount)) {
-		hugetlbfs_vfsmount = vfsmount;
-		return 0;
+	i = 0;
+	for_each_hstate (h) {
+		char buf[50];
+		unsigned ps_kb = 1U << (h->order + PAGE_SHIFT - 10);
+
+		snprintf(buf, sizeof buf, "pagesize=%uK", ps_kb);
+		hugetlbfs_vfsmount[i] = kern_mount_data(&hugetlbfs_fs_type,
+							buf);
+
+		if (IS_ERR(hugetlbfs_vfsmount[i])) {
+				pr_err(
+			"hugetlb: Cannot mount internal hugetlbfs for page size %uK",
+			       ps_kb);
+			error = PTR_ERR(hugetlbfs_vfsmount[i]);
+			hugetlbfs_vfsmount[i] = NULL;
+		}
+		i++;
 	}
-
-	error = PTR_ERR(vfsmount);
+	/* Non default hstates are optional */
+	if (!IS_ERR_OR_NULL(hugetlbfs_vfsmount[default_hstate_idx]))
+		return 0;
 
  out:
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
@@ -1047,13 +1079,19 @@ static int __init init_hugetlbfs_fs(void
 
 static void __exit exit_hugetlbfs_fs(void)
 {
+	struct hstate *h;
+	int i;
+
+
 	/*
 	 * Make sure all delayed rcu free inodes are flushed before we
 	 * destroy cache.
 	 */
 	rcu_barrier();
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
-	kern_unmount(hugetlbfs_vfsmount);
+	i = 0;
+	for_each_hstate (h)
+		kern_unmount(hugetlbfs_vfsmount[i++]);
 	unregister_filesystem(&hugetlbfs_fs_type);
 	bdi_destroy(&hugetlbfs_backing_dev_info);
 }
diff -puN include/linux/hugetlb.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7
+++ a/include/linux/hugetlb.h
@@ -183,7 +183,8 @@ extern const struct file_operations huge
 extern const struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, unsigned long addr,
 				size_t size, vm_flags_t acct,
-				struct user_struct **user, int creat_flags);
+				struct user_struct **user, int creat_flags,
+				int page_size_log);
 
 static inline int is_file_hugepages(struct file *file)
 {
@@ -195,12 +196,14 @@ static inline int is_file_hugepages(stru
 	return 0;
 }
 
+
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
 static inline struct file *
 hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
-		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
+		vm_flags_t acctflag, struct user_struct **user, int creat_flags,
+		int page_size_log)
 {
 	return ERR_PTR(-ENOSYS);
 }
diff -puN include/linux/shm.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7 include/linux/shm.h
--- a/include/linux/shm.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7
+++ a/include/linux/shm.h
@@ -23,12 +23,31 @@ struct shmid_kernel /* private to the ke
 	struct task_struct	*shm_creator;
 };
 
+#endif
+
 /* shm_mode upper byte flags */
 #define	SHM_DEST	01000	/* segment will be destroyed on last detach */
 #define SHM_LOCKED      02000   /* segment will not be swapped */
 #define SHM_HUGETLB     04000   /* segment will use huge TLB pages */
 #define SHM_NORESERVE   010000  /* don't check for reservations */
 
+/* Bits [26:31] are reserved */
+
+/*
+ * When SHM_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */
+#define SHM_HUGE_SHIFT  26
+#define SHM_HUGE_MASK   0x3f
+#define SHM_HUGE_2MB    (21 << SHM_HUGE_SHIFT)
+#define SHM_HUGE_1GB    (30 << SHM_HUGE_SHIFT)
+
+#ifdef __KERNEL__
+
 #ifdef CONFIG_SYSVIPC
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
 	      unsigned long shmlba);
diff -puN include/uapi/asm-generic/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7 include/uapi/asm-generic/mman.h
--- a/include/uapi/asm-generic/mman.h~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7
+++ a/include/uapi/asm-generic/mman.h
@@ -13,6 +13,19 @@
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
+/* Bits [26:31] are reserved */
+
+/*
+ * When MAP_HUGETLB is set bits [26:31] encode the log2 of the huge page size.
+ * This gives us 6 bits, which is enough until someone invents 128 bit address
+ * spaces.
+ *
+ * Assume these are all power of twos.
+ * When 0 use the default page size.
+ */
+#define MAP_HUGE_SHIFT  26
+#define MAP_HUGE_MASK   0x3f
+
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
diff -puN ipc/shm.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7 ipc/shm.c
--- a/ipc/shm.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7
+++ a/ipc/shm.c
@@ -495,7 +495,8 @@ static int newseg(struct ipc_namespace *
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
 		file = hugetlb_file_setup(name, 0, size, acctflag,
-					&shp->mlock_user, HUGETLB_SHMFS_INODE);
+				  &shp->mlock_user, HUGETLB_SHMFS_INODE,
+				(shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK);
 	} else {
 		/*
 		 * Do not allow no accounting for OVERCOMMIT_NEVER, even
diff -puN mm/mmap.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7 mm/mmap.c
--- a/mm/mmap.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7
+++ a/mm/mmap.c
@@ -1151,8 +1151,9 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 		 * memory so no accounting is necessary
 		 */
 		file = hugetlb_file_setup(HUGETLB_ANON_FILE, addr, len,
-						VM_NORESERVE, &user,
-						HUGETLB_ANONHUGE_INODE);
+				VM_NORESERVE,
+				&user, HUGETLB_ANONHUGE_INODE,
+				(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
 		if (IS_ERR(file))
 			return PTR_ERR(file);
 	}
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
hwpoison-fix-action_result-to-print-out-dirty-clean.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch

