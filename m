From: akpm@linux-foundation.org
Subject: + shmem-rename-functions-that-are-memfd-related.patch added to
 -mm tree
Date: Wed, 20 Dec 2017 16:25:08 -0800
Message-ID: <5a3aff64.LmkkDbcANlxwI36n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756253AbdLUAZJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 19:25:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcandre.lureau@redhat.com, aarcange@redhat.com, dh.herrmann@gmail.com, hughd@google.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: rename functions that are memfd-related
has been added to the -mm tree.  Its filename is
     shmem-rename-functions-that-are-memfd-related.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-rename-functions-that-are-memfd-related.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-rename-functions-that-are-memfd-related.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marc-André Lureau <marcandre.lureau@redhat.com>
Subject: shmem: rename functions that are memfd-related

Those functions are called for memfd files, backed by shmem or
hugetlb (the next patches will handle hugetlb).

Link: http://lkml.kernel.org/r/20171107122800.25517-3-marcandre.lureau@redhat.com
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c               |    2 +-
 include/linux/shmem_fs.h |    4 ++--
 mm/shmem.c               |   10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/fcntl.c~shmem-rename-functions-that-are-memfd-related fs/fcntl.c
--- a/fs/fcntl.c~shmem-rename-functions-that-are-memfd-related
+++ a/fs/fcntl.c
@@ -418,7 +418,7 @@ static long do_fcntl(int fd, unsigned in
 		break;
 	case F_ADD_SEALS:
 	case F_GET_SEALS:
-		err = shmem_fcntl(filp, cmd, arg);
+		err = memfd_fcntl(filp, cmd, arg);
 		break;
 	case F_GET_RW_HINT:
 	case F_SET_RW_HINT:
diff -puN include/linux/shmem_fs.h~shmem-rename-functions-that-are-memfd-related include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~shmem-rename-functions-that-are-memfd-related
+++ a/include/linux/shmem_fs.h
@@ -112,11 +112,11 @@ extern void shmem_uncharge(struct inode
 
 #ifdef CONFIG_TMPFS
 
-extern long shmem_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
+extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
 
 #else
 
-static inline long shmem_fcntl(struct file *f, unsigned int c, unsigned long a)
+static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned long a)
 {
 	return -EINVAL;
 }
diff -puN mm/shmem.c~shmem-rename-functions-that-are-memfd-related mm/shmem.c
--- a/mm/shmem.c~shmem-rename-functions-that-are-memfd-related
+++ a/mm/shmem.c
@@ -2725,7 +2725,7 @@ continue_resched:
 		     F_SEAL_GROW | \
 		     F_SEAL_WRITE)
 
-static int shmem_add_seals(struct file *file, unsigned int seals)
+static int memfd_add_seals(struct file *file, unsigned int seals)
 {
 	struct inode *inode = file_inode(file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -2795,7 +2795,7 @@ unlock:
 	return error;
 }
 
-static int shmem_get_seals(struct file *file)
+static int memfd_get_seals(struct file *file)
 {
 	if (file->f_op != &shmem_file_operations)
 		return -EINVAL;
@@ -2803,7 +2803,7 @@ static int shmem_get_seals(struct file *
 	return SHMEM_I(file_inode(file))->seals;
 }
 
-long shmem_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
+long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long error;
 
@@ -2813,10 +2813,10 @@ long shmem_fcntl(struct file *file, unsi
 		if (arg > UINT_MAX)
 			return -EINVAL;
 
-		error = shmem_add_seals(file, arg);
+		error = memfd_add_seals(file, arg);
 		break;
 	case F_GET_SEALS:
-		error = shmem_get_seals(file);
+		error = memfd_get_seals(file);
 		break;
 	default:
 		error = -EINVAL;
_

Patches currently in -mm which might be from marcandre.lureau@redhat.com are

shmem-unexport-shmem_add_seals-shmem_get_seals.patch
shmem-rename-functions-that-are-memfd-related.patch
hugetlb-expose-hugetlbfs_inode_info-in-header.patch
hugetlb-implement-memfd-sealing.patch
shmem-add-sealing-support-to-hugetlb-backed-memfd.patch
memfd-test-test-hugetlbfs-sealing.patch
memfd-test-add-memfd-hugetlb-prefix-when-testing-hugetlbfs.patch
memfd-test-move-common-code-to-a-shared-unit.patch
memfd-test-run-fuse-test-on-hugetlb-backend-memory.patch
mm-page_owner-align-with-pageblock_nr_pages.patch

