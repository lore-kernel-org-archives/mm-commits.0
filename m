From: akpm@linux-foundation.org
Subject: + dmapool-enable-debugging-for-config_slub_debug_on-too.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:28:49 -0700
Message-ID: <200803120428.m2C4SnHB009942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbYCLE2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:28:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, willy@linux.intel.com


The patch titled
     dmapool: enable debugging for CONFIG_SLUB_DEBUG_ON too
has been added to the -mm tree.  Its filename is
     dmapool-enable-debugging-for-config_slub_debug_on-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmapool: enable debugging for CONFIG_SLUB_DEBUG_ON too
From: Andi Kleen <ak@suse.de>

Previously it was only enabled for CONFIG_DEBUG_SLAB.

Not hooked into the slub runtime debug configuration, so you currently only
get it with CONFIG_SLUB_DEBUG_ON, not plain CONFIG_SLUB_DEBUG

Acked-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/dmapool.c~dmapool-enable-debugging-for-config_slub_debug_on-too mm/dmapool.c
--- a/mm/dmapool.c~dmapool-enable-debugging-for-config_slub_debug_on-too
+++ a/mm/dmapool.c
@@ -37,6 +37,10 @@
 #include <linux/types.h>
 #include <linux/wait.h>
 
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB_DEBUG_ON)
+#define DMAPOOL_DEBUG 1
+#endif
+
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
 	spinlock_t lock;
@@ -216,7 +220,7 @@ static struct dma_page *pool_alloc_page(
 	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
 					 &page->dma, mem_flags);
 	if (page->vaddr) {
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
@@ -239,7 +243,7 @@ static void pool_free_page(struct dma_po
 {
 	dma_addr_t dma = page->dma;
 
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
@@ -336,7 +340,7 @@ void *dma_pool_alloc(struct dma_pool *po
 	page->offset = *(int *)(page->vaddr + offset);
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
  done:
@@ -391,7 +395,7 @@ void dma_pool_free(struct dma_pool *pool
 	}
 
 	offset = vaddr - page->vaddr;
-#ifdef	CONFIG_DEBUG_SLAB
+#ifdef	DMAPOOL_DEBUG
 	if ((dma - page->dma) != offset) {
 		if (pool->dev)
 			dev_err(pool->dev,
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
git-x86.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-ocfs2.patch
git-scsi-misc.patch
block-fix-memory-hotplug-and-bouncing-in-block-layer.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
dmapool-enable-debugging-for-config_slub_debug_on-too.patch

