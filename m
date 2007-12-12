From: akpm@linux-foundation.org
Subject: + acpi-sbs-ignore-alarms-coming-from-unknown-devices.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:44:38 -0800
Message-ID: <200712120544.lBC5icc4028088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbXLLFoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:44:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, lenb@kernel.org


The patch titled
     ACPI: SBS: Ignore alarms coming from unknown devices
has been added to the -mm tree.  Its filename is
     acpi-sbs-ignore-alarms-coming-from-unknown-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: SBS: Ignore alarms coming from unknown devices
From: Alexey Starikovskiy <astarikovskiy@suse.de>

Reference: http://bugzilla.kernel.org/show_bug.cgi?id=9362

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c   |    6 ------
 drivers/acpi/sbshc.c |   16 ++++++++++++----
 drivers/acpi/sbshc.h |    6 ++++++
 3 files changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/acpi/sbs.c~acpi-sbs-ignore-alarms-coming-from-unknown-devices drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-sbs-ignore-alarms-coming-from-unknown-devices
+++ a/drivers/acpi/sbs.c
@@ -54,12 +54,6 @@
 #define ACPI_BATTERY_DIR_NAME		"BAT%i"
 #define ACPI_AC_DIR_NAME		"AC0"
 
-enum acpi_sbs_device_addr {
-	ACPI_SBS_CHARGER = 0x9,
-	ACPI_SBS_MANAGER = 0xa,
-	ACPI_SBS_BATTERY = 0xb,
-};
-
 #define ACPI_SBS_NOTIFY_STATUS		0x80
 #define ACPI_SBS_NOTIFY_INFO		0x81
 
diff -puN drivers/acpi/sbshc.c~acpi-sbs-ignore-alarms-coming-from-unknown-devices drivers/acpi/sbshc.c
--- a/drivers/acpi/sbshc.c~acpi-sbs-ignore-alarms-coming-from-unknown-devices
+++ a/drivers/acpi/sbshc.c
@@ -202,10 +202,9 @@ int acpi_smbus_unregister_callback(struc
 
 EXPORT_SYMBOL_GPL(acpi_smbus_unregister_callback);
 
-static void acpi_smbus_callback(void *context)
+static inline void acpi_smbus_callback(void *context)
 {
 	struct acpi_smb_hc *hc = context;
-
 	if (hc->callback)
 		hc->callback(hc->context);
 }
@@ -214,6 +213,7 @@ static int smbus_alarm(void *context)
 {
 	struct acpi_smb_hc *hc = context;
 	union acpi_smb_status status;
+	u8 address;
 	if (smb_hc_read(hc, ACPI_SMB_STATUS, &status.raw))
 		return 0;
 	/* Check if it is only a completion notify */
@@ -222,10 +222,18 @@ static int smbus_alarm(void *context)
 	if (!status.fields.alarm)
 		return 0;
 	mutex_lock(&hc->lock);
+	smb_hc_read(hc, ACPI_SMB_ALARM_ADDRESS, &address);
 	status.fields.alarm = 0;
 	smb_hc_write(hc, ACPI_SMB_STATUS, status.raw);
-	if (hc->callback)
-		acpi_os_execute(OSL_GPE_HANDLER, acpi_smbus_callback, hc);
+	/* We are only interested in events coming from known devices */
+	switch (address >> 1) {
+		case ACPI_SBS_CHARGER:
+		case ACPI_SBS_MANAGER:
+		case ACPI_SBS_BATTERY:
+			acpi_os_execute(OSL_GPE_HANDLER,
+					acpi_smbus_callback, hc);
+		default:;
+	}
 	mutex_unlock(&hc->lock);
 	return 0;
 }
diff -puN drivers/acpi/sbshc.h~acpi-sbs-ignore-alarms-coming-from-unknown-devices drivers/acpi/sbshc.h
--- a/drivers/acpi/sbshc.h~acpi-sbs-ignore-alarms-coming-from-unknown-devices
+++ a/drivers/acpi/sbshc.h
@@ -16,6 +16,12 @@ enum acpi_smb_protocol {
 
 static const u8 SMBUS_PEC = 0x80;
 
+enum acpi_sbs_device_addr {
+	ACPI_SBS_CHARGER = 0x9,
+	ACPI_SBS_MANAGER = 0xa,
+	ACPI_SBS_BATTERY = 0xb,
+};
+
 typedef void (*smbus_alarm_callback)(void *context);
 
 extern int acpi_smbus_read(struct acpi_smb_hc *hc, u8 protocol, u8 address,
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

git-acpi.patch
acpi-sbs-reset-alarm-bit.patch
acpi-sbs-ignore-alarms-coming-from-unknown-devices.patch
acpi-sbs-return-rate-in-mw-if-capacity-in-mwh.patch
