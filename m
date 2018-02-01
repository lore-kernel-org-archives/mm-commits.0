From: akpm@linux-foundation.org
Subject: [patch 088/119] shmem: add sealing support to
 hugetlb-backed memfd
Date: Wed, 31 Jan 2018 16:19:29 -0800
Message-ID: <20180201001929.5CLknSRVm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755813AbeBAATa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:19:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, dh.herrmann@gmail.com, hughd@google.com, marcandre.lureau@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Marc-André Lureau <marcandre.lureau@redhat.com>
Subject: shmem: add sealing support to hugetlb-backed memfd

Adapt add_seals()/get_seals() to work with hugetbfs-backed memory.

Teach memfd_create() to allow sealing operations on MFD_HUGETLB.

Link: http://lkml.kernel.org/r/20171107122800.25517-6-marcandre.lureau@redhat.com
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   47 ++++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff -puN mm/shmem.c~shmem-add-sealing-support-to-hugetlb-backed-memfd mm/shmem.c
--- a/mm/shmem.c~shmem-add-sealing-support-to-hugetlb-backed-memfd
+++ a/mm/shmem.c
@@ -2717,6 +2717,19 @@ continue_resched:
 	return error;
 }
 
+static unsigned int *memfd_file_seals_ptr(struct file *file)
+{
+	if (file->f_op == &shmem_file_operations)
+		return &SHMEM_I(file_inode(file))->seals;
+
+#ifdef CONFIG_HUGETLBFS
+	if (file->f_op == &hugetlbfs_file_operations)
+		return &HUGETLBFS_I(file_inode(file))->seals;
+#endif
+
+	return NULL;
+}
+
 #define F_ALL_SEALS (F_SEAL_SEAL | \
 		     F_SEAL_SHRINK | \
 		     F_SEAL_GROW | \
@@ -2725,7 +2738,7 @@ continue_resched:
 static int memfd_add_seals(struct file *file, unsigned int seals)
 {
 	struct inode *inode = file_inode(file);
-	struct shmem_inode_info *info = SHMEM_I(inode);
+	unsigned int *file_seals;
 	int error;
 
 	/*
@@ -2758,8 +2771,6 @@ static int memfd_add_seals(struct file *
 	 * other file types.
 	 */
 
-	if (file->f_op != &shmem_file_operations)
-		return -EINVAL;
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EPERM;
 	if (seals & ~(unsigned int)F_ALL_SEALS)
@@ -2767,12 +2778,18 @@ static int memfd_add_seals(struct file *
 
 	inode_lock(inode);
 
-	if (info->seals & F_SEAL_SEAL) {
+	file_seals = memfd_file_seals_ptr(file);
+	if (!file_seals) {
+		error = -EINVAL;
+		goto unlock;
+	}
+
+	if (*file_seals & F_SEAL_SEAL) {
 		error = -EPERM;
 		goto unlock;
 	}
 
-	if ((seals & F_SEAL_WRITE) && !(info->seals & F_SEAL_WRITE)) {
+	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
 		error = mapping_deny_writable(file->f_mapping);
 		if (error)
 			goto unlock;
@@ -2784,7 +2801,7 @@ static int memfd_add_seals(struct file *
 		}
 	}
 
-	info->seals |= seals;
+	*file_seals |= seals;
 	error = 0;
 
 unlock:
@@ -2794,10 +2811,9 @@ unlock:
 
 static int memfd_get_seals(struct file *file)
 {
-	if (file->f_op != &shmem_file_operations)
-		return -EINVAL;
+	unsigned int *seals = memfd_file_seals_ptr(file);
 
-	return SHMEM_I(file_inode(file))->seals;
+	return seals ? *seals : -EINVAL;
 }
 
 long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -3655,7 +3671,7 @@ SYSCALL_DEFINE2(memfd_create,
 		const char __user *, uname,
 		unsigned int, flags)
 {
-	struct shmem_inode_info *info;
+	unsigned int *file_seals;
 	struct file *file;
 	int fd, error;
 	char *name;
@@ -3665,9 +3681,6 @@ SYSCALL_DEFINE2(memfd_create,
 		if (flags & ~(unsigned int)MFD_ALL_FLAGS)
 			return -EINVAL;
 	} else {
-		/* Sealing not supported in hugetlbfs (MFD_HUGETLB) */
-		if (flags & MFD_ALLOW_SEALING)
-			return -EINVAL;
 		/* Allow huge page size encoding in flags. */
 		if (flags & ~(unsigned int)(MFD_ALL_FLAGS |
 				(MFD_HUGE_MASK << MFD_HUGE_SHIFT)))
@@ -3720,12 +3733,8 @@ SYSCALL_DEFINE2(memfd_create,
 	file->f_flags |= O_RDWR | O_LARGEFILE;
 
 	if (flags & MFD_ALLOW_SEALING) {
-		/*
-		 * flags check at beginning of function ensures
-		 * this is not a hugetlbfs (MFD_HUGETLB) file.
-		 */
-		info = SHMEM_I(file_inode(file));
-		info->seals &= ~F_SEAL_SEAL;
+		file_seals = memfd_file_seals_ptr(file);
+		*file_seals &= ~F_SEAL_SEAL;
 	}
 
 	fd_install(fd, file);
_
