From: akpm@linux-foundation.org
Subject: - acpi-also-autoload-the-bay-driver-was-forgotten.patch removed from -mm tree
Date: Mon, 10 Dec 2007 15:21:55 -0800
Message-ID: <200712102321.lBANLtiB024301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbXLJXWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 18:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: also autoload the bay driver, was forgotten
has been removed from the -mm tree.  Its filename was
     acpi-also-autoload-the-bay-driver-was-forgotten.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: also autoload the bay driver, was forgotten
From: Thomas Renninger <trenn@suse.de>

Also autoload the bay driver, was forgotten...

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bay.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/acpi/bay.c~acpi-also-autoload-the-bay-driver-was-forgotten drivers/acpi/bay.c
--- a/drivers/acpi/bay.c~acpi-also-autoload-the-bay-driver-was-forgotten
+++ a/drivers/acpi/bay.c
@@ -46,6 +46,12 @@ MODULE_LICENSE("GPL");
 	printk(KERN_DEBUG PREFIX "%s: %s\n", prefix, s); }
 static void bay_notify(acpi_handle handle, u32 event, void *data);
 
+static const struct acpi_device_id bay_device_ids[] = {
+	{"LNXIOBAY", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, bay_device_ids);
+
 struct bay {
 	acpi_handle handle;
 	char *name;
_

Patches currently in -mm which might be from trenn@suse.de are

git-acpi.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
git-alsa.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
declare-pnp-option-parsing-functions-as-__init.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
