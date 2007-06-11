From: akpm@linux-foundation.org
Subject: + shm-fix-the-filename-of-hugetlb-sysv-shared-memory.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:09:09 -0700
Message-ID: <200706111809.l5BI99eT025560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbXFKSJb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:09:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, acahalan@gmail.com, pbadari@us.ibm.com, serge@hallyn.com


The patch titled
     shm: fix the filename of hugetlb sysv shared memory
has been added to the -mm tree.  Its filename is
     shm-fix-the-filename-of-hugetlb-sysv-shared-memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: shm: fix the filename of hugetlb sysv shared memory
From: Eric W. Biederman <ebiederm@xmission.com>

Some user space tools need to identify SYSV shared memory when examining
/proc/<pid>/maps.  To do so they look for a block device with major zero, a
dentry named SYSV<sysv key>, and having the minor of the internal sysv
shared memory kernel mount.

To help these tools and to make it easier for people just browsing
/proc/<pid>/maps this patch modifies hugetlb sysv shared memory to use the
SYSV<key> dentry naming convention.

User space tools will still have to be aware that hugetlb sysv shared
memory lives on a different internal kernel mount and so has a different
block device minor number from the rest of sysv shared memory.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Albert Cahalan <acahalan@gmail.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    7 ++-----
 include/linux/hugetlb.h |    4 ++--
 ipc/shm.c               |    6 +++---
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN fs/hugetlbfs/inode.c~shm-fix-the-filename-of-hugetlb-sysv-shared-memory fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~shm-fix-the-filename-of-hugetlb-sysv-shared-memory
+++ a/fs/hugetlbfs/inode.c
@@ -736,15 +736,13 @@ static int can_do_hugetlb_shm(void)
 			can_do_mlock());
 }
 
-struct file *hugetlb_zero_setup(size_t size)
+struct file *hugetlb_file_setup(const char *name, size_t size)
 {
 	int error = -ENOMEM;
 	struct file *file;
 	struct inode *inode;
 	struct dentry *dentry, *root;
 	struct qstr quick_string;
-	char buf[16];
-	static atomic_t counter;
 
 	if (!hugetlbfs_vfsmount)
 		return ERR_PTR(-ENOENT);
@@ -756,8 +754,7 @@ struct file *hugetlb_zero_setup(size_t s
 		return ERR_PTR(-ENOMEM);
 
 	root = hugetlbfs_vfsmount->mnt_root;
-	snprintf(buf, 16, "%u", atomic_inc_return(&counter));
-	quick_string.name = buf;
+	quick_string.name = name;
 	quick_string.len = strlen(quick_string.name);
 	quick_string.hash = 0;
 	dentry = d_alloc(root, &quick_string);
diff -puN include/linux/hugetlb.h~shm-fix-the-filename-of-hugetlb-sysv-shared-memory include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~shm-fix-the-filename-of-hugetlb-sysv-shared-memory
+++ a/include/linux/hugetlb.h
@@ -163,7 +163,7 @@ static inline struct hugetlbfs_sb_info *
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_zero_setup(size_t);
+struct file *hugetlb_file_setup(const char *name, size_t);
 int hugetlb_get_quota(struct address_space *mapping);
 void hugetlb_put_quota(struct address_space *mapping);
 
@@ -185,7 +185,7 @@ static inline void set_file_hugepages(st
 
 #define is_file_hugepages(file)		0
 #define set_file_hugepages(file)	BUG()
-#define hugetlb_zero_setup(size)	ERR_PTR(-ENOSYS)
+#define hugetlb_file_setup(name,size)	ERR_PTR(-ENOSYS)
 
 #endif /* !CONFIG_HUGETLBFS */
 
diff -puN ipc/shm.c~shm-fix-the-filename-of-hugetlb-sysv-shared-memory ipc/shm.c
--- a/ipc/shm.c~shm-fix-the-filename-of-hugetlb-sysv-shared-memory
+++ a/ipc/shm.c
@@ -364,9 +364,10 @@ static int newseg (struct ipc_namespace 
 		return error;
 	}
 
+	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
-		/* hugetlb_zero_setup takes care of mlock user accounting */
-		file = hugetlb_zero_setup(size);
+		/* hugetlb_file_setup takes care of mlock user accounting */
+		file = hugetlb_file_setup(name, size);
 		shp->mlock_user = current->user;
 	} else {
 		int acctflag = VM_ACCOUNT;
@@ -377,7 +378,6 @@ static int newseg (struct ipc_namespace 
 		if  ((shmflg & SHM_NORESERVE) &&
 				sysctl_overcommit_memory != OVERCOMMIT_NEVER)
 			acctflag = 0;
-		sprintf (name, "SYSV%08x", key);
 		file = shmem_file_setup(name, size, acctflag);
 	}
 	error = PTR_ERR(file);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage.patch
shm-fix-the-filename-of-hugetlb-sysv-shared-memory.patch
dvb_en_50221-convert-to-kthread-api.patch
git-kbuild.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
buffer-kill-old-incorrect-comment.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
