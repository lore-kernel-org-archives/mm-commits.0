From: akpm@linux-foundation.org
Subject: - pata_atiixp-dont-disable.patch removed from -mm tree
Date: Tue, 06 May 2008 22:23:53 -0700
Message-ID: <200805070523.m475NrHg013231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758AbYEGFYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 01:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, davidg@havidave.com, mm-commits@vger.kernel.org


The patch titled
     pata_atiixp: Don't disable
has been removed from the -mm tree.  Its filename was
     pata_atiixp-dont-disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pata_atiixp: Don't disable
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

A couple of distributions (Fedora, Ubuntu) were having weird problems with the
ATI IXP series PATA controllers being reported as simplex.  At the heart of
the problem is that both distros ignored the recommendations to load pata_acpi
and ata_generic *AFTER* specific host drivers.

The underlying cause however is that if you D3 and then D0 an ATI IXP it
helpfully throws away some configuration and won't let you rewrite it.

Add checks to ata_generic and pata_acpi to pin ATIIXP devices.  Possibly the
real answer here is to quirk them and pin them, but right now we can't do that
before they've been pcim_enable()'d by a driver.

I'm indebted to David Gero for this.  His bug report not only reported the
problem but identified the cause correctly and he had tested the right values
to prove what was going on

[If you backport this for 2.6.24 you will need to pull in the 2.6.25
removal of the bogus WARN_ON() in pcim_enagle]

Signed-off-by: Alan Cox <alan@redhat.com>
Tested-by: David Gero <davidg@havidave.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c |    6 ++++++
 drivers/ata/pata_acpi.c   |    6 ++++++
 2 files changed, 12 insertions(+)

diff -puN drivers/ata/ata_generic.c~pata_atiixp-dont-disable drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~pata_atiixp-dont-disable
+++ a/drivers/ata/ata_generic.c
@@ -152,6 +152,12 @@ static int ata_generic_init_one(struct p
 	if (dev->vendor == PCI_VENDOR_ID_AL)
 		ata_pci_bmdma_clear_simplex(dev);
 
+	if (dev->vendor == PCI_VENDOR_ID_ATI) {
+		int rc = pcim_enable_device(pdev);
+		if (rc < 0)
+			return rc;
+		pcim_pin_device(pdev);
+	}
 	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL);
 }
 
diff -puN drivers/ata/pata_acpi.c~pata_atiixp-dont-disable drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~pata_atiixp-dont-disable
+++ a/drivers/ata/pata_acpi.c
@@ -259,6 +259,12 @@ static int pacpi_init_one (struct pci_de
 		.port_ops	= &pacpi_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
+	if (pdev->vendor == PCI_VENDOR_ID_ATI) {
+		int rc = pcim_enable_device(pdev);
+		if (rc < 0)
+			return rc;
+		pcim_pin_device(pdev);
+	}
 	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL);
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
linux-next.patch
git-gfs2-nmw.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
iphase-fix-64bit-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
vt-fix-vcs-sysfs-file-creation-race.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

