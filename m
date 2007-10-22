From: akpm@linux-foundation.org
Subject: + bufferhead-revert-constructor-removal.patch added to -mm tree
Date: Mon, 22 Oct 2007 14:34:05 -0700
Message-ID: <200710222134.l9MLY532016114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbXJVVeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 17:34:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, nickpiggin@yahoo.com.au


The patch titled
     bufferhead: Revert constructor removal
has been added to the -mm tree.  Its filename is
     bufferhead-revert-constructor-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bufferhead: Revert constructor removal
From: Christoph Lameter <clameter@sgi.com>

The constructor for buffer_head slabs was removed recently.  We need the
constructor back in slab defrag in order to insure that slab objects always
have a definite state even before we allocated them.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN fs/buffer.c~bufferhead-revert-constructor-removal fs/buffer.c
--- a/fs/buffer.c~bufferhead-revert-constructor-removal
+++ a/fs/buffer.c
@@ -3153,7 +3153,7 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep,
+	struct buffer_head *ret = kmem_cache_alloc(bh_cachep,
 				set_migrateflags(gfp_flags, __GFP_RECLAIMABLE));
 	if (ret) {
 		INIT_LIST_HEAD(&ret->b_assoc_buffers);
@@ -3197,12 +3197,24 @@ static int buffer_cpu_notify(struct noti
 	return NOTIFY_OK;
 }
 
+static void
+init_buffer_head(struct kmem_cache *cachep, void *data)
+{
+	struct buffer_head * bh = (struct buffer_head *)data;
+
+	memset(bh, 0, sizeof(*bh));
+	INIT_LIST_HEAD(&bh->b_assoc_buffers);
+}
+
 void __init buffer_init(void)
 {
 	int nrpages;
 
-	bh_cachep = KMEM_CACHE(buffer_head,
-			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
+	bh_cachep = kmem_cache_create("buffer_head",
+			sizeof(struct buffer_head), 0,
+				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
+				SLAB_MEM_SPREAD),
+				init_buffer_head);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
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
