Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77266C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57EC961241
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhKKCxl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234518AbhKKCxe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80B19610A2;
        Thu, 11 Nov 2021 02:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599045;
        bh=IIfln/d6fULd4cZby6Ket8Wu09IdFbEakSoaZBK/9/Y=;
        h=Date:From:To:Subject:From;
        b=OB/u/jsPFTSwBy9TlbfNsjGwIgztb7ZcYzcYAYSNbA+DyDk1WLfYb7XYcbi52ODlL
         PJUdEjZVOC09wilMyE5wHy5y5OmPJX21UOSuN17tG5P8GY3n9lXfru0EJk+1xt/c50
         wEVElbKVPt5HRPfkVuPkQTRucMKXgsxyLWi9TbRg=
Date:   Wed, 10 Nov 2021 18:50:45 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, liuzixian4@huawei.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        wuxu.wu@huawei.com, zhangyiru3@huawei.com
Subject:  [merged]
 mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch removed from -mm tree
Message-ID: <20211111025045.By5WAFPOx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: remove mlock ulimit for SHM_HUGETLB
has been removed from the -mm tree.  Its filename was
     mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhangyiru <zhangyiru3@huawei.com>
Subject: mm,hugetlb: remove mlock ulimit for SHM_HUGETLB

commit 21a3c273f88c9cbbaf7e ("mm, hugetlb: add thread name and pid to
SHM_HUGETLB mlock rlimit warning") marked this as deprecated in 2012, but
it is not deleted yet.

Mike says he still sees that message in log files on occasion, so maybe we
should preserve this warning.

Also remove hugetlbfs related user_shm_unlock in ipc/shm.c and remove the
user_shm_unlock after out.

Link: https://lkml.kernel.org/r/20211103105857.25041-1-zhangyiru3@huawei.com
Signed-off-by: zhangyiru <zhangyiru3@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liu Zixian <liuzixian4@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: wuxu.wu <wuxu.wu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   23 ++++++++---------------
 include/linux/hugetlb.h |    6 ++----
 ipc/shm.c               |    8 +-------
 mm/memfd.c              |    4 +---
 mm/mmap.c               |    3 +--
 5 files changed, 13 insertions(+), 31 deletions(-)

--- a/fs/hugetlbfs/inode.c~mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb
+++ a/fs/hugetlbfs/inode.c
@@ -1446,8 +1446,8 @@ static int get_hstate_idx(int page_size_
  * otherwise hugetlb_reserve_pages reserves one less hugepages than intended.
  */
 struct file *hugetlb_file_setup(const char *name, size_t size,
-				vm_flags_t acctflag, struct ucounts **ucounts,
-				int creat_flags, int page_size_log)
+				vm_flags_t acctflag, int creat_flags,
+				int page_size_log)
 {
 	struct inode *inode;
 	struct vfsmount *mnt;
@@ -1458,22 +1458,19 @@ struct file *hugetlb_file_setup(const ch
 	if (hstate_idx < 0)
 		return ERR_PTR(-ENODEV);
 
-	*ucounts = NULL;
 	mnt = hugetlbfs_vfsmount[hstate_idx];
 	if (!mnt)
 		return ERR_PTR(-ENOENT);
 
 	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
-		*ucounts = current_ucounts();
-		if (user_shm_lock(size, *ucounts)) {
-			task_lock(current);
-			pr_warn_once("%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
+		struct ucounts *ucounts = current_ucounts();
+
+		if (user_shm_lock(size, ucounts)) {
+			pr_warn_once("%s (%d): Using mlock ulimits for SHM_HUGETLB is obsolete\n",
 				current->comm, current->pid);
-			task_unlock(current);
-		} else {
-			*ucounts = NULL;
-			return ERR_PTR(-EPERM);
+			user_shm_unlock(size, ucounts);
 		}
+		return ERR_PTR(-EPERM);
 	}
 
 	file = ERR_PTR(-ENOSPC);
@@ -1498,10 +1495,6 @@ struct file *hugetlb_file_setup(const ch
 
 	iput(inode);
 out:
-	if (*ucounts) {
-		user_shm_unlock(size, *ucounts);
-		*ucounts = NULL;
-	}
 	return file;
 }
 
--- a/include/linux/hugetlb.h~mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb
+++ a/include/linux/hugetlb.h
@@ -477,8 +477,7 @@ static inline struct hugetlbfs_inode_inf
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
-				struct ucounts **ucounts, int creat_flags,
-				int page_size_log);
+				int creat_flags, int page_size_log);
 
 static inline bool is_file_hugepages(struct file *file)
 {
@@ -497,8 +496,7 @@ static inline struct hstate *hstate_inod
 #define is_file_hugepages(file)			false
 static inline struct file *
 hugetlb_file_setup(const char *name, size_t size, vm_flags_t acctflag,
-		struct ucounts **ucounts, int creat_flags,
-		int page_size_log)
+		int creat_flags, int page_size_log)
 {
 	return ERR_PTR(-ENOSYS);
 }
--- a/ipc/shm.c~mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb
+++ a/ipc/shm.c
@@ -287,9 +287,6 @@ static void shm_destroy(struct ipc_names
 	shm_unlock(shp);
 	if (!is_file_hugepages(shm_file))
 		shmem_lock(shm_file, 0, shp->mlock_ucounts);
-	else if (shp->mlock_ucounts)
-		user_shm_unlock(i_size_read(file_inode(shm_file)),
-				shp->mlock_ucounts);
 	fput(shm_file);
 	ipc_update_pid(&shp->shm_cprid, NULL);
 	ipc_update_pid(&shp->shm_lprid, NULL);
@@ -650,8 +647,7 @@ static int newseg(struct ipc_namespace *
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
 		file = hugetlb_file_setup(name, hugesize, acctflag,
-				  &shp->mlock_ucounts, HUGETLB_SHMFS_INODE,
-				(shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK);
+				HUGETLB_SHMFS_INODE, (shmflg >> SHM_HUGE_SHIFT) & SHM_HUGE_MASK);
 	} else {
 		/*
 		 * Do not allow no accounting for OVERCOMMIT_NEVER, even
@@ -698,8 +694,6 @@ static int newseg(struct ipc_namespace *
 no_id:
 	ipc_update_pid(&shp->shm_cprid, NULL);
 	ipc_update_pid(&shp->shm_lprid, NULL);
-	if (is_file_hugepages(file) && shp->mlock_ucounts)
-		user_shm_unlock(size, shp->mlock_ucounts);
 	fput(file);
 	ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
 	return error;
--- a/mm/memfd.c~mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb
+++ a/mm/memfd.c
@@ -297,9 +297,7 @@ SYSCALL_DEFINE2(memfd_create,
 	}
 
 	if (flags & MFD_HUGETLB) {
-		struct ucounts *ucounts = NULL;
-
-		file = hugetlb_file_setup(name, 0, VM_NORESERVE, &ucounts,
+		file = hugetlb_file_setup(name, 0, VM_NORESERVE,
 					HUGETLB_ANONHUGE_INODE,
 					(flags >> MFD_HUGE_SHIFT) &
 					MFD_HUGE_MASK);
--- a/mm/mmap.c~mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb
+++ a/mm/mmap.c
@@ -1599,7 +1599,6 @@ unsigned long ksys_mmap_pgoff(unsigned l
 			goto out_fput;
 		}
 	} else if (flags & MAP_HUGETLB) {
-		struct ucounts *ucounts = NULL;
 		struct hstate *hs;
 
 		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
@@ -1615,7 +1614,7 @@ unsigned long ksys_mmap_pgoff(unsigned l
 		 */
 		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
 				VM_NORESERVE,
-				&ucounts, HUGETLB_ANONHUGE_INODE,
+				HUGETLB_ANONHUGE_INODE,
 				(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
 		if (IS_ERR(file))
 			return PTR_ERR(file);
_

Patches currently in -mm which might be from zhangyiru3@huawei.com are


