From: akpm@linux-foundation.org
Subject: [merged] dma-debug-introduce-dma_debug_disabled.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:54:57 -0800
Message-ID: <5489e881.vCdzNZjyzeLkeRhj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaLKSy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: f.fainelli@gmail.com, computersforpeace@gmail.com, dan.j.williams@intel.com, horia.geanta@freescale.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: introduce dma_debug_disabled
has been removed from the -mm tree.  Its filename was
     dma-debug-introduce-dma_debug_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: dma-debug: introduce dma_debug_disabled

Add a helper function which returns whether the DMA debugging API is
disabled, right now we only check for global_disable, but in order to
accommodate early callers of the DMA-API, we will check for more
initialization flags in the next patch.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Horia Geanta <horia.geanta@freescale.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-introduce-dma_debug_disabled lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-introduce-dma_debug_disabled
+++ a/lib/dma-debug.c
@@ -102,6 +102,11 @@ static DEFINE_SPINLOCK(free_entries_lock
 /* Global disable flag - will be set in case of an error */
 static u32 global_disable __read_mostly;
 
+static inline bool dma_debug_disabled(void)
+{
+	return global_disable;
+}
+
 /* Global error count */
 static u32 error_count;
 
@@ -945,7 +950,7 @@ static int dma_debug_device_change(struc
 	struct dma_debug_entry *uninitialized_var(entry);
 	int count;
 
-	if (global_disable)
+	if (dma_debug_disabled())
 		return 0;
 
 	switch (action) {
@@ -973,7 +978,7 @@ void dma_debug_add_bus(struct bus_type *
 {
 	struct notifier_block *nb;
 
-	if (global_disable)
+	if (dma_debug_disabled())
 		return;
 
 	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
@@ -994,7 +999,7 @@ void dma_debug_init(u32 num_entries)
 {
 	int i;
 
-	if (global_disable)
+	if (dma_debug_disabled())
 		return;
 
 	for (i = 0; i < HASH_SIZE; ++i) {
@@ -1243,7 +1248,7 @@ void debug_dma_map_page(struct device *d
 {
 	struct dma_debug_entry *entry;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	if (dma_mapping_error(dev, dma_addr))
@@ -1283,7 +1288,7 @@ void debug_dma_mapping_error(struct devi
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.dev = dev;
@@ -1325,7 +1330,7 @@ void debug_dma_unmap_page(struct device
 		.direction      = direction,
 	};
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	if (map_single)
@@ -1342,7 +1347,7 @@ void debug_dma_map_sg(struct device *dev
 	struct scatterlist *s;
 	int i;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	for_each_sg(sg, s, mapped_ents, i) {
@@ -1395,7 +1400,7 @@ void debug_dma_unmap_sg(struct device *d
 	struct scatterlist *s;
 	int mapped_ents = 0, i;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	for_each_sg(sglist, s, nelems, i) {
@@ -1427,7 +1432,7 @@ void debug_dma_alloc_coherent(struct dev
 {
 	struct dma_debug_entry *entry;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	if (unlikely(virt == NULL))
@@ -1462,7 +1467,7 @@ void debug_dma_free_coherent(struct devi
 		.direction      = DMA_BIDIRECTIONAL,
 	};
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	check_unmap(&ref);
@@ -1474,7 +1479,7 @@ void debug_dma_sync_single_for_cpu(struc
 {
 	struct dma_debug_entry ref;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.type         = dma_debug_single;
@@ -1494,7 +1499,7 @@ void debug_dma_sync_single_for_device(st
 {
 	struct dma_debug_entry ref;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.type         = dma_debug_single;
@@ -1515,7 +1520,7 @@ void debug_dma_sync_single_range_for_cpu
 {
 	struct dma_debug_entry ref;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.type         = dma_debug_single;
@@ -1536,7 +1541,7 @@ void debug_dma_sync_single_range_for_dev
 {
 	struct dma_debug_entry ref;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	ref.type         = dma_debug_single;
@@ -1556,7 +1561,7 @@ void debug_dma_sync_sg_for_cpu(struct de
 	struct scatterlist *s;
 	int mapped_ents = 0, i;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
@@ -1589,7 +1594,7 @@ void debug_dma_sync_sg_for_device(struct
 	struct scatterlist *s;
 	int mapped_ents = 0, i;
 
-	if (unlikely(global_disable))
+	if (unlikely(dma_debug_disabled()))
 		return;
 
 	for_each_sg(sg, s, nelems, i) {
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

origin.patch
linux-next.patch

