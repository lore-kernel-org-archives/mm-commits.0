From: akpm@linux-foundation.org
Subject: + try-parent-numa_node-at-first-before-using-default.patch added to -mm tree
Date: Tue, 07 Aug 2007 19:29:27 -0700
Message-ID: <200708080229.l782TRoN016683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758495AbXHHCaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 22:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, apw@shadowen.org, clameter@sgi.com, davem@davemloft.net, jeff@garzik.org, yinghai.lu@Sun.COM


The patch titled
     try parent numa_node at first before using default
has been added to the -mm tree.  Its filename is
     try-parent-numa_node-at-first-before-using-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: try parent numa_node at first before using default
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

In the device_add, we try to use use parent numa_node.  need to make sure pci
root bus's bridge device numa_node is set.  then we could use
device->numa_node direclty for all device.  and don't need to call
pcibus_to_node().

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   15 +++++++++++++--
 drivers/pci/probe.c |    4 +++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/base/core.c~try-parent-numa_node-at-first-before-using-default drivers/base/core.c
--- a/drivers/base/core.c~try-parent-numa_node-at-first-before-using-default
+++ a/drivers/base/core.c
@@ -761,6 +761,11 @@ int device_add(struct device *dev)
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
@@ -1349,8 +1354,11 @@ int device_move(struct device *dev, stru
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
@@ -1360,9 +1368,12 @@ int device_move(struct device *dev, stru
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
diff -puN drivers/pci/probe.c~try-parent-numa_node-at-first-before-using-default drivers/pci/probe.c
--- a/drivers/pci/probe.c~try-parent-numa_node-at-first-before-using-default
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

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

x86_64-remove-sync_arb_ids.patch
x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
