From: akpm@linux-foundation.org
Subject: - mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:32 -0700
Message-ID: <200707192008.l6JK8Wxx020468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760946AbXGSUQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adurbin@google.com, ak@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mmconfig x86_64/i386: insert unclaimed MMCONFIG resources
has been removed from the -mm tree.  Its filename was
     mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mmconfig x86_64/i386: insert unclaimed MMCONFIG resources
From: Aaron Durbin <adurbin@google.com>

Insert the unclaimed MMCONFIG resources into the resource tree without the
IORESOURCE_BUSY flag during late initialization.  This allows the MMCONFIG
regions to be visible in the iomem resource tree without interfering with
other system resources that were discovered during PCI initialization.

[akpm@linux-foundation.org: nanofixes]
Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/mmconfig-shared.c |   48 ++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 3 deletions(-)

diff -puN arch/i386/pci/mmconfig-shared.c~mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -24,6 +24,9 @@
 
 DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
 
+/* Indicate if the mmcfg resources have been placed into the resource table. */
+static int __initdata pci_mmcfg_resources_inserted;
+
 /* K8 systems have some devices (typically in the builtin northbridge)
    that are only accessible using type1
    Normally this can be expressed in the MCFG by not listing them
@@ -170,7 +173,7 @@ static int __init pci_mmcfg_check_hostbr
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(void)
+static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -194,10 +197,13 @@ static void __init pci_mmcfg_insert_reso
 			 cfg->pci_segment);
 		res->start = cfg->address;
 		res->end = res->start + (num_buses << 20) - 1;
-		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		res->flags = IORESOURCE_MEM | resource_flags;
 		insert_resource(&iomem_resource, res);
 		names += PCI_MMCFG_RESOURCE_NAME_LEN;
 	}
+
+	/* Mark that the resources have been inserted. */
+	pci_mmcfg_resources_inserted = 1;
 }
 
 static void __init pci_mmcfg_reject_broken(int type)
@@ -267,7 +273,43 @@ void __init pci_mmcfg_init(int type)
 		if (type == 1)
 			unreachable_devices();
 		if (known_bridge)
-			pci_mmcfg_insert_resources();
+			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
+	} else {
+		/*
+		 * Signal not to attempt to insert mmcfg resources because
+		 * the architecture mmcfg setup could not initialize.
+		 */
+		pci_mmcfg_resources_inserted = 1;
 	}
 }
+
+static int __init pci_mmcfg_late_insert_resources(void)
+{
+	/*
+	 * If resources are already inserted or we are not using MMCONFIG,
+	 * don't insert the resources.
+	 */
+	if ((pci_mmcfg_resources_inserted == 1) ||
+	    (pci_probe & PCI_PROBE_MMCONF) == 0 ||
+	    (pci_mmcfg_config_num == 0) ||
+	    (pci_mmcfg_config == NULL) ||
+	    (pci_mmcfg_config[0].address == 0))
+		return 1;
+
+	/*
+	 * Attempt to insert the mmcfg resources but not with the busy flag
+	 * marked so it won't cause request errors when __request_region is
+	 * called.
+	 */
+	pci_mmcfg_insert_resources(0);
+
+	return 0;
+}
+
+/*
+ * Perform MMCONFIG resource insertion after PCI initialization to allow for
+ * misprogrammed MCFG tables that state larger sizes but actually conflict
+ * with other system resources.
+ */
+late_initcall(pci_mmcfg_late_insert_resources);
_

Patches currently in -mm which might be from adurbin@google.com are

acpi-add-reboot-mechanism.patch
acpi-add-reboot-mechanism-fix.patch
x86_64-add-acpi-reboot-option.patch
x86_64-make-acpi-the-default-reset-option.patch
