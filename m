From: akpm@linux-foundation.org
Subject: - pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set.patch removed from -mm tree
Date: Fri, 09 May 2008 14:47:20 -0700
Message-ID: <200805092147.m49LlKmf027202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755622AbYEIVr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaneshige.kenji@jp.fujitsu.com, jbarnes@virtuousgeek.org, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     PCI ACPI: fix uninitialized variable in __pci_osc_support_set
has been removed from the -mm tree.  Its filename was
     pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI ACPI: fix uninitialized variable in __pci_osc_support_set
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

If the ACPI namespace doesn't have any device object corresponding to the
specified hid, 'retval' in __pci_osc_support_set() is not changed by the
acpi_query_osc() callback.  Since 'retval' is not initizlized in the current
implementation, the contents of 'retval' is undefined in this case.  This
causes a mis-handling of ctrlset_buf[OSC_SUPPORT_TYPE] and will cause an
unexpected result in the subsequent pci_osc_control_set() call as a result.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/pci-acpi.c~pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set drivers/pci/pci-acpi.c
--- a/drivers/pci/pci-acpi.c~pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set
+++ a/drivers/pci/pci-acpi.c
@@ -166,7 +166,7 @@ run_osc_out:
 acpi_status __pci_osc_support_set(u32 flags, const char *hid)
 {
 	u32 temp;
-	acpi_status retval;
+	acpi_status retval = AE_NOT_FOUND;
 
 	if (!(flags & OSC_SUPPORT_MASKS)) {
 		return AE_TYPE;
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

linux-next.patch
pci-hotplug-construct-one-fakephp-slot-per-pci-slot.patch
pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch

