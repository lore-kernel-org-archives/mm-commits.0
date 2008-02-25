From: akpm@linux-foundation.org
Subject: - dmi-prevent-linked-list-corruption-resent.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:18 -0800
Message-ID: <200802250045.m1P0jIS5006252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbYBYAtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, Matt_Domsch@dell.com, mingo@elte.hu, parag.warudkar@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     dmi: prevent linked list corruption
has been removed from the -mm tree.  Its filename was
     dmi-prevent-linked-list-corruption-resent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
apanel-fix-kconfig-dependencies.patch
dmi-clean-up-dmi-helper-declarations.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
