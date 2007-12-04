From: akpm@linux-foundation.org
Subject: - phy-add-the-phy_device_release-device-method.patch removed from -mm tree
Date: Mon, 03 Dec 2007 21:45:09 -0800
Message-ID: <200712040545.lB45j9Ka003095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbXLDFpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 00:45:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     PHY: add the phy_device_release device method
has been removed from the -mm tree.  Its filename was
     phy-add-the-phy_device_release-device-method.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: PHY: add the phy_device_release device method
From: Thierry Reding <thierry.reding@avionic-design.de>

In cases where more than a single PHY is found on the MDIO bus, the kernel
will print a warning that this method is missing for each PHY device that
is not attached to a networking device.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/mdio_bus.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN drivers/net/phy/mdio_bus.c~phy-add-the-phy_device_release-device-method drivers/net/phy/mdio_bus.c
--- a/drivers/net/phy/mdio_bus.c~phy-add-the-phy_device_release-device-method
+++ a/drivers/net/phy/mdio_bus.c
@@ -36,6 +36,23 @@
 #include <asm/uaccess.h>
 
 /**
+ * phy_device_release - free a phy_device structure when all users of it are
+ * 	finished.
+ *
+ * @dev: device that's been disconnected
+ *
+ * Will be called only by the device core when all users of this phy_device
+ * are done.
+ */
+static void phy_device_release(struct device *dev)
+{
+	struct phy_device *phy;
+
+	phy = to_phy_device(dev);
+	kfree(phy);
+}
+
+/**
  * mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
  * @bus: target mii_bus
  *
@@ -83,6 +100,7 @@ int mdiobus_register(struct mii_bus *bus
 		if (phydev) {
 			phydev->irq = bus->irq[i];
 
+			phydev->dev.release = phy_device_release;
 			phydev->dev.parent = bus->dev;
 			phydev->dev.bus = &mdio_bus_type;
 			snprintf(phydev->dev.bus_id, BUS_ID_SIZE, PHY_ID_FMT, bus->id, i);
@@ -112,7 +130,6 @@ void mdiobus_unregister(struct mii_bus *
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
 		if (bus->phy_map[i]) {
 			device_unregister(&bus->phy_map[i]->dev);
-			kfree(bus->phy_map[i]);
 		}
 	}
 }
_

Patches currently in -mm which might be from thierry.reding@avionic-design.de are

phy-add-the-phy_device_release-device-method.patch
