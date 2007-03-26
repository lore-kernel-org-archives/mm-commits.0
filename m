From: akpm@linux-foundation.org
Subject: + minor-spi_butterfly-cleanup.patch added to -mm tree
Date: Mon, 26 Mar 2007 15:00:52 -0700
Message-ID: <200703262200.l2QM0qVu031683@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54449 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338AbXCZWA6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:00:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     minor spi_butterfly cleanup
has been added to the -mm tree.  Its filename is
     minor-spi_butterfly-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: minor spi_butterfly cleanup
From: David Brownell <david-b@pacbell.net>

Simplify the spi_butterfly driver by removing incomplete/unused support for
the second SPI bus, implemented by the USI controller.  This should make
this a clearer example of how to write a parport bitbang driver.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_butterfly.c |   62 ++--------------------------------
 1 files changed, 4 insertions(+), 58 deletions(-)

diff -puN drivers/spi/spi_butterfly.c~minor-spi_butterfly-cleanup drivers/spi/spi_butterfly.c
--- a/drivers/spi/spi_butterfly.c~minor-spi_butterfly-cleanup
+++ a/drivers/spi/spi_butterfly.c
@@ -40,8 +40,6 @@
  * and use this custom parallel port cable.
  */
 
-#undef	HAVE_USI	/* nyet */
-
 
 /* DATA output bits (pins 2..9 == D0..D7) */
 #define	butterfly_nreset (1 << 1)		/* pin 3 */
@@ -49,19 +47,13 @@
 #define	spi_sck_bit	(1 << 0)		/* pin 2 */
 #define	spi_mosi_bit	(1 << 7)		/* pin 9 */
 
-#define	usi_sck_bit	(1 << 3)		/* pin 5 */
-#define	usi_mosi_bit	(1 << 4)		/* pin 6 */
-
 #define	vcc_bits	((1 << 6) | (1 << 5))	/* pins 7, 8 */
 
 /* STATUS input bits */
 #define	spi_miso_bit	PARPORT_STATUS_BUSY	/* pin 11 */
 
-#define	usi_miso_bit	PARPORT_STATUS_PAPEROUT	/* pin 12 */
-
 /* CONTROL output bits */
 #define	spi_cs_bit	PARPORT_CONTROL_SELECT	/* pin 17 */
-/* USI uses no chipselect */
 
 
 
@@ -70,15 +62,6 @@ static inline struct butterfly *spidev_t
 	return spi->controller_data;
 }
 
-static inline int is_usidev(struct spi_device *spi)
-{
-#ifdef	HAVE_USI
-	return spi->chip_select != 1;
-#else
-	return 0;
-#endif
-}
-
 
 struct butterfly {
 	/* REVISIT ... for now, this must be first */
@@ -97,23 +80,13 @@ struct butterfly {
 
 /*----------------------------------------------------------------------*/
 
-/*
- * these routines may be slower than necessary because they're hiding
- * the fact that there are two different SPI busses on this cable: one
- * to the DataFlash chip (or AVR SPI controller), the other to the
- * AVR USI controller.
- */
-
 static inline void
 setsck(struct spi_device *spi, int is_on)
 {
 	struct butterfly	*pp = spidev_to_pp(spi);
 	u8			bit, byte = pp->lastbyte;
 
-	if (is_usidev(spi))
-		bit = usi_sck_bit;
-	else
-		bit = spi_sck_bit;
+	bit = spi_sck_bit;
 
 	if (is_on)
 		byte |= bit;
@@ -129,10 +102,7 @@ setmosi(struct spi_device *spi, int is_o
 	struct butterfly	*pp = spidev_to_pp(spi);
 	u8			bit, byte = pp->lastbyte;
 
-	if (is_usidev(spi))
-		bit = usi_mosi_bit;
-	else
-		bit = spi_mosi_bit;
+	bit = spi_mosi_bit;
 
 	if (is_on)
 		byte |= bit;
@@ -148,10 +118,7 @@ static inline int getmiso(struct spi_dev
 	int			value;
 	u8			bit;
 
-	if (is_usidev(spi))
-		bit = usi_miso_bit;
-	else
-		bit = spi_miso_bit;
+	bit = spi_miso_bit;
 
 	/* only STATUS_BUSY is NOT negated */
 	value = !(parport_read_status(pp->port) & bit);
@@ -166,10 +133,6 @@ static void butterfly_chipselect(struct 
 	if (value != BITBANG_CS_INACTIVE)
 		setsck(spi, spi->mode & SPI_CPOL);
 
-	/* no chipselect on this USI link config */
-	if (is_usidev(spi))
-		return;
-
 	/* here, value == "activate or not";
 	 * most PARPORT_CONTROL_* bits are negated, so we must
 	 * morph it to value == "bit value to write in control register"
@@ -300,7 +263,7 @@ static void butterfly_attach(struct parp
 	parport_frob_control(pp->port, spi_cs_bit, 0);
 
 	/* stabilize power with chip in reset (nRESET), and
-	 * both spi_sck_bit and usi_sck_bit clear (CPOL=0)
+	 * spi_sck_bit clear (CPOL=0)
 	 */
 	pp->lastbyte |= vcc_bits;
 	parport_write_data(pp->port, pp->lastbyte);
@@ -334,23 +297,6 @@ static void butterfly_attach(struct parp
 		pr_debug("%s: dataflash at %s\n", p->name,
 				pp->dataflash->dev.bus_id);
 
-#ifdef	HAVE_USI
-	/* Bus 2 is only for talking to the AVR, and it can work no
-	 * matter who masters bus 1; needs appropriate AVR firmware.
-	 */
-	pp->info[1].max_speed_hz = 10 /* ?? */ * 1000 * 1000;
-	strcpy(pp->info[1].modalias, "butterfly");
-	// pp->info[1].platform_data = ... TBD ... ;
-	pp->info[1].chip_select = 2,
-	pp->info[1].controller_data = pp;
-	pp->butterfly = spi_new_device(pp->bitbang.master, &pp->info[1]);
-	if (pp->butterfly)
-		pr_debug("%s: butterfly at %s\n", p->name,
-				pp->butterfly->dev.bus_id);
-
-	/* FIXME setup ACK for the IRQ line ...  */
-#endif
-
 	// dev_info(_what?_, ...)
 	pr_info("%s: AVR Butterfly\n", p->name);
 	butterfly = pp;
_

Patches currently in -mm which might be from david-b@pacbell.net are

8250-make-probing-for-txen-bug-a-config-option.patch
scsi-newstyle-hotplug-coldplug-support.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-kconfig-cleanup.patch
