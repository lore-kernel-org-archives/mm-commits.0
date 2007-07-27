From: akpm@linux-foundation.org
Subject: - try-parent-numa_node-at-first-before-using-default-v2.patch removed from -mm tree
Date: Thu, 26 Jul 2007 23:20:41 -0700
Message-ID: <200707270620.l6R6KfJB009231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066AbXG0GVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, clameter@sgi.com, cornelia.huck@de.ibm.com, davem@davemloft.net, greg@kroah.com, hch@infradead.org, rientjes@google.com, stefanr@s5r6.in-berlin.de, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     pci: try parent numa_node before using default
has been removed from the -mm tree.  Its filename was
     try-parent-numa_node-at-first-before-using-default-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pci: try parent numa_node before using default
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

For pci_device, pcibios_scan_root and pci_scan_root will call
pci_device_add.  pci_device_add will call device_initialize and
set_dev_node(&dev->dev, pcibus_to_node(bus)).  other device such as netdev,
and usb_device, set_dev_node is never be used.  So that field numa_node
always is -1.

So for netdev, it will need to use dev->parent to get pci_device to use
it's numa_node.  esp in netdev_alloc_skb() not sure how other device such
as infiniband do that.

Actually before patch
[PATCH 1/2] x86_64: get mp_bus_to_node as early
there is a bug about squence of bus->sysdata and using pcibus_to_node.
the numa_node of pci_dev->dev is never set correctly...always 0.

So some device have to use pcibus_to_node(to_pci_dev(dev)->bus) directly
such as dma_alloc_pages in arch/x86_64/kernel/pci-dma.c.  or hwif_to_node
in include/linux/ide.h

According to Stefan Richter
  - Change all subsystems to set dev->parent before device_initialize().
    *Document* that the device_initialize() API has this requirement.
    This is counter-intuitive, amounts to some work across the kernel,
    and could be gotten wrong again in future code because it's a
    counter-intuitive API.

  - Move your code from device_initialize() to device_add().  One minor
    drawback is that node-specific allocations based on the device's
    numa_node would not be optimized before device_add(), but there is
    probably no need for this.  Driver probes come after device_add().

  - Let subsystems explicitly call set_dev_node() on their own.

this patch is using second method.

Also we don't need call set_dev_node in pci_device_add anymore. but need to
make sure every pci root bus's bridge device numa is set.

with this patch, we could use device->numa_node direclty for all device.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   15 +++++++++++++--
 drivers/pci/probe.c |    4 +++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/base/core.c~try-parent-numa_node-at-first-before-using-default-v2 drivers/base/core.c
--- a/drivers/base/core.c~try-parent-numa_node-at-first-before-using-default-v2
+++ a/drivers/base/core.c
@@ -764,6 +764,11 @@ int device_add(struct device *dev)
 	if (error)
 		goto Error;
 
+	/* use parent numa_node */
+	if (parent) {
+		set_dev_node(dev, dev_to_node(parent));
+	}
+
 	/* first, register with generic layer. */
 	kobject_set_name(&dev->kobj, "%s", dev->bus_id);
 	error = kobject_add(&dev->kobj);
@@ -1352,8 +1357,11 @@ int device_move(struct device *dev, stru
 	dev->parent = new_parent;
 	if (old_parent)
 		klist_remove(&dev->knode_parent);
-	if (new_parent)
+	if (new_parent) {
 		klist_add_tail(&dev->knode_parent, &new_parent->klist_children);
+		set_dev_node(dev, dev_to_node(new_parent));
+	}
+
 	if (!dev->class)
 		goto out_put;
 	error = device_move_class_links(dev, old_parent, new_parent);
@@ -1363,9 +1371,12 @@ int device_move(struct device *dev, stru
 		if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
 			if (new_parent)
 				klist_remove(&dev->knode_parent);
-			if (old_parent)
+			dev->parent = old_parent;
+			if (old_parent) {
 				klist_add_tail(&dev->knode_parent,
 					       &old_parent->klist_children);
+				set_dev_node(dev, dev_to_node(old_parent));
+			}
 		}
 		put_device(new_parent);
 		goto out;
diff -puN drivers/pci/probe.c~try-parent-numa_node-at-first-before-using-default-v2 drivers/pci/probe.c
--- a/drivers/pci/probe.c~try-parent-numa_node-at-first-before-using-default-v2
+++ a/drivers/pci/probe.c
@@ -993,7 +993,6 @@ void pci_device_add(struct pci_dev *dev,
 	dev->dev.release = pci_release_dev;
 	pci_dev_get(dev);
 
-	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
@@ -1154,6 +1153,9 @@ struct pci_bus * pci_create_bus(struct d
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 
+	if (!parent)
+		set_dev_node(b->bridge, pcibus_to_node(b));
+
 	b->class_dev.class = &pcibus_class;
 	sprintf(b->class_dev.class_id, "%04x:%02x", pci_domain_nr(b), bus);
 	error = class_device_register(&b->class_dev);
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

try-parent-numa_node-at-first-before-using-default-v2.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
