From: akpm@linux-foundation.org
Subject: - ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:50:50 -0700
Message-ID: <200804290550.m3T5oodh003870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035AbYD2Fzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: remove unnecessary memory barriers
has been removed from the -mm tree.  Its filename was
     ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch

This patch was dropped because it was folded into ipmi-dont-grab-locks-in-run-to-completion-mode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: remove unnecessary memory barriers
From: Corey Minyard <cminyard@mvista.com>

Remove some unnecessary barriers.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-dont-grab-locks-in-run-to-completion-mode-fix drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-dont-grab-locks-in-run-to-completion-mode-fix
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -3511,7 +3511,6 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 	/* To preserve message order, if the list is not empty, we
            tack this message onto the end of the list. */
 	run_to_completion = intf->run_to_completion;
-	barrier();
 	if (!run_to_completion)
 		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
 	if (!list_empty(&intf->waiting_msgs)) {
@@ -3528,7 +3527,6 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 		/* Could not handle the message now, just add it to a
                    list to handle later. */
 		run_to_completion = intf->run_to_completion;
-		barrier();
 		if (!run_to_completion)
 			spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
 		list_add_tail(&msg->link, &intf->waiting_msgs);
_

Patches currently in -mm which might be from cminyard@mvista.com are

ipmi-hold-attn-until-upper-layer-ready.patch
ipmi-run-to-completion-fixes.patch
ipmi-dont-grab-locks-in-run-to-completion-mode.patch
ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch
ipmi-dont-print-event-queue-full-on-every-event.patch
ipmi-update-driver-version.patch
ipmi-convert-locked-counters-to-atomics.patch
ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch
ipmi-style-fixes-in-the-base-code.patch
ipmi-style-fixes-in-the-system-interface-code.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
ipmi-style-fixes-in-the-misc-code.patch
ipmi-make-comment-match-actual-preprocessor-check.patch
ipmi-make-alloc_recv_msg-static.patch
ipmi-fix-return-from-atca_oem_poweroff_hook.patch

