From: akpm@linux-foundation.org
Subject: - potential-parse-error-in-ifdef.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:11 -0700
Message-ID: <200706011747.l51HlAIs015111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760788AbXFARra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: padator@wanadoo.fr, James.Bottomley@steeleye.com, dwmw2@infradead.org, jeff@garzik.org, matthew@wil.cx, rmk@arm.linux.org.uk, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     potential parse error in ifdef
has been removed from the -mm tree.  Its filename was
     potential-parse-error-in-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: potential parse error in ifdef
From: Yoann Padioleau <padator@wanadoo.fr>

I have made a tool to parse the kernel that does not pre-process the
source.  That means that my parser tries to parse all the code, including
code in the #else branch or code that is not often compiled because the
driver is not very used (or not used at all).  So, my parser sometimes
reports parse error not originally detected by gcc.  Here is my (first)
patch.

[akpm@linux-foundation.org: fix amd8111e.c]
Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Acked-by: Matthew Wilcox <matthew@wil.cx>
Acked-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Jeff Garzik <jeff@garzik.org>
Acked-by: James Bottomley <James.Bottomley@steeleye.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/ixp2000_wdt.c |    2 +-
 drivers/mtd/devices/pmc551.c        |    2 +-
 drivers/mtd/nand/autcpu12.c         |    2 +-
 drivers/mtd/nand/ppchameleonevb.c   |    2 +-
 drivers/net/amd8111e.c              |    2 +-
 drivers/net/amd8111e.h              |    2 +-
 drivers/net/skfp/smt.c              |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
 sound/arm/sa11xx-uda1341.c          |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/char/watchdog/ixp2000_wdt.c~potential-parse-error-in-ifdef drivers/char/watchdog/ixp2000_wdt.c
--- a/drivers/char/watchdog/ixp2000_wdt.c~potential-parse-error-in-ifdef
+++ a/drivers/char/watchdog/ixp2000_wdt.c
@@ -205,7 +205,7 @@ static void __exit ixp2000_wdt_exit(void
 module_init(ixp2000_wdt_init);
 module_exit(ixp2000_wdt_exit);
 
-MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net">);
+MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
 MODULE_DESCRIPTION("IXP2000 Network Processor Watchdog");
 
 module_param(heartbeat, int, 0);
diff -puN drivers/mtd/devices/pmc551.c~potential-parse-error-in-ifdef drivers/mtd/devices/pmc551.c
--- a/drivers/mtd/devices/pmc551.c~potential-parse-error-in-ifdef
+++ a/drivers/mtd/devices/pmc551.c
@@ -650,7 +650,7 @@ MODULE_DESCRIPTION(PMC551_VERSION);
  */
 static int msize = 0;
 #if defined(CONFIG_MTD_PMC551_APERTURE_SIZE)
-static int asize = CONFIG_MTD_PMC551_APERTURE_SIZE
+static int asize = CONFIG_MTD_PMC551_APERTURE_SIZE;
 #else
 static int asize = 0;
 #endif
diff -puN drivers/mtd/nand/autcpu12.c~potential-parse-error-in-ifdef drivers/mtd/nand/autcpu12.c
--- a/drivers/mtd/nand/autcpu12.c~potential-parse-error-in-ifdef
+++ a/drivers/mtd/nand/autcpu12.c
@@ -101,7 +101,7 @@ static void autcpu12_hwcontrol(struct mt
 	struct nand_chip *chip = mtd->priv;
 
 	if (ctrl & NAND_CTRL_CHANGE) {
-		void __iomem *addr
+		void __iomem *addr;
 		unsigned char bits;
 
 		addr = CS89712_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
diff -puN drivers/mtd/nand/ppchameleonevb.c~potential-parse-error-in-ifdef drivers/mtd/nand/ppchameleonevb.c
--- a/drivers/mtd/nand/ppchameleonevb.c~potential-parse-error-in-ifdef
+++ a/drivers/mtd/nand/ppchameleonevb.c
@@ -81,7 +81,7 @@ __setup("ppchameleonevb_fio_pbase=", ppc
  */
 static struct mtd_partition partition_info_hi[] = {
       { .name = "PPChameleon HI Nand Flash",
-	offset = 0,
+	.offset = 0,
 	.size = 128 * 1024 * 1024
       }
 };
diff -puN drivers/net/amd8111e.c~potential-parse-error-in-ifdef drivers/net/amd8111e.c
--- a/drivers/net/amd8111e.c~potential-parse-error-in-ifdef
+++ a/drivers/net/amd8111e.c
@@ -155,7 +155,7 @@ This function will write into PHY regist
 */
 static int amd8111e_write_phy(struct amd8111e_priv* lp,int phy_id, int reg, u32 val)
 {
-	unsigned int repeat = REPEAT_CNT
+	unsigned int repeat = REPEAT_CNT;
 	void __iomem *mmio = lp->mmio;
 	unsigned int reg_val;
 
diff -puN drivers/net/amd8111e.h~potential-parse-error-in-ifdef drivers/net/amd8111e.h
--- a/drivers/net/amd8111e.h~potential-parse-error-in-ifdef
+++ a/drivers/net/amd8111e.h
@@ -615,7 +615,7 @@ typedef enum {
 #define SSTATE  2
 
 /* Assume contoller gets data 10 times the maximum processing time */
-#define  REPEAT_CNT			10;
+#define  REPEAT_CNT			10
 
 /* amd8111e decriptor flag definitions */
 typedef enum {
diff -puN drivers/net/skfp/smt.c~potential-parse-error-in-ifdef drivers/net/skfp/smt.c
--- a/drivers/net/skfp/smt.c~potential-parse-error-in-ifdef
+++ a/drivers/net/skfp/smt.c
@@ -1748,7 +1748,7 @@ char *addr_to_string(struct fddi_addr *a
 #endif
 
 #ifdef	AM29K
-smt_ifconfig(int argc, char *argv[])
+int smt_ifconfig(int argc, char *argv[])
 {
 	if (argc >= 2 && !strcmp(argv[0],"opt_bypass") &&
 	    !strcmp(argv[1],"yes")) {
diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~potential-parse-error-in-ifdef drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~potential-parse-error-in-ifdef
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -5180,7 +5180,7 @@ ahd_handle_devreset(struct ahd_softc *ah
 			cur_lun = lun;
 			max_lun = lun;
 		}
-		for (cur_lun <= max_lun; cur_lun++) {
+		for (;cur_lun <= max_lun; cur_lun++) {
 			struct ahd_tmode_lstate* lstate;
 
 			lstate = tstate->enabled_luns[cur_lun];
diff -puN sound/arm/sa11xx-uda1341.c~potential-parse-error-in-ifdef sound/arm/sa11xx-uda1341.c
--- a/sound/arm/sa11xx-uda1341.c~potential-parse-error-in-ifdef
+++ a/sound/arm/sa11xx-uda1341.c
@@ -987,7 +987,7 @@ static int __init sa11xx_uda1341_init(vo
 		if (platform_get_drvdata(device))
 			return 0;
 		platform_device_unregister(device);
-		err = -ENODEV
+		err = -ENODEV;
 	} else
 		err = PTR_ERR(device);
 	platform_driver_unregister(&sa11xx_uda1341_driver);
_

Patches currently in -mm which might be from padator@wanadoo.fr are

origin.patch
atari_pamsnetc-old-declaration-ritchie-style-fix.patch
