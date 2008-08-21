From: akpm@linux-foundation.org
Subject: - mm-xip-ext2-fix-block-allocation-race.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:54 -0700
Message-ID: <200808210349.m7L3nsXl015671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869AbYHUDuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, cotte@freenet.de, hugh@veritas.com, jaredeh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: xip/ext2 fix block allocation race
has been removed from the -mm tree.  Its filename was
     mm-xip-ext2-fix-block-allocation-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: xip/ext2 fix block allocation race
From: Nick Piggin <npiggin@suse.de>

XIP can call into get_xip_mem concurrently with the same file,offset with
create=1.  This usually maps down to get_block, which expects the page
lock to prevent such a situation.  This causes ext2 to explode for one
reason or another.

Serialise those calls for the moment.  For common usages today, I suspect
get_xip_mem rarely is called to create new blocks.  In future as XIP
technologies evolve we might need to look at which operations require
scalability, and rework the locking to suit.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Acked-by: Carsten Otte <cotte@freenet.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap_xip.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/filemap_xip.c~mm-xip-ext2-fix-block-allocation-race mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-xip-ext2-fix-block-allocation-race
+++ a/mm/filemap_xip.c
@@ -248,15 +248,16 @@ again:
 		int err;
 
 		/* maybe shared writable, allocate new block */
+		mutex_lock(&xip_sparse_mutex);
 		error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 1,
 							&xip_mem, &xip_pfn);
+		mutex_unlock(&xip_sparse_mutex);
 		if (error)
 			return VM_FAULT_SIGBUS;
 		/* unmap sparse mappings at pgoff from all other vmas */
 		__xip_unmap(mapping, vmf->pgoff);
 
 found:
-		printk("%s insert %lx@%lx\n", current->comm, (unsigned long)vmf->virtual_address, xip_pfn);
 		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
 							xip_pfn);
 		if (err == -ENOMEM)
@@ -340,8 +341,10 @@ __xip_file_write(struct file *filp, cons
 						&xip_mem, &xip_pfn);
 		if (status == -ENODATA) {
 			/* we allocate a new page unmap it */
+			mutex_lock(&xip_sparse_mutex);
 			status = a_ops->get_xip_mem(mapping, index, 1,
 							&xip_mem, &xip_pfn);
+			mutex_unlock(&xip_sparse_mutex);
 			if (!status)
 				/* unmap page at pgoff from all other vmas */
 				__xip_unmap(mapping, index);
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
mm-pagecache-insertion-fewer-atomics.patch
mm-unlockless-reclaim.patch
mm-page-lock-use-lock-bitops.patch
fs-buffer-lock-use-lock-bitops.patch
mm-page-allocator-minor-speedup.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

