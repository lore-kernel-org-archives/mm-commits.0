From: akpm@linux-foundation.org
Subject: - rtc-cmos-make-it-load-on-pnpbios-systems.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:42 -0700
Message-ID: <200705090254.l492sg6Y009831@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032273AbXEICyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mvrh@freeshells.ch, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos: make it load on PNPBIOS systems
has been removed from the -mm tree.  Its filename was
     rtc-cmos-make-it-load-on-pnpbios-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-cmos: make it load on PNPBIOS systems
From: Marko Vrh <mvrh@freeshells.ch>

Replace CONFIG_PNPACPI with CONFIG_PNP, so it loads on ACPI-less PNPBIOS
systems.

Signed-off-by: Marko Vrh <mvrh@freeshells.ch>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-make-it-load-on-pnpbios-systems drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-make-it-load-on-pnpbios-systems
+++ a/drivers/rtc/rtc-cmos.c
@@ -383,12 +383,12 @@ static irqreturn_t cmos_interrupt(int ir
 		return IRQ_NONE;
 }
 
-#ifdef	CONFIG_PNPACPI
-#define	is_pnpacpi()	1
+#ifdef	CONFIG_PNP
+#define	is_pnp()	1
 #define	INITSECTION
 
 #else
-#define	is_pnpacpi()	0
+#define	is_pnp()	0
 #define	INITSECTION	__init
 #endif
 
@@ -438,7 +438,7 @@ cmos_do_probe(struct device *dev, struct
 	 * REVISIT for non-x86 systems we may need to handle io memory
 	 * resources: ioremap them, and request_mem_region().
 	 */
-	if (is_pnpacpi()) {
+	if (is_pnp()) {
 		retval = request_resource(&ioport_resource, ports);
 		if (retval < 0) {
 			dev_dbg(dev, "i/o registers already in use\n");
@@ -531,7 +531,7 @@ static void __exit cmos_do_remove(struct
 
 	cmos_do_shutdown();
 
-	if (is_pnpacpi())
+	if (is_pnp())
 		release_resource(cmos->iomem);
 	rename_region(cmos->iomem, NULL);
 
@@ -630,7 +630,7 @@ static int cmos_resume(struct device *de
  * the device node will always be created as a PNPACPI device.
  */
 
-#ifdef	CONFIG_PNPACPI
+#ifdef	CONFIG_PNP
 
 #include <linux/pnp.h>
 
@@ -701,11 +701,11 @@ static void __exit cmos_exit(void)
 }
 module_exit(cmos_exit);
 
-#else	/* no PNPACPI */
+#else	/* no PNP */
 
 /*----------------------------------------------------------------*/
 
-/* Platform setup should have set up an RTC device, when PNPACPI is
+/* Platform setup should have set up an RTC device, when PNP is
  * unavailable ... this could happen even on (older) PCs.
  */
 
@@ -751,7 +751,7 @@ static void __exit cmos_exit(void)
 module_exit(cmos_exit);
 
 
-#endif	/* !PNPACPI */
+#endif	/* !PNP */
 
 MODULE_AUTHOR("David Brownell");
 MODULE_DESCRIPTION("Driver for PC-style 'CMOS' RTCs");
_

Patches currently in -mm which might be from mvrh@freeshells.ch are

origin.patch
