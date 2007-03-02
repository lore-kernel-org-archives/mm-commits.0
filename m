From: akpm@linux-foundation.org
Subject: - fix-get_unmapped_area-and-fsync-for-hugetlb-shm-segments.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:42 -0800
Message-ID: <200703020507.l2257gjZ000890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42426 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422778AbXCBFHw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, bill.irwin@oracle.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Fix get_unmapped_area and fsync for hugetlb shm segments
has been removed from the -mm tree.  Its filename was
     fix-get_unmapped_area-and-fsync-for-hugetlb-shm-segments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix get_unmapped_area and fsync for hugetlb shm segments
From: Adam Litke <agl@us.ibm.com>

This patch provides the following hugetlb-related fixes to the recent stacked
shm files changes:
 - Update is_file_hugepages() so it will reconize hugetlb shm segments.
 - get_unmapped_area must be called with the nested file struct to handle
   the sfd->file->f_ops->get_unmapped_area == NULL case.
 - The fsync f_op must be wrapped since it is specified in the hugetlbfs
   f_ops.

This is based on proposed fixes from Eric Biederman that were debugged and
tested by me.  Without it, attempting to use hugetlb shared memory segments
on powerpc (and likely ia64) will kill your box.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: William Irwin <bill.irwin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    8 +++++++-
 include/linux/shm.h     |    5 +++++
 ipc/shm.c               |   32 ++++++++++++++++++++++++++------
 3 files changed, 38 insertions(+), 7 deletions(-)

diff -puN include/linux/hugetlb.h~fix-get_unmapped_area-and-fsync-for-hugetlb-shm-segments include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~fix-get_unmapped_area-and-fsync-for-hugetlb-shm-segments
+++ a/include/linux/hugetlb.h
@@ -4,6 +4,7 @@
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
+#include <linux/shm.h>
 #include <asm/tlbflush.h>
 
 struct ctl_table;
@@ -168,7 +169,12 @@ void hugetlb_put_quota(struct address_sp
 
 static inline int is_file_hugepages(struct file *file)
 {
-	return file->f_op == &hugetlbfs_file_operations;
+	if (file->f_op == &hugetlbfs_file_operations)
+		return 1;
+	if (is_file_shm_hugepages(file))
+		return 1;
+
+	return 0;
 }
 
 static inline void set_file_hugepages(struct file *file)
diff -puN include/linux/shm.h~fix-get_unmapped_area-and-fsync-for-hugetlb-shm-segments include/linux/shm.h
--- a/include/linux/shm.h~fix-get_unmapped_area-and-fsync-for-hugetlb-shm-segments
+++ a/include/linux/shm.h
@@ -96,12 +96,17 @@ struct shmid_kernel /* private to the ke
 
 #ifdef CONFIG_SYSVIPC
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr);
+extern int is_file_shm_hugepages(struct file *file);
 #else
 static inline long do_shmat(int shmid, char __user *shmaddr,
 				int shmflg, unsigned long *addr)
 {
 	return -ENOSYS;
 }
+static inline int is_file_shm_hugepages(struct file *file)
+{
+	return 0;
+}
 #endif
 
 #endif /* __KERNEL__ */
diff -puN ipc/shm.c~fix-get_unmapped_area-and-fsync-for-hugetlb-shm-segments ipc/shm.c
--- a/ipc/shm.c~fix-get_unmapped_area-and-fsync-for-hugetlb-shm-segments
+++ a/ipc/shm.c
@@ -285,21 +285,41 @@ static int shm_release(struct inode *ino
 	return 0;
 }
 
-#ifndef CONFIG_MMU
+static int shm_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int (*fsync) (struct file *, struct dentry *, int datasync);
+	struct shm_file_data *sfd = shm_file_data(file);
+	int ret = -EINVAL;
+
+	fsync = sfd->file->f_op->fsync;
+	if (fsync)
+		ret = fsync(sfd->file, sfd->file->f_path.dentry, datasync);
+	return ret;
+}
+
 static unsigned long shm_get_unmapped_area(struct file *file,
 	unsigned long addr, unsigned long len, unsigned long pgoff,
 	unsigned long flags)
 {
 	struct shm_file_data *sfd = shm_file_data(file);
-	return sfd->file->f_op->get_unmapped_area(sfd->file, addr, len, pgoff,
-							flags);
+	return get_unmapped_area(sfd->file, addr, len, pgoff, flags);
+}
+
+int is_file_shm_hugepages(struct file *file)
+{
+	int ret = 0;
+
+	if (file->f_op == &shm_file_operations) {
+		struct shm_file_data *sfd;
+		sfd = shm_file_data(file);
+		ret = is_file_hugepages(sfd->file);
+	}
+	return ret;
 }
-#else
-#define shm_get_unmapped_area NULL
-#endif
 
 static const struct file_operations shm_file_operations = {
 	.mmap		= shm_mmap,
+	.fsync		= shm_fsync,
 	.release	= shm_release,
 	.get_unmapped_area	= shm_get_unmapped_area,
 };
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch
