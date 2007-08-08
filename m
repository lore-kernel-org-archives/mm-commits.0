From: akpm@linux-foundation.org
Subject: + use-ssb-extif-in-ssb-mips-core-driver-fix.patch added to -mm tree
Date: Tue, 07 Aug 2007 17:40:44 -0700
Message-ID: <200708080040.l780eirq012811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758945AbXHHAlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 20:41:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, aurelien@aurel32.net, nbd@openwrt.org


The patch titled
     ssb: Fix extif compile error
has been added to the -mm tree.  Its filename is
     use-ssb-extif-in-ssb-mips-core-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ssb: Fix extif compile error
From: Michael Buesch <mb@bu3sch.de>

This is a compilation fix for a recently applied patch
[PATCH 2/3] Use SSB EXTIF in SSB MIPS core driver
when the extif core is not enabled.

This also makes the extif driver depend on CONFIG_SSB_DRIVER_EXTIF
(sorry, my mistake).

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/main.c                   |    2 -
 include/linux/ssb/ssb_driver_extif.h |   36 ++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 5 deletions(-)

diff -puN drivers/ssb/main.c~use-ssb-extif-in-ssb-mips-core-driver-fix drivers/ssb/main.c
--- a/drivers/ssb/main.c~use-ssb-extif-in-ssb-mips-core-driver-fix
+++ a/drivers/ssb/main.c
@@ -819,7 +819,7 @@ u32 ssb_clockspeed(struct ssb_bus *bus)
 	u32 plltype;
 	u32 clkctl_n, clkctl_m;
 
-	if (bus->extif.dev)
+	if (ssb_extif_available(&bus->extif))
 		ssb_extif_get_clockcontrol(&bus->extif, &plltype,
 					   &clkctl_n, &clkctl_m);
 	else if (bus->chipco.dev)
diff -puN include/linux/ssb/ssb_driver_extif.h~use-ssb-extif-in-ssb-mips-core-driver-fix include/linux/ssb/ssb_driver_extif.h
--- a/include/linux/ssb/ssb_driver_extif.h~use-ssb-extif-in-ssb-mips-core-driver-fix
+++ a/include/linux/ssb/ssb_driver_extif.h
@@ -20,10 +20,6 @@
 #ifndef LINUX_SSB_EXTIFCORE_H_
 #define LINUX_SSB_EXTIFCORE_H_
 
-struct ssb_extif {
-	struct ssb_device *dev;
-};
-
 /* external interface address space */
 #define	SSB_EXTIF_PCMCIA_MEMBASE(x)	(x)
 #define	SSB_EXTIF_PCMCIA_IOBASE(x)	((x) + 0x100000)
@@ -156,6 +152,19 @@ struct ssb_extif {
 /* watchdog */
 #define SSB_EXTIF_WATCHDOG_CLK		48000000	/* Hz */
 
+
+
+#ifdef CONFIG_SSB_DRIVER_EXTIF
+
+struct ssb_extif {
+	struct ssb_device *dev;
+};
+
+static inline bool ssb_extif_available(struct ssb_extif *extif)
+{
+	return (extif->dev != NULL);
+}
+
 extern void ssb_extif_get_clockcontrol(struct ssb_extif *extif,
 			               u32 *plltype, u32 *n, u32 *m);
 
@@ -167,4 +176,23 @@ extern int ssb_extif_serial_init(struct 
 				 struct ssb_serial_port *ports);
 #endif /* CONFIG_SSB_SERIAL */
 
+
+#else /* CONFIG_SSB_DRIVER_EXTIF */
+/* extif disabled */
+
+struct ssb_extif {
+};
+
+static inline bool ssb_extif_available(struct ssb_extif *extif)
+{
+	return 0;
+}
+
+static inline
+void ssb_extif_get_clockcontrol(struct ssb_extif *extif,
+			        u32 *plltype, u32 *n, u32 *m)
+{
+}
+
+#endif /* CONFIG_SSB_DRIVER_EXTIF */
 #endif /* LINUX_SSB_EXTIFCORE_H_ */
_

Patches currently in -mm which might be from mb@bu3sch.de are

git-wireless.patch
merge-the-sonics-silicon-backplane-subsystem.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
avoid-ssb-compililation-on-s390.patch
b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
merge-the-sonics-silicon-backplane-subsystem-update.patch
ssb-compile-fix.patch
watchdog-support-3.patch
ssb-chipcommon-add-function-to-get-processor-clock.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
ssb-mainc-needs-dma-mappingh.patch
ssb-extif-timing-serial-port-initialization.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
use-ssb-extif-in-ssb-mips-core-driver-fix.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
ssb-add-a-driver-for-the-broadcom-ohci-core.patch
