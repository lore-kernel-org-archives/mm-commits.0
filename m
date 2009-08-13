From: akpm@linux-foundation.org
Subject: [to-be-updated] input-add-a-driver-for-the-winbond-wpcd376i-consumer-ir-hardware-fixes.patch removed from -mm tree
Date: Thu, 13 Aug 2009 12:23:17 -0700
Message-ID: <200908131923.n7DJNHNH019034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbZHMTXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 15:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@hardeman.nu, dtor@mail.ru, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     Fixes for the Winbond WPCD376I driver
has been removed from the -mm tree.  Its filename was
     input-add-a-driver-for-the-winbond-wpcd376i-consumer-ir-hardware-f=
ixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: Fixes for the Winbond WPCD376I driver
=46rom: David H=E4rdeman <david@hardeman.nu>

Adds a couple of fixes for the IR RX handling in the
drivers/input/misc/winbond-cir.c driver.

Most importantly, the hardware forces a FIFO RX/TX buffer size of 16
even though this isn't documented in the specs (meaning that an
interrupt is generated when 8 bytes are loaded, not when 16 bytes are
loaded).

Second, a loop was using the wrong parameter.

Third, it makes more sense to disable RX before draining the RX buffer
rather than the other way around.

This patch applies on top of the patches already in the -mm tree.

Signed-off-by: David H=E4rdeman <david@hardeman.nu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/winbond-cir.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/input/misc/winbond-cir.c~input-add-a-driver-for-the-w=
inbond-wpcd376i-consumer-ir-hardware-fixes drivers/input/misc/winbond-c=
ir.c
--- a/drivers/input/misc/winbond-cir.c~input-add-a-driver-for-the-winbo=
nd-wpcd376i-consumer-ir-hardware-fixes
+++ a/drivers/input/misc/winbond-cir.c
@@ -941,7 +941,7 @@ wbcir_irq_handler(int irqno, void *cooki
 	struct device *dev =3D &device->dev;
 	u8 status;
 	unsigned long flags;
-	u8 irdata[16];
+	u8 irdata[8];
 	int i;
 	unsigned int hw;
=20
@@ -962,11 +962,10 @@ wbcir_irq_handler(int irqno, void *cooki
 	if (!(status & WBCIR_IRQ_RX))
 		goto out;
=20
-	/* Since RXHDLEV is set, at least 16 bytes are in the FIFO */
+	/* Since RXHDLEV is set, at least 8 bytes are in the FIFO */
 	insb(data->sbase + WBCIR_REG_SP3_RXDATA, &irdata[0], 8);
-	insb(data->sbase + WBCIR_REG_SP3_RXDATA, &irdata[8], 8);
=20
-	for (i =3D 0; i < sizeof(data); i++) {
+	for (i =3D 0; i < sizeof(irdata); i++) {
 		hw =3D hweight8(irdata[i]);
 		if (hw > 4)
 			add_irdata_bit(data, 0);
@@ -980,13 +979,13 @@ wbcir_irq_handler(int irqno, void *cooki
 	}
=20
 	if (data->idle_count > WBCIR_MAX_IDLE_BYTES) {
-		/* Drain the FIFO */
+		/* Set RXINACTIVE... */
+		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
+
+		/* ...and drain the FIFO */
 		while (inb(data->sbase + WBCIR_REG_SP3_LSR) & WBCIR_RX_AVAIL)
 			inb(data->sbase + WBCIR_REG_SP3_RXDATA);
=20
-		/* And set RXINACTIVE */
-		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
-
 		dev_dbg(dev, "IRDATA:\n");
 		for (i =3D 0; i < data->irdata_count; i +=3D BITS_PER_LONG)
 			dev_dbg(dev, "0x%08lX\n", data->irdata[i/BITS_PER_LONG]);
@@ -1438,10 +1437,13 @@ wbcir_probe(struct pnp_dev *device, cons
 	 *
 	 * The ECIR registers include a flag to change the
 	 * 24Mhz clock freq to 48Mhz.
+	 *
+	 * It's not documented in the specs, but fifo levels
+	 * other than 16 seem to be unsupported.
 	 */
=20
-	/* prescaler 1.0, tx/rx fifo lvl 32 */
-	outb(0x35, data->sbase + WBCIR_REG_SP3_EXCR2);
+	/* prescaler 1.0, tx/rx fifo lvl 16 */
+	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
=20
 	/* Set baud divisor to generate one byte per bit/cell */
 	switch (protocol) {
@@ -1490,7 +1492,7 @@ wbcir_probe(struct pnp_dev *device, cons
 	else
 		outb(0x00, data->sbase + WBCIR_REG_SP3_IRCFG4);
=20
-	/* Set FIFO thresholds (RX =3D 16, TX =3D 7), reset RX/TX */
+	/* Set FIFO thresholds (RX =3D 8, TX =3D 3), reset RX/TX */
 	wbcir_select_bank(data, WBCIR_BANK_0);
 	outb(0x97, data->sbase + WBCIR_REG_SP3_FCR);
=20
@@ -1498,7 +1500,6 @@ wbcir_probe(struct pnp_dev *device, cons
 	outb(0xE0, data->sbase + WBCIR_REG_SP3_ASCR);
=20
 	/* Enable interrupts */
-	wbcir_select_bank(data, WBCIR_BANK_0);
 	outb(WBCIR_IRQ_RX | WBCIR_IRQ_ERR, data->sbase + WBCIR_REG_SP3_IER);
=20
 	return 0;
_

Patches currently in -mm which might be from david@hardeman.nu are

acpi-reintroduce-acpi_device_ops-shutdown-method.patch
input-add-a-shutdown-method-to-pnp-drivers.patch
input-add-a-driver-for-the-winbond-wpcd376i-consumer-ir-hardware-fixes.=
patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
