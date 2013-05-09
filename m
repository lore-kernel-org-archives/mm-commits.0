From: akpm@linux-foundation.org
Subject: + rapidio-switches-remove-tsi500-driver.patch added to -mm tree
Date: Thu, 09 May 2013 13:16:25 -0700
Message-ID: <20130509201625.75D825A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:45669 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3EIUQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:16:26 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so329546ggm.3
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:16:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio/switches: remove tsi500 driver
has been added to the -mm tree.  Its filename is
     rapidio-switches-remove-tsi500-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/switches: remove tsi500 driver

Remove the driver for Tsi500 Parallel RapidIO switch because this device
has not been available for several years.  Since the first introduction of
Tsi500, the parallel RapidIO interface was replaced by the serial RapidIO
(sRIO) and therefore there is no value in keeping this driver.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/Kconfig  |    7 --
 drivers/rapidio/switches/Makefile |    1 
 drivers/rapidio/switches/tsi500.c |   78 ----------------------------
 3 files changed, 86 deletions(-)

diff -puN drivers/rapidio/switches/Kconfig~rapidio-switches-remove-tsi500-driver drivers/rapidio/switches/Kconfig
--- a/drivers/rapidio/switches/Kconfig~rapidio-switches-remove-tsi500-driver
+++ a/drivers/rapidio/switches/Kconfig
@@ -26,10 +26,3 @@ config RAPIDIO_CPS_GEN2
 	default n
 	---help---
 	  Includes support for ITD CPS Gen.2 serial RapidIO switches.
-
-config RAPIDIO_TSI500
-	bool "Tsi500 Parallel RapidIO switch support"
-	depends on RAPIDIO
-	default n
-	---help---
-	  Includes support for IDT Tsi500 parallel RapidIO switch.
diff -puN drivers/rapidio/switches/Makefile~rapidio-switches-remove-tsi500-driver drivers/rapidio/switches/Makefile
--- a/drivers/rapidio/switches/Makefile~rapidio-switches-remove-tsi500-driver
+++ a/drivers/rapidio/switches/Makefile
@@ -5,5 +5,4 @@
 obj-$(CONFIG_RAPIDIO_TSI57X)	+= tsi57x.o
 obj-$(CONFIG_RAPIDIO_CPS_XX)	+= idtcps.o
 obj-$(CONFIG_RAPIDIO_TSI568)	+= tsi568.o
-obj-$(CONFIG_RAPIDIO_TSI500)	+= tsi500.o
 obj-$(CONFIG_RAPIDIO_CPS_GEN2)	+= idt_gen2.o
diff -puN drivers/rapidio/switches/tsi500.c~rapidio-switches-remove-tsi500-driver /dev/null
--- a/drivers/rapidio/switches/tsi500.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * RapidIO Tsi500 switch support
- *
- * Copyright 2009-2010 Integrated Device Technology, Inc.
- * Alexandre Bounine <alexandre.bounine@idt.com>
- *  - Modified switch operations initialization.
- *
- * Copyright 2005 MontaVista Software, Inc.
- * Matt Porter <mporter@kernel.crashing.org>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/rio.h>
-#include <linux/rio_drv.h>
-#include <linux/rio_ids.h>
-#include "../rio.h"
-
-static int
-tsi500_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount, u16 table, u16 route_destid, u8 route_port)
-{
-	int i;
-	u32 offset = 0x10000 + 0xa00 + ((route_destid / 2)&~0x3);
-	u32 result;
-
-	if (table == 0xff) {
-		rio_mport_read_config_32(mport, destid, hopcount, offset, &result);
-		result &= ~(0xf << (4*(route_destid & 0x7)));
-		for (i=0;i<4;i++)
-			rio_mport_write_config_32(mport, destid, hopcount, offset + (0x20000*i), result | (route_port << (4*(route_destid & 0x7))));
-	}
-	else {
-		rio_mport_read_config_32(mport, destid, hopcount, offset + (0x20000*table), &result);
-		result &= ~(0xf << (4*(route_destid & 0x7)));
-		rio_mport_write_config_32(mport, destid, hopcount, offset + (0x20000*table), result | (route_port << (4*(route_destid & 0x7))));
-	}
-
-	return 0;
-}
-
-static int
-tsi500_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount, u16 table, u16 route_destid, u8 *route_port)
-{
-	int ret = 0;
-	u32 offset = 0x10000 + 0xa00 + ((route_destid / 2)&~0x3);
-	u32 result;
-
-	if (table == 0xff)
-		rio_mport_read_config_32(mport, destid, hopcount, offset, &result);
-	else
-		rio_mport_read_config_32(mport, destid, hopcount, offset + (0x20000*table), &result);
-
-	result &= 0xf << (4*(route_destid & 0x7));
-	*route_port = result >> (4*(route_destid & 0x7));
-	if (*route_port > 3)
-		ret = -1;
-
-	return ret;
-}
-
-static int tsi500_switch_init(struct rio_dev *rdev, int do_enum)
-{
-	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
-	rdev->rswitch->add_entry = tsi500_route_add_entry;
-	rdev->rswitch->get_entry = tsi500_route_get_entry;
-	rdev->rswitch->clr_table = NULL;
-	rdev->rswitch->set_domain = NULL;
-	rdev->rswitch->get_domain = NULL;
-	rdev->rswitch->em_init = NULL;
-	rdev->rswitch->em_handle = NULL;
-
-	return 0;
-}
