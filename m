From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-fix-alignment-of-huge-page-requests.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:10 -0700
Message-ID: <20120322201910.66CC4A06FD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:42272 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476Ab2CVUTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:13 -0400
Received: by lbbgj3 with SMTP id gj3so134103lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steven.truelove@utoronto.ca, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix alignment of huge page requests
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-alignment-of-huge-page-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Steven Truelove <steven.truelove@utoronto.ca>
Subject: hugetlbfs: fix alignment of huge page requests

When calling shmget() with SHM_HUGETLB, shmget aligns the request size to
PAGE_SIZE, but this is not sufficient.

Modify hugetlb_file_setup() to align requests to the huge page size, and
to accept an address argument so that all alignment checks can be
performed in hugetlb_file_setup(), rather than in its callers.  Change
newseg() and mmap_pgoff() to match the new prototype and eliminate a now
redundant alignment check.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   14 +++++++++-----
 include/linux/hugetlb.h |    6 ++++--
 ipc/shm.c               |    2 +-
 mm/mmap.c               |    6 +++---
 4 files changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-fix-alignment-of-huge-page-requests fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-alignment-of-huge-page-requests
+++ a/fs/hugetlbfs/inode.c
@@ -935,8 +935,8 @@ static int can_do_hugetlb_shm(void)
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
-struct file *hugetlb_file_setup(const char *name, size_t size,
-				vm_flags_t acctflag,
+struct file *hugetlb_file_setup(const char *name, unsigned long addr,
+				size_t size, vm_flags_t acctflag,
 				struct user_struct **user, int creat_flags)
 {
 	int error = -ENOMEM;
@@ -945,6 +945,8 @@ struct file *hugetlb_file_setup(const ch
 	struct path path;
 	struct dentry *root;
 	struct qstr quick_string;
+	struct hstate *hstate;
+	unsigned long num_pages;
 
 	*user = NULL;
 	if (!hugetlbfs_vfsmount)
@@ -978,10 +980,12 @@ struct file *hugetlb_file_setup(const ch
 	if (!inode)
 		goto out_dentry;
 
+	hstate = hstate_inode(inode);
+	size += addr & ~huge_page_mask(hstate);
+	num_pages = ALIGN(size, huge_page_size(hstate)) >>
+			huge_page_shift(hstate);
 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0,
-			size >> huge_page_shift(hstate_inode(inode)), NULL,
-			acctflag))
+	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
 		goto out_inode;
 
 	d_instantiate(path.dentry, inode);
diff -puN include/linux/hugetlb.h~hugetlbfs-fix-alignment-of-huge-page-requests include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-fix-alignment-of-huge-page-requests
+++ a/include/linux/hugetlb.h
@@ -152,7 +152,8 @@ static inline struct hugetlbfs_sb_info *
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
+struct file *hugetlb_file_setup(const char *name, unsigned long addr,
+				size_t size, vm_flags_t acct,
 				struct user_struct **user, int creat_flags);
 
 static inline int is_file_hugepages(struct file *file)
@@ -168,7 +169,8 @@ static inline int is_file_hugepages(stru
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
-static inline struct file *hugetlb_file_setup(const char *name, size_t size,
+static inline struct file *
+hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
 		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
 {
 	return ERR_PTR(-ENOSYS);
diff -puN ipc/shm.c~hugetlbfs-fix-alignment-of-huge-page-requests ipc/shm.c
--- a/ipc/shm.c~hugetlbfs-fix-alignment-of-huge-page-requests
+++ a/ipc/shm.c
@@ -482,7 +482,7 @@ static int newseg(struct ipc_namespace *
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
-		file = hugetlb_file_setup(name, size, acctflag,
+		file = hugetlb_file_setup(name, 0, size, acctflag,
 					&shp->mlock_user, HUGETLB_SHMFS_INODE);
 	} else {
 		/*
diff -puN mm/mmap.c~hugetlbfs-fix-alignment-of-huge-page-requests mm/mmap.c
--- a/mm/mmap.c~hugetlbfs-fix-alignment-of-huge-page-requests
+++ a/mm/mmap.c
@@ -1099,9 +1099,9 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 		 * A dummy user value is used because we are not locking
 		 * memory so no accounting is necessary
 		 */
-		len = ALIGN(len, huge_page_size(&default_hstate));
-		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
-						&user, HUGETLB_ANONHUGE_INODE);
+		file = hugetlb_file_setup(HUGETLB_ANON_FILE, addr, len,
+						VM_NORESERVE, &user,
+						HUGETLB_ANONHUGE_INODE);
 		if (IS_ERR(file))
 			return PTR_ERR(file);
 	}
_

Patches currently in -mm which might be from steven.truelove@utoronto.ca are

origin.patch

