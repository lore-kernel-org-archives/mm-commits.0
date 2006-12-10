From: akpm@osdl.org
Subject: - sun3-scsi-make-sun3-scsi-drivers-compile-work-again.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:52:58 -0800
Message-ID: <200612100152.kBA1qwBE010615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40602 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759292AbWLJBx5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sammy@sammy.net, James.Bottomley@steeleye.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Sun3 SCSI: Make sun3 scsi drivers compile/work again
has been removed from the -mm tree.  Its filename was
     sun3-scsi-make-sun3-scsi-drivers-compile-work-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Sun3 SCSI: Make sun3 scsi drivers compile/work again
From: Sam Creasey <sammy@sammy.net>

Make sun3 scsi drivers compile/work again (though with way too many warnings...)

Tested on 3/50, 3/60.

Signed-off-by: Sam Creasey <sammy@sammy.net>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/Kconfig         |    2 +-
 drivers/scsi/sun3_NCR5380.c  |    4 ++--
 drivers/scsi/sun3_scsi.c     |    2 +-
 drivers/scsi/sun3_scsi.h     |    2 +-
 drivers/scsi/sun3_scsi_vme.c |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/Kconfig~sun3-scsi-make-sun3-scsi-drivers-compile-work-again drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~sun3-scsi-make-sun3-scsi-drivers-compile-work-again
+++ a/drivers/scsi/Kconfig
@@ -1737,7 +1737,7 @@ config SCSI_NCR53C7xx_FAST
 
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
-	depends on SUN3 && SCSI && BROKEN
+	depends on SUN3 && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This option will enable support for the OBIO (onboard io) NCR5380
diff -puN drivers/scsi/sun3_NCR5380.c~sun3-scsi-make-sun3-scsi-drivers-compile-work-again drivers/scsi/sun3_NCR5380.c
--- a/drivers/scsi/sun3_NCR5380.c~sun3-scsi-make-sun3-scsi-drivers-compile-work-again
+++ a/drivers/scsi/sun3_NCR5380.c
@@ -1271,7 +1271,7 @@ static irqreturn_t NCR5380_intr (int irq
 	NCR_PRINT(NDEBUG_INTR);
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
 	    done = 0;
-	    ENABLE_IRQ();
+//	    ENABLE_IRQ();
 	    INT_PRINTK("scsi%d: SEL interrupt\n", HOSTNO);
 	    NCR5380_reselect(instance);
 	    (void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
@@ -1304,7 +1304,7 @@ static irqreturn_t NCR5380_intr (int irq
 		INT_PRINTK("scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
 		NCR5380_dma_complete( instance );
 		done = 0;
-		ENABLE_IRQ();
+//		ENABLE_IRQ();
 	    } else
 #endif /* REAL_DMA */
 	    {
diff -puN drivers/scsi/sun3_scsi.c~sun3-scsi-make-sun3-scsi-drivers-compile-work-again drivers/scsi/sun3_scsi.c
--- a/drivers/scsi/sun3_scsi.c~sun3-scsi-make-sun3-scsi-drivers-compile-work-again
+++ a/drivers/scsi/sun3_scsi.c
@@ -75,9 +75,9 @@
 #define REAL_DMA
 
 #include "scsi.h"
+#include "initio.h"
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
-#include "NCR5380.h"
 
 static void NCR5380_print(struct Scsi_Host *instance);
 
diff -puN drivers/scsi/sun3_scsi.h~sun3-scsi-make-sun3-scsi-drivers-compile-work-again drivers/scsi/sun3_scsi.h
--- a/drivers/scsi/sun3_scsi.h~sun3-scsi-make-sun3-scsi-drivers-compile-work-again
+++ a/drivers/scsi/sun3_scsi.h
@@ -221,7 +221,7 @@ struct sun3_udc_regs {
  *
  */
 
-
+#include "NCR5380.h"
 
 #if NDEBUG & NDEBUG_ARBITRATION
 #define ARB_PRINTK(format, args...) \
diff -puN drivers/scsi/sun3_scsi_vme.c~sun3-scsi-make-sun3-scsi-drivers-compile-work-again drivers/scsi/sun3_scsi_vme.c
--- a/drivers/scsi/sun3_scsi_vme.c~sun3-scsi-make-sun3-scsi-drivers-compile-work-again
+++ a/drivers/scsi/sun3_scsi_vme.c
@@ -41,9 +41,9 @@
 #define REAL_DMA
 
 #include "scsi.h"
+#include "initio.h"
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
-#include "NCR5380.h"
 
 extern int sun3_map_test(unsigned long, char *);
 
_

Patches currently in -mm which might be from sammy@sammy.net are

origin.patch

