From: akpm@linux-foundation.org
Subject: - pci-iommu-iotlb-flushing-speedup.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:42:08 -0700
Message-ID: <200804261642.m3QGg8Yo031184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782AbYDZQmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, greg@kroah.com, grundler@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     pci-iommu-iotlb-flushing-speedup
has been removed from the -mm tree.  Its filename was
     pci-iommu-iotlb-flushing-speedup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-iommu-iotlb-flushing-speedup
From: mark gross <mgross@linux.intel.com>

The following patch is an update to use an array instead of a list of
IOVA's in the implementation of defered iotlb flushes.  It takes
inspiration from sba_iommu.c

I like this implementation better as it encapsulates the batch process
within intel-iommu.c, and no longer touches iova.h (which is shared)

Performance data:  Netperf 32byte UDP streaming
2.6.25-rc3-mm1:
IOMMU-strict : 58Mps @ 62% cpu
NO-IOMMU : 71Mbs @ 41% cpu
List-based IOMMU-default-batched-IOTLB flush: 66Mbps @ 57% cpu

with this patch:
IOMMU-strict : 73Mps @ 75% cpu
NO-IOMMU : 74Mbs @ 42% cpu
Array-based IOMMU-default-batched-IOTLB flush: 72Mbps @ 62% cpu

Signed-off-by: <mgross@linux.intel.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   76 ++++++++++++++++++------------------
 drivers/pci/iova.h        |    2 
 2 files changed, 40 insertions(+), 38 deletions(-)

diff -puN drivers/pci/intel-iommu.c~pci-iommu-iotlb-flushing-speedup drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~pci-iommu-iotlb-flushing-speedup
+++ a/drivers/pci/intel-iommu.c
@@ -59,8 +59,17 @@ static void flush_unmaps_timeout(unsigne
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
 
 static struct intel_iommu *g_iommus;
+
+#define HIGH_WATER_MARK 250
+struct deferred_flush_tables {
+	int next;
+	struct iova *iova[HIGH_WATER_MARK];
+	struct dmar_domain *domain[HIGH_WATER_MARK];
+};
+
+static struct deferred_flush_tables *deferred_flush;
+
 /* bitmap for indexing intel_iommus */
-static unsigned long 	*g_iommus_to_flush;
 static int g_num_of_iommus;
 
 static DEFINE_SPINLOCK(async_umap_flush_lock);
@@ -68,10 +77,6 @@ static LIST_HEAD(unmaps_to_do);
 
 static int timer_on;
 static long list_size;
-static int high_watermark;
-
-static struct dentry *intel_iommu_debug, *debug;
-
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
@@ -1692,7 +1697,7 @@ int __init init_dmars(void)
 	struct dmar_rmrr_unit *rmrr;
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
-	int nlongs, i, ret, unit = 0;
+	int i, ret, unit = 0;
 
 	/*
 	 * for each drhd
@@ -1711,17 +1716,16 @@ int __init init_dmars(void)
 		 */
 	}
 
-	nlongs = BITS_TO_LONGS(g_num_of_iommus);
-	g_iommus_to_flush = kzalloc(nlongs * sizeof(unsigned long), GFP_KERNEL);
-	if (!g_iommus_to_flush) {
-		printk(KERN_ERR "Intel-IOMMU: "
-			"Allocating bitmap array failed\n");
-		return -ENOMEM;
-	}
-
 	g_iommus = kzalloc(g_num_of_iommus * sizeof(*iommu), GFP_KERNEL);
 	if (!g_iommus) {
-		kfree(g_iommus_to_flush);
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	deferred_flush = kzalloc(g_num_of_iommus *
+		sizeof(struct deferred_flush_tables), GFP_KERNEL);
+	if (!deferred_flush) {
+		kfree(g_iommus);
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -1970,42 +1974,48 @@ error:
 
 static void flush_unmaps(void)
 {
-	struct iova *node, *n;
-	unsigned long flags;
-	int i;
+	int i, j;
 
-	spin_lock_irqsave(&async_umap_flush_lock, flags);
 	timer_on = 0;
 
 	/* just flush them all */
 	for (i = 0; i < g_num_of_iommus; i++) {
-		if (test_and_clear_bit(i, g_iommus_to_flush))
+		if (deferred_flush[i].next) {
 			iommu_flush_iotlb_global(&g_iommus[i], 0);
+			for (j = 0; j < deferred_flush[i].next; j++) {
+				__free_iova(&deferred_flush[i].domain[j]->iovad,
+						deferred_flush[i].iova[j]);
+			}
+			deferred_flush[i].next = 0;
+		}
 	}
 
-	list_for_each_entry_safe(node, n, &unmaps_to_do, list) {
-		/* free iova */
-		list_del(&node->list);
-		__free_iova(&((struct dmar_domain *)node->dmar)->iovad, node);
-
-	}
 	list_size = 0;
-	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
 }
 
 static void flush_unmaps_timeout(unsigned long data)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&async_umap_flush_lock, flags);
 	flush_unmaps();
+	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
 }
 
 static void add_unmap(struct dmar_domain *dom, struct iova *iova)
 {
 	unsigned long flags;
+	int next, iommu_id;
 
 	spin_lock_irqsave(&async_umap_flush_lock, flags);
-	iova->dmar = dom;
-	list_add(&iova->list, &unmaps_to_do);
-	set_bit((dom->iommu - g_iommus), g_iommus_to_flush);
+	if (list_size == HIGH_WATER_MARK)
+		flush_unmaps();
+
+	iommu_id = dom->iommu - g_iommus;
+	next = deferred_flush[iommu_id].next;
+	deferred_flush[iommu_id].domain[next] = dom;
+	deferred_flush[iommu_id].iova[next] = iova;
+	deferred_flush[iommu_id].next++;
 
 	if (!timer_on) {
 		mod_timer(&unmap_timer, jiffies + msecs_to_jiffies(10));
@@ -2054,8 +2064,6 @@ static void intel_unmap_single(struct de
 		 * queue up the release of the unmap to save the 1/6th of the
 		 * cpu used up by the iotlb flush operation...
 		 */
-		if (list_size > high_watermark)
-			flush_unmaps();
 	}
 }
 
@@ -2380,10 +2388,6 @@ int __init intel_iommu_init(void)
 	if (dmar_table_init())
 		return 	-ENODEV;
 
-	high_watermark = 250;
-	intel_iommu_debug = debugfs_create_dir("intel_iommu", NULL);
-	debug = debugfs_create_u32("high_watermark", S_IWUGO | S_IRUGO,
-					intel_iommu_debug, &high_watermark);
 	iommu_init_mempool();
 	dmar_init_reserved_ranges();
 
diff -puN drivers/pci/iova.h~pci-iommu-iotlb-flushing-speedup drivers/pci/iova.h
--- a/drivers/pci/iova.h~pci-iommu-iotlb-flushing-speedup
+++ a/drivers/pci/iova.h
@@ -24,8 +24,6 @@ struct iova {
 	struct rb_node	node;
 	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
 	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
-	struct list_head list;
-	void *dmar;
 };
 
 /* holds all the iova translations for a domain */
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch

