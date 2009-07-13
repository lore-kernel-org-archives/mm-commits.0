From: akpm@linux-foundation.org
Subject: + toshiba_acpi-return-on-a-fail-path.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:52:03 -0700
Message-ID: <200907132152.n6DLq3dZ011055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756454AbZGMVxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, hmh@hmh.eng.br, johannes@sipsolutions.net, len.brown@intel.com, linville@tuxdriver.com


The patch titled
     toshiba_acpi: return on a fail path
has been added to the -mm tree.  Its filename is
     toshiba_acpi-return-on-a-fail-path.patch

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
Subject: toshiba_acpi: return on a fail path
From: Jiri Slaby <jirislaby@gmail.com>

Return from bt_rfkill_poll() when hci_get_radio_state() fails.

value is invalid in that case and should not be assigned to the rfkill
state.

This also fixes a double unlock bug.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/toshiba_acpi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/toshiba_acpi.c~toshiba_acpi-return-on-a-fail-path drivers/platform/x86/toshiba_acpi.c
--- a/drivers/platform/x86/toshiba_acpi.c~toshiba_acpi-return-on-a-fail-path
+++ a/drivers/platform/x86/toshiba_acpi.c
@@ -335,6 +335,7 @@ static void bt_rfkill_poll(struct rfkill
 	if (hci_result != HCI_SUCCESS) {
 		/* Can't do anything useful */
 		mutex_unlock(&dev->mutex);
+		return;
 	}
 
 	new_rfk_state = value;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
reiser4.patch

