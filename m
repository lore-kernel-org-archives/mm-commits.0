From: akpm@linux-foundation.org
Subject: + mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch added to -mm tree
Date: Fri, 11 May 2007 13:55:52 -0700
Message-ID: <200705112055.l4BKtq46026450@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759313AbXEKU46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 16:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adurbin@google.com, ak@suse.de


The patch titled
     mmconfig x86_64/i386: insert unclaimed MMCONFIG resources
has been added to the -mm tree.  Its filename is
     mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mmconfig x86_64/i386: insert unclaimed MMCONFIG resources
From: Aaron Durbin <adurbin@google.com>

Insert the unclaimed MMCONFIG resources into the resource tree without the
IORESOURCE_BUSY flag during late initialization.  This allows the MMCONFIG
regions to be visible in the iomem resource tree without interfering with
other system resources that were discovered during PCI initialization.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/mmconfig-shared.c |   49 +++++++++++++++++++++++++++---
 1 files changed, 45 insertions(+), 4 deletions(-)

diff -puN arch/i386/pci/mmconfig-shared.c~mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -24,6 +24,9 @@
 
 DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
 
+/* Indicate if the mmcfg resources have been placed into the resource table. */
+static int __initdata pci_mmcfg_resources_inserted = 0;
+
 /* K8 systems have some devices (typically in the builtin northbridge)
    that are only accessible using type1
    Normally this can be expressed in the MCFG by not listing them
@@ -170,7 +173,7 @@ static int __init pci_mmcfg_check_hostbr
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(void)
+static void __init pci_mmcfg_insert_resources(int resource_flags)
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
@@ -267,7 +273,42 @@ void __init pci_mmcfg_init(int type)
 		if (type == 1)
 			unreachable_devices();
 		if (known_bridge)
-			pci_mmcfg_insert_resources();
+			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	}
+	} else
+		/*
+		 * Signal not to attempt to insert mmcfg resources because
+		 * the architecture mmcfg setup could not initialize.
+		 */
+		pci_mmcfg_resources_inserted = 1;
+}
+
+static int __init pci_mmcfg_late_insert_resources(void)
+{
+	/*
+	 * If resources are already inserted or we are not using MMCONFIG,
+	 * don't insert the resources.
+	 * */
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
 }
+
+/*
+ * Perform MMCONFIG resource insertion after PCI initialization to allow for
+ * misprogrammed MCFG tables that state larger sizes but actually conflict
+ * with other system resources.
+ */
+late_initcall(pci_mmcfg_late_insert_resources);
_

Patches currently in -mm which might be from adurbin@google.com are

mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
