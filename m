From: akpm@osdl.org
Subject: - cxgb3-build-files-and-versioning.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:46:38 -0800
Message-ID: <200701222046.l0MKkcdA001565@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50478 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581AbXAVUrO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: divy@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     cxgb3: build files and versioning
has been removed from the -mm tree.  Its filename was
     cxgb3-build-files-and-versioning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxgb3: build files and versioning
From: Divy Le Ray <divy@chelsio.com>

Implement build files and versioning for the Chelsio T3 network adapter's
driver.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/Kconfig         |   18 ++++++++++++++++++
 drivers/net/Makefile        |    1 +
 drivers/net/cxgb3/Makefile  |    8 ++++++++
 drivers/net/cxgb3/version.h |   24 ++++++++++++++++++++++++
 4 files changed, 51 insertions(+)

diff -puN drivers/net/Kconfig~cxgb3-build-files-and-versioning drivers/net/Kconfig
--- a/drivers/net/Kconfig~cxgb3-build-files-and-versioning
+++ a/drivers/net/Kconfig
@@ -2389,6 +2389,24 @@ config CHELSIO_T1_NAPI
 	  NAPI is a driver API designed to reduce CPU and interrupt load
 	  when the driver is receiving lots of packets from the card.
 
+config CHELSIO_T3
+        tristate "Chelsio Communications T3 10Gb Ethernet support"
+        depends on PCI
+        help
+          This driver supports Chelsio T3-based gigabit and 10Gb Ethernet
+          adapters.
+
+          For general information about Chelsio and our products, visit
+          our website at <http://www.chelsio.com>.
+
+          For customer support, please visit our customer support page at
+          <http://www.chelsio.com/support.htm>.
+
+          Please send feedback to <linux-bugs@chelsio.com>.
+
+          To compile this driver as a module, choose M here: the module
+          will be called cxgb3.
+
 config EHEA
 	tristate "eHEA Ethernet support"
 	depends on IBMEBUS
diff -puN drivers/net/Makefile~cxgb3-build-files-and-versioning drivers/net/Makefile
--- a/drivers/net/Makefile~cxgb3-build-files-and-versioning
+++ a/drivers/net/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_E1000) += e1000/
 obj-$(CONFIG_IBM_EMAC) += ibm_emac/
 obj-$(CONFIG_IXGB) += ixgb/
 obj-$(CONFIG_CHELSIO_T1) += chelsio/
+obj-$(CONFIG_CHELSIO_T3) += cxgb3/
 obj-$(CONFIG_EHEA) += ehea/
 obj-$(CONFIG_BONDING) += bonding/
 obj-$(CONFIG_GIANFAR) += gianfar_driver.o
diff -puN /dev/null drivers/net/cxgb3/Makefile
--- /dev/null
+++ a/drivers/net/cxgb3/Makefile
@@ -0,0 +1,8 @@
+#
+# Chelsio T3 driver
+#
+
+obj-$(CONFIG_CHELSIO_T3) += cxgb3.o
+
+cxgb3-objs := cxgb3_main.o ael1002.o vsc8211.o t3_hw.o mc5.o \
+	      xgmac.o sge.o l2t.o cxgb3_offload.o
diff -puN /dev/null drivers/net/cxgb3/version.h
--- /dev/null
+++ a/drivers/net/cxgb3/version.h
@@ -0,0 +1,24 @@
+/*****************************************************************************
+ *                                                                           *
+ * File:                                                                     *
+ *  version.h                                                                *
+ *                                                                           *
+ * Description:                                                              *
+ *  Chelsio driver version defines.                                          *
+ *                                                                           *
+ * Copyright (c) 2003 - 2006 Chelsio Communications, Inc.                    *
+ * All rights reserved.                                                      *
+ *                                                                           *
+ * Maintainers: maintainers@chelsio.com                                      *
+ *                                                                           *
+ * http://www.chelsio.com                                                    *
+ *                                                                           *
+ ****************************************************************************/
+/* $Date: 2006/10/31 18:57:51 $ $RCSfile: version.h,v $ $Revision: 1.3 $ */
+#ifndef __CHELSIO_VERSION_H
+#define __CHELSIO_VERSION_H
+#define DRV_DESC "Chelsio T3 Network Driver"
+#define DRV_NAME "cxgb3"
+/* Driver version */
+#define DRV_VERSION "1.0"
+#endif				/* __CHELSIO_VERSION_H */
_

Patches currently in -mm which might be from divy@chelsio.com are

git-netdev-all.patch
cxgb3-vs-gregkh-driver-network-device.patch
