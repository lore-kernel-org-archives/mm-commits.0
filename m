From: akpm@linux-foundation.org
Subject: + shmem-unexport-shmem_add_seals-shmem_get_seals.patch added to
 -mm tree
Date: Wed, 20 Dec 2017 16:25:05 -0800
Message-ID: <5a3aff61.yZoS2t+Ier7eiE9a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756134AbdLUAZH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 19:25:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcandre.lureau@redhat.com, aarcange@redhat.com, dh.herrmann@gmail.com, hughd@google.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: unexport shmem_add_seals()/shmem_get_seals()
has been added to the -mm tree.  Its filename is
     shmem-unexport-shmem_add_seals-shmem_get_seals.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-unexport-shmem_add_seals-shmem_get_seals.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-unexport-shmem_add_seals-shmem_get_seals.patch

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
Subject: shmem: unexport shmem_add_seals()/shmem_get_seals()

Patch series "memfd: add sealing to hugetlb-backed memory", v3.

Recently, Mike Kravetz added hugetlbfs support to memfd.  However, he
didn't add sealing support.  One of the reasons to use memfd is to have
shared memory sealing when doing IPC or sharing memory with another
process with some extra safety.  qemu uses shared memory & hugetables with
vhost-user (used by dpdk), so it is reasonable to use memfd now instead
for convenience and security reasons.


This patch (of 9):

The functions are called through shmem_fcntl() only.  And no danger in
removing the EXPORTs as the routines only work with shmem file structs.

Link: http://lkml.kernel.org/r/20171107122800.25517-2-marcandre.lureau@redhat.com
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 --
 mm/shmem.c               |    6 ++----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN include/linux/shmem_fs.h~shmem-unexport-shmem_add_seals-shmem_get_seals include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~shmem-unexport-shmem_add_seals-shmem_get_seals
+++ a/include/linux/shmem_fs.h
@@ -112,8 +112,6 @@ extern void shmem_uncharge(struct inode
 
 #ifdef CONFIG_TMPFS
 
-extern int shmem_add_seals(struct file *file, unsigned int seals);
-extern int shmem_get_seals(struct file *file);
 extern long shmem_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
 
 #else
diff -puN mm/shmem.c~shmem-unexport-shmem_add_seals-shmem_get_seals mm/shmem.c
--- a/mm/shmem.c~shmem-unexport-shmem_add_seals-shmem_get_seals
+++ a/mm/shmem.c
@@ -2725,7 +2725,7 @@ continue_resched:
 		     F_SEAL_GROW | \
 		     F_SEAL_WRITE)
 
-int shmem_add_seals(struct file *file, unsigned int seals)
+static int shmem_add_seals(struct file *file, unsigned int seals)
 {
 	struct inode *inode = file_inode(file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -2794,16 +2794,14 @@ unlock:
 	inode_unlock(inode);
 	return error;
 }
-EXPORT_SYMBOL_GPL(shmem_add_seals);
 
-int shmem_get_seals(struct file *file)
+static int shmem_get_seals(struct file *file)
 {
 	if (file->f_op != &shmem_file_operations)
 		return -EINVAL;
 
 	return SHMEM_I(file_inode(file))->seals;
 }
-EXPORT_SYMBOL_GPL(shmem_get_seals);
 
 long shmem_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 {
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

