From: akpm@linux-foundation.org
Subject: + fix-page-allocation-flags-in-grow_dev_page.patch added to -mm tree
Date: Tue, 15 May 2007 22:32:30 -0700
Message-ID: <200705160532.l4G5WTaZ027065@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758675AbXEPFer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 01:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, hugh@veritas.com


The patch titled
     Fix page allocation flags in grow_dev_page()
has been added to the -mm tree.  Its filename is
     fix-page-allocation-flags-in-grow_dev_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix page allocation flags in grow_dev_page()
From: Christoph Lameter <clameter@sgi.com>

grow_dev_page() simply passes GFP_NOFS to find_or_create_page.  This means
the allocation of radix tree nodes is done with GFP_NOFS and the allocation
of a new page is done using GFP_NOFS.

The mapping has a flags field that contains the necessary allocation flags
for the page cache allocation.  These need to be consulted in order to get
DMA and HIGHMEM allocations etc right.  And yes a blockdev could be
allowing Highmem allocations if its a ramdisk.

Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/buffer.c~fix-page-allocation-flags-in-grow_dev_page fs/buffer.c
--- a/fs/buffer.c~fix-page-allocation-flags-in-grow_dev_page
+++ a/fs/buffer.c
@@ -981,7 +981,8 @@ grow_dev_page(struct block_device *bdev,
 	struct page *page;
 	struct buffer_head *bh;
 
-	page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+	page = find_or_create_page(inode->i_mapping, index,
+		mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 	if (!page)
 		return NULL;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-it-is-legit-to-allocate-a-slab-of-the-maximum-permitted-size.patch
slub-dont-confuse-ctor-and-dtor.patch
fix-find_or_create_page-skips-cpuset-memory-spreading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slab-warn-on-zero-length-allocations.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
slub-fix-handling-of-oversized-slabs.patch
fix-page-allocation-flags-in-grow_dev_page.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
