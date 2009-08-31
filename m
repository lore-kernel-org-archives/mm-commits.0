From: akpm@linux-foundation.org
Subject: [merged] toshiba_acpi-return-on-a-fail-path.patch removed from -mm tree
Date: Mon, 31 Aug 2009 14:18:43 -0700
Message-ID: <200908312118.n7VLIhLa018433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbZHaVUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Aug 2009 17:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, hmh@hmh.eng.br, johannes@sipsolutions.net, len.brown@intel.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     toshiba_acpi: return on a fail path
has been removed from the -mm tree.  Its filename was
     toshiba_acpi-return-on-a-fail-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
md-dm-log-fix-cn_ulog_callback-declaration.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

