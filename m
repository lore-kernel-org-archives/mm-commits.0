From: akpm@linux-foundation.org
Subject: + vm-allow-get_page_unless_zero-on-compound-pages.patch added to -mm tree
Date: Mon, 22 Oct 2007 14:33:58 -0700
Message-ID: <200710222134.l9MLY1mN016077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbXJVVeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 17:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     VM: Allow get_page_unless_zero on compound pages
has been added to the -mm tree.  Its filename is
     vm-allow-get_page_unless_zero-on-compound-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VM: Allow get_page_unless_zero on compound pages
From: Christoph Lameter <clameter@sgi.com>

Both slab defrag and the large blocksize patches need to ability to take
refcounts on compound pages.  May be useful in other places as well.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~vm-allow-get_page_unless_zero-on-compound-pages include/linux/mm.h
--- a/include/linux/mm.h~vm-allow-get_page_unless_zero-on-compound-pages
+++ a/include/linux/mm.h
@@ -226,7 +226,7 @@ static inline int put_page_testzero(stru
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page));
+	VM_BUG_ON(PageTail(page));
 	return atomic_inc_not_zero(&page->_count);
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-x86.patch
slub-avoid-atomic-operation-for-slab_unlock.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
