From: akpm@linux-foundation.org
Subject: + ipmi-hold-attn-until-upper-layer-ready.patch added to -mm tree
Date: Wed, 13 Feb 2008 15:28:16 -0800
Message-ID: <200802132328.m1DNSGgL019549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759203AbYBMX3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 18:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com, Patrick.Schoeller@hp.com


The patch titled
     ipmi: hold ATTN until upper layer ready
has been added to the -mm tree.  Its filename is
     ipmi-hold-attn-until-upper-layer-ready.patch

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
Subject: ipmi: hold ATTN until upper layer ready
From: Corey Minyard <cminyard@mvista.com>

Hold handling of ATTN until the upper layer has reported that it is
ready.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-hold-attn-until-upper-layer-ready drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-hold-attn-until-upper-layer-ready
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -723,8 +723,11 @@ static enum si_sm_result smi_event_handl
 		si_sm_result = smi_info->handlers->event(smi_info->si_sm, 0);
 	}
 
-	/* We prefer handling attn over new messages. */
-	if (si_sm_result == SI_SM_ATTN)
+	/*
+	 * We prefer handling attn over new messages.  But don't do
+	 * this if there is not yet an upper layer to handle anything.
+	 */
+	if (likely(smi_info->intf) && si_sm_result == SI_SM_ATTN)
 	{
 		unsigned char msg[2];
 
_

Patches currently in -mm which might be from cminyard@mvista.com are

git-watchdog.patch
ipmi-hold-attn-until-upper-layer-ready.patch
ipmi-change-device-node-ordering-to-reflect-probe-order.patch
ipmi-run-to-completion-fixes.patch
ipmi-dont-grab-locks-in-run-to-completion-mode.patch
ipmi-dont-print-event-queue-full-on-every-event.patch
ipmi-update-driver-version.patch
ipmi-convert-locked-counters-to-atomics.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch
