From: akpm@linux-foundation.org
Subject: + drivers-edac-lindent-i82875p.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:51:19 -0700
Message-ID: <200706060151.l561pJpn007503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934095AbXFFB4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com, dougthompson@xmission.com


The patch titled
     drivers-edac: Lindent i82875p
has been added to the -mm tree.  Its filename is
     drivers-edac-lindent-i82875p.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: Lindent i82875p

=BFFrom: Dave Jiang <djiang@mvista.com>

Lindent cleanup of i82875p_edac driver

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |   62 ++++++++++++++++------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff -puN drivers/edac/i82875p_edac.c~drivers-edac-lindent-i82875p driv=
ers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~drivers-edac-lindent-i82875p
+++ a/drivers/edac/i82875p_edac.c
@@ -174,8 +174,7 @@ struct i82875p_error_info {
=20
 static const struct i82875p_dev_info i82875p_devs[] =3D {
 	[I82875P] =3D {
-		.ctl_name =3D "i82875p"
-	},
+		     .ctl_name =3D "i82875p"},
 };
=20
 static struct pci_dev *mci_pdev =3D NULL;	/* init dev: in case that AG=
P code has
@@ -185,7 +184,7 @@ static struct pci_dev *mci_pdev =3D NULL;=09
 static int i82875p_registered =3D 1;
=20
 static void i82875p_get_error_info(struct mem_ctl_info *mci,
-		struct i82875p_error_info *info)
+				   struct i82875p_error_info *info)
 {
 	struct pci_dev *pdev;
=20
@@ -216,13 +215,13 @@ static void i82875p_get_error_info(struc
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
 		pci_read_config_dword(pdev, I82875P_EAP, &info->eap);
 		pci_read_config_byte(pdev, I82875P_DES, &info->des);
-		pci_read_config_byte(pdev, I82875P_DERRSYN,
-				&info->derrsyn);
+		pci_read_config_byte(pdev, I82875P_DERRSYN, &info->derrsyn);
 	}
 }
=20
 static int i82875p_process_error_info(struct mem_ctl_info *mci,
-		struct i82875p_error_info *info, int handle_errors)
+				      struct i82875p_error_info *info,
+				      int handle_errors)
 {
 	int row, multi_chan;
=20
@@ -246,8 +245,8 @@ static int i82875p_process_error_info(st
 		edac_mc_handle_ue(mci, info->eap, 0, row, "i82875p UE");
 	else
 		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row,
-				multi_chan ? (info->des & 0x1) : 0,
-				"i82875p CE");
+				  multi_chan ? (info->des & 0x1) : 0,
+				  "i82875p CE");
=20
 	return 1;
 }
@@ -263,7 +262,8 @@ static void i82875p_check(struct mem_ctl
=20
 /* Return 0 on success or 1 on failure. */
 static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
-		struct pci_dev **ovrfl_pdev, void __iomem **ovrfl_window)
+				    struct pci_dev **ovrfl_pdev,
+				    void __iomem ** ovrfl_window)
 {
 	struct pci_dev *dev;
 	void __iomem *window;
@@ -284,7 +284,7 @@ static int i82875p_setup_overfl_dev(stru
 		if (dev =3D=3D NULL)
 			return 1;
=20
-        	pci_bus_add_device(dev);
+		pci_bus_add_device(dev);
 	}
=20
 	*ovrfl_pdev =3D dev;
@@ -314,32 +314,31 @@ static int i82875p_setup_overfl_dev(stru
 	*ovrfl_window =3D window;
 	return 0;
=20
-fail1:
+      fail1:
 	pci_release_regions(dev);
=20
 #ifdef CORRECT_BIOS
-fail0:
+      fail0:
 	pci_disable_device(dev);
 #endif
 	/* NOTE: the ovrfl proc entry and pci_dev are intentionally left */
 	return 1;
 }
=20
-
 /* Return 1 if dual channel mode is active.  Else return 0. */
 static inline int dual_channel_active(u32 drc)
 {
 	return (drc >> 21) & 0x1;
 }
=20
-
 static void i82875p_init_csrows(struct mem_ctl_info *mci,
-		struct pci_dev *pdev, void __iomem *ovrfl_window, u32 drc)
+				struct pci_dev *pdev,
+				void __iomem * ovrfl_window, u32 drc)
 {
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	u8 value;
-	u32 drc_ddim;  /* DRAM Data Integrity Mode 0=3Dnone,2=3Dedac */
+	u32 drc_ddim;		/* DRAM Data Integrity Mode 0=3Dnone,2=3Dedac */
 	u32 cumul_size;
 	int index;
=20
@@ -392,7 +391,7 @@ static int i82875p_probe1(struct pci_dev
 	drc =3D readl(ovrfl_window + I82875P_DRC);
 	nr_chans =3D dual_channel_active(drc) + 1;
 	mci =3D edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
-				nr_chans);
+			    nr_chans);
=20
 	if (!mci) {
 		rc =3D -ENOMEM;
@@ -411,16 +410,16 @@ static int i82875p_probe1(struct pci_dev
 	mci->edac_check =3D i82875p_check;
 	mci->ctl_page_to_phys =3D NULL;
 	debugf3("%s(): init pvt\n", __func__);
-	pvt =3D (struct i82875p_pvt *) mci->pvt_info;
+	pvt =3D (struct i82875p_pvt *)mci->pvt_info;
 	pvt->ovrfl_pdev =3D ovrfl_pdev;
 	pvt->ovrfl_window =3D ovrfl_window;
 	i82875p_init_csrows(mci, pdev, ovrfl_window, drc);
-	i82875p_get_error_info(mci, &discard);  /* clear counters */
+	i82875p_get_error_info(mci, &discard);	/* clear counters */
=20
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail1;
 	}
@@ -429,10 +428,10 @@ static int i82875p_probe1(struct pci_dev
 	debugf3("%s(): success\n", __func__);
 	return 0;
=20
-fail1:
+      fail1:
 	edac_mc_free(mci);
=20
-fail0:
+      fail0:
 	iounmap(ovrfl_window);
 	pci_release_regions(ovrfl_pdev);
=20
@@ -443,7 +442,7 @@ fail0:
=20
 /* returns count (>=3D 0), or negative on error */
 static int __devinit i82875p_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				      const struct pci_device_id *ent)
 {
 	int rc;
=20
@@ -471,7 +470,7 @@ static void __devexit i82875p_remove_one
 	if ((mci =3D edac_mc_del_mc(&pdev->dev)) =3D=3D NULL)
 		return;
=20
-	pvt =3D (struct i82875p_pvt *) mci->pvt_info;
+	pvt =3D (struct i82875p_pvt *)mci->pvt_info;
=20
 	if (pvt->ovrfl_window)
 		iounmap(pvt->ovrfl_window);
@@ -489,12 +488,11 @@ static void __devexit i82875p_remove_one
=20
 static const struct pci_device_id i82875p_pci_tbl[] __devinitdata =3D =
{
 	{
-		PCI_VEND_DEV(INTEL, 82875_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		I82875P
-	},
+	 PCI_VEND_DEV(INTEL, 82875_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 I82875P},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
=20
 MODULE_DEVICE_TABLE(pci, i82875p_pci_tbl);
@@ -518,7 +516,7 @@ static int __init i82875p_init(void)
=20
 	if (mci_pdev =3D=3D NULL) {
 		mci_pdev =3D pci_get_device(PCI_VENDOR_ID_INTEL,
-				PCI_DEVICE_ID_INTEL_82875_0, NULL);
+					  PCI_DEVICE_ID_INTEL_82875_0, NULL);
=20
 		if (!mci_pdev) {
 			debugf0("875p pci_get_device fail\n");
@@ -537,10 +535,10 @@ static int __init i82875p_init(void)
=20
 	return 0;
=20
-fail1:
+      fail1:
 	pci_unregister_driver(&i82875p_driver);
=20
-fail0:
+      fail0:
 	if (mci_pdev !=3D NULL)
 		pci_dev_put(mci_pdev);
=20
_

Patches currently in -mm which might be from djiang@mvista.com are

drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-mod-pci-poll-names.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
