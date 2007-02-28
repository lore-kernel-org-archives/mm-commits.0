From: akpm@linux-foundation.org
Subject: - spidernet-spidernet-add-support-for-celleb.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:53 -0800
Message-ID: <200702282352.l1SNqrYI031038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48284 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657AbXB1Xw6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kou.ishizaki@toshiba.co.jp, linas@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: spidernet: add support for Celleb
has been removed from the -mm tree.  Its filename was
     spidernet-spidernet-add-support-for-celleb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spidernet: spidernet: add support for Celleb
From: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>

This patch adds or changes some HW specific settings for spider_net on Celleb.

Signed-off-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig      |    2 +-
 drivers/net/spider_net.c |    8 +++++++-
 drivers/net/spider_net.h |    6 ++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/net/Kconfig~spidernet-spidernet-add-support-for-celleb drivers/net/Kconfig
--- a/drivers/net/Kconfig~spidernet-spidernet-add-support-for-celleb
+++ a/drivers/net/Kconfig
@@ -2245,7 +2245,7 @@ config BNX2
 
 config SPIDER_NET
 	tristate "Spider Gigabit Ethernet driver"
-	depends on PCI && PPC_IBM_CELL_BLADE
+	depends on PCI && (PPC_IBM_CELL_BLADE || PPC_CELLEB)
 	select FW_LOADER
 	help
 	  This driver supports the Gigabit Ethernet chips present on the
diff -puN drivers/net/spider_net.c~spidernet-spidernet-add-support-for-celleb drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-spidernet-add-support-for-celleb
+++ a/drivers/net/spider_net.c
@@ -1,7 +1,8 @@
 /*
- * Network device driver for Cell Processor-Based Blade
+ * Network device driver for Cell Processor-Based Blade and Celleb platform
  *
  * (C) Copyright IBM Corp. 2005
+ * (C) Copyright 2006 TOSHIBA CORPORATION
  *
  * Authors : Utz Bacher <utz.bacher@de.ibm.com>
  *           Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
@@ -1605,6 +1606,11 @@ spider_net_init_card(struct spider_net_c
 
 	spider_net_write_reg(card, SPIDER_NET_CKRCTRL,
 			     SPIDER_NET_CKRCTRL_RUN_VALUE);
+
+	/* trigger ETOMOD signal */
+	spider_net_write_reg(card, SPIDER_NET_GMACOPEMD,
+		spider_net_read_reg(card, SPIDER_NET_GMACOPEMD) | 0x4);
+
 }
 
 /**
diff -puN drivers/net/spider_net.h~spidernet-spidernet-add-support-for-celleb drivers/net/spider_net.h
--- a/drivers/net/spider_net.h~spidernet-spidernet-add-support-for-celleb
+++ a/drivers/net/spider_net.h
@@ -1,7 +1,8 @@
 /*
- * Network device driver for Cell Processor-Based Blade
+ * Network device driver for Cell Processor-Based Blade and Celleb platform
  *
  * (C) Copyright IBM Corp. 2005
+ * (C) Copyright 2006 TOSHIBA CORPORATION
  *
  * Authors : Utz Bacher <utz.bacher@de.ibm.com>
  *           Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
@@ -184,7 +185,8 @@ extern char spider_net_driver_name[];
 
 /* pause frames: automatic, no upper retransmission count */
 /* outside loopback mode: ETOMOD signal dont matter, not connected */
-#define SPIDER_NET_OPMODE_VALUE		0x00000063
+/* ETOMOD signal is brought to PHY reset. bit 2 must be 1 in Celleb */
+#define SPIDER_NET_OPMODE_VALUE		0x00000067
 /*#define SPIDER_NET_OPMODE_VALUE		0x001b0062*/
 #define SPIDER_NET_LENLMT_VALUE		0x00000908
 
_

Patches currently in -mm which might be from kou.ishizaki@toshiba.co.jp are
