From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-fix-mmap-failure-in-unaligned-size-request.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:34 -0700
Message-ID: <20130508183434.8E2B231C1EA__47001.7025284053$1368038089$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:61963 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150Ab3EHSeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:36 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so207650vbg.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hannes@cmpxchg.org, hughd@google.com, iceman_dvd@yahoo.com, stable@vger.kernel.org, steven.truelove@utoronto.ca, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix mmap failure in unaligned size request
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-mmap-failure-in-unaligned-size-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlbfs: fix mmap failure in unaligned size request

The current kernel returns -EINVAL unless a given mmap length is "almost"
hugepage aligned.  This is because in sys_mmap_pgoff() the given length is
passed to vm_mmap_pgoff() as it is without being aligned with hugepage
boundary.

This is a regression introduced in commit 40716e29243d ("hugetlbfs: fix
alignment of huge page requests"), where alignment code is pushed into
hugetlb_file_setup() and the variable len in caller side is not changed.

To fix this, this patch partially reverts that commit, and adds alignment
code in caller side. And it also introduces hstate_sizelog() in order to
get proper hstate to specified hugepage size.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=56881

[akpm@linux-foundation.org: fix warning when CONFIG_HUGETLB_PAGE=n]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: <iceman_dvd@yahoo.com>
Cc: Steven Truelove <steven.truelove@utoronto.ca>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   24 ++++++++++--------------
 include/linux/hugetlb.h |   19 +++++++++++++------
 ipc/shm.c               |    6 +++++-
 mm/mmap.c               |    7 ++++++-
 4 files changed, 34 insertions(+), 22 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-fix-mmap-failure-in-unaligned-size-request fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-mmap-failure-in-unaligned-size-request
+++ a/fs/hugetlbfs/inode.c
@@ -909,11 +909,8 @@ static int can_do_hugetlb_shm(void)
 
 static int get_hstate_idx(int page_size_log)
 {
-	struct hstate *h;
+	struct hstate *h = hstate_sizelog(page_size_log);
 
-	if (!page_size_log)
-		return default_hstate_idx;
-	h = size_to_hstate(1 << page_size_log);
 	if (!h)
 		return -1;
 	return h - hstates;
@@ -929,9 +926,12 @@ static struct dentry_operations anon_ops
 	.d_dname = hugetlb_dname
 };
 
-struct file *hugetlb_file_setup(const char *name, unsigned long addr,
-				size_t size, vm_flags_t acctflag,
-				struct user_struct **user,
+/*
+ * Note that size should be aligned to proper hugepage size in caller side,
+ * otherwise hugetlb_reserve_pages reserves one less hugepages than intended.
+ */
+struct file *hugetlb_file_setup(const char *name, size_t size,
+				vm_flags_t acctflag, struct user_struct **user,
 				int creat_flags, int page_size_log)
 {
 	struct file *file = ERR_PTR(-ENOMEM);
@@ -939,8 +939,6 @@ struct file *hugetlb_file_setup(const ch
 	struct path path;
 	struct super_block *sb;
 	struct qstr quick_string;
-	struct hstate *hstate;
-	unsigned long num_pages;
 	int hstate_idx;
 
 	hstate_idx = get_hstate_idx(page_size_log);
@@ -980,12 +978,10 @@ struct file *hugetlb_file_setup(const ch
 	if (!inode)
 		goto out_dentry;
 
-	hstate = hstate_inode(inode);
-	size += addr & ~huge_page_mask(hstate);
-	num_pages = ALIGN(size, huge_page_size(hstate)) >>
-			huge_page_shift(hstate);
 	file = ERR_PTR(-ENOMEM);
-	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
+	if (hugetlb_reserve_pages(inode, 0,
+			size >> huge_page_shift(hstate_inode(inode)), NULL,
+			acctflag))
 		goto out_inode;
 
 	d_instantiate(path.dentry, inode);
diff -puN include/linux/hugetlb.h~hugetlbfs-fix-mmap-failure-in-unaligned-size-request include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-fix-mmap-failure-in-unaligned-size-request
+++ a/include/linux/hugetlb.h
@@ -189,8 +189,7 @@ static inline struct hugetlbfs_sb_info *
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, unsigned long addr,
-				size_t size, vm_flags_t acct,
+struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
 				struct user_struct **user, int creat_flags,
 				int page_size_log);
 
@@ -209,8 +208,8 @@ static inline int is_file_hugepages(stru
 
 #define is_file_hugepages(file)			0
 static inline struct file *
-hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
-		vm_flags_t acctflag, struct user_struct **user, int creat_flags,
+hugetlb_file_setup(const char *name, size_t size, vm_flags_t acctflag,
+		struct user_struct **user, int creat_flags,
 		int page_size_log)
 {
 	return ERR_PTR(-ENOSYS);
@@ -288,6 +287,13 @@ static inline struct hstate *hstate_file
 	return hstate_inode(file_inode(f));
 }
 
+static inline struct hstate *hstate_sizelog(int page_size_log)
+{
+	if (!page_size_log)
+		return &default_hstate;
+	return size_to_hstate(1 << page_size_log);
+}
+
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
 {
 	return hstate_file(vma->vm_file);
@@ -352,11 +358,12 @@ static inline int hstate_index(struct hs
 	return h - hstates;
 }
 
-#else
+#else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
+#define hstate_sizelog(s) NULL
 #define hstate_vma(v) NULL
 #define hstate_inode(i) NULL
 #define huge_page_size(h) PAGE_SIZE
@@ -371,6 +378,6 @@ static inline unsigned int pages_per_hug
 }
 #define hstate_index_to_shift(index) 0
 #define hstate_index(h) 0
-#endif
+#endif	/* CONFIG_HUGETLB_PAGE */
 
 #endif /* _LINUX_HUGETLB_H */
diff -puN ipc/shm.c~hugetlbfs-fix-mmap-failure-in-unaligned-size-request ipc/shm.c
--- a/ipc/shm.c~hugetlbfs-fix-mmap-failure-in-unaligned-size-request
+++ a/ipc/shm.c
@@ -491,10 +491,14 @@ static int newseg(struct ipc_namespace *
 
 	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
+		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
+						& SHM_HUGE_MASK);
+		size_t hugesize = ALIGN(size, huge_page_size(hs));
+
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
-		file = hugetlb_file_setup(name, 0, size, acctflag,
+		file = hugetlb_file_setup(name, hugesize, acctflag,
 				  &shp->mlock_user, HUGETLB_SHMFS_INODE,
 				(shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK);
 	} else {
diff -puN mm/mmap.c~hugetlbfs-fix-mmap-failure-in-unaligned-size-request mm/mmap.c
--- a/mm/mmap.c~hugetlbfs-fix-mmap-failure-in-unaligned-size-request
+++ a/mm/mmap.c
@@ -1363,15 +1363,20 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 		file = fget(fd);
 		if (!file)
 			goto out;
+		if (is_file_hugepages(file))
+			len = ALIGN(len, huge_page_size(hstate_file(file)));
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
+
+		len = ALIGN(len, huge_page_size(hstate_sizelog(
+			(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK)));
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called
 		 * A dummy user value is used because we are not locking
 		 * memory so no accounting is necessary
 		 */
-		file = hugetlb_file_setup(HUGETLB_ANON_FILE, addr, len,
+		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
 				VM_NORESERVE,
 				&user, HUGETLB_ANONHUGE_INODE,
 				(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

