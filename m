From: akpm@linux-foundation.org
Subject: + dmi-prevent-linked-list-corruption-resent.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:17:14 -0800
Message-ID: <200802142117.m1ELHESf003283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759556AbYBNVSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:18:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, Matt_Domsch@dell.com, mingo@elte.hu, parag.warudkar@gmail.com, tglx@linutronix.de


The patch titled
     dmi: prevent linked list corruption
has been added to the -mm tree.  Its filename is
     dmi-prevent-linked-list-corruption-resent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmi: prevent linked list corruption
From: Jean Delvare <khali@linux-fr.org>

Adding the same item to a given linked list more than once is guaranteed to
break and corrupt the list.  This is however what we do in dmi_scan since
commit 79da4721117fcf188b4b007b775738a530f574da.

Given that there is absolutely no interest in saving empty OEM strings
anyway, I propose the simple and efficient fix below: we discard the empty
OEM strings altogether.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-prevent-linked-list-corruption-resent drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-prevent-linked-list-corruption-resent
+++ a/drivers/firmware/dmi_scan.c
@@ -217,10 +217,6 @@ static void __init dmi_save_devices(cons
 	}
 }
 
-static struct dmi_device empty_oem_string_dev = {
-	.name = dmi_empty_string,
-};
-
 static void __init dmi_save_oem_strings_devices(const struct dmi_header *dm)
 {
 	int i, count = *(u8 *)(dm + 1);
@@ -229,10 +225,8 @@ static void __init dmi_save_oem_strings_
 	for (i = 1; i <= count; i++) {
 		char *devname = dmi_string(dm, i);
 
-		if (!strcmp(devname, dmi_empty_string)) {
-			list_add(&empty_oem_string_dev.list, &dmi_devices);
+		if (devname == dmi_empty_string)
 			continue;
-		}
 
 		dev = dmi_alloc(sizeof(*dev));
 		if (!dev) {
_

Patches currently in -mm which might be from khali@linux-fr.org are

mm-only-enforce-acpi-resource-conflict-checks.patch
oz99x-i2c-button-and-led-support-driver.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
apanel-fix-kconfig-dependencies.patch
dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
dmi-prevent-linked-list-corruption-resent.patch
dmi-clean-up-dmi-helper-declarations.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
