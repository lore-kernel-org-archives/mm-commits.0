From: akpm@linux-foundation.org
Subject: [merged] hp-wmi-fix-regressions-caused-by-missing-if-statement.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:13:55 -0800
Message-ID: <200901301913.n0UJDteI026781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538AbZA3TRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:17:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, Larry.Finger@lwfinger.net, lenb@kernel.org, mjg59@srcf.ucam.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     hp-wmi: fix regressions caused by missing if statement
has been removed from the -mm tree.  Its filename was
     hp-wmi-fix-regressions-caused-by-missing-if-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp-wmi: fix regressions caused by missing if statement
From: Frans Pop <elendil@planet.nl>

Error was introduced in commit fe8e4e039dc3 ("hp-wmi: handle
rfkill_register() failure").

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-fix-regressions-caused-by-missing-if-statement drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-fix-regressions-caused-by-missing-if-statement
+++ a/drivers/platform/x86/hp-wmi.c
@@ -441,6 +441,7 @@ static int __init hp_wmi_bios_setup(stru
 		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
 		bluetooth_rfkill->user_claim_unsupported = 1;
 		err = rfkill_register(bluetooth_rfkill);
+		if (err)
 			goto register_bluetooth_error;
 	}
 
_

Patches currently in -mm which might be from elendil@planet.nl are

origin.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch

