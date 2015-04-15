From: akpm@linux-foundation.org
Subject: [merged] mm-mempool-do-not-allow-atomic-resizing.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 12:30:44 -0700
Message-ID: <552ebc64.5h/cHiYIhPi04m/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com, schwidefsky@de.ibm.com, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: do not allow atomic resizing
has been removed from the -mm tree.  Its filename was
     mm-mempool-do-not-allow-atomic-resizing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempool: do not allow atomic resizing

Allocating a large number of elements in atomic context could quickly
deplete memory reserves, so just disallow atomic resizing entirely.

Nothing currently uses mempool_resize() with anything other than
GFP_KERNEL, so convert existing callers to drop the gfp_mask.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Steffen Maier <maier@linux.vnet.ibm.com>	[zfcp]
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/scsi/zfcp_erp.c |    4 ++--
 fs/cifs/connect.c            |    6 ++----
 include/linux/mempool.h      |    2 +-
 mm/mempool.c                 |   10 ++++++----
 4 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/s390/scsi/zfcp_erp.c~mm-mempool-do-not-allow-atomic-resizing drivers/s390/scsi/zfcp_erp.c
--- a/drivers/s390/scsi/zfcp_erp.c~mm-mempool-do-not-allow-atomic-resizing
+++ a/drivers/s390/scsi/zfcp_erp.c
@@ -738,11 +738,11 @@ static int zfcp_erp_adapter_strategy_ope
 		return ZFCP_ERP_FAILED;
 
 	if (mempool_resize(act->adapter->pool.sr_data,
-			   act->adapter->stat_read_buf_num, GFP_KERNEL))
+			   act->adapter->stat_read_buf_num))
 		return ZFCP_ERP_FAILED;
 
 	if (mempool_resize(act->adapter->pool.status_read_req,
-			   act->adapter->stat_read_buf_num, GFP_KERNEL))
+			   act->adapter->stat_read_buf_num))
 		return ZFCP_ERP_FAILED;
 
 	atomic_set(&act->adapter->stat_miss, act->adapter->stat_read_buf_num);
diff -puN fs/cifs/connect.c~mm-mempool-do-not-allow-atomic-resizing fs/cifs/connect.c
--- a/fs/cifs/connect.c~mm-mempool-do-not-allow-atomic-resizing
+++ a/fs/cifs/connect.c
@@ -773,8 +773,7 @@ static void clean_demultiplex_info(struc
 
 	length = atomic_dec_return(&tcpSesAllocCount);
 	if (length > 0)
-		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
-				GFP_KERNEL);
+		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 }
 
 static int
@@ -848,8 +847,7 @@ cifs_demultiplex_thread(void *p)
 
 	length = atomic_inc_return(&tcpSesAllocCount);
 	if (length > 1)
-		mempool_resize(cifs_req_poolp, length + cifs_min_rcv,
-				GFP_KERNEL);
+		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 
 	set_freezable();
 	while (server->tcpStatus != CifsExiting) {
diff -puN include/linux/mempool.h~mm-mempool-do-not-allow-atomic-resizing include/linux/mempool.h
--- a/include/linux/mempool.h~mm-mempool-do-not-allow-atomic-resizing
+++ a/include/linux/mempool.h
@@ -29,7 +29,7 @@ extern mempool_t *mempool_create_node(in
 			mempool_free_t *free_fn, void *pool_data,
 			gfp_t gfp_mask, int nid);
 
-extern int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask);
+extern int mempool_resize(mempool_t *pool, int new_min_nr);
 extern void mempool_destroy(mempool_t *pool);
 extern void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask);
 extern void mempool_free(void *element, mempool_t *pool);
diff -puN mm/mempool.c~mm-mempool-do-not-allow-atomic-resizing mm/mempool.c
--- a/mm/mempool.c~mm-mempool-do-not-allow-atomic-resizing
+++ a/mm/mempool.c
@@ -113,23 +113,24 @@ EXPORT_SYMBOL(mempool_create_node);
  *              mempool_create().
  * @new_min_nr: the new minimum number of elements guaranteed to be
  *              allocated for this pool.
- * @gfp_mask:   the usual allocation bitmask.
  *
  * This function shrinks/grows the pool. In the case of growing,
  * it cannot be guaranteed that the pool will be grown to the new
  * size immediately, but new mempool_free() calls will refill it.
+ * This function may sleep.
  *
  * Note, the caller must guarantee that no mempool_destroy is called
  * while this function is running. mempool_alloc() & mempool_free()
  * might be called (eg. from IRQ contexts) while this function executes.
  */
-int mempool_resize(mempool_t *pool, int new_min_nr, gfp_t gfp_mask)
+int mempool_resize(mempool_t *pool, int new_min_nr)
 {
 	void *element;
 	void **new_elements;
 	unsigned long flags;
 
 	BUG_ON(new_min_nr <= 0);
+	might_sleep();
 
 	spin_lock_irqsave(&pool->lock, flags);
 	if (new_min_nr <= pool->min_nr) {
@@ -145,7 +146,8 @@ int mempool_resize(mempool_t *pool, int
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	/* Grow the pool */
-	new_elements = kmalloc(new_min_nr * sizeof(*new_elements), gfp_mask);
+	new_elements = kmalloc_array(new_min_nr, sizeof(*new_elements),
+				     GFP_KERNEL);
 	if (!new_elements)
 		return -ENOMEM;
 
@@ -164,7 +166,7 @@ int mempool_resize(mempool_t *pool, int
 
 	while (pool->curr_nr < pool->min_nr) {
 		spin_unlock_irqrestore(&pool->lock, flags);
-		element = pool->alloc(gfp_mask, pool->pool_data);
+		element = pool->alloc(GFP_KERNEL, pool->pool_data);
 		if (!element)
 			goto out;
 		spin_lock_irqsave(&pool->lock, flags);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
cxgb4-drop-__gfp_nofail-allocation.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix.patch
mm-compaction-reset-compaction-scanner-positions.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mremap-should-return-enomem-when-__vm_enough_memory-fail.patch
clean-up-goto-just-return-err_ptr.patch
fs-jfs-remove-slab-object-constructor.patch
mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch
mm-mempool-poison-elements-backed-by-slab-allocator.patch
mm-mempool-poison-elements-backed-by-page-allocator.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch
mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
thp-cleanup-khugepaged-startup.patch
mm-mempool-kasan-poison-mempool-elements.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

