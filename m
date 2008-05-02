From: akpm@linux-foundation.org
Subject: - smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch removed from -mm tree
Date: Fri, 02 May 2008 15:20:17 -0700
Message-ID: <200805022220.m42MKHNm017829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760412AbYEBWUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 18:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, kamalesh@linux.vnet.ibm.com, samuel@sortiz.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
has been removed from the -mm tree.  Its filename was
     smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Wrap PNP probe code in #ifdef CONFIG_PNP.

Without this change, we'll have unresolved references to pnp_get_resource()
function when CONFIG_PNP=n.  (This is a new interface that's not in mainline
yet.)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/smsc-ircc2.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/net/irda/smsc-ircc2.c~smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp drivers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -79,9 +79,13 @@ MODULE_AUTHOR("Daniele Peri <peri@csai.u
 MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_PNP
 static int smsc_nopnp = 1;
 module_param_named(nopnp, smsc_nopnp, bool, 0);
 MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings, defaults to true");
+#else
+#define smsc_nopnp 1
+#endif
 
 #define DMA_INVAL 255
 static int ircc_dma = DMA_INVAL;
@@ -366,6 +370,10 @@ static inline void register_bank(int iob
                iobase + IRCC_MASTER);
 }
 
+static int pnp_driver_registered;
+
+#ifdef CONFIG_PNP
+
 /* PNP hotplug support */
 static const struct pnp_device_id smsc_ircc_pnp_table[] = {
 	{ .id = "SMCf010", .driver_data = 0 },
@@ -374,8 +382,6 @@ static const struct pnp_device_id smsc_i
 };
 MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_table);
 
-static int pnp_driver_registered;
-
 static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
 				      const struct pnp_device_id *dev_id)
 {
@@ -403,6 +409,10 @@ static struct pnp_driver smsc_ircc_pnp_d
 	.probe		= smsc_ircc_pnp_probe,
 };
 
+#else
+static struct pnp_driver smsc_ircc_pnp_driver;
+#endif
+
 
 /*******************************************************************************
  *
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
linux-next.patch
pnp-fix-missing-kernel-doc-notation.patch
acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-irq-index-in-sysfs-set-irq-interface.patch

