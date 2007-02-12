From: akpm@linux-foundation.org
Subject: - ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:50:05 -0800
Message-ID: <200702122250.l1CMo5FN014200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030404AbXBLWuq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3: add shutdown to virtual uart port driver framework
has been removed from the -mm tree.  Its filename was
     ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3: add shutdown to virtual uart port driver framework
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

PS3: Add a shutdown method to the PS3's virtual uart port driver framework

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ps3/vuart.c |   17 +++++++++++++++++
 drivers/ps3/vuart.h |    1 +
 2 files changed, 18 insertions(+)

diff -puN drivers/ps3/vuart.c~ps3-add-shutdown-to-virtual-uart-port-driver-framework drivers/ps3/vuart.c
--- a/drivers/ps3/vuart.c~ps3-add-shutdown-to-virtual-uart-port-driver-framework
+++ a/drivers/ps3/vuart.c
@@ -867,6 +867,22 @@ static int ps3_vuart_remove(struct devic
 	return 0;
 }
 
+static void ps3_vuart_shutdown(struct device *_dev)
+{
+	struct ps3_vuart_port_device *dev = to_ps3_vuart_port_device(_dev);
+	struct ps3_vuart_port_driver *drv =
+		to_ps3_vuart_port_driver(_dev->driver);
+
+	dev_dbg(&dev->core, "%s:%d: %s\n", __func__, __LINE__,
+		dev->core.bus_id);
+
+	if (drv->shutdown)
+		drv->shutdown(dev);
+	else
+		dev_dbg(&dev->core, "%s:%d: %s no shutdown method\n", __func__,
+			__LINE__, dev->core.bus_id);
+}
+
 /**
  * ps3_vuart - The vuart instance.
  *
@@ -878,6 +894,7 @@ struct bus_type ps3_vuart = {
 	.match = ps3_vuart_match,
 	.probe = ps3_vuart_probe,
 	.remove = ps3_vuart_remove,
+	.shutdown = ps3_vuart_shutdown,
 };
 
 int __init ps3_vuart_init(void)
diff -puN drivers/ps3/vuart.h~ps3-add-shutdown-to-virtual-uart-port-driver-framework drivers/ps3/vuart.h
--- a/drivers/ps3/vuart.h~ps3-add-shutdown-to-virtual-uart-port-driver-framework
+++ a/drivers/ps3/vuart.h
@@ -30,6 +30,7 @@ struct ps3_vuart_port_driver {
 	struct device_driver core;
 	int (*probe)(struct ps3_vuart_port_device *);
 	int (*remove)(struct ps3_vuart_port_device *);
+	void (*shutdown)(struct ps3_vuart_port_device *);
 	int (*tx_event)(struct ps3_vuart_port_device *dev);
 	int (*rx_event)(struct ps3_vuart_port_device *dev);
 	int (*disconnect_event)(struct ps3_vuart_port_device *dev);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
