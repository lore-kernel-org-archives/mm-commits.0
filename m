From: akpm@linux-foundation.org
Subject: [merged] fakephp-allocate-pci-resources-before-adding-the-device.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:37:00 -0800
Message-ID: <200902021937.n12Jb0pW013688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbZBBThH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:37:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, achiang@hp.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     fakephp: allocate PCI resources before adding the device
has been removed from the -mm tree.  Its filename was
     fakephp-allocate-pci-resources-before-adding-the-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fakephp: allocate PCI resources before adding the device
From: "Darrick J. Wong" <djwong@us.ibm.com>

For PCI devices, pci_bus_assign_resources() must be called to set up the
pci_device->resource array before pci_bus_add_devices() can be called,
else attempts to load drivers results in BAR collision errors where there
are none.  This is not done in fakephp, so devices can be "unplugged" but
scanning the parent bus won't bring the devices back due to resource
unallocation.

Move the pci_bus_add_device-calling logic into pci_rescan_bus and preface
it with a call to pci_bus_assign_resources so that we only have to
(re)allocate resources once per bus where a new device is found.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/fakephp.c |   42 +++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff -puN drivers/pci/hotplug/fakephp.c~fakephp-allocate-pci-resources-before-adding-the-device drivers/pci/hotplug/fakephp.c
--- a/drivers/pci/hotplug/fakephp.c~fakephp-allocate-pci-resources-before-adding-the-device
+++ a/drivers/pci/hotplug/fakephp.c
@@ -195,13 +195,13 @@ static void remove_slot_worker(struct wo
  * Tries hard not to re-enable already existing devices;
  * also handles scanning of subfunctions.
  */
-static void pci_rescan_slot(struct pci_dev *temp)
+static int pci_rescan_slot(struct pci_dev *temp)
 {
 	struct pci_bus *bus = temp->bus;
 	struct pci_dev *dev;
 	int func;
-	int retval;
 	u8 hdr_type;
+	int count = 0;
 
 	if (!pci_read_config_byte(temp, PCI_HEADER_TYPE, &hdr_type)) {
 		temp->hdr_type = hdr_type & 0x7f;
@@ -213,17 +213,12 @@ static void pci_rescan_slot(struct pci_d
 				dbg("New device on %s function %x:%x\n",
 					bus->name, temp->devfn >> 3,
 					temp->devfn & 7);
-				retval = pci_bus_add_device(dev);
-				if (retval)
-					dev_err(&dev->dev, "error adding "
-						"device, continuing.\n");
-				else
-					add_slot(dev);
+				count++;
 			}
 		}
 		/* multifunction device? */
 		if (!(hdr_type & 0x80))
-			return;
+			return count;
 
 		/* continue scanning for other functions */
 		for (func = 1, temp->devfn++; func < 8; func++, temp->devfn++) {
@@ -239,16 +234,13 @@ static void pci_rescan_slot(struct pci_d
 					dbg("New device on %s function %x:%x\n",
 						bus->name, temp->devfn >> 3,
 						temp->devfn & 7);
-					retval = pci_bus_add_device(dev);
-					if (retval)
-						dev_err(&dev->dev, "error adding "
-							"device, continuing.\n");
-					else
-						add_slot(dev);
+					count++;
 				}
 			}
 		}
 	}
+
+	return count;
 }
 
 
@@ -262,6 +254,8 @@ static void pci_rescan_bus(const struct 
 {
 	unsigned int devfn;
 	struct pci_dev *dev;
+	int retval;
+	int found = 0;
 	dev = alloc_pci_dev();
 	if (!dev)
 		return;
@@ -270,7 +264,23 @@ static void pci_rescan_bus(const struct 
 	dev->sysdata = bus->sysdata;
 	for (devfn = 0; devfn < 0x100; devfn += 8) {
 		dev->devfn = devfn;
-		pci_rescan_slot(dev);
+		found += pci_rescan_slot(dev);
+	}
+
+	if (found) {
+		pci_bus_assign_resources(bus);
+		list_for_each_entry(dev, &bus->devices, bus_list) {
+			/* Skip already-added devices */
+			if (dev->is_added)
+					continue;
+			retval = pci_bus_add_device(dev);
+			if (retval)
+				dev_err(&dev->dev,
+					"Error adding device, continuing\n");
+			else
+				add_slot(dev);
+		}
+		pci_bus_add_devices(bus);
 	}
 	kfree(dev);
 }
_

Patches currently in -mm which might be from djwong@us.ibm.com are

linux-next.patch

