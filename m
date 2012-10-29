From: akpm@linux-foundation.org
Subject: [merged] dma-debug-new-interfaces-to-debug-dma-mapping-errors.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:49:25 -0700
Message-ID: <20121029194926.3849E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:34369 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2J2Tt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:49:28 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so344293wey.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:49:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuah.khan@hp.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: new interfaces to debug dma mapping errors
has been removed from the -mm tree.  Its filename was
     dma-debug-new-interfaces-to-debug-dma-mapping-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.khan@hp.com>
Subject: dma-debug: new interfaces to debug dma mapping errors

Add dma-debug interface debug_dma_mapping_error() to debug drivers that
fail to check dma mapping errors on addresses returned by dma_map_single()
and dma_map_page() interfaces.  This interface clears a flag set by
debug_dma_map_page() to indicate that dma_mapping_error() has been called
by the driver.  When driver does unmap, debug_dma_unmap() checks the flag
and if this flag is still set, prints warning message that includes call
trace that leads up to the unmap.  This interface can be called from
dma_mapping_error() routines to enable dma mapping error check debugging.

Tested: Intel iommu and swiotlb (iommu=soft) on x86-64 with
        CONFIG_DMA_API_DEBUG enabled and disabled.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt          |   12 ++++
 arch/x86/include/asm/dma-mapping.h |    1 
 include/linux/dma-debug.h          |    7 ++
 lib/dma-debug.c                    |   71 +++++++++++++++++++++++++--
 4 files changed, 87 insertions(+), 4 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-debug-new-interfaces-to-debug-dma-mapping-errors Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-debug-new-interfaces-to-debug-dma-mapping-errors
+++ a/Documentation/DMA-API.txt
@@ -678,3 +678,15 @@ out of dma_debug_entries. These entries 
 of preallocated entries is defined per architecture. If it is too low for you
 boot with 'dma_debug_entries=<your_desired_number>' to overwrite the
 architectural default.
+
+void debug_dmap_mapping_error(struct device *dev, dma_addr_t dma_addr);
+
+dma-debug interface debug_dma_mapping_error() to debug drivers that fail
+to check dma mapping errors on addresses returned by dma_map_single() and
+dma_map_page() interfaces. This interface clears a flag set by
+debug_dma_map_page() to indicate that dma_mapping_error() has been called by
+the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
+this flag is still set, prints warning message that includes call trace that
+leads up to the unmap. This interface can be called from dma_mapping_error()
+routines to enable dma mapping error check debugging.
+
diff -puN arch/x86/include/asm/dma-mapping.h~dma-debug-new-interfaces-to-debug-dma-mapping-errors arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-debug-new-interfaces-to-debug-dma-mapping-errors
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -47,6 +47,7 @@ static inline struct dma_map_ops *get_dm
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
+	debug_dma_mapping_error(dev, dma_addr);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
diff -puN include/linux/dma-debug.h~dma-debug-new-interfaces-to-debug-dma-mapping-errors include/linux/dma-debug.h
--- a/include/linux/dma-debug.h~dma-debug-new-interfaces-to-debug-dma-mapping-errors
+++ a/include/linux/dma-debug.h
@@ -39,6 +39,8 @@ extern void debug_dma_map_page(struct de
 			       int direction, dma_addr_t dma_addr,
 			       bool map_single);
 
+extern void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
+
 extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 				 size_t size, int direction, bool map_single);
 
@@ -105,6 +107,11 @@ static inline void debug_dma_map_page(st
 {
 }
 
+static inline void debug_dma_mapping_error(struct device *dev,
+					  dma_addr_t dma_addr)
+{
+}
+
 static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 					size_t size, int direction,
 					bool map_single)
diff -puN lib/dma-debug.c~dma-debug-new-interfaces-to-debug-dma-mapping-errors lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-new-interfaces-to-debug-dma-mapping-errors
+++ a/lib/dma-debug.c
@@ -45,6 +45,12 @@ enum {
 	dma_debug_coherent,
 };
 
+enum map_err_types {
+	MAP_ERR_CHECK_NOT_APPLICABLE,
+	MAP_ERR_NOT_CHECKED,
+	MAP_ERR_CHECKED,
+};
+
 #define DMA_DEBUG_STACKTRACE_ENTRIES 5
 
 struct dma_debug_entry {
@@ -57,6 +63,7 @@ struct dma_debug_entry {
 	int              direction;
 	int		 sg_call_ents;
 	int		 sg_mapped_ents;
+	enum map_err_types  map_err_type;
 #ifdef CONFIG_STACKTRACE
 	struct		 stack_trace stacktrace;
 	unsigned long	 st_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
@@ -114,6 +121,12 @@ static struct device_driver *current_dri
 
 static DEFINE_RWLOCK(driver_name_lock);
 
+static const char *const maperr2str[] = {
+	[MAP_ERR_CHECK_NOT_APPLICABLE] = "dma map error check not applicable",
+	[MAP_ERR_NOT_CHECKED] = "dma map error not checked",
+	[MAP_ERR_CHECKED] = "dma map error checked",
+};
+
 static const char *type2name[4] = { "single", "page",
 				    "scather-gather", "coherent" };
 
@@ -376,11 +389,12 @@ void debug_dma_dump_mappings(struct devi
 		list_for_each_entry(entry, &bucket->list, list) {
 			if (!dev || dev == entry->dev) {
 				dev_info(entry->dev,
-					 "%s idx %d P=%Lx D=%Lx L=%Lx %s\n",
+					 "%s idx %d P=%Lx D=%Lx L=%Lx %s %s\n",
 					 type2name[entry->type], idx,
 					 (unsigned long long)entry->paddr,
 					 entry->dev_addr, entry->size,
-					 dir2name[entry->direction]);
+					 dir2name[entry->direction],
+					 maperr2str[entry->map_err_type]);
 			}
 		}
 
@@ -838,13 +852,28 @@ static __init int dma_debug_entries_cmdl
 __setup("dma_debug=", dma_debug_cmdline);
 __setup("dma_debug_entries=", dma_debug_entries_cmdline);
 
+/* Calling dma_mapping_error() from dma-debug api will result in calling
+   debug_dma_mapping_error() - need internal mapping error routine to
+   avoid debug checks */
+#ifndef DMA_ERROR_CODE
+#define DMA_ERROR_CODE 0
+#endif
+static inline int has_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	if (ops->mapping_error)
+		return ops->mapping_error(dev, dma_addr);
+
+	return (dma_addr == DMA_ERROR_CODE);
+}
+
 static void check_unmap(struct dma_debug_entry *ref)
 {
 	struct dma_debug_entry *entry;
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
+	if (unlikely(has_mapping_error(ref->dev, ref->dev_addr))) {
 		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
 			   "to free an invalid DMA memory address\n");
 		return;
@@ -910,6 +939,15 @@ static void check_unmap(struct dma_debug
 			   dir2name[ref->direction]);
 	}
 
+	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
+		err_printk(ref->dev, entry,
+			   "DMA-API: device driver failed to check map error"
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped as %s]",
+			   ref->dev_addr, ref->size,
+			   type2name[entry->type]);
+	}
+
 	hash_bucket_del(entry);
 	dma_entry_free(entry);
 
@@ -1017,7 +1055,7 @@ void debug_dma_map_page(struct device *d
 	if (unlikely(global_disable))
 		return;
 
-	if (unlikely(dma_mapping_error(dev, dma_addr)))
+	if (unlikely(has_mapping_error(dev, dma_addr)))
 		return;
 
 	entry = dma_entry_alloc();
@@ -1030,6 +1068,7 @@ void debug_dma_map_page(struct device *d
 	entry->dev_addr  = dma_addr;
 	entry->size      = size;
 	entry->direction = direction;
+	entry->map_err_type = MAP_ERR_NOT_CHECKED;
 
 	if (map_single)
 		entry->type = dma_debug_single;
@@ -1045,6 +1084,30 @@ void debug_dma_map_page(struct device *d
 }
 EXPORT_SYMBOL(debug_dma_map_page);
 
+void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	struct dma_debug_entry ref;
+	struct dma_debug_entry *entry;
+	struct hash_bucket *bucket;
+	unsigned long flags;
+
+	if (unlikely(global_disable))
+		return;
+
+	ref.dev = dev;
+	ref.dev_addr = dma_addr;
+	bucket = get_hash_bucket(&ref, &flags);
+	entry = bucket_find_exact(bucket, &ref);
+
+	if (!entry)
+		goto out;
+
+	entry->map_err_type = MAP_ERR_CHECKED;
+out:
+	put_hash_bucket(bucket, &flags);
+}
+EXPORT_SYMBOL(debug_dma_mapping_error);
+
 void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 			  size_t size, int direction, bool map_single)
 {
_

Patches currently in -mm which might be from shuah.khan@hp.com are

linux-next.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch

