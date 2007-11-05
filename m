From: akpm@linux-foundation.org
Subject: + acpi-ac-update-ac-state-on-resume.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:01:06 -0800
Message-ID: <200711052301.lA5N16BH024033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbXKEXBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:01:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, arvidjaar@mail.ru, lenb@kernel.org, rjw@sisk.pl


The patch titled
     ACPI: AC: Update AC state on resume
has been added to the -mm tree.  Its filename is
     acpi-ac-update-ac-state-on-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: AC: Update AC state on resume
From: Alexey Starikovskiy <astarikovskiy@suse.de>

Check if AC state has changed across resume and notify userspace if so.

Fixes "[2.6.24-rc1 regression] AC adapter state does not change after resume"

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ac.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN drivers/acpi/ac.c~acpi-ac-update-ac-state-on-resume drivers/acpi/ac.c
--- a/drivers/acpi/ac.c~acpi-ac-update-ac-state-on-resume
+++ a/drivers/acpi/ac.c
@@ -59,6 +59,7 @@ static int acpi_ac_open_fs(struct inode 
 
 static int acpi_ac_add(struct acpi_device *device);
 static int acpi_ac_remove(struct acpi_device *device, int type);
+static int acpi_ac_resume(struct acpi_device *device);
 
 const static struct acpi_device_id ac_device_ids[] = {
 	{"ACPI0003", 0},
@@ -73,6 +74,7 @@ static struct acpi_driver acpi_ac_driver
 	.ops = {
 		.add = acpi_ac_add,
 		.remove = acpi_ac_remove,
+		.resume = acpi_ac_resume,
 		},
 };
 
@@ -307,6 +309,21 @@ static int acpi_ac_add(struct acpi_devic
 	return result;
 }
 
+static int acpi_ac_resume(struct acpi_device *device)
+{
+	struct acpi_ac *ac;
+	unsigned old_state;
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+	ac = acpi_driver_data(device);
+	old_state = ac->state;
+	if (acpi_ac_get_state(ac))
+		return 0;
+	if (old_state != ac->state)
+		kobject_uevent(&ac->charger.dev->kobj, KOBJ_CHANGE);
+	return 0;
+}
+
 static int acpi_ac_remove(struct acpi_device *device, int type)
 {
 	acpi_status status = AE_OK;
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

origin.patch
git-acpi.patch
make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch
acpi-ac-update-ac-state-on-resume.patch
