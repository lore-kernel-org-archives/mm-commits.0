From: akpm@osdl.org
Subject: - add-numa-node-information-to-struct-device.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:14 -0800
Message-ID: <200612072257.kB7MvE2J029265@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163606AbWLGW51 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, clameter@engr.sgi.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     add numa node information to struct device
has been removed from the -mm tree.  Its filename was
     add-numa-node-information-to-struct-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add numa node information to struct device
From: Christoph Hellwig <hch@lst.de>

For node-aware skb allocations we need information about the node in struct
net_device or struct device.  Davem suggested to put it into struct device
which this patch does.

In particular:

 - struct device gets a new int numa_node member if CONFIG_NUMA is set
 - there are two new helpers, dev_to_node and set_dev_node to
   transparently deal with the non-numa case
 - for pci devices the node-info is set to the value we get from
   pcibus_to_node.

Note that for some architectures pcibus_to_node doesn't work yet at the time
we call it currently.  This is harmless and will just mean skb allocations
aren't node-local on this architectures until the implementation of
pcibus_to_node on these architectures have been updated (There are patches for
x86 and x86_64 floating around)

[akpm@osdl.org: cleanup]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/base/core.c    |    1 +
 drivers/pci/probe.c    |    1 +
 include/linux/device.h |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+)

diff -puN drivers/base/core.c~add-numa-node-information-to-struct-device drivers/base/core.c
--- a/drivers/base/core.c~add-numa-node-information-to-struct-device
+++ a/drivers/base/core.c
@@ -386,6 +386,7 @@ void device_initialize(struct device *de
 	INIT_LIST_HEAD(&dev->node);
 	init_MUTEX(&dev->sem);
 	device_init_wakeup(dev, 0);
+	set_dev_node(dev, -1);
 }
 
 #ifdef CONFIG_SYSFS_DEPRECATED
diff -puN drivers/pci/probe.c~add-numa-node-information-to-struct-device drivers/pci/probe.c
--- a/drivers/pci/probe.c~add-numa-node-information-to-struct-device
+++ a/drivers/pci/probe.c
@@ -873,6 +873,7 @@ void __devinit pci_device_add(struct pci
 	dev->dev.release = pci_release_dev;
 	pci_dev_get(dev);
 
+	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
diff -puN include/linux/device.h~add-numa-node-information-to-struct-device include/linux/device.h
--- a/include/linux/device.h~add-numa-node-information-to-struct-device
+++ a/include/linux/device.h
@@ -371,6 +371,9 @@ struct device {
 					   core doesn't touch it */
 	struct dev_pm_info	power;
 
+#ifdef CONFIG_NUMA
+	int		numa_node;	/* NUMA node this device is close to */
+#endif
 	u64		*dma_mask;	/* dma mask (if dma'able device) */
 	u64		coherent_dma_mask;/* Like dma_mask, but for
 					     alloc_coherent mappings as
@@ -394,6 +397,25 @@ struct device {
 	void	(*release)(struct device * dev);
 };
 
+#ifdef CONFIG_NUMA
+static inline int dev_to_node(struct device *dev)
+{
+	return dev->numa_node;
+}
+static inline void set_dev_node(struct device *dev, int node)
+{
+	dev->numa_node = node;
+}
+#else
+static inline int dev_to_node(struct device *dev)
+{
+	return -1;
+}
+static inline void set_dev_node(struct device *dev, int node)
+{
+}
+#endif
+
 static inline void *
 dev_get_drvdata (struct device *dev)
 {
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
touch_atime-cleanup.patch
relative-atime.patch
ocfs2-relative-atime-support.patch
ocfs2-relative-atime-support-tweaks.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
fdtable-delete-pointless-code-in-dup_fd.patch
fdtable-make-fdarray-and-fdsets-equal-in-size.patch
fdtable-remove-the-free_files-field.patch
fdtable-implement-new-pagesize-based-fdtable-allocator.patch

