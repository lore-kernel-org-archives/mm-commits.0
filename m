From: akpm@linux-foundation.org
Subject: + acpi-also-autoload-the-bay-driver-was-forgotten.patch added to -mm tree
Date: Fri, 07 Dec 2007 13:40:11 -0800
Message-ID: <200712072140.lB7LeBl1005076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851AbXLGVkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 16:40:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org


The patch titled
     acpi: also autoload the bay driver, was forgotten
has been added to the -mm tree.  Its filename is
     acpi-also-autoload-the-bay-driver-was-forgotten.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

acpi-also-autoload-the-bay-driver-was-forgotten.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
git-alsa.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
declare-pnp-option-parsing-functions-as-__init.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
