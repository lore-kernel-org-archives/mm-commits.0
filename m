From: akpm@linux-foundation.org
Subject: + dma-debug-introduce-debug_dma_assert_idle.patch added to -mm
 tree
Date: Tue, 14 Jan 2014 16:01:53 -0800
Message-ID: <52d5cff1.tkkkORficiLx0yA1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAOABy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 19:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vinod.koul@intel.com, rmk+kernel@arm.linux.org.uk, joro@8bytes.org, JBottomley@Parallels.com, dan.j.williams@intel.com

Subject: + dma-debug-introduce-debug_dma_assert_idle.patch added to -mm tree
To: dan.j.williams@intel.com,JBottomley@Parallels.com,joro@8bytes.org,rmk+kernel@arm.linux.org.uk,vinod.koul@intel.com
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 16:01:53 -0800


The patch titled
     Subject: dma-debug: introduce debug_dma_assert_idle()
has been added to the -mm tree.  Its filename is
     dma-debug-introduce-debug_dma_assert_idle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-introduce-debug_dma_assert_idle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-introduce-debug_dma_assert_idle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dma-debug: introduce debug_dma_assert_idle()

Record actively mapped pages and provide an api for asserting a given page
is dma inactive before execution proceeds.  Placing
debug_dma_assert_idle() in cow_user_page() flagged the violation of the
dma-api in the NET_DMA implementation (see commit 77873803363c "net_dma:
mark broken").

The implementation includes the capability to count, in a limited way,
repeat mappings of the same page that occur without an intervening unmap. 
This 'overlap' counter is limited to the few bits of tag space in a radix
tree.  This mechanism is added to mitigate false negative cases where, for
example, a page is dma mapped twice and debug_dma_assert_idle() is called
after the page is un-mapped once.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-debug.h |    6 +
 lib/Kconfig.debug         |   12 +-
 lib/dma-debug.c           |  193 +++++++++++++++++++++++++++++++++---
 mm/memory.c               |    3 
 4 files changed, 199 insertions(+), 15 deletions(-)

diff -puN include/linux/dma-debug.h~dma-debug-introduce-debug_dma_assert_idle include/linux/dma-debug.h
--- a/include/linux/dma-debug.h~dma-debug-introduce-debug_dma_assert_idle
+++ a/include/linux/dma-debug.h
@@ -85,6 +85,8 @@ extern void debug_dma_sync_sg_for_device
 
 extern void debug_dma_dump_mappings(struct device *dev);
 
+extern void debug_dma_assert_idle(struct page *page);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_add_bus(struct bus_type *bus)
@@ -183,6 +185,10 @@ static inline void debug_dma_dump_mappin
 {
 }
 
+static inline void debug_dma_assert_idle(struct page *page)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff -puN lib/Kconfig.debug~dma-debug-introduce-debug_dma_assert_idle lib/Kconfig.debug
--- a/lib/Kconfig.debug~dma-debug-introduce-debug_dma_assert_idle
+++ a/lib/Kconfig.debug
@@ -1575,8 +1575,16 @@ config DMA_API_DEBUG
 	  With this option you will be able to detect common bugs in device
 	  drivers like double-freeing of DMA mappings or freeing mappings that
 	  were never allocated.
-	  This option causes a performance degredation.  Use only if you want
-	  to debug device drivers. If unsure, say N.
+
+	  This also attempts to catch cases where a page owned by DMA is
+	  accessed by the cpu in a way that could cause data corruption.  For
+	  example, this enables cow_user_page() to check that the source page is
+	  not undergoing DMA.
+
+	  This option causes a performance degradation.  Use only if you want to
+	  debug device drivers and dma interactions.
+
+	  If unsure, say N.
 
 source "samples/Kconfig"
 
diff -puN lib/dma-debug.c~dma-debug-introduce-debug_dma_assert_idle lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-introduce-debug_dma_assert_idle
+++ a/lib/dma-debug.c
@@ -53,11 +53,26 @@ enum map_err_types {
 
 #define DMA_DEBUG_STACKTRACE_ENTRIES 5
 
+/**
+ * struct dma_debug_entry - track a dma_map* or dma_alloc_coherent mapping
+ * @list: node on pre-allocated free_entries list
+ * @dev: 'dev' argument to dma_map_{page|single|sg} or dma_alloc_coherent
+ * @type: single, page, sg, coherent
+ * @pfn: page frame of the start address
+ * @offset: offset of mapping relative to pfn
+ * @size: length of the mapping
+ * @direction: enum dma_data_direction
+ * @sg_call_ents: 'nents' from dma_map_sg
+ * @sg_mapped_ents: 'mapped_ents' from dma_map_sg
+ * @map_err_type: track whether dma_mapping_error() was checked
+ * @stacktrace: support backtraces when a violation is detected
+ */
 struct dma_debug_entry {
 	struct list_head list;
 	struct device    *dev;
 	int              type;
-	phys_addr_t      paddr;
+	unsigned long	 pfn;
+	size_t		 offset;
 	u64              dev_addr;
 	u64              size;
 	int              direction;
@@ -372,6 +387,11 @@ static void hash_bucket_del(struct dma_d
 	list_del(&entry->list);
 }
 
+static unsigned long long phys_addr(struct dma_debug_entry *entry)
+{
+	return page_to_phys(pfn_to_page(entry->pfn)) + entry->offset;
+}
+
 /*
  * Dump mapping entries for debugging purposes
  */
@@ -389,9 +409,9 @@ void debug_dma_dump_mappings(struct devi
 		list_for_each_entry(entry, &bucket->list, list) {
 			if (!dev || dev == entry->dev) {
 				dev_info(entry->dev,
-					 "%s idx %d P=%Lx D=%Lx L=%Lx %s %s\n",
+					 "%s idx %d P=%Lx N=%lx D=%Lx L=%Lx %s %s\n",
 					 type2name[entry->type], idx,
-					 (unsigned long long)entry->paddr,
+					 phys_addr(entry), entry->pfn,
 					 entry->dev_addr, entry->size,
 					 dir2name[entry->direction],
 					 maperr2str[entry->map_err_type]);
@@ -404,6 +424,133 @@ void debug_dma_dump_mappings(struct devi
 EXPORT_SYMBOL(debug_dma_dump_mappings);
 
 /*
+ * For each page mapped (initial page in the case of
+ * dma_alloc_coherent/dma_map_{single|page}, or each page in a
+ * scatterlist) insert into this tree using the pfn as the key. At
+ * dma_unmap_{single|sg|page} or dma_free_coherent delete the entry.  If
+ * the pfn already exists at insertion time add a tag as a reference
+ * count for the overlapping mappings.  For now, the overlap tracking
+ * just ensures that 'unmaps' balance 'maps' before marking the pfn
+ * idle, but we should also be flagging overlaps as an API violation.
+ *
+ * Memory usage is mostly constrained by the maximum number of available
+ * dma-debug entries in that we need a free dma_debug_entry before
+ * inserting into the tree.  In the case of dma_map_{single|page} and
+ * dma_alloc_coherent there is only one dma_debug_entry and one pfn to
+ * track per event.  dma_map_sg(), on the other hand,
+ * consumes a single dma_debug_entry, but inserts 'nents' entries into
+ * the tree.
+ *
+ * At any time debug_dma_assert_idle() can be called to trigger a
+ * warning if the given page is in the active set.
+ */
+static RADIX_TREE(dma_active_pfn, GFP_NOWAIT);
+static DEFINE_SPINLOCK(radix_lock);
+#define ACTIVE_PFN_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
+
+static int active_pfn_read_overlap(unsigned long pfn)
+{
+	int overlap = 0, i;
+
+	for (i = RADIX_TREE_MAX_TAGS - 1; i >= 0; i--)
+		if (radix_tree_tag_get(&dma_active_pfn, pfn, i))
+			overlap |= 1 << i;
+	return overlap;
+}
+
+static int active_pfn_set_overlap(unsigned long pfn, int overlap)
+{
+	int i;
+
+	if (overlap > ACTIVE_PFN_MAX_OVERLAP || overlap < 0)
+		return 0;
+
+	for (i = RADIX_TREE_MAX_TAGS - 1; i >= 0; i--)
+		if (overlap & 1 << i)
+			radix_tree_tag_set(&dma_active_pfn, pfn, i);
+		else
+			radix_tree_tag_clear(&dma_active_pfn, pfn, i);
+
+	return overlap;
+}
+
+static void active_pfn_inc_overlap(unsigned long pfn)
+{
+	int overlap = active_pfn_read_overlap(pfn);
+
+	overlap = active_pfn_set_overlap(pfn, ++overlap);
+
+	/* If we overflowed the overlap counter then we're potentially
+	 * leaking dma-mappings.  Otherwise, if maps and unmaps are
+	 * balanced then this overflow may cause false negatives in
+	 * debug_dma_assert_idle() as the pfn may be marked idle
+	 * prematurely.
+	 */
+	WARN_ONCE(overlap == 0,
+		  "DMA-API: exceeded %d overlapping mappings of pfn %lx\n",
+		  ACTIVE_PFN_MAX_OVERLAP, pfn);
+}
+
+static int active_pfn_dec_overlap(unsigned long pfn)
+{
+	int overlap = active_pfn_read_overlap(pfn);
+
+	return active_pfn_set_overlap(pfn, --overlap);
+}
+
+static int active_pfn_insert(struct dma_debug_entry *entry)
+{
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&radix_lock, flags);
+	rc = radix_tree_insert(&dma_active_pfn, entry->pfn, entry);
+	if (rc == -EEXIST)
+		active_pfn_inc_overlap(entry->pfn);
+	spin_unlock_irqrestore(&radix_lock, flags);
+
+	return rc;
+}
+
+static void active_pfn_remove(struct dma_debug_entry *entry)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&radix_lock, flags);
+	if (active_pfn_dec_overlap(entry->pfn) == 0)
+		radix_tree_delete(&dma_active_pfn, entry->pfn);
+	spin_unlock_irqrestore(&radix_lock, flags);
+}
+
+/**
+ * debug_dma_assert_idle() - assert that a page is not undergoing dma
+ * @page: page to lookup in the dma_active_pfn tree
+ *
+ * Place a call to this routine in cases where the cpu touching the page
+ * before the dma completes (page is dma_unmapped) will lead to data
+ * corruption.
+ */
+void debug_dma_assert_idle(struct page *page)
+{
+	unsigned long flags;
+	struct dma_debug_entry *entry;
+
+	if (!page)
+		return;
+
+	spin_lock_irqsave(&radix_lock, flags);
+	entry = radix_tree_lookup(&dma_active_pfn, page_to_pfn(page));
+	spin_unlock_irqrestore(&radix_lock, flags);
+
+	if (!entry)
+		return;
+
+	err_printk(entry->dev, entry,
+		   "DMA-API: cpu touching an active dma mapped page "
+		   "[pfn=0x%lx]\n", entry->pfn);
+}
+
+/*
  * Wrapper function for adding an entry to the hash.
  * This function takes care of locking itself.
  */
@@ -411,10 +558,21 @@ static void add_dma_entry(struct dma_deb
 {
 	struct hash_bucket *bucket;
 	unsigned long flags;
+	int rc;
 
 	bucket = get_hash_bucket(entry, &flags);
 	hash_bucket_add(bucket, entry);
 	put_hash_bucket(bucket, &flags);
+
+	rc = active_pfn_insert(entry);
+	if (rc == -ENOMEM) {
+		pr_err("DMA-API: pfn tracking ENOMEM, dma-debug disabled\n");
+		global_disable = true;
+	}
+
+	/* TODO: report -EEXIST errors here as overlapping mappings are
+	 * not supported by the DMA API
+	 */
 }
 
 static struct dma_debug_entry *__dma_entry_alloc(void)
@@ -469,6 +627,8 @@ static void dma_entry_free(struct dma_de
 {
 	unsigned long flags;
 
+	active_pfn_remove(entry);
+
 	/*
 	 * add to beginning of the list - this way the entries are
 	 * more likely cache hot when they are reallocated.
@@ -895,15 +1055,15 @@ static void check_unmap(struct dma_debug
 			   ref->dev_addr, ref->size,
 			   type2name[entry->type], type2name[ref->type]);
 	} else if ((entry->type == dma_debug_coherent) &&
-		   (ref->paddr != entry->paddr)) {
+		   (phys_addr(ref) != phys_addr(entry))) {
 		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different CPU address "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[cpu alloc address=0x%016llx] "
 			   "[cpu free address=0x%016llx]",
 			   ref->dev_addr, ref->size,
-			   (unsigned long long)entry->paddr,
-			   (unsigned long long)ref->paddr);
+			   phys_addr(entry),
+			   phys_addr(ref));
 	}
 
 	if (ref->sg_call_ents && ref->type == dma_debug_sg &&
@@ -1052,7 +1212,8 @@ void debug_dma_map_page(struct device *d
 
 	entry->dev       = dev;
 	entry->type      = dma_debug_page;
-	entry->paddr     = page_to_phys(page) + offset;
+	entry->pfn	 = page_to_pfn(page);
+	entry->offset	 = offset,
 	entry->dev_addr  = dma_addr;
 	entry->size      = size;
 	entry->direction = direction;
@@ -1148,7 +1309,8 @@ void debug_dma_map_sg(struct device *dev
 
 		entry->type           = dma_debug_sg;
 		entry->dev            = dev;
-		entry->paddr          = sg_phys(s);
+		entry->pfn	      = page_to_pfn(sg_page(s));
+		entry->offset	      = s->offset,
 		entry->size           = sg_dma_len(s);
 		entry->dev_addr       = sg_dma_address(s);
 		entry->direction      = direction;
@@ -1198,7 +1360,8 @@ void debug_dma_unmap_sg(struct device *d
 		struct dma_debug_entry ref = {
 			.type           = dma_debug_sg,
 			.dev            = dev,
-			.paddr          = sg_phys(s),
+			.pfn		= page_to_pfn(sg_page(s)),
+			.offset		= s->offset,
 			.dev_addr       = sg_dma_address(s),
 			.size           = sg_dma_len(s),
 			.direction      = dir,
@@ -1233,7 +1396,8 @@ void debug_dma_alloc_coherent(struct dev
 
 	entry->type      = dma_debug_coherent;
 	entry->dev       = dev;
-	entry->paddr     = virt_to_phys(virt);
+	entry->pfn	 = page_to_pfn(virt_to_page(virt));
+	entry->offset	 = (size_t) virt & PAGE_MASK;
 	entry->size      = size;
 	entry->dev_addr  = dma_addr;
 	entry->direction = DMA_BIDIRECTIONAL;
@@ -1248,7 +1412,8 @@ void debug_dma_free_coherent(struct devi
 	struct dma_debug_entry ref = {
 		.type           = dma_debug_coherent,
 		.dev            = dev,
-		.paddr          = virt_to_phys(virt),
+		.pfn		= page_to_pfn(virt_to_page(virt)),
+		.offset		= (size_t) virt & PAGE_MASK,
 		.dev_addr       = addr,
 		.size           = size,
 		.direction      = DMA_BIDIRECTIONAL,
@@ -1356,7 +1521,8 @@ void debug_dma_sync_sg_for_cpu(struct de
 		struct dma_debug_entry ref = {
 			.type           = dma_debug_sg,
 			.dev            = dev,
-			.paddr          = sg_phys(s),
+			.pfn		= page_to_pfn(sg_page(s)),
+			.offset		= s->offset,
 			.dev_addr       = sg_dma_address(s),
 			.size           = sg_dma_len(s),
 			.direction      = direction,
@@ -1388,7 +1554,8 @@ void debug_dma_sync_sg_for_device(struct
 		struct dma_debug_entry ref = {
 			.type           = dma_debug_sg,
 			.dev            = dev,
-			.paddr          = sg_phys(s),
+			.pfn		= page_to_pfn(sg_page(s)),
+			.offset		= s->offset,
 			.dev_addr       = sg_dma_address(s),
 			.size           = sg_dma_len(s),
 			.direction      = direction,
diff -puN mm/memory.c~dma-debug-introduce-debug_dma_assert_idle mm/memory.c
--- a/mm/memory.c~dma-debug-introduce-debug_dma_assert_idle
+++ a/mm/memory.c
@@ -59,6 +59,7 @@
 #include <linux/gfp.h>
 #include <linux/migrate.h>
 #include <linux/string.h>
+#include <linux/dma-debug.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -2559,6 +2560,8 @@ static inline int pte_unmap_same(struct
 
 static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va, struct vm_area_struct *vma)
 {
+	debug_dma_assert_idle(src);
+
 	/*
 	 * If the source page was a PFN mapping, we don't have
 	 * a "struct page" for it. We do a best-effort copy by
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dma-debug-introduce-debug_dma_assert_idle.patch
linux-next.patch

