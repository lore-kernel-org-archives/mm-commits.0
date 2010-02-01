From: akpm@linux-foundation.org
Subject: + tpm_infineon-fix-suspend-resume-handler-for-pnp_driver-2.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:13:33 -0800
Message-ID: <201002012213.o11MDX7m015694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787Ab0BAWPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.selhorst@sirrix.com, debora@linux.vnet.ibm.com, hirofumi@mail.parknet.co.jp, srajiv@linux.vnet.ibm.com, stable@kernel.org


The patch titled
     tpm_infineon: fix suspend/resume handler for pnp_driver
has been added to the -mm tree.  Its filename is
     tpm_infineon-fix-suspend-resume-handler-for-pnp_driver-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm_infineon: fix suspend/resume handler for pnp_driver
From: Marcel Selhorst <m.selhorst@sirrix.com>

When suspending, tpm_infineon calls the generic suspend function of the
TPM framework.  However, the TPM framework does not return and the system
hangs upon suspend.  When sending the necessary command "TPM_SaveState"
directly within the driver, suspending and resuming works fine.

Signed-off-by: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: <stable@kernel.org>		[2.6.32.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_infineon.c |   79 +++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff -puN drivers/char/tpm/tpm_infineon.c~tpm_infineon-fix-suspend-resume-handler-for-pnp_driver-2 drivers/char/tpm/tpm_infineon.c
--- a/drivers/char/tpm/tpm_infineon.c~tpm_infineon-fix-suspend-resume-handler-for-pnp_driver-2
+++ a/drivers/char/tpm/tpm_infineon.c
@@ -39,12 +39,12 @@
 struct tpm_inf_dev {
 	int iotype;
 
-	void __iomem *mem_base;		/* MMIO ioremap'd addr */
-	unsigned long map_base;		/* phys MMIO base */
-	unsigned long map_size;		/* MMIO region size */
-	unsigned int index_off;		/* index register offset */
+	void __iomem *mem_base;	/* MMIO ioremap'd addr */
+	unsigned long map_base;	/* phys MMIO base */
+	unsigned long map_size;	/* MMIO region size */
+	unsigned int index_off;	/* index register offset */
 
-	unsigned int data_regs;		/* Data registers */
+	unsigned int data_regs;	/* Data registers */
 	unsigned int data_size;
 
 	unsigned int config_port;	/* IO Port config index reg */
@@ -406,14 +406,14 @@ static const struct tpm_vendor_specific 
 	.miscdev = {.fops = &inf_ops,},
 };
 
-static const struct pnp_device_id tpm_pnp_tbl[] = {
+static const struct pnp_device_id tpm_inf_pnp_tbl[] = {
 	/* Infineon TPMs */
 	{"IFX0101", 0},
 	{"IFX0102", 0},
 	{"", 0}
 };
 
-MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
+MODULE_DEVICE_TABLE(pnp, tpm_inf_pnp_tbl);
 
 static int __devinit tpm_inf_pnp_probe(struct pnp_dev *dev,
 				       const struct pnp_device_id *dev_id)
@@ -430,7 +430,7 @@ static int __devinit tpm_inf_pnp_probe(s
 	if (pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) &&
 	    !(pnp_port_flags(dev, 0) & IORESOURCE_DISABLED)) {
 
-	    	tpm_dev.iotype = TPM_INF_IO_PORT;
+		tpm_dev.iotype = TPM_INF_IO_PORT;
 
 		tpm_dev.config_port = pnp_port_start(dev, 0);
 		tpm_dev.config_size = pnp_port_len(dev, 0);
@@ -459,9 +459,9 @@ static int __devinit tpm_inf_pnp_probe(s
 			goto err_last;
 		}
 	} else if (pnp_mem_valid(dev, 0) &&
-	           !(pnp_mem_flags(dev, 0) & IORESOURCE_DISABLED)) {
+		   !(pnp_mem_flags(dev, 0) & IORESOURCE_DISABLED)) {
 
-	    	tpm_dev.iotype = TPM_INF_IO_MEM;
+		tpm_dev.iotype = TPM_INF_IO_MEM;
 
 		tpm_dev.map_base = pnp_mem_start(dev, 0);
 		tpm_dev.map_size = pnp_mem_len(dev, 0);
@@ -563,11 +563,11 @@ static int __devinit tpm_inf_pnp_probe(s
 			 "product id 0x%02x%02x"
 			 "%s\n",
 			 tpm_dev.iotype == TPM_INF_IO_PORT ?
-				tpm_dev.config_port :
-				tpm_dev.map_base + tpm_dev.index_off,
+			 tpm_dev.config_port :
+			 tpm_dev.map_base + tpm_dev.index_off,
 			 tpm_dev.iotype == TPM_INF_IO_PORT ?
-				tpm_dev.data_regs :
-				tpm_dev.map_base + tpm_dev.data_regs,
+			 tpm_dev.data_regs :
+			 tpm_dev.map_base + tpm_dev.data_regs,
 			 version[0], version[1],
 			 vendorid[0], vendorid[1],
 			 productid[0], productid[1], chipname);
@@ -607,20 +607,55 @@ static __devexit void tpm_inf_pnp_remove
 			iounmap(tpm_dev.mem_base);
 			release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
 		}
+		tpm_dev_vendor_release(chip);
 		tpm_remove_hardware(chip->dev);
 	}
 }
 
+static int tpm_inf_pnp_suspend(struct pnp_dev *dev, pm_message_t pm_state)
+{
+	struct tpm_chip *chip = pnp_get_drvdata(dev);
+	int rc;
+	if (chip) {
+		u8 savestate[] = {
+			0, 193,	/* TPM_TAG_RQU_COMMAND */
+			0, 0, 0, 10,	/* blob length (in bytes) */
+			0, 0, 0, 152	/* TPM_ORD_SaveState */
+		};
+		dev_info(&dev->dev, "saving TPM state\n");
+		rc = tpm_inf_send(chip, savestate, sizeof(savestate));
+		if (rc < 0) {
+			dev_err(&dev->dev, "error while saving TPM state\n");
+			return rc;
+		}
+	}
+	return 0;
+}
+
+static int tpm_inf_pnp_resume(struct pnp_dev *dev)
+{
+	/* Re-configure TPM after suspending */
+	tpm_config_out(ENABLE_REGISTER_PAIR, TPM_INF_ADDR);
+	tpm_config_out(IOLIMH, TPM_INF_ADDR);
+	tpm_config_out((tpm_dev.data_regs >> 8) & 0xff, TPM_INF_DATA);
+	tpm_config_out(IOLIML, TPM_INF_ADDR);
+	tpm_config_out((tpm_dev.data_regs & 0xff), TPM_INF_DATA);
+	/* activate register */
+	tpm_config_out(TPM_DAR, TPM_INF_ADDR);
+	tpm_config_out(0x01, TPM_INF_DATA);
+	tpm_config_out(DISABLE_REGISTER_PAIR, TPM_INF_ADDR);
+	/* disable RESET, LP and IRQC */
+	tpm_data_out(RESET_LP_IRQC_DISABLE, CMD);
+	return tpm_pm_resume(&dev->dev);
+}
+
 static struct pnp_driver tpm_inf_pnp_driver = {
 	.name = "tpm_inf_pnp",
-	.driver = {
-		.owner = THIS_MODULE,
-		.suspend = tpm_pm_suspend,
-		.resume = tpm_pm_resume,
-	},
-	.id_table = tpm_pnp_tbl,
+	.id_table = tpm_inf_pnp_tbl,
 	.probe = tpm_inf_pnp_probe,
-	.remove = __devexit_p(tpm_inf_pnp_remove),
+	.suspend = tpm_inf_pnp_suspend,
+	.resume = tpm_inf_pnp_resume,
+	.remove = __devexit_p(tpm_inf_pnp_remove)
 };
 
 static int __init init_inf(void)
@@ -638,5 +673,5 @@ module_exit(cleanup_inf);
 
 MODULE_AUTHOR("Marcel Selhorst <m.selhorst@sirrix.com>");
 MODULE_DESCRIPTION("Driver for Infineon TPM SLD 9630 TT 1.1 / SLB 9635 TT 1.2");
-MODULE_VERSION("1.9");
+MODULE_VERSION("1.9.2");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from m.selhorst@sirrix.com are

tpm_infineon-fix-suspend-resume-handler-for-pnp_driver-2.patch

