From: akpm@osdl.org
Subject: - mmconfig-reject-a-broken-mcfg-tables-on-asus-etc.patch removed from -mm tree
Date: Wed, 10 Jan 2007 14:46:12 -0800
Message-ID: <200701102246.l0AMkCIg010286@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60097 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965166AbXAJWqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 17:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, ak@suse.de, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     MMCONFIG: Reject a broken MCFG tables on Asus etc
has been removed from the -mm tree.  Its filename was
     mmconfig-reject-a-broken-mcfg-tables-on-asus-etc.patch

This patch was dropped because x86_64 tree changes trashed it

------------------------------------------------------
Subject: MMCONFIG: Reject a broken MCFG tables on Asus etc
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This rejects a broken MCFG tables on Asus etc.  Arjan and Andi suggest this.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |   24 +++++++++++++++++++++++-
 arch/i386/pci/mmconfig.c        |    9 ---------
 arch/x86_64/pci/mmconfig.c      |    9 ---------
 3 files changed, 23 insertions(+), 19 deletions(-)

diff -puN arch/i386/pci/mmconfig-shared.c~mmconfig-reject-a-broken-mcfg-tables-on-asus-etc arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~mmconfig-reject-a-broken-mcfg-tables-on-asus-etc
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -184,6 +184,26 @@ static void __init pci_mmcfg_insert_reso
 	}
 }
 
+static void __init pci_mmcfg_reject_broken(void)
+{
+	struct acpi_table_mcfg_config *cfg = &pci_mmcfg_config[0];
+
+	/*
+	 * Handle more broken MCFG tables on Asus etc.
+	 * They only contain a single entry for bus 0-0.
+	 */
+	if (pci_mmcfg_config_num == 1 &&
+	    cfg->pci_segment_group_number == 0 &&
+	    (cfg->start_bus_number | cfg->end_bus_number) == 0) {
+		kfree(pci_mmcfg_config);
+		pci_mmcfg_config = NULL;
+		pci_mmcfg_config_num = 0;
+
+		printk(KERN_ERR "PCI: start and end of bus number is 0. "
+		       "Rejected as broken MCFG.");
+	}
+}
+
 void __init pci_mmcfg_init(int type)
 {
 	int known_bridge = 0;
@@ -194,8 +214,10 @@ void __init pci_mmcfg_init(int type)
 	if (type == 1 && pci_mmcfg_check_hostbridge())
 		known_bridge = 1;
 
-	if (!known_bridge)
+	if (!known_bridge) {
 		acpi_table_parse(ACPI_MCFG, acpi_parse_mcfg);
+		pci_mmcfg_reject_broken();
+	}
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
diff -puN arch/i386/pci/mmconfig.c~mmconfig-reject-a-broken-mcfg-tables-on-asus-etc arch/i386/pci/mmconfig.c
--- a/arch/i386/pci/mmconfig.c~mmconfig-reject-a-broken-mcfg-tables-on-asus-etc
+++ a/arch/i386/pci/mmconfig.c
@@ -42,15 +42,6 @@ static u32 get_base_addr(unsigned int se
 			return cfg->base_address;
 	}
 
-	/* Handle more broken MCFG tables on Asus etc.
-	   They only contain a single entry for bus 0-0. Assume
- 	   this applies to all busses. */
-	cfg = &pci_mmcfg_config[0];
-	if (pci_mmcfg_config_num == 1 &&
-		cfg->pci_segment_group_number == 0 &&
-		(cfg->start_bus_number | cfg->end_bus_number) == 0)
-		return cfg->base_address;
-
 	/* Fall back to type 0 */
 	return 0;
 }
diff -puN arch/x86_64/pci/mmconfig.c~mmconfig-reject-a-broken-mcfg-tables-on-asus-etc arch/x86_64/pci/mmconfig.c
--- a/arch/x86_64/pci/mmconfig.c~mmconfig-reject-a-broken-mcfg-tables-on-asus-etc
+++ a/arch/x86_64/pci/mmconfig.c
@@ -33,15 +33,6 @@ static char __iomem *get_virt(unsigned i
 			return pci_mmcfg_virt[cfg_num].virt;
 	}
 
-	/* Handle more broken MCFG tables on Asus etc.
-	   They only contain a single entry for bus 0-0. Assume
- 	   this applies to all busses. */
-	cfg = &pci_mmcfg_config[0];
-	if (pci_mmcfg_config_num == 1 &&
-		cfg->pci_segment_group_number == 0 &&
-		(cfg->start_bus_number | cfg->end_bus_number) == 0)
-		return pci_mmcfg_virt[0].virt;
-
 	/* Fall back to type 0 */
 	return NULL;
 }
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fix-the-reproducible-oops-in-scsi.patch
mmconfig-cleanup.patch
mmconfig-reject-a-broken-mcfg-tables-on-asus-etc.patch
mmconfig-fix-unreachable_devices.patch
mmconfig-fix-x86_64-ioremap-base_address.patch
relax-check-for-aix-in-msdos-partition-table.patch
msdos-partitions-fix-logic-error-in-aix-detection.patch
