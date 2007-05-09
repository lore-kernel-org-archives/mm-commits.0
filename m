From: akpm@linux-foundation.org
Subject: - smsc-ircc2-add-pnp-support.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:50 -0700
Message-ID: <200705090256.l492uolH010099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970218AbXEIC66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, castet.matthieu@free.fr, jt@hpl.hp.com, kaos@ocs.com.au, lenb@kernel.org, mjg59@srcf.ucam.org, rmk+serial@arm.linux.org.uk, samuel@sortiz.org, syrjala@sci.fi, mm-commits@vger.kernel.org


The patch titled
     smsc-ircc2: add PNP support
has been removed from the -mm tree.  Its filename was
     smsc-ircc2-add-pnp-support.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: smsc-ircc2: add PNP support
=46rom: Bjorn Helgaas <bjorn.helgaas@hp.com>

Claim devices using PNP, unless the user explicitly specified device
addresses.  This can be disabled with the "smsc-ircc2.nopnp" option.

This removes the need for probing legacy addresses and helps untangle I=
R
devices from serial8250 devices.

Sometimes the SMC device is at a legacy COM port address but does not u=
se the
legacy COM IRQ.  In this case, claiming the device using PNP rather tha=
n 8250
legacy probe means we can automatically use the correct IRQ rather than
forcing the user to use "setserial" to set the IRQ manually.

If the PNP claim doesn't work, make sure you don't have a setserial ini=
t
script, e.g., /etc/init.d/setserial, configured to poke in legacy COM p=
ort
resources for the IRDA device.  That causes the serial driver to claim
resources needed by this driver.

Based on this patch by Ville Syrj=E4l=E4:
    http://www.hpl.hp.com/personal/Jean_Tourrilhes/IrDA/ir260_smsc_pnp.=
diff

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Acked-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   11 ++
 drivers/net/irda/smsc-ircc2.c       |   98 +++++++++++++++++++-------
 2 files changed, 86 insertions(+), 23 deletions(-)

diff -puN Documentation/kernel-parameters.txt~smsc-ircc2-add-pnp-suppor=
t Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~smsc-ircc2-add-pnp-support
+++ a/Documentation/kernel-parameters.txt
@@ -1578,6 +1578,17 @@ and is between 256 and 4096 characters.=20
 	smp-alt-once	[IA-32,SMP] On a hotplug CPU system, only
 			attempt to substitute SMP alternatives once at boot.
=20
+	smsc-ircc2.nopnp	[HW] Don't use PNP to discover SMC devices
+	smsc-ircc2.ircc_cfg=3D	[HW] Device configuration I/O port
+	smsc-ircc2.ircc_sir=3D	[HW] SIR base I/O port
+	smsc-ircc2.ircc_fir=3D	[HW] FIR base I/O port
+	smsc-ircc2.ircc_irq=3D	[HW] IRQ line
+	smsc-ircc2.ircc_dma=3D	[HW] DMA channel
+	smsc-ircc2.ircc_transceiver=3D [HW] Transceiver type:
+				0: Toshiba Satellite 1800 (GP data pin select)
+				1: Fast pin select (default)
+				2: ATC IRMode
+
 	snd-ad1816a=3D	[HW,ALSA]
=20
 	snd-ad1848=3D	[HW,ALSA]
diff -puN drivers/net/irda/smsc-ircc2.c~smsc-ircc2-add-pnp-support driv=
ers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~smsc-ircc2-add-pnp-support
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -79,6 +79,10 @@ MODULE_AUTHOR("Daniele Peri <peri@csai.u
 MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
 MODULE_LICENSE("GPL");
=20
+static int smsc_nopnp;
+module_param_named(nopnp, smsc_nopnp, bool, 0);
+MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings"=
);
+
 #define DMA_INVAL 255
 static int ircc_dma =3D DMA_INVAL;
 module_param(ircc_dma, int, 0);
@@ -362,7 +366,6 @@ static inline void register_bank(int iob
                iobase + IRCC_MASTER);
 }
=20
-#ifdef	CONFIG_PNP
 /* PNP hotplug support */
 static const struct pnp_device_id smsc_ircc_pnp_table[] =3D {
 	{ .id =3D "SMCf010", .driver_data =3D 0 },
@@ -370,7 +373,35 @@ static const struct pnp_device_id smsc_i
 	{ }
 };
 MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_table);
-#endif
+
+static int pnp_driver_registered;
+
+static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
+				      const struct pnp_device_id *dev_id)
+{
+	unsigned int firbase, sirbase;
+	u8 dma, irq;
+
+	if (!(pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) &&
+	      pnp_dma_valid(dev, 0) && pnp_irq_valid(dev, 0)))
+		return -EINVAL;
+
+	sirbase =3D pnp_port_start(dev, 0);
+	firbase =3D pnp_port_start(dev, 1);
+	dma =3D pnp_dma(dev, 0);
+	irq =3D pnp_irq(dev, 0);
+
+	if (smsc_ircc_open(firbase, sirbase, dma, irq))
+		return -ENODEV;
+
+	return 0;
+}
+
+static struct pnp_driver smsc_ircc_pnp_driver =3D {
+	.name		=3D "smsc-ircc2",
+	.id_table	=3D smsc_ircc_pnp_table,
+	.probe		=3D smsc_ircc_pnp_probe,
+};
=20
=20
 /*********************************************************************=
**********
@@ -381,6 +412,35 @@ MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_t
  *
  *********************************************************************=
**********/
=20
+static int __init smsc_ircc_legacy_probe(void)
+{
+	int ret =3D 0;
+
+	if (ircc_fir > 0 && ircc_sir > 0) {
+		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
+		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
+
+		if (smsc_ircc_open(ircc_fir, ircc_sir, ircc_dma, ircc_irq))
+			ret =3D -ENODEV;
+	} else {
+		ret =3D -ENODEV;
+
+		/* try user provided configuration register base address */
+		if (ircc_cfg > 0) {
+			IRDA_MESSAGE(" Overriding configuration address "
+				     "0x%04x\n", ircc_cfg);
+			if (!smsc_superio_fdc(ircc_cfg))
+				ret =3D 0;
+			if (!smsc_superio_lpc(ircc_cfg))
+				ret =3D 0;
+		}
+
+		if (smsc_ircc_look_for_chips() > 0)
+			ret =3D 0;
+	}
+	return ret;
+}
+
 /*
  * Function smsc_ircc_init ()
  *
@@ -408,31 +468,20 @@ static int __init smsc_ircc_init(void)
=20
 	dev_count =3D 0;
=20
-	if (ircc_fir > 0 && ircc_sir > 0) {
-		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
-		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
-
-		if (smsc_ircc_open(ircc_fir, ircc_sir, ircc_dma, ircc_irq))
-			ret =3D -ENODEV;
+	if (smsc_nopnp || !pnp_platform_devices ||
+	    ircc_cfg || ircc_fir || ircc_sir ||
+	    ircc_dma !=3D DMA_INVAL || ircc_irq !=3D IRQ_INVAL) {
+		ret =3D smsc_ircc_legacy_probe();
 	} else {
-		ret =3D -ENODEV;
-
-		/* try user provided configuration register base address */
-		if (ircc_cfg > 0) {
-			IRDA_MESSAGE(" Overriding configuration address "
-				     "0x%04x\n", ircc_cfg);
-			if (!smsc_superio_fdc(ircc_cfg))
-				ret =3D 0;
-			if (!smsc_superio_lpc(ircc_cfg))
-				ret =3D 0;
-		}
-
-		if (smsc_ircc_look_for_chips() > 0)
-			ret =3D 0;
+		if (pnp_register_driver(&smsc_ircc_pnp_driver) =3D=3D 0)
+			pnp_driver_registered =3D 1;
 	}
=20
-	if (ret)
+	if (ret) {
+		if (pnp_driver_registered)
+			pnp_unregister_driver(&smsc_ircc_pnp_driver);
 		platform_driver_unregister(&smsc_ircc_driver);
+	}
=20
 	return ret;
 }
@@ -1842,6 +1891,9 @@ static void __exit smsc_ircc_cleanup(voi
 			smsc_ircc_close(dev_self[i]);
 	}
=20
+	if (pnp_driver_registered)
+		pnp_unregister_driver(&smsc_ircc_pnp_driver);
+
 	platform_driver_unregister(&smsc_ircc_driver);
 }
=20
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
move-free-pages-between-lists-on-steal.patch
use-menuconfig-objects-pnp.patch
