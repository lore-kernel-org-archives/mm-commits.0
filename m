From: akpm@linux-foundation.org
Subject: + hp-wmi-fix-regressions-caused-by-missing-if-statement.patch added to -mm tree
Date: Fri, 16 Jan 2009 17:40:44 -0800
Message-ID: <200901170140.n0H1eiNE007537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbZAQBle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 20:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, Larry.Finger@lwfinger.net, lenb@kernel.org, mjg59@srcf.ucam.org


The patch titled
     hp-wmi: fix regressions caused by missing if statement
has been added to the -mm tree.  Its filename is
     hp-wmi-fix-regressions-caused-by-missing-if-statement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp-wmi: fix regressions caused by missing if statement
From: Frans Pop <elendil@planet.nl>

Error was introduced in commit fe8e4e039dc3 ("hp-wmi: handle
rfkill_register() failure").

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
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

hp-wmi-fix-regressions-caused-by-missing-if-statement.patch
input-keyboard-hilkbdc-fix-crash-when-removing-hilkbd-module.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch

