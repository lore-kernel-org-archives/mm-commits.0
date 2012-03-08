From: akpm@linux-foundation.org
Subject: + hugetlbfs-fix-alignment-of-huge-page-requests.patch added to -mm tree
Date: Thu, 08 Mar 2012 12:16:45 -0800
Message-ID: <20120308201646.001E0A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:56524 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2CHUQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 15:16:48 -0500
Received: by vbnl22 with SMTP id l22so112911vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 12:16:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steven.truelove@utoronto.ca, hughd@google.com


The patch titled
     Subject: hugetlbfs: fix alignment of huge page requests
has been added to the -mm tree.  Its filename is
     hugetlbfs-fix-alignment-of-huge-page-requests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   14 +++++++++-----
 include/linux/hugetlb.h |    3 ++-
 ipc/shm.c               |    2 +-
 mm/mmap.c               |    6 +++---
 4 files changed, 15 insertions(+), 10 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-fix-alignment-of-huge-page-requests fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-alignment-of-huge-page-requests
+++ a/fs/hugetlbfs/inode.c
@@ -926,8 +926,8 @@ static int can_do_hugetlb_shm(void)
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
-struct file *hugetlb_file_setup(const char *name, size_t size,
-				vm_flags_t acctflag,
+struct file *hugetlb_file_setup(const char *name, unsigned long addr,
+				size_t size, vm_flags_t acctflag,
 				struct user_struct **user, int creat_flags)
 {
 	int error = -ENOMEM;
@@ -936,6 +936,8 @@ struct file *hugetlb_file_setup(const ch
 	struct path path;
 	struct dentry *root;
 	struct qstr quick_string;
+	struct hstate *hstate;
+	unsigned long num_pages;
 
 	*user = NULL;
 	if (!hugetlbfs_vfsmount)
@@ -967,10 +969,12 @@ struct file *hugetlb_file_setup(const ch
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
@@ -1122,9 +1122,9 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
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
Subject: Subject: hugetlbfs: fix alignment of huge page requests

Patches currently in -mm which might be from steven.truelove@utoronto.ca are

hugetlbfs-fix-alignment-of-huge-page-requests.patch

