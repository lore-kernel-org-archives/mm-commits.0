From: akpm@linux-foundation.org
Subject: + ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch added to -mm tree
Date: Thu, 14 Feb 2008 11:06:19 -0800
Message-ID: <200802141906.m1EJ6JD9030471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757021AbYBNTJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 14:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com


The patch titled
     ipmi: remove unnecessary memory barriers
has been added to the -mm tree.  Its filename is
     ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch

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

git-watchdog.patch
ipmi-hold-attn-until-upper-layer-ready.patch
ipmi-change-device-node-ordering-to-reflect-probe-order.patch
ipmi-run-to-completion-fixes.patch
ipmi-run-to-completion-fixes-fix.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-dont-grab-locks-in-run-to-completion-mode.patch
ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch
ipmi-dont-print-event-queue-full-on-every-event.patch
ipmi-update-driver-version.patch
