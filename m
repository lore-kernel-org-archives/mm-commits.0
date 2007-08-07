From: akpm@linux-foundation.org
Subject: - try-parent-numa_node-at-first-before-using-default-v2.patch removed from -mm tree
Date: Tue, 07 Aug 2007 15:46:02 -0700
Message-ID: <200708072246.l77Mk2Qw008754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224AbXHGWrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:47:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, greg@kroah.com, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     try parent numa_node at first before using default
has been removed from the -mm tree.  Its filename was
     try-parent-numa_node-at-first-before-using-default-v2.patch

This patch was dropped because finish-i386-and-x86-64-sysdata-conversion.patch might have destroyed it

------------------------------------------------------
Subject: try parent numa_node at first before using default
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

In the device_add, we try to use use parent numa_node.  need to make sure pci
root bus's bridge device numa_node is set.  then we could use
device->numa_node direclty for all device.  and don't need to call
pcibus_to_node().

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Greg KH <greg@kroah.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   15 +++++++++++++--
 drivers/pci/probe.c |    4 +++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/base/core.c~try-parent-numa_node-at-first-before-using-default-v2 drivers/base/core.c
--- a/drivers/base/core.c~try-parent-numa_node-at-first-before-using-default-v2
+++ a/drivers/base/core.c
@@ -767,6 +767,11 @@ int device_add(struct device *dev)
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
@@ -995,7 +995,6 @@ void pci_device_add(struct pci_dev *dev,
 	dev->dev.release = pci_release_dev;
 	pci_dev_get(dev);
 
-	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
@@ -1156,6 +1155,9 @@ struct pci_bus * pci_create_bus(struct d
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 
+	if (!parent)
+		set_dev_node(b->bridge, pcibus_to_node(b));
+
 	b->class_dev.class = &pcibus_class;
 	sprintf(b->class_dev.class_id, "%04x:%02x", pci_domain_nr(b), bus);
 	error = class_device_register(&b->class_dev);
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

finish-i386-and-x86-64-sysdata-conversion.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
