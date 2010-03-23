From: akpm@linux-foundation.org
Subject: + pci-dmar-combine-the-bios-dmar-table-warning-messages.patch added to -mm tree
Date: Mon, 22 Mar 2010 22:50:12 -0400
Message-ID: <201003230551.o2N5p3Sr016725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab0CWFve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 01:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, David.Woodhouse@intel.com, arnd@arndb.de, benh@kernel.crashing.org, ddaney@caviumnetworks.com, deller@gmx.de, heiko.carstens@de.ibm.com, jbarnes@virtuousgeek.org, jesper.nilsson@axis.com, lethal@linux-sh.org, matt@console-pimps.org, schwidefsky@de.ibm.com


The patch titled
     pci/dmar: combine the BIOS DMAR table warning messages
has been added to the -mm tree.  Its filename is
     pci-dmar-combine-the-bios-dmar-table-warning-messages.patch

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
Subject: pci/dmar: combine the BIOS DMAR table warning messages
From: Ben Hutchings <ben@decadent.org.uk>

We have nearly the same code for warnings repeated four times.  Move
it into a separate function.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Helge Deller <deller@gmx.de>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |   48 ++++++++++++-------------------------------
 1 file changed, 14 insertions(+), 34 deletions(-)

diff -puN drivers/pci/dmar.c~pci-dmar-combine-the-bios-dmar-table-warning-messages drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~pci-dmar-combine-the-bios-dmar-table-warning-messages
+++ a/drivers/pci/dmar.c
@@ -613,7 +613,15 @@ int __init dmar_table_init(void)
 	return 0;
 }
 
-static int bios_warned;
+static void warn_invalid_dmar(u64 addr, const char *message)
+{
+	WARN_ONCE(1, "Your BIOS is broken; DMAR reported at address %llx%s!\n"
+		  "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+		  addr, message,
+		  dmi_get_system_info(DMI_BIOS_VENDOR),
+		  dmi_get_system_info(DMI_BIOS_VERSION),
+		  dmi_get_system_info(DMI_PRODUCT_VERSION));
+}
 
 int __init check_zero_address(void)
 {
@@ -639,13 +647,7 @@ int __init check_zero_address(void)
 
 			drhd = (void *)entry_header;
 			if (!drhd->address) {
-				/* Promote an attitude of violence to a BIOS engineer today */
-				WARN(1, "Your BIOS is broken; DMAR reported at address zero!\n"
-				     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-				     dmi_get_system_info(DMI_BIOS_VENDOR),
-				     dmi_get_system_info(DMI_BIOS_VERSION),
-				     dmi_get_system_info(DMI_PRODUCT_VERSION));
-				bios_warned = 1;
+				warn_invalid_dmar(0, "");
 				goto failed;
 			}
 
@@ -658,14 +660,8 @@ int __init check_zero_address(void)
 			ecap = dmar_readq(addr + DMAR_ECAP_REG);
 			early_iounmap(addr, VTD_PAGE_SIZE);
 			if (cap == (uint64_t)-1 && ecap == (uint64_t)-1) {
-				/* Promote an attitude of violence to a BIOS engineer today */
-				WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"
-				     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-				      drhd->address,
-				      dmi_get_system_info(DMI_BIOS_VENDOR),
-				      dmi_get_system_info(DMI_BIOS_VERSION),
-				      dmi_get_system_info(DMI_PRODUCT_VERSION));
-				bios_warned = 1;
+				warn_invalid_dmar(drhd->address,
+						  " returns all ones");
 				goto failed;
 			}
 		}
@@ -730,14 +726,7 @@ int alloc_iommu(struct dmar_drhd_unit *d
 	int msagaw = 0;
 
 	if (!drhd->reg_base_addr) {
-		if (!bios_warned) {
-			WARN(1, "Your BIOS is broken; DMAR reported at address zero!\n"
-			     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-			     dmi_get_system_info(DMI_BIOS_VENDOR),
-			     dmi_get_system_info(DMI_BIOS_VERSION),
-			     dmi_get_system_info(DMI_PRODUCT_VERSION));
-			bios_warned = 1;
-		}
+		warn_invalid_dmar(0, "");
 		return -EINVAL;
 	}
 
@@ -757,16 +746,7 @@ int alloc_iommu(struct dmar_drhd_unit *d
 	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
 
 	if (iommu->cap == (uint64_t)-1 && iommu->ecap == (uint64_t)-1) {
-		if (!bios_warned) {
-			/* Promote an attitude of violence to a BIOS engineer today */
-			WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"
-			     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-			     drhd->reg_base_addr,
-			     dmi_get_system_info(DMI_BIOS_VENDOR),
-			     dmi_get_system_info(DMI_BIOS_VERSION),
-			     dmi_get_system_info(DMI_PRODUCT_VERSION));
-			bios_warned = 1;
-		}
+		warn_invalid_dmar(drhd->reg_base_addr, " returns all ones");
 		goto err_unmap;
 	}
 
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
panic-add-taint-flag-taint_firmware_workaround-i.patch
pci-dmar-combine-the-bios-dmar-table-warning-messages.patch
pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

