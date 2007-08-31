From: akpm@linux-foundation.org
Subject: - libata-switch-most-of-the-remaining-sff-drivers-to.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:34 -0700
Message-ID: <200708311656.l7VGuY54017496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965362AbXHaRIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: switch most of the remaining SFF drivers to  ata_sff_port_start
has been removed from the -mm tree.  Its filename was
     libata-switch-most-of-the-remaining-sff-drivers-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: switch most of the remaining SFF drivers to  ata_sff_port_start
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This avoids allocating DMA buffers if not needed but at the moment is mostly
just a neatness item.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c       |    2 +-
 drivers/ata/pata_acpi.c         |    2 +-
 drivers/ata/pata_ali.c          |    8 ++++----
 drivers/ata/pata_amd.c          |   12 ++++++------
 drivers/ata/pata_artop.c        |    4 ++--
 drivers/ata/pata_atiixp.c       |    2 +-
 drivers/ata/pata_cmd640.c       |    2 +-
 drivers/ata/pata_cs5520.c       |    2 +-
 drivers/ata/pata_cs5530.c       |    2 +-
 drivers/ata/pata_cs5535.c       |    2 +-
 drivers/ata/pata_cypress.c      |    2 +-
 drivers/ata/pata_efar.c         |    2 +-
 drivers/ata/pata_hpt366.c       |    2 +-
 drivers/ata/pata_hpt37x.c       |    8 ++++----
 drivers/ata/pata_hpt3x2n.c      |    2 +-
 drivers/ata/pata_hpt3x3.c       |    2 +-
 drivers/ata/pata_isapnp.c       |    2 +-
 drivers/ata/pata_it8213.c       |    2 +-
 drivers/ata/pata_it821x.c       |    2 +-
 drivers/ata/pata_marvell.c      |    2 +-
 drivers/ata/pata_mpiix.c        |    2 +-
 drivers/ata/pata_netcell.c      |    2 +-
 drivers/ata/pata_ns87410.c      |    2 +-
 drivers/ata/pata_oldpiix.c      |    2 +-
 drivers/ata/pata_opti.c         |    2 +-
 drivers/ata/pata_optidma.c      |    4 ++--
 drivers/ata/pata_pdc2027x.c     |    4 ++--
 drivers/ata/pata_pdc202xx_old.c |    4 ++--
 drivers/ata/pata_qdi.c          |    4 ++--
 drivers/ata/pata_radisys.c      |    2 +-
 drivers/ata/pata_rz1000.c       |    2 +-
 drivers/ata/pata_sc1200.c       |    2 +-
 drivers/ata/pata_serverworks.c  |    4 ++--
 drivers/ata/pata_sil680.c       |    2 +-
 drivers/ata/pata_sis.c          |   12 ++++++------
 drivers/ata/pata_sl82c105.c     |    2 +-
 drivers/ata/pata_triflex.c      |    2 +-
 drivers/ata/pata_via.c          |    4 ++--
 drivers/ata/pata_winbond.c      |    2 +-
 39 files changed, 62 insertions(+), 62 deletions(-)

diff -puN drivers/ata/ata_generic.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/ata_generic.c
@@ -121,7 +121,7 @@ static struct ata_port_operations generi
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int all_generic_ide;		/* Set to claim all devices */
diff -puN drivers/ata/pata_acpi.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_acpi.c
@@ -270,7 +270,7 @@ static int pacpi_port_start(struct ata_p
 	acpi->mask[0] = pacpi_discover_modes(ap, &ap->device[0]);
 	acpi->mask[1] = pacpi_discover_modes(ap, &ap->device[1]);
 
-	ret = ata_port_start(ap);
+	ret = ata_sff_port_start(ap);
 	if (ret < 0)
 		return ret;
 
diff -puN drivers/ata/pata_ali.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_ali.c
--- a/drivers/ata/pata_ali.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_ali.c
@@ -320,7 +320,7 @@ static struct ata_port_operations ali_ea
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -359,7 +359,7 @@ static struct ata_port_operations ali_20
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -396,7 +396,7 @@ static struct ata_port_operations ali_c2
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -432,7 +432,7 @@ static struct ata_port_operations ali_c5
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 
diff -puN drivers/ata/pata_amd.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_amd.c
@@ -361,7 +361,7 @@ static struct ata_port_operations amd33_
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations amd66_port_ops = {
@@ -394,7 +394,7 @@ static struct ata_port_operations amd66_
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations amd100_port_ops = {
@@ -427,7 +427,7 @@ static struct ata_port_operations amd100
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations amd133_port_ops = {
@@ -460,7 +460,7 @@ static struct ata_port_operations amd133
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations nv100_port_ops = {
@@ -493,7 +493,7 @@ static struct ata_port_operations nv100_
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations nv133_port_ops = {
@@ -526,7 +526,7 @@ static struct ata_port_operations nv133_
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_artop.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_artop.c
--- a/drivers/ata/pata_artop.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_artop.c
@@ -361,7 +361,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static const struct ata_port_operations artop6260_ops = {
@@ -392,7 +392,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 
diff -puN drivers/ata/pata_atiixp.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_atiixp.c
--- a/drivers/ata/pata_atiixp.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_atiixp.c
@@ -262,7 +262,7 @@ static struct ata_port_operations atiixp
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_cmd640.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_cmd640.c
--- a/drivers/ata/pata_cmd640.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_cmd640.c
@@ -153,7 +153,7 @@ static int cmd640_port_start(struct ata_
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct cmd640_reg *timing;
 
-	int ret = ata_port_start(ap);
+	int ret = ata_sff_port_start(ap);
 	if (ret < 0)
 		return ret;
 
diff -puN drivers/ata/pata_cs5520.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_cs5520.c
--- a/drivers/ata/pata_cs5520.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_cs5520.c
@@ -184,7 +184,7 @@ static struct ata_port_operations cs5520
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_cs5530.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_cs5530.c
--- a/drivers/ata/pata_cs5530.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_cs5530.c
@@ -209,7 +209,7 @@ static struct ata_port_operations cs5530
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct dmi_system_id palmax_dmi_table[] = {
diff -puN drivers/ata/pata_cs5535.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_cs5535.c
--- a/drivers/ata/pata_cs5535.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_cs5535.c
@@ -206,7 +206,7 @@ static struct ata_port_operations cs5535
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_cypress.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_cypress.c
--- a/drivers/ata/pata_cypress.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_cypress.c
@@ -158,7 +158,7 @@ static struct ata_port_operations cy82c6
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_efar.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_efar.c
--- a/drivers/ata/pata_efar.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_efar.c
@@ -279,7 +279,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 
diff -puN drivers/ata/pata_hpt366.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_hpt366.c
@@ -342,7 +342,7 @@ static struct ata_port_operations hpt366
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_hpt37x.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_hpt37x.c
--- a/drivers/ata/pata_hpt37x.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_hpt37x.c
@@ -673,7 +673,7 @@ static struct ata_port_operations hpt370
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -710,7 +710,7 @@ static struct ata_port_operations hpt370
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -748,7 +748,7 @@ static struct ata_port_operations hpt372
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -786,7 +786,7 @@ static struct ata_port_operations hpt374
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_hpt3x2n.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_hpt3x2n.c
--- a/drivers/ata/pata_hpt3x2n.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_hpt3x2n.c
@@ -391,7 +391,7 @@ static struct ata_port_operations hpt3x2
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_hpt3x3.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_hpt3x3.c
--- a/drivers/ata/pata_hpt3x3.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_hpt3x3.c
@@ -153,7 +153,7 @@ static struct ata_port_operations hpt3x3
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_isapnp.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_isapnp.c
--- a/drivers/ata/pata_isapnp.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_isapnp.c
@@ -58,7 +58,7 @@ static struct ata_port_operations isapnp
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_it8213.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_it8213.c
--- a/drivers/ata/pata_it8213.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_it8213.c
@@ -289,7 +289,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 
diff -puN drivers/ata/pata_it821x.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_it821x.c
--- a/drivers/ata/pata_it821x.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_it821x.c
@@ -559,7 +559,7 @@ static int it821x_port_start(struct ata_
 	struct it821x_dev *itdev;
 	u8 conf;
 
-	int ret = ata_port_start(ap);
+	int ret = ata_sff_port_start(ap);
 	if (ret < 0)
 		return ret;
 
diff -puN drivers/ata/pata_marvell.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_marvell.c
--- a/drivers/ata/pata_marvell.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_marvell.c
@@ -139,7 +139,7 @@ static const struct ata_port_operations 
 	.irq_on			= ata_irq_on,
 
 	/* Generic PATA PCI ATA helpers */
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 
diff -puN drivers/ata/pata_mpiix.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_mpiix.c
--- a/drivers/ata/pata_mpiix.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_mpiix.c
@@ -190,7 +190,7 @@ static struct ata_port_operations mpiix_
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int mpiix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_netcell.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_netcell.c
--- a/drivers/ata/pata_netcell.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_netcell.c
@@ -68,7 +68,7 @@ static const struct ata_port_operations 
 	.irq_on			= ata_irq_on,
 
 	/* Generic PATA PCI ATA helpers */
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 
diff -puN drivers/ata/pata_ns87410.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_ns87410.c
--- a/drivers/ata/pata_ns87410.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_ns87410.c
@@ -185,7 +185,7 @@ static struct ata_port_operations ns8741
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_oldpiix.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_oldpiix.c
--- a/drivers/ata/pata_oldpiix.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_oldpiix.c
@@ -266,7 +266,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 
diff -puN drivers/ata/pata_opti.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_opti.c
--- a/drivers/ata/pata_opti.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_opti.c
@@ -210,7 +210,7 @@ static struct ata_port_operations opti_p
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_optidma.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_optidma.c
--- a/drivers/ata/pata_optidma.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_optidma.c
@@ -398,7 +398,7 @@ static struct ata_port_operations optidm
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations optiplus_port_ops = {
@@ -432,7 +432,7 @@ static struct ata_port_operations optipl
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_pdc2027x.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_pdc2027x.c
--- a/drivers/ata/pata_pdc2027x.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_pdc2027x.c
@@ -173,7 +173,7 @@ static struct ata_port_operations pdc202
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static struct ata_port_operations pdc2027x_pata133_ops = {
@@ -206,7 +206,7 @@ static struct ata_port_operations pdc202
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static struct ata_port_info pdc2027x_port_info[] = {
diff -puN drivers/ata/pata_pdc202xx_old.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_pdc202xx_old.c
--- a/drivers/ata/pata_pdc202xx_old.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_pdc202xx_old.c
@@ -275,7 +275,7 @@ static struct ata_port_operations pdc202
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations pdc2026x_port_ops = {
@@ -308,7 +308,7 @@ static struct ata_port_operations pdc202
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_qdi.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_qdi.c
@@ -192,7 +192,7 @@ static struct ata_port_operations qdi650
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations qdi6580_port_ops = {
@@ -218,7 +218,7 @@ static struct ata_port_operations qdi658
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_radisys.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_radisys.c
--- a/drivers/ata/pata_radisys.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_radisys.c
@@ -231,7 +231,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 
diff -puN drivers/ata/pata_rz1000.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_rz1000.c
--- a/drivers/ata/pata_rz1000.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_rz1000.c
@@ -99,7 +99,7 @@ static struct ata_port_operations rz1000
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int rz1000_fifo_disable(struct pci_dev *pdev)
diff -puN drivers/ata/pata_sc1200.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_sc1200.c
--- a/drivers/ata/pata_sc1200.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_sc1200.c
@@ -227,7 +227,7 @@ static struct ata_port_operations sc1200
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_serverworks.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_serverworks.c
--- a/drivers/ata/pata_serverworks.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_serverworks.c
@@ -348,7 +348,7 @@ static struct ata_port_operations server
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations serverworks_csb_port_ops = {
@@ -382,7 +382,7 @@ static struct ata_port_operations server
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int serverworks_fixup_osb4(struct pci_dev *pdev)
diff -puN drivers/ata/pata_sil680.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_sil680.c
--- a/drivers/ata/pata_sil680.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_sil680.c
@@ -267,7 +267,7 @@ static struct ata_port_operations sil680
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_sis.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_sis.c
@@ -557,7 +557,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static const struct ata_port_operations sis_133_for_sata_ops = {
@@ -589,7 +589,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static const struct ata_port_operations sis_133_early_ops = {
@@ -621,7 +621,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static const struct ata_port_operations sis_100_ops = {
@@ -653,7 +653,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static const struct ata_port_operations sis_66_ops = {
@@ -685,7 +685,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static const struct ata_port_operations sis_old_ops = {
@@ -717,7 +717,7 @@ static const struct ata_port_operations 
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_sff_port_start,
 };
 
 static const struct ata_port_info sis_info = {
diff -puN drivers/ata/pata_sl82c105.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_sl82c105.c
--- a/drivers/ata/pata_sl82c105.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_sl82c105.c
@@ -254,7 +254,7 @@ static struct ata_port_operations sl82c1
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_triflex.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_triflex.c
--- a/drivers/ata/pata_triflex.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_triflex.c
@@ -227,7 +227,7 @@ static struct ata_port_operations trifle
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff -puN drivers/ata/pata_via.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_via.c
--- a/drivers/ata/pata_via.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_via.c
@@ -367,7 +367,7 @@ static struct ata_port_operations via_po
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations via_port_ops_noirq = {
@@ -401,7 +401,7 @@ static struct ata_port_operations via_po
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
diff -puN drivers/ata/pata_winbond.c~libata-switch-most-of-the-remaining-sff-drivers-to drivers/ata/pata_winbond.c
--- a/drivers/ata/pata_winbond.c~libata-switch-most-of-the-remaining-sff-drivers-to
+++ a/drivers/ata/pata_winbond.c
@@ -160,7 +160,7 @@ static struct ata_port_operations winbon
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /**
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
git-xtensa.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
