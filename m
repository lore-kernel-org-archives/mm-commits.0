From: akpm@linux-foundation.org
Subject: [merged]
 shmem-unexport-shmem_add_seals-shmem_get_seals.patch removed from -mm tree
Date: Thu, 01 Feb 2018 11:33:20 -0800
Message-ID: <20180201193320.msdvYNVjE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754563AbeBATdW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dh.herrmann@gmail.com, hughd@google.com, marcandre.lureau@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: unexport shmem_add_seals()/shmem_get_seals()
has been removed from the -mm tree.  Its filename was
     shmem-unexport-shmem_add_seals-shmem_get_seals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2722,7 +2722,7 @@ continue_resched:
 		     F_SEAL_GROW | \
 		     F_SEAL_WRITE)
 
-int shmem_add_seals(struct file *file, unsigned int seals)
+static int shmem_add_seals(struct file *file, unsigned int seals)
 {
 	struct inode *inode = file_inode(file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -2791,16 +2791,14 @@ unlock:
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

mm-page_owner-align-with-pageblock_nr_pages.patch

