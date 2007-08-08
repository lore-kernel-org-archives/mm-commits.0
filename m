From: akpm@linux-foundation.org
Subject: - use-ssb-extif-in-ssb-mips-core-driver.patch removed from -mm tree
Date: Wed, 08 Aug 2007 16:54:27 -0700
Message-ID: <200708082359.l78NxJWS005076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756674AbXHIAAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 20:00:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, mb@bu3sch.de, nbd@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     Use SSB EXTIF in SSB MIPS core driver
has been removed from the -mm tree.  Its filename was
     use-ssb-extif-in-ssb-mips-core-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Use SSB EXTIF in SSB MIPS core driver
From: Aurelien Jarno <aurelien@aurel32.net>

Use the functions added in the previous patch to do serial and timing
initializations for EXTIF, currently marked as TODO.  It also implements the
ssb_cpu_clock() and export it.  This function is needed to support the
BCM947xx CPUs.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/driver_mipscore.c       |   89 +++++++-------------------
 drivers/ssb/main.c                  |    9 +-
 include/linux/ssb/ssb_driver_mips.h |    1 
 3 files changed, 31 insertions(+), 68 deletions(-)

diff -puN drivers/ssb/driver_mipscore.c~use-ssb-extif-in-ssb-mips-core-driver drivers/ssb/driver_mipscore.c
--- a/drivers/ssb/driver_mipscore.c~use-ssb-extif-in-ssb-mips-core-driver
+++ a/drivers/ssb/driver_mipscore.c
@@ -117,51 +117,10 @@ static void set_irq(struct ssb_device *d
 	ssb_write32(mdev, SSB_IPSFLAG, irqflag);
 }
 
-/* XXX: leave here or move into separate extif driver? */
-static int ssb_extif_serial_init(struct ssb_device *dev, struct ssb_serial_ports *ports)
-{
-
-}
-
-
 static void ssb_mips_serial_init(struct ssb_mipscore *mcore)
 {
 	struct ssb_bus *bus = mcore->dev->bus;
 
-	//TODO if (EXTIF available
-#if 0
-		extifregs_t *eir = (extifregs_t *) regs;
-		sbconfig_t *sb;
-
-		/* Determine external UART register base */
-		sb = (sbconfig_t *)((ulong) eir + SBCONFIGOFF);
-		base = EXTIF_CFGIF_BASE(sb_base(R_REG(&sb->sbadmatch1)));
-
-		/* Determine IRQ */
-		irq = sb_irq(sbh);
-
-		/* Disable GPIO interrupt initially */
-		W_REG(&eir->gpiointpolarity, 0);
-		W_REG(&eir->gpiointmask, 0);
-
-		/* Search for external UARTs */
-		n = 2;
-		for (i = 0; i < 2; i++) {
-			regs = (void *) REG_MAP(base + (i * 8), 8);
-			if (BCMINIT(serial_exists)(regs)) {
-				/* Set GPIO 1 to be the external UART IRQ */
-				W_REG(&eir->gpiointmask, 2);
-				if (add)
-					add(regs, irq, 13500000, 0);
-			}
-		}
-
-		/* Add internal UART if enabled */
-		if (R_REG(&eir->corecontrol) & CC_UE)
-			if (add)
-				add((void *) &eir->uartdata, irq, sb_clock(sbh), 2);
-
-#endif
 	if (bus->extif.dev)
 		mcore->nr_serial_ports = ssb_extif_serial_init(&bus->extif, mcore->serial_ports);
 	else if (bus->chipco.dev)
@@ -183,9 +142,29 @@ static void ssb_mips_flash_detect(struct
 	}
 }
 
-
-static void ssb_cpu_clock(struct ssb_mipscore *mcore)
+u32 ssb_cpu_clock(struct ssb_mipscore *mcore)
 {
+	struct ssb_bus *bus = mcore->dev->bus;
+	u32 pll_type, n, m, rate = 0;
+
+	if (bus->extif.dev) {
+		ssb_extif_get_clockcontrol(&bus->extif, &pll_type, &n, &m);
+	} else if (bus->chipco.dev) {
+		ssb_chipco_get_clockcpu(&bus->chipco, &pll_type, &n, &m);
+	} else
+		return 0;
+
+	if ((pll_type == SSB_PLLTYPE_5) || (bus->chip_id == 0x5365)) {
+		rate = 200000000;
+	} else {
+		rate = ssb_calc_clock_rate(pll_type, n, m);
+	}
+
+	if (pll_type == SSB_PLLTYPE_6) {
+		rate *= 2;
+	}
+
+	return rate;
 }
 
 void ssb_mipscore_init(struct ssb_mipscore *mcore)
@@ -205,27 +184,9 @@ void ssb_mipscore_init(struct ssb_mipsco
 		hz = 100000000;
 	ns = 1000000000 / hz;
 
-//TODO
-#if 0
-	if (have EXTIF) {
-		/* Initialize extif so we can get to the LEDs and external UART */
-		W_REG(&eir->prog_config, CF_EN);
-
-		/* Set timing for the flash */
-		tmp = CEIL(10, ns) << FW_W3_SHIFT;	/* W3 = 10nS */
-		tmp = tmp | (CEIL(40, ns) << FW_W1_SHIFT); /* W1 = 40nS */
-		tmp = tmp | CEIL(120, ns);		/* W0 = 120nS */
-		W_REG(&eir->prog_waitcount, tmp);	/* 0x01020a0c for a 100Mhz clock */
-
-		/* Set programmable interface timing for external uart */
-		tmp = CEIL(10, ns) << FW_W3_SHIFT;	/* W3 = 10nS */
-		tmp = tmp | (CEIL(20, ns) << FW_W2_SHIFT); /* W2 = 20nS */
-		tmp = tmp | (CEIL(100, ns) << FW_W1_SHIFT); /* W1 = 100nS */
-		tmp = tmp | CEIL(120, ns);		/* W0 = 120nS */
-		W_REG(&eir->prog_waitcount, tmp);
-	}
-#endif
-	if (bus->chipco.dev)
+	if (bus->extif.dev)
+		ssb_extif_timing_init(&bus->extif, ns);
+	else if (bus->chipco.dev)
 		ssb_chipco_timing_init(&bus->chipco, ns);
 
 	/* Assign IRQs to all cores on the bus, start with irq line 2, because serial usually takes 1 */
diff -puN drivers/ssb/main.c~use-ssb-extif-in-ssb-mips-core-driver drivers/ssb/main.c
--- a/drivers/ssb/main.c~use-ssb-extif-in-ssb-mips-core-driver
+++ a/drivers/ssb/main.c
@@ -819,12 +819,13 @@ u32 ssb_clockspeed(struct ssb_bus *bus)
 	u32 plltype;
 	u32 clkctl_n, clkctl_m;
 
-	//TODO if EXTIF: PLLTYPE == 1, read n from clockcontrol_n, m from clockcontrol_sb
-
-	if (bus->chipco.dev) {
+	if (bus->extif.dev)
+		ssb_extif_get_clockcontrol(&bus->extif, &plltype,
+					   &clkctl_n, &clkctl_m);
+	else if (bus->chipco.dev)
 		ssb_chipco_get_clockcontrol(&bus->chipco, &plltype,
 					    &clkctl_n, &clkctl_m);
-	} else
+	else
 		return 0;
 
 	if (bus->chip_id == 0x5365) {
diff -puN include/linux/ssb/ssb_driver_mips.h~use-ssb-extif-in-ssb-mips-core-driver include/linux/ssb/ssb_driver_mips.h
--- a/include/linux/ssb/ssb_driver_mips.h~use-ssb-extif-in-ssb-mips-core-driver
+++ a/include/linux/ssb/ssb_driver_mips.h
@@ -25,6 +25,7 @@ struct ssb_mipscore {
 };
 
 extern void ssb_mipscore_init(struct ssb_mipscore *mcore);
+extern u32 ssb_cpu_clock(struct ssb_mipscore *mcore);
 
 extern unsigned int ssb_mips_irq(struct ssb_device *dev);
 
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-wireless.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
