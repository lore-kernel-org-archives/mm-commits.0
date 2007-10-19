From: akpm@linux-foundation.org
Subject: + drivers-edac-add-freescale-mpc85xx-driver.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:18:17 -0700
Message-ID: <200710192118.l9JLIHMG020602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765251AbXJSVS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com


The patch titled
     drivers-edac: add freescale mpc85xx driver
has been added to the -mm tree.  Its filename is
     drivers-edac-add-freescale-mpc85xx-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: add freescale mpc85xx driver
From: Dave Jiang <djiang@mvista.com>

EDAC chip driver support for Freescale MPC85xx platforms. PPC based.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig        |    7 
 drivers/edac/Makefile       |    1 
 drivers/edac/mpc85xx_edac.c | 1043 ++++++++++++++++++++++++++++++++++
 drivers/edac/mpc85xx_edac.h |  162 +++++
 4 files changed, 1213 insertions(+)

diff -puN drivers/edac/Kconfig~drivers-edac-add-freescale-mpc85xx-driver drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~drivers-edac-add-freescale-mpc85xx-driver
+++ a/drivers/edac/Kconfig
@@ -123,6 +123,13 @@ config EDAC_I5000
 	  Support for error detection and correction the Intel
 	  Greekcreek/Blackford chipsets.
 
+config EDAC_MPC85XX
+	tristate "Freescale MPC85xx"
+	depends on EDAC_MM_EDAC && FSL_SOC && MPC85xx
+	help
+	  Support for error detection and correction on the Freescale
+	  MPC8560, MPC8540, MPC8548
+
 config EDAC_PASEMI
 	tristate "PA Semi PWRficient"
 	depends on EDAC_MM_EDAC && PCI
diff -puN drivers/edac/Makefile~drivers-edac-add-freescale-mpc85xx-driver drivers/edac/Makefile
--- a/drivers/edac/Makefile~drivers-edac-add-freescale-mpc85xx-driver
+++ a/drivers/edac/Makefile
@@ -28,5 +28,6 @@ obj-$(CONFIG_EDAC_I3000)		+= i3000_edac.
 obj-$(CONFIG_EDAC_I82860)		+= i82860_edac.o
 obj-$(CONFIG_EDAC_R82600)		+= r82600_edac.o
 obj-$(CONFIG_EDAC_PASEMI)		+= pasemi_edac.o
+obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
 
diff -puN /dev/null drivers/edac/mpc85xx_edac.c
--- /dev/null
+++ a/drivers/edac/mpc85xx_edac.c
@@ -0,0 +1,1043 @@
+/*
+ * Freescale MPC85xx Memory Controller kenel module
+ *
+ * Author: Dave Jiang <djiang@mvista.com>
+ *
+ * 2006-2007 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ *
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/ctype.h>
+#include <linux/io.h>
+#include <linux/mod_devicetable.h>
+#include <linux/edac.h>
+
+#include <linux/of_platform.h>
+#include <linux/of_device.h>
+#include <asm/mpc85xx.h>
+#include "edac_module.h"
+#include "edac_core.h"
+#include "mpc85xx_edac.h"
+
+static int edac_dev_idx;
+static int edac_pci_idx;
+static int edac_mc_idx;
+
+static u32 orig_ddr_err_disable;
+static u32 orig_ddr_err_sbe;
+
+/*
+ * PCI Err defines
+ */
+#ifdef CONFIG_PCI
+static u32 orig_pci_err_cap_dr;
+static u32 orig_pci_err_en;
+#endif
+
+static u32 orig_l2_err_disable;
+static u32 orig_hid1;
+
+const char *mpc85xx_ctl_name = "MPC85xx";
+
+/************************ MC SYSFS parts ***********************************/
+
+static ssize_t mpc85xx_mc_inject_data_hi_show(struct mem_ctl_info *mci,
+					      char *data)
+{
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	return sprintf(data, "0x%08x",
+		       in_be32(pdata->mc_vbase +
+			       MPC85XX_MC_DATA_ERR_INJECT_HI));
+}
+
+static ssize_t mpc85xx_mc_inject_data_lo_show(struct mem_ctl_info *mci,
+					      char *data)
+{
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	return sprintf(data, "0x%08x",
+		       in_be32(pdata->mc_vbase +
+			       MPC85XX_MC_DATA_ERR_INJECT_LO));
+}
+
+static ssize_t mpc85xx_mc_inject_ctrl_show(struct mem_ctl_info *mci, char *data)
+{
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	return sprintf(data, "0x%08x",
+		       in_be32(pdata->mc_vbase + MPC85XX_MC_ECC_ERR_INJECT));
+}
+
+static ssize_t mpc85xx_mc_inject_data_hi_store(struct mem_ctl_info *mci,
+					       const char *data, size_t count)
+{
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	if (isdigit(*data)) {
+		out_be32(pdata->mc_vbase + MPC85XX_MC_DATA_ERR_INJECT_HI,
+			 simple_strtoul(data, NULL, 0));
+		return count;
+	}
+	return 0;
+}
+
+static ssize_t mpc85xx_mc_inject_data_lo_store(struct mem_ctl_info *mci,
+					       const char *data, size_t count)
+{
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	if (isdigit(*data)) {
+		out_be32(pdata->mc_vbase + MPC85XX_MC_DATA_ERR_INJECT_LO,
+			 simple_strtoul(data, NULL, 0));
+		return count;
+	}
+	return 0;
+}
+
+static ssize_t mpc85xx_mc_inject_ctrl_store(struct mem_ctl_info *mci,
+					    const char *data, size_t count)
+{
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	if (isdigit(*data)) {
+		out_be32(pdata->mc_vbase + MPC85XX_MC_ECC_ERR_INJECT,
+			 simple_strtoul(data, NULL, 0));
+		return count;
+	}
+	return 0;
+}
+
+static struct mcidev_sysfs_attribute mpc85xx_mc_sysfs_attributes[] = {
+	{
+	 .attr = {
+		  .name = "inject_data_hi",
+		  .mode = (S_IRUGO | S_IWUSR)
+		  },
+	 .show = mpc85xx_mc_inject_data_hi_show,
+	 .store = mpc85xx_mc_inject_data_hi_store},
+	{
+	 .attr = {
+		  .name = "inject_data_lo",
+		  .mode = (S_IRUGO | S_IWUSR)
+		  },
+	 .show = mpc85xx_mc_inject_data_lo_show,
+	 .store = mpc85xx_mc_inject_data_lo_store},
+	{
+	 .attr = {
+		  .name = "inject_ctrl",
+		  .mode = (S_IRUGO | S_IWUSR)
+		  },
+	 .show = mpc85xx_mc_inject_ctrl_show,
+	 .store = mpc85xx_mc_inject_ctrl_store},
+
+	/* End of list */
+	{
+	 .attr = {.name = NULL}
+	 }
+};
+
+static void mpc85xx_set_mc_sysfs_attributes(struct mem_ctl_info *mci)
+{
+	mci->mc_driver_sysfs_attributes = mpc85xx_mc_sysfs_attributes;
+}
+
+/**************************** PCI Err device ***************************/
+#ifdef CONFIG_PCI
+
+static void mpc85xx_pci_check(struct edac_pci_ctl_info *pci)
+{
+	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
+	u32 err_detect;
+
+	err_detect = in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR);
+
+	/* master aborts can happen during PCI config cycles */
+	if (!(err_detect & ~(PCI_EDE_MULTI_ERR | PCI_EDE_MST_ABRT))) {
+		out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR, err_detect);
+		return;
+	}
+
+	printk(KERN_ERR "PCI error(s) detected\n");
+	printk(KERN_ERR "PCI/X ERR_DR register: %#08x\n", err_detect);
+
+	printk(KERN_ERR "PCI/X ERR_ATTRIB register: %#08x\n",
+	       in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_ATTRIB));
+	printk(KERN_ERR "PCI/X ERR_ADDR register: %#08x\n",
+	       in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_ADDR));
+	printk(KERN_ERR "PCI/X ERR_EXT_ADDR register: %#08x\n",
+	       in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EXT_ADDR));
+	printk(KERN_ERR "PCI/X ERR_DL register: %#08x\n",
+	       in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DL));
+	printk(KERN_ERR "PCI/X ERR_DH register: %#08x\n",
+	       in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DH));
+
+	/* clear error bits */
+	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR, err_detect);
+
+	if (err_detect & PCI_EDE_PERR_MASK)
+		edac_pci_handle_pe(pci, pci->ctl_name);
+
+	if ((err_detect & ~PCI_EDE_MULTI_ERR) & ~PCI_EDE_PERR_MASK)
+		edac_pci_handle_npe(pci, pci->ctl_name);
+}
+
+static irqreturn_t mpc85xx_pci_isr(int irq, void *dev_id)
+{
+	struct edac_pci_ctl_info *pci = dev_id;
+	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
+	u32 err_detect;
+
+	err_detect = in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR);
+
+	if (!err_detect)
+		return IRQ_NONE;
+
+	mpc85xx_pci_check(pci);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit mpc85xx_pci_err_probe(struct platform_device *pdev)
+{
+	struct edac_pci_ctl_info *pci;
+	struct mpc85xx_pci_pdata *pdata;
+	struct resource *r;
+	int res = 0;
+
+	if (!devres_open_group(&pdev->dev, mpc85xx_pci_err_probe, GFP_KERNEL))
+		return -ENOMEM;
+
+	pci = edac_pci_alloc_ctl_info(sizeof(*pdata), "mpc85xx_pci_err");
+	if (!pci)
+		return -ENOMEM;
+
+	pdata = pci->pvt_info;
+	pdata->name = "mpc85xx_pci_err";
+	pdata->irq = NO_IRQ;
+	platform_set_drvdata(pdev, pci);
+	pci->dev = &pdev->dev;
+	pci->mod_name = EDAC_MOD_STR;
+	pci->ctl_name = pdata->name;
+	pci->dev_name = pdev->dev.bus_id;
+
+	if (edac_op_state == EDAC_OPSTATE_POLL)
+		pci->edac_check = mpc85xx_pci_check;
+
+	pdata->edac_idx = edac_pci_idx++;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		printk(KERN_ERR "%s: Unable to get resource for "
+		       "PCI err regs\n", __func__);
+		goto err;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, r->start,
+				     r->end - r->start + 1, pdata->name)) {
+		printk(KERN_ERR "%s: Error while requesting mem region\n",
+		       __func__);
+		res = -EBUSY;
+		goto err;
+	}
+
+	pdata->pci_vbase = devm_ioremap(&pdev->dev, r->start,
+					r->end - r->start + 1);
+	if (!pdata->pci_vbase) {
+		printk(KERN_ERR "%s: Unable to setup PCI err regs\n", __func__);
+		res = -ENOMEM;
+		goto err;
+	}
+
+	orig_pci_err_cap_dr =
+	    in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR);
+
+	/* PCI master abort is expected during config cycles */
+	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR, 0x40);
+
+	orig_pci_err_en = in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN);
+
+	/* disable master abort reporting */
+	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, ~0x40);
+
+	/* clear error bits */
+	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR, ~0);
+
+	if (edac_pci_add_device(pci, pdata->edac_idx) > 0) {
+		debugf3("%s(): failed edac_pci_add_device()\n", __func__);
+		goto err;
+	}
+
+	if (edac_op_state == EDAC_OPSTATE_INT) {
+		pdata->irq = platform_get_irq(pdev, 0);
+		res = devm_request_irq(&pdev->dev, pdata->irq,
+				       mpc85xx_pci_isr, IRQF_DISABLED,
+				       "[EDAC] PCI err", pci);
+		if (res < 0) {
+			printk(KERN_ERR
+			       "%s: Unable to requiest irq %d for "
+			       "MPC85xx PCI err\n", __func__, pdata->irq);
+			res = -ENODEV;
+			goto err2;
+		}
+
+		printk(KERN_INFO EDAC_MOD_STR " acquired irq %d for PCI Err\n",
+		       pdata->irq);
+	}
+
+	devres_remove_group(&pdev->dev, mpc85xx_pci_err_probe);
+	debugf3("%s(): success\n", __func__);
+	printk(KERN_INFO EDAC_MOD_STR " PCI err registered\n");
+
+	return 0;
+
+err2:
+	edac_pci_del_device(&pdev->dev);
+err:
+	edac_pci_free_ctl_info(pci);
+	devres_release_group(&pdev->dev, mpc85xx_pci_err_probe);
+	return res;
+}
+
+static int mpc85xx_pci_err_remove(struct platform_device *pdev)
+{
+	struct edac_pci_ctl_info *pci = platform_get_drvdata(pdev);
+	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
+
+	debugf0("%s()\n", __func__);
+
+	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR,
+		 orig_pci_err_cap_dr);
+
+	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, orig_pci_err_en);
+
+	edac_pci_del_device(pci->dev);
+
+	if (edac_op_state == EDAC_OPSTATE_INT)
+		irq_dispose_mapping(pdata->irq);
+
+	edac_pci_free_ctl_info(pci);
+
+	return 0;
+}
+
+static struct platform_driver mpc85xx_pci_err_driver = {
+	.probe = mpc85xx_pci_err_probe,
+	.remove = __devexit_p(mpc85xx_pci_err_remove),
+	.driver = {
+		.name = "mpc85xx_pci_err",
+	}
+};
+
+#endif				/* CONFIG_PCI */
+
+/**************************** L2 Err device ***************************/
+
+/************************ L2 SYSFS parts ***********************************/
+
+static ssize_t mpc85xx_l2_inject_data_hi_show(struct edac_device_ctl_info
+					      *edac_dev, char *data)
+{
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+	return sprintf(data, "0x%08x",
+		       in_be32(pdata->l2_vbase + MPC85XX_L2_ERRINJHI));
+}
+
+static ssize_t mpc85xx_l2_inject_data_lo_show(struct edac_device_ctl_info
+					      *edac_dev, char *data)
+{
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+	return sprintf(data, "0x%08x",
+		       in_be32(pdata->l2_vbase + MPC85XX_L2_ERRINJLO));
+}
+
+static ssize_t mpc85xx_l2_inject_ctrl_show(struct edac_device_ctl_info
+					   *edac_dev, char *data)
+{
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+	return sprintf(data, "0x%08x",
+		       in_be32(pdata->l2_vbase + MPC85XX_L2_ERRINJCTL));
+}
+
+static ssize_t mpc85xx_l2_inject_data_hi_store(struct edac_device_ctl_info
+					       *edac_dev, const char *data,
+					       size_t count)
+{
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+	if (isdigit(*data)) {
+		out_be32(pdata->l2_vbase + MPC85XX_L2_ERRINJHI,
+			 simple_strtoul(data, NULL, 0));
+		return count;
+	}
+	return 0;
+}
+
+static ssize_t mpc85xx_l2_inject_data_lo_store(struct edac_device_ctl_info
+					       *edac_dev, const char *data,
+					       size_t count)
+{
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+	if (isdigit(*data)) {
+		out_be32(pdata->l2_vbase + MPC85XX_L2_ERRINJLO,
+			 simple_strtoul(data, NULL, 0));
+		return count;
+	}
+	return 0;
+}
+
+static ssize_t mpc85xx_l2_inject_ctrl_store(struct edac_device_ctl_info
+					    *edac_dev, const char *data,
+					    size_t count)
+{
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+	if (isdigit(*data)) {
+		out_be32(pdata->l2_vbase + MPC85XX_L2_ERRINJCTL,
+			 simple_strtoul(data, NULL, 0));
+		return count;
+	}
+	return 0;
+}
+
+static struct edac_dev_sysfs_attribute mpc85xx_l2_sysfs_attributes[] = {
+	{
+	 .attr = {
+		  .name = "inject_data_hi",
+		  .mode = (S_IRUGO | S_IWUSR)
+		  },
+	 .show = mpc85xx_l2_inject_data_hi_show,
+	 .store = mpc85xx_l2_inject_data_hi_store},
+	{
+	 .attr = {
+		  .name = "inject_data_lo",
+		  .mode = (S_IRUGO | S_IWUSR)
+		  },
+	 .show = mpc85xx_l2_inject_data_lo_show,
+	 .store = mpc85xx_l2_inject_data_lo_store},
+	{
+	 .attr = {
+		  .name = "inject_ctrl",
+		  .mode = (S_IRUGO | S_IWUSR)
+		  },
+	 .show = mpc85xx_l2_inject_ctrl_show,
+	 .store = mpc85xx_l2_inject_ctrl_store},
+
+	/* End of list */
+	{
+	 .attr = {.name = NULL}
+	 }
+};
+
+static void mpc85xx_set_l2_sysfs_attributes(struct edac_device_ctl_info
+					    *edac_dev)
+{
+	edac_dev->sysfs_attributes = mpc85xx_l2_sysfs_attributes;
+}
+
+/***************************** L2 ops ***********************************/
+
+static void mpc85xx_l2_check(struct edac_device_ctl_info *edac_dev)
+{
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+	u32 err_detect;
+
+	err_detect = in_be32(pdata->l2_vbase + MPC85XX_L2_ERRDET);
+
+	if (!(err_detect & L2_EDE_MASK))
+		return;
+
+	printk(KERN_ERR "ECC Error in CPU L2 cache\n");
+	printk(KERN_ERR "L2 Error Detect Register: 0x%08x\n", err_detect);
+	printk(KERN_ERR "L2 Error Capture Data High Register: 0x%08x\n",
+	       in_be32(pdata->l2_vbase + MPC85XX_L2_CAPTDATAHI));
+	printk(KERN_ERR "L2 Error Capture Data Lo Register: 0x%08x\n",
+	       in_be32(pdata->l2_vbase + MPC85XX_L2_CAPTDATALO));
+	printk(KERN_ERR "L2 Error Syndrome Register: 0x%08x\n",
+	       in_be32(pdata->l2_vbase + MPC85XX_L2_CAPTECC));
+	printk(KERN_ERR "L2 Error Attributes Capture Register: 0x%08x\n",
+	       in_be32(pdata->l2_vbase + MPC85XX_L2_ERRATTR));
+	printk(KERN_ERR "L2 Error Address Capture Register: 0x%08x\n",
+	       in_be32(pdata->l2_vbase + MPC85XX_L2_ERRADDR));
+
+	/* clear error detect register */
+	out_be32(pdata->l2_vbase + MPC85XX_L2_ERRDET, err_detect);
+
+	if (err_detect & L2_EDE_CE_MASK)
+		edac_device_handle_ce(edac_dev, 0, 0, edac_dev->ctl_name);
+
+	if (err_detect & L2_EDE_UE_MASK)
+		edac_device_handle_ue(edac_dev, 0, 0, edac_dev->ctl_name);
+}
+
+static irqreturn_t mpc85xx_l2_isr(int irq, void *dev_id)
+{
+	struct edac_device_ctl_info *edac_dev = dev_id;
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+	u32 err_detect;
+
+	err_detect = in_be32(pdata->l2_vbase + MPC85XX_L2_ERRDET);
+
+	if (!(err_detect & L2_EDE_MASK))
+		return IRQ_NONE;
+
+	mpc85xx_l2_check(edac_dev);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit mpc85xx_l2_err_probe(struct of_device *op,
+					  const struct of_device_id *match)
+{
+	struct edac_device_ctl_info *edac_dev;
+	struct mpc85xx_l2_pdata *pdata;
+	struct resource r;
+	int res;
+
+	if (!devres_open_group(&op->dev, mpc85xx_l2_err_probe, GFP_KERNEL))
+		return -ENOMEM;
+
+	edac_dev = edac_device_alloc_ctl_info(sizeof(*pdata),
+					      "cpu", 1, "L", 1, 2, NULL, 0,
+					      edac_dev_idx);
+	if (!edac_dev) {
+		devres_release_group(&op->dev, mpc85xx_l2_err_probe);
+		return -ENOMEM;
+	}
+
+	pdata = edac_dev->pvt_info;
+	pdata->name = "mpc85xx_l2_err";
+	pdata->irq = NO_IRQ;
+	edac_dev->dev = &op->dev;
+	dev_set_drvdata(edac_dev->dev, edac_dev);
+	edac_dev->ctl_name = pdata->name;
+	edac_dev->dev_name = pdata->name;
+
+	res = of_address_to_resource(op->node, 0, &r);
+	if (res) {
+		printk(KERN_ERR "%s: Unable to get resource for "
+		       "L2 err regs\n", __func__);
+		goto err;
+	}
+
+	/* we only need the error registers */
+	r.start += 0xe00;
+
+	if (!devm_request_mem_region(&op->dev, r.start,
+				     r.end - r.start + 1, pdata->name)) {
+		printk(KERN_ERR "%s: Error while requesting mem region\n",
+		       __func__);
+		res = -EBUSY;
+		goto err;
+	}
+
+	pdata->l2_vbase = devm_ioremap(&op->dev, r.start, r.end - r.start + 1);
+	if (!pdata->l2_vbase) {
+		printk(KERN_ERR "%s: Unable to setup L2 err regs\n", __func__);
+		res = -ENOMEM;
+		goto err;
+	}
+
+	out_be32(pdata->l2_vbase + MPC85XX_L2_ERRDET, ~0);
+
+	orig_l2_err_disable = in_be32(pdata->l2_vbase + MPC85XX_L2_ERRDIS);
+
+	/* clear the err_dis */
+	out_be32(pdata->l2_vbase + MPC85XX_L2_ERRDIS, 0);
+
+	edac_dev->mod_name = EDAC_MOD_STR;
+
+	if (edac_op_state == EDAC_OPSTATE_POLL)
+		edac_dev->edac_check = mpc85xx_l2_check;
+
+	mpc85xx_set_l2_sysfs_attributes(edac_dev);
+
+	pdata->edac_idx = edac_dev_idx++;
+
+	if (edac_device_add_device(edac_dev) > 0) {
+		debugf3("%s(): failed edac_device_add_device()\n", __func__);
+		goto err;
+	}
+
+	if (edac_op_state == EDAC_OPSTATE_INT) {
+		pdata->irq = irq_of_parse_and_map(op->node, 0);
+		res = devm_request_irq(&op->dev, pdata->irq,
+				       mpc85xx_l2_isr, IRQF_DISABLED,
+				       "[EDAC] L2 err", edac_dev);
+		if (res < 0) {
+			printk(KERN_ERR
+			       "%s: Unable to requiest irq %d for "
+			       "MPC85xx L2 err\n", __func__, pdata->irq);
+			irq_dispose_mapping(pdata->irq);
+			res = -ENODEV;
+			goto err2;
+		}
+
+		printk(KERN_INFO EDAC_MOD_STR " acquired irq %d for L2 Err\n",
+		       pdata->irq);
+
+		edac_dev->op_state = OP_RUNNING_INTERRUPT;
+
+		out_be32(pdata->l2_vbase + MPC85XX_L2_ERRINTEN, L2_EIE_MASK);
+	}
+
+	devres_remove_group(&op->dev, mpc85xx_l2_err_probe);
+
+	debugf3("%s(): success\n", __func__);
+	printk(KERN_INFO EDAC_MOD_STR " L2 err registered\n");
+
+	return 0;
+
+err2:
+	edac_device_del_device(&op->dev);
+err:
+	devres_release_group(&op->dev, mpc85xx_l2_err_probe);
+	edac_device_free_ctl_info(edac_dev);
+	return res;
+}
+
+static int mpc85xx_l2_err_remove(struct of_device *op)
+{
+	struct edac_device_ctl_info *edac_dev = dev_get_drvdata(&op->dev);
+	struct mpc85xx_l2_pdata *pdata = edac_dev->pvt_info;
+
+	debugf0("%s()\n", __func__);
+
+	if (edac_op_state == EDAC_OPSTATE_INT) {
+		out_be32(pdata->l2_vbase + MPC85XX_L2_ERRINTEN, 0);
+		irq_dispose_mapping(pdata->irq);
+	}
+
+	out_be32(pdata->l2_vbase + MPC85XX_L2_ERRDIS, orig_l2_err_disable);
+	edac_device_del_device(&op->dev);
+	edac_device_free_ctl_info(edac_dev);
+	return 0;
+}
+
+static struct of_device_id mpc85xx_l2_err_of_match[] = {
+	{
+	 .compatible = "fsl,8540-l2-cache-controller",
+	 },
+	{
+	 .compatible = "fsl,8541-l2-cache-controller",
+	 },
+	{
+	 .compatible = "fsl,8544-l2-cache-controller",
+	 },
+	{
+	 .compatible = "fsl,8548-l2-cache-controller",
+	 },
+	{
+	 .compatible = "fsl,8555-l2-cache-controller",
+	 },
+	{
+	 .compatible = "fsl,8568-l2-cache-controller",
+	 },
+	{},
+};
+
+static struct of_platform_driver mpc85xx_l2_err_driver = {
+	.owner = THIS_MODULE,
+	.name = "mpc85xx_l2_err",
+	.match_table = mpc85xx_l2_err_of_match,
+	.probe = mpc85xx_l2_err_probe,
+	.remove = mpc85xx_l2_err_remove,
+	.driver = {
+		   .name = "mpc85xx_l2_err",
+		   .owner = THIS_MODULE,
+		   },
+};
+
+/**************************** MC Err device ***************************/
+
+static void mpc85xx_mc_check(struct mem_ctl_info *mci)
+{
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	struct csrow_info *csrow;
+	u32 err_detect;
+	u32 syndrome;
+	u32 err_addr;
+	u32 pfn;
+	int row_index;
+
+	err_detect = in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT);
+	if (err_detect)
+		return;
+
+	mpc85xx_mc_printk(mci, KERN_ERR, "Err Detect Register: %#8.8x\n",
+			  err_detect);
+
+	/* no more processing if not ECC bit errors */
+	if (!(err_detect & (DDR_EDE_SBE | DDR_EDE_MBE))) {
+		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, err_detect);
+		return;
+	}
+
+	syndrome = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_ECC);
+	err_addr = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_ADDRESS);
+	pfn = err_addr >> PAGE_SHIFT;
+
+	for (row_index = 0; row_index < mci->nr_csrows; row_index++) {
+		csrow = &mci->csrows[row_index];
+		if ((pfn >= csrow->first_page) && (pfn <= csrow->last_page))
+			break;
+	}
+
+	mpc85xx_mc_printk(mci, KERN_ERR, "Capture Data High: %#8.8x\n",
+			  in_be32(pdata->mc_vbase +
+				  MPC85XX_MC_CAPTURE_DATA_HI));
+	mpc85xx_mc_printk(mci, KERN_ERR, "Capture Data Low: %#8.8x\n",
+			  in_be32(pdata->mc_vbase +
+				  MPC85XX_MC_CAPTURE_DATA_LO));
+	mpc85xx_mc_printk(mci, KERN_ERR, "syndrome: %#8.8x\n", syndrome);
+	mpc85xx_mc_printk(mci, KERN_ERR, "err addr: %#8.8x\n", err_addr);
+	mpc85xx_mc_printk(mci, KERN_ERR, "PFN: %#8.8x\n", pfn);
+
+	/* we are out of range */
+	if (row_index == mci->nr_csrows)
+		mpc85xx_mc_printk(mci, KERN_ERR, "PFN out of range!\n");
+
+	if (err_detect & DDR_EDE_SBE)
+		edac_mc_handle_ce(mci, pfn, err_addr & PAGE_MASK,
+				  syndrome, row_index, 0, mci->ctl_name);
+
+	if (err_detect & DDR_EDE_MBE)
+		edac_mc_handle_ue(mci, pfn, err_addr & PAGE_MASK,
+				  row_index, mci->ctl_name);
+
+	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, err_detect);
+}
+
+static irqreturn_t mpc85xx_mc_isr(int irq, void *dev_id)
+{
+	struct mem_ctl_info *mci = dev_id;
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	u32 err_detect;
+
+	err_detect = in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT);
+	if (!err_detect)
+		return IRQ_NONE;
+
+	mpc85xx_mc_check(mci);
+
+	return IRQ_HANDLED;
+}
+
+static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
+{
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+	struct csrow_info *csrow;
+	u32 sdram_ctl;
+	u32 sdtype;
+	enum mem_type mtype;
+	u32 cs_bnds;
+	int index;
+
+	sdram_ctl = in_be32(pdata->mc_vbase + MPC85XX_MC_DDR_SDRAM_CFG);
+
+	sdtype = sdram_ctl & DSC_SDTYPE_MASK;
+	if (sdram_ctl & DSC_RD_EN) {
+		switch (sdtype) {
+		case DSC_SDTYPE_DDR:
+			mtype = MEM_RDDR;
+			break;
+		case DSC_SDTYPE_DDR2:
+			mtype = MEM_RDDR2;
+			break;
+		default:
+			mtype = MEM_UNKNOWN;
+			break;
+		}
+	} else {
+		switch (sdtype) {
+		case DSC_SDTYPE_DDR:
+			mtype = MEM_DDR;
+			break;
+		case DSC_SDTYPE_DDR2:
+			mtype = MEM_DDR2;
+			break;
+		default:
+			mtype = MEM_UNKNOWN;
+			break;
+		}
+	}
+
+	for (index = 0; index < mci->nr_csrows; index++) {
+		u32 start;
+		u32 end;
+
+		csrow = &mci->csrows[index];
+		cs_bnds = in_be32(pdata->mc_vbase + MPC85XX_MC_CS_BNDS_0 +
+				  (index * MPC85XX_MC_CS_BNDS_OFS));
+		start = (cs_bnds & 0xfff0000) << 4;
+		end = ((cs_bnds & 0xfff) << 20);
+		if (start)
+			start |= 0xfffff;
+		if (end)
+			end |= 0xfffff;
+
+		if (start == end)
+			continue;	/* not populated */
+
+		csrow->first_page = start >> PAGE_SHIFT;
+		csrow->last_page = end >> PAGE_SHIFT;
+		csrow->nr_pages = csrow->last_page + 1 - csrow->first_page;
+		csrow->grain = 8;
+		csrow->mtype = mtype;
+		csrow->dtype = DEV_UNKNOWN;
+		if (sdram_ctl & DSC_X32_EN)
+			csrow->dtype = DEV_X32;
+		csrow->edac_mode = EDAC_SECDED;
+	}
+}
+
+static int __devinit mpc85xx_mc_err_probe(struct of_device *op,
+					  const struct of_device_id *match)
+{
+	struct mem_ctl_info *mci;
+	struct mpc85xx_mc_pdata *pdata;
+	struct resource r;
+	u32 sdram_ctl;
+	int res;
+
+	if (!devres_open_group(&op->dev, mpc85xx_mc_err_probe, GFP_KERNEL))
+		return -ENOMEM;
+
+	mci = edac_mc_alloc(sizeof(*pdata), 4, 1, edac_mc_idx);
+	if (!mci) {
+		devres_release_group(&op->dev, mpc85xx_mc_err_probe);
+		return -ENOMEM;
+	}
+
+	pdata = mci->pvt_info;
+	pdata->name = "mpc85xx_mc_err";
+	pdata->irq = NO_IRQ;
+	mci->dev = &op->dev;
+	pdata->edac_idx = edac_mc_idx++;
+	dev_set_drvdata(mci->dev, mci);
+	mci->ctl_name = pdata->name;
+	mci->dev_name = pdata->name;
+
+	res = of_address_to_resource(op->node, 0, &r);
+	if (res) {
+		printk(KERN_ERR "%s: Unable to get resource for MC err regs\n",
+		       __func__);
+		goto err;
+	}
+
+	if (!devm_request_mem_region(&op->dev, r.start,
+				     r.end - r.start + 1, pdata->name)) {
+		printk(KERN_ERR "%s: Error while requesting mem region\n",
+		       __func__);
+		res = -EBUSY;
+		goto err;
+	}
+
+	pdata->mc_vbase = devm_ioremap(&op->dev, r.start, r.end - r.start + 1);
+	if (!pdata->mc_vbase) {
+		printk(KERN_ERR "%s: Unable to setup MC err regs\n", __func__);
+		res = -ENOMEM;
+		goto err;
+	}
+
+	sdram_ctl = in_be32(pdata->mc_vbase + MPC85XX_MC_DDR_SDRAM_CFG);
+	if (!(sdram_ctl & DSC_ECC_EN)) {
+		/* no ECC */
+		printk(KERN_WARNING "%s: No ECC DIMMs discovered\n", __func__);
+		res = -ENODEV;
+		goto err;
+	}
+
+	debugf3("%s(): init mci\n", __func__);
+	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_RDDR2 |
+	    MEM_FLAG_DDR | MEM_FLAG_DDR2;
+	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
+	mci->edac_cap = EDAC_FLAG_SECDED;
+	mci->mod_name = EDAC_MOD_STR;
+	mci->mod_ver = MPC85XX_REVISION;
+
+	if (edac_op_state == EDAC_OPSTATE_POLL)
+		mci->edac_check = mpc85xx_mc_check;
+
+	mci->ctl_page_to_phys = NULL;
+
+	mci->scrub_mode = SCRUB_SW_SRC;
+
+	mpc85xx_set_mc_sysfs_attributes(mci);
+
+	mpc85xx_init_csrows(mci);
+
+#ifdef CONFIG_EDAC_DEBUG
+	edac_mc_register_mcidev_debug((struct attribute **)debug_attr);
+#endif
+
+	/* store the original error disable bits */
+	orig_ddr_err_disable =
+	    in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DISABLE);
+	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DISABLE, 0);
+
+	/* clear all error bits */
+	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, ~0);
+
+	if (edac_mc_add_mc(mci)) {
+		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
+		goto err;
+	}
+
+	if (edac_op_state == EDAC_OPSTATE_INT) {
+		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_INT_EN,
+			 DDR_EIE_MBEE | DDR_EIE_SBEE);
+
+		/* store the original error management threshold */
+		orig_ddr_err_sbe = in_be32(pdata->mc_vbase +
+					   MPC85XX_MC_ERR_SBE) & 0xff0000;
+
+		/* set threshold to 1 error per interrupt */
+		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_SBE, 0x10000);
+
+		/* register interrupts */
+		pdata->irq = irq_of_parse_and_map(op->node, 0);
+		res = devm_request_irq(&op->dev, pdata->irq,
+				       mpc85xx_mc_isr, IRQF_DISABLED,
+				       "[EDAC] MC err", mci);
+		if (res < 0) {
+			printk(KERN_ERR "%s: Unable to request irq %d for "
+			       "MPC85xx DRAM ERR\n", __func__, pdata->irq);
+			irq_dispose_mapping(pdata->irq);
+			res = -ENODEV;
+			goto err2;
+		}
+
+		printk(KERN_INFO EDAC_MOD_STR " acquired irq %d for MC\n",
+		       pdata->irq);
+	}
+
+	devres_remove_group(&op->dev, mpc85xx_mc_err_probe);
+	debugf3("%s(): success\n", __func__);
+	printk(KERN_INFO EDAC_MOD_STR " MC err registered\n");
+
+	return 0;
+
+err2:
+	edac_mc_del_mc(&op->dev);
+err:
+	devres_release_group(&op->dev, mpc85xx_mc_err_probe);
+	edac_mc_free(mci);
+	return res;
+}
+
+static int mpc85xx_mc_err_remove(struct of_device *op)
+{
+	struct mem_ctl_info *mci = dev_get_drvdata(&op->dev);
+	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
+
+	debugf0("%s()\n", __func__);
+
+	if (edac_op_state == EDAC_OPSTATE_INT) {
+		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_INT_EN, 0);
+		irq_dispose_mapping(pdata->irq);
+	}
+
+	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DISABLE,
+		 orig_ddr_err_disable);
+	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_SBE, orig_ddr_err_sbe);
+
+	edac_mc_del_mc(&op->dev);
+	edac_mc_free(mci);
+	return 0;
+}
+
+static struct of_device_id mpc85xx_mc_err_of_match[] = {
+	{
+	 .compatible = "fsl,8540-memory-controller",
+	 },
+	{
+	 .compatible = "fsl,8541-memory-controller",
+	 },
+	{
+	 .compatible = "fsl,8544-memory-controller",
+	 },
+	{
+	 .compatible = "fsl,8548-memory-controller",
+	 },
+	{
+	 .compatible = "fsl,8555-memory-controller",
+	 },
+	{
+	 .compatible = "fsl,8568-memory-controller",
+	 },
+	{},
+};
+
+static struct of_platform_driver mpc85xx_mc_err_driver = {
+	.owner = THIS_MODULE,
+	.name = "mpc85xx_mc_err",
+	.match_table = mpc85xx_mc_err_of_match,
+	.probe = mpc85xx_mc_err_probe,
+	.remove = mpc85xx_mc_err_remove,
+	.driver = {
+		   .name = "mpc85xx_mc_err",
+		   .owner = THIS_MODULE,
+		   },
+};
+
+static int __init mpc85xx_mc_init(void)
+{
+	int res = 0;
+
+	printk(KERN_INFO "Freescale(R) MPC85xx EDAC driver, "
+	       "(C) 2006 Montavista Software\n");
+
+	/* make sure error reporting method is sane */
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_INT:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_INT;
+		break;
+	}
+
+	res = of_register_platform_driver(&mpc85xx_mc_err_driver);
+	if (res)
+		printk(KERN_WARNING EDAC_MOD_STR "MC fails to register\n");
+
+	res = of_register_platform_driver(&mpc85xx_l2_err_driver);
+	if (res)
+		printk(KERN_WARNING EDAC_MOD_STR "L2 fails to register\n");
+
+#ifdef CONFIG_PCI
+	res = platform_driver_register(&mpc85xx_pci_err_driver);
+	if (res)
+		printk(KERN_WARNING EDAC_MOD_STR "PCI fails to register\n");
+#endif
+
+	/*
+	 * need to clear HID1[RFXE] to disable machine check int
+	 * so we can catch it
+	 */
+	if (edac_op_state == EDAC_OPSTATE_INT) {
+		orig_hid1 = mfspr(SPRN_HID1);
+		mtspr(SPRN_HID1, (orig_hid1 & ~0x20000));
+	}
+
+	return 0;
+}
+
+module_init(mpc85xx_mc_init);
+
+static void __exit mpc85xx_mc_exit(void)
+{
+	mtspr(SPRN_HID1, orig_hid1);
+#ifdef CONFIG_PCI
+	platform_driver_unregister(&mpc85xx_pci_err_driver);
+#endif
+	of_unregister_platform_driver(&mpc85xx_l2_err_driver);
+	of_unregister_platform_driver(&mpc85xx_mc_err_driver);
+}
+
+module_exit(mpc85xx_mc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Montavista Software, Inc.");
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state,
+		 "EDAC Error Reporting state: 0=Poll, 2=Interrupt");
diff -puN /dev/null drivers/edac/mpc85xx_edac.h
--- /dev/null
+++ a/drivers/edac/mpc85xx_edac.h
@@ -0,0 +1,162 @@
+/*
+ * Freescale MPC85xx Memory Controller kenel module
+ * Author: Dave Jiang <djiang@mvista.com>
+ *
+ * 2006-2007 (c) MontaVista Software, Inc. This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ *
+ */
+#ifndef _MPC85XX_EDAC_H_
+#define _MPC85XX_EDAC_H_
+
+#define MPC85XX_REVISION " Ver: 2.0.0 " __DATE__
+#define EDAC_MOD_STR	"MPC85xx_edac"
+
+#define mpc85xx_printk(level, fmt, arg...) \
+	edac_printk(level, "MPC85xx", fmt, ##arg)
+
+#define mpc85xx_mc_printk(mci, level, fmt, arg...) \
+	edac_mc_chipset_printk(mci, level, "MPC85xx", fmt, ##arg)
+
+/*
+ * DRAM error defines
+ */
+
+/* DDR_SDRAM_CFG */
+#define MPC85XX_MC_DDR_SDRAM_CFG	0x0110
+#define MPC85XX_MC_CS_BNDS_0		0x0000
+#define MPC85XX_MC_CS_BNDS_1		0x0008
+#define MPC85XX_MC_CS_BNDS_2		0x0010
+#define MPC85XX_MC_CS_BNDS_3		0x0018
+#define MPC85XX_MC_CS_BNDS_OFS		0x0008
+
+#define MPC85XX_MC_DATA_ERR_INJECT_HI	0x0e00
+#define MPC85XX_MC_DATA_ERR_INJECT_LO	0x0e04
+#define MPC85XX_MC_ECC_ERR_INJECT	0x0e08
+#define MPC85XX_MC_CAPTURE_DATA_HI	0x0e20
+#define MPC85XX_MC_CAPTURE_DATA_LO	0x0e24
+#define MPC85XX_MC_CAPTURE_ECC		0x0e28
+#define MPC85XX_MC_ERR_DETECT		0x0e40
+#define MPC85XX_MC_ERR_DISABLE		0x0e44
+#define MPC85XX_MC_ERR_INT_EN		0x0e48
+#define MPC85XX_MC_CAPTURE_ATRIBUTES	0x0e4c
+#define MPC85XX_MC_CAPTURE_ADDRESS	0x0e50
+#define MPC85XX_MC_ERR_SBE		0x0e58
+
+#define DSC_MEM_EN	0x80000000
+#define DSC_ECC_EN	0x20000000
+#define DSC_RD_EN	0x10000000
+
+#define DSC_SDTYPE_MASK		0x07000000
+
+#define DSC_SDTYPE_DDR		0x02000000
+#define DSC_SDTYPE_DDR2		0x03000000
+#define DSC_X32_EN	0x00000020
+
+/* Err_Int_En */
+#define DDR_EIE_MSEE	0x1	/* memory select */
+#define DDR_EIE_SBEE	0x4	/* single-bit ECC error */
+#define DDR_EIE_MBEE	0x8	/* multi-bit ECC error */
+
+/* Err_Detect */
+#define DDR_EDE_MSE		0x1	/* memory select */
+#define DDR_EDE_SBE		0x4	/* single-bit ECC error */
+#define DDR_EDE_MBE		0x8	/* multi-bit ECC error */
+#define DDR_EDE_MME		0x80000000	/* multiple memory errors */
+
+/* Err_Disable */
+#define DDR_EDI_MSED	0x1	/* memory select disable */
+#define	DDR_EDI_SBED	0x4	/* single-bit ECC error disable */
+#define	DDR_EDI_MBED	0x8	/* multi-bit ECC error disable */
+
+/*
+ * L2 Err defines
+ */
+#define MPC85XX_L2_ERRINJHI	0x0000
+#define MPC85XX_L2_ERRINJLO	0x0004
+#define MPC85XX_L2_ERRINJCTL	0x0008
+#define MPC85XX_L2_CAPTDATAHI	0x0020
+#define MPC85XX_L2_CAPTDATALO	0x0024
+#define MPC85XX_L2_CAPTECC	0x0028
+#define MPC85XX_L2_ERRDET	0x0040
+#define MPC85XX_L2_ERRDIS	0x0044
+#define MPC85XX_L2_ERRINTEN	0x0048
+#define MPC85XX_L2_ERRATTR	0x004c
+#define MPC85XX_L2_ERRADDR	0x0050
+#define MPC85XX_L2_ERRCTL	0x0058
+
+/* Error Interrupt Enable */
+#define L2_EIE_L2CFGINTEN	0x1
+#define L2_EIE_SBECCINTEN	0x4
+#define L2_EIE_MBECCINTEN	0x8
+#define L2_EIE_TPARINTEN	0x10
+#define L2_EIE_MASK	(L2_EIE_L2CFGINTEN | L2_EIE_SBECCINTEN | \
+			L2_EIE_MBECCINTEN | L2_EIE_TPARINTEN)
+
+/* Error Detect */
+#define L2_EDE_L2CFGERR		0x1
+#define L2_EDE_SBECCERR		0x4
+#define L2_EDE_MBECCERR		0x8
+#define L2_EDE_TPARERR		0x10
+#define L2_EDE_MULL2ERR		0x80000000
+
+#define L2_EDE_CE_MASK	L2_EDE_SBECCERR
+#define L2_EDE_UE_MASK	(L2_EDE_L2CFGERR | L2_EDE_MBECCERR | \
+			L2_EDE_TPARERR)
+#define L2_EDE_MASK	(L2_EDE_L2CFGERR | L2_EDE_SBECCERR | \
+			L2_EDE_MBECCERR | L2_EDE_TPARERR | L2_EDE_MULL2ERR)
+
+/*
+ * PCI Err defines
+ */
+#define PCI_EDE_TOE			0x00000001
+#define PCI_EDE_SCM			0x00000002
+#define PCI_EDE_IRMSV			0x00000004
+#define PCI_EDE_ORMSV			0x00000008
+#define PCI_EDE_OWMSV			0x00000010
+#define PCI_EDE_TGT_ABRT		0x00000020
+#define PCI_EDE_MST_ABRT		0x00000040
+#define PCI_EDE_TGT_PERR		0x00000080
+#define PCI_EDE_MST_PERR		0x00000100
+#define PCI_EDE_RCVD_SERR		0x00000200
+#define PCI_EDE_ADDR_PERR		0x00000400
+#define PCI_EDE_MULTI_ERR		0x80000000
+
+#define PCI_EDE_PERR_MASK	(PCI_EDE_TGT_PERR | PCI_EDE_MST_PERR | \
+				PCI_EDE_ADDR_PERR)
+
+#define MPC85XX_PCI_ERR_DR		0x0000
+#define MPC85XX_PCI_ERR_CAP_DR		0x0004
+#define MPC85XX_PCI_ERR_EN		0x0008
+#define MPC85XX_PCI_ERR_ATTRIB		0x000c
+#define MPC85XX_PCI_ERR_ADDR		0x0010
+#define MPC85XX_PCI_ERR_EXT_ADDR	0x0014
+#define MPC85XX_PCI_ERR_DL		0x0018
+#define MPC85XX_PCI_ERR_DH		0x001c
+#define MPC85XX_PCI_GAS_TIMR		0x0020
+#define MPC85XX_PCI_PCIX_TIMR		0x0024
+
+struct mpc85xx_mc_pdata {
+	char *name;
+	int edac_idx;
+	void __iomem *mc_vbase;
+	int irq;
+};
+
+struct mpc85xx_l2_pdata {
+	char *name;
+	int edac_idx;
+	void __iomem *l2_vbase;
+	int irq;
+};
+
+struct mpc85xx_pci_pdata {
+	char *name;
+	int edac_idx;
+	void __iomem *pci_vbase;
+	int irq;
+};
+
+#endif
_

Patches currently in -mm which might be from djiang@mvista.com are

drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
