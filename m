From: akpm@linux-foundation.org
Subject: - shmem-sgp_quick-and-sgp_fault-redundant.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:05 -0800
Message-ID: <200802052229.m15MTk35012007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932365AbYBEWnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     shmem: SGP_QUICK and SGP_FAULT redundant
has been removed from the -mm tree.  Its filename was
     shmem-sgp_quick-and-sgp_fault-redundant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem: SGP_QUICK and SGP_FAULT redundant
From: Hugh Dickins <hugh@veritas.com>

Remove SGP_QUICK from the sgp_type enum: it was for shmem_populate and has no
users now.  Remove SGP_FAULT from the enum: SGP_CACHE does just as well (and
shmem_getpage is about to return with page always locked).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN mm/shmem.c~shmem-sgp_quick-and-sgp_fault-redundant mm/shmem.c
--- a/mm/shmem.c~shmem-sgp_quick-and-sgp_fault-redundant
+++ a/mm/shmem.c
@@ -78,11 +78,9 @@
 
 /* Flag allocation requirements to shmem_getpage and shmem_swp_alloc */
 enum sgp_type {
-	SGP_QUICK,	/* don't try more than file page cache lookup */
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
 	SGP_WRITE,	/* may exceed i_size, may allocate page */
-	SGP_FAULT,	/* same as SGP_CACHE, return with page locked */
 };
 
 static int shmem_getpage(struct inode *inode, unsigned long idx,
@@ -1116,8 +1114,6 @@ repeat:
 	if (filepage && PageUptodate(filepage))
 		goto done;
 	error = 0;
-	if (sgp == SGP_QUICK)
-		goto failed;
 	gfp = mapping_gfp_mask(mapping);
 
 	spin_lock(&info->lock);
@@ -1292,7 +1288,7 @@ repeat:
 done:
 	if (*pagep != filepage) {
 		*pagep = filepage;
-		if (sgp != SGP_FAULT)
+		if (sgp != SGP_CACHE)
 			unlock_page(filepage);
 
 	}
@@ -1315,7 +1311,7 @@ static int shmem_fault(struct vm_area_st
 	if (((loff_t)vmf->pgoff << PAGE_CACHE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
-	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_FAULT, &ret);
+	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
