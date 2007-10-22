From: akpm@linux-foundation.org
Subject: + shmem-sgp_quick-and-sgp_fault-redundant.patch added to -mm tree
Date: Mon, 22 Oct 2007 15:13:43 -0700
Message-ID: <200710222213.l9MMDhmc017643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbXJVWOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 18:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, riel@redhat.com


The patch titled
     shmem: SGP_QUICK and SGP_FAULT redundant
has been added to the -mm tree.  Its filename is
     shmem-sgp_quick-and-sgp_fault-redundant.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1101,8 +1099,6 @@ repeat:
 	if (filepage && PageUptodate(filepage))
 		goto done;
 	error = 0;
-	if (sgp == SGP_QUICK)
-		goto failed;
 	gfp = mapping_gfp_mask(mapping);
 
 	spin_lock(&info->lock);
@@ -1276,7 +1272,7 @@ repeat:
 done:
 	if (*pagep != filepage) {
 		*pagep = filepage;
-		if (sgp != SGP_FAULT)
+		if (sgp != SGP_CACHE)
 			unlock_page(filepage);
 
 	}
@@ -1299,7 +1295,7 @@ static int shmem_fault(struct vm_area_st
 	if (((loff_t)vmf->pgoff << PAGE_CACHE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
-	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_FAULT, &ret);
+	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
fix-mprotect-vma_wants_writenotify-prot.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch
