From: akpm@linux-foundation.org
Subject: - hp-wmi-handle-rfkill_register-failure.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:43 -0800
Message-ID: <200901121958.n0CJwhqs027842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbZALUJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 15:09:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Larry.Finger@lwfinger.net, lenb@kernel.org, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     hp-wmi: handle rfkill_register() failure
has been removed from the -mm tree.  Its filename was
     hp-wmi-handle-rfkill_register-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp-wmi: handle rfkill_register() failure
From: Larry Finger <Larry.Finger@lwfinger.net>

Compilation of the HP WMI hotkeys code results in the following:

  CC [M]  drivers/misc/hp-wmi.o
drivers/platform/x86/hp-wmi.c: In function hp_wmi_bios_setup:
drivers/platform/x86/hp-wmi.c:431: warning: ignoring return value of rfkill_register,
	 declared with attribute warn_unused_result
drivers/platform/x86/hp-wmi.c:441: warning: ignoring return value of rfkill_register,
	 declared with attribute warn_unused_result
drivers/platform/x86/hp-wmi.c:450: warning: ignoring return value of rfkill_register,
	 declared with attribute warn_unused_result

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-handle-rfkill_register-failure drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-handle-rfkill_register-failure
+++ a/drivers/platform/x86/hp-wmi.c
@@ -428,7 +428,9 @@ static int __init hp_wmi_bios_setup(stru
 		wifi_rfkill->state = hp_wmi_wifi_state();
 		wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
 		wifi_rfkill->user_claim_unsupported = 1;
-		rfkill_register(wifi_rfkill);
+		err = rfkill_register(wifi_rfkill);
+		if (err)
+			goto add_sysfs_error;
 	}
 
 	if (wireless & 0x2) {
@@ -438,7 +440,8 @@ static int __init hp_wmi_bios_setup(stru
 		bluetooth_rfkill->state = hp_wmi_bluetooth_state();
 		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
 		bluetooth_rfkill->user_claim_unsupported = 1;
-		rfkill_register(bluetooth_rfkill);
+		err = rfkill_register(bluetooth_rfkill);
+			goto register_bluetooth_error;
 	}
 
 	if (wireless & 0x4) {
@@ -447,10 +450,16 @@ static int __init hp_wmi_bios_setup(stru
 		wwan_rfkill->state = hp_wmi_wwan_state();
 		wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
 		wwan_rfkill->user_claim_unsupported = 1;
-		rfkill_register(wwan_rfkill);
+		err = rfkill_register(wwan_rfkill);
+		if (err)
+			goto register_wwan_err;
 	}
 
 	return 0;
+register_wwan_err:
+	rfkill_unregister(bluetooth_rfkill);
+register_bluetooth_error:
+	rfkill_unregister(wifi_rfkill);
 add_sysfs_error:
 	cleanup_sysfs(device);
 	return err;
_

Patches currently in -mm which might be from Larry.Finger@lwfinger.net are

linux-next.patch

