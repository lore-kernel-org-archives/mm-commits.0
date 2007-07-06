From: akpm@linux-foundation.org
Subject: - acpi-fix-acpi_osi=linux.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:51:21 -0700
Message-ID: <200707060051.l660pL8o028212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760663AbXGFAvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lenb@kernel.org, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: fix acpi_osi=!Linux
has been removed from the -mm tree.  Its filename was
     acpi-fix-acpi_osi=linux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: fix acpi_osi=!Linux
From: Len Brown <lenb@kernel.org>

Need to check for special case "acpi_osi=!Linux" before general case
"acpi_osi=!*", or it will have no effect.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/osl.c~acpi-fix-acpi_osi=linux drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~acpi-fix-acpi_osi=linux
+++ a/drivers/acpi/osl.c
@@ -993,11 +993,11 @@ static int __init acpi_osi_setup(char *s
 	if (str == NULL || *str == '\0') {
 		printk(KERN_INFO PREFIX "_OSI method disabled\n");
 		acpi_gbl_create_osi_method = FALSE;
+	} else if (!strcmp("!Linux", str)) {
+		enable_osi_linux(0);
 	} else if (*str == '!') {
 		if (acpi_osi_invalidate(++str) == AE_OK)
 			printk(KERN_INFO PREFIX "Deleted _OSI(%s)\n", str);
-	} else if (!strcmp("!Linux", str)) {
-		enable_osi_linux(0);
 	} else if (!strcmp("Linux", str)) {
 		enable_osi_linux(1);
 	} else if (*osi_additional_string == '\0') {
_

Patches currently in -mm which might be from lenb@kernel.org are

origin.patch
i386-es7000-build-breakage-fix.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
fix-empty-macros-in-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-battery-vs-git-acpi.patch
revert-acpi-change-for-scsi.patch
restore-acpi-change-for-scsi.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
mmconfig-validate-against-acpi-motherboard-resources-fix-2-3.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
acpi-do-not-prepare-for-hibernation-in-acpi_shutdown.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
