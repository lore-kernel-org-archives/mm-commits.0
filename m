From: akpm@osdl.org
Subject: - acpi-fix-single-linked-list-manipulation.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:08 -0800
Message-ID: <200612210036.kBL0a9xN011168@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53217 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161054AbWLUAgM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:36:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: fix single linked list manipulation
has been removed from the -mm tree.  Its filename was
     acpi-fix-single-linked-list-manipulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: fix single linked list manipulation
From: Akinobu Mita <akinobu.mita@gmail.com>

Fix single linked list manipulation for sub_driver.  If the remving entry
is not on the head of the sub_driver list, it goes into infinate loop.

Though that infinite loop doesn't happen.  Because the only user of
acpi_pci_register_dirver() is acpiphp.

Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/pci_root.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/acpi/pci_root.c~acpi-fix-single-linked-list-manipulation drivers/acpi/pci_root.c
--- a/drivers/acpi/pci_root.c~acpi-fix-single-linked-list-manipulation
+++ a/drivers/acpi/pci_root.c
@@ -98,11 +98,12 @@ void acpi_pci_unregister_driver(struct a
 
 	struct acpi_pci_driver **pptr = &sub_driver;
 	while (*pptr) {
-		if (*pptr != driver)
-			continue;
-		*pptr = (*pptr)->next;
-		break;
+		if (*pptr == driver)
+			break;
+		pptr = &(*pptr)->next;
 	}
+	BUG_ON(!*pptr);
+	*pptr = (*pptr)->next;
 
 	if (!driver->remove)
 		return;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
audit-fix-kstrdup-error-check.patch
gss_spkm3-fix-error-handling-in-module-init.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

