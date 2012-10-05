From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-scsi.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:20 -0700
Message-ID: <20121005201320.A0CEC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42422 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUNV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:21 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so93671qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/scsi
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-scsi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/scsi

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/linit.c        |    2 +-
 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/linit.c~sections-fix-section-conflicts-in-drivers-scsi drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~sections-fix-section-conflicts-in-drivers-scsi
+++ a/drivers/scsi/aacraid/linit.c
@@ -93,7 +93,7 @@ static DECLARE_PCI_DEVICE_TABLE(aac_pci_
 #elif defined(__devinitconst)
 static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
 #else
-static const struct pci_device_id aac_pci_tbl[] __devinitdata = {
+static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
 #endif
 	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
 	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di (Opal/PERC3Di) */
diff -puN drivers/scsi/aic94xx/aic94xx_init.c~sections-fix-section-conflicts-in-drivers-scsi drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~sections-fix-section-conflicts-in-drivers-scsi
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -1012,7 +1012,7 @@ static struct sas_domain_function_templa
 	.lldd_ata_set_dmamode	= asd_set_dmamode,
 };
 
-static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {
+static const struct pci_device_id aic94xx_pci_table[] __devinitconst = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x410),0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x412),0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x416),0, 0, 1},
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

