From: akpm@linux-foundation.org
Subject: + ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:07:14 -0800
Message-ID: <200802152107.m1FL7Edx023973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357AbYBOVIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:08:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com, peterz@infradead.org


The patch titled
     IPMI: convert message handler defines to an enum
has been added to the -mm tree.  Its filename is
     ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch

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
Subject: IPMI: convert message handler defines to an enum
From: Corey Minyard <cminyard@mvista.com>

Convert the #defines for statistics into an enum in the IPMI message
handler.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |  125 +++++++++++++-------------
 1 file changed, 67 insertions(+), 58 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -189,90 +189,99 @@ struct bmc_device
  * Various statistics for IPMI, these index stats[] in the ipmi_smi
  * structure.
  */
-/* Commands we got from the user that were invalid. */
-#define IPMI_STAT_sent_invalid_commands			0
+enum ipmi_stat_indexes {
+	/* Commands we got from the user that were invalid. */
+	IPMI_STAT_sent_invalid_commands = 0,
 
-/* Commands we sent to the MC. */
-#define IPMI_STAT_sent_local_commands			1
+	/* Commands we sent to the MC. */
+	IPMI_STAT_sent_local_commands,
 
-/* Responses from the MC that were delivered to a user. */
-#define IPMI_STAT_handled_local_responses		2
+	/* Responses from the MC that were delivered to a user. */
+	IPMI_STAT_handled_local_responses,
 
-/* Responses from the MC that were not delivered to a user. */
-#define IPMI_STAT_unhandled_local_responses		3
+	/* Responses from the MC that were not delivered to a user. */
+	IPMI_STAT_unhandled_local_responses,
 
-/* Commands we sent out to the IPMB bus. */
-#define IPMI_STAT_sent_ipmb_commands			4
+	/* Commands we sent out to the IPMB bus. */
+	IPMI_STAT_sent_ipmb_commands,
 
-/* Commands sent on the IPMB that had errors on the SEND CMD */
-#define IPMI_STAT_sent_ipmb_command_errs		5
+	/* Commands sent on the IPMB that had errors on the SEND CMD */
+	IPMI_STAT_sent_ipmb_command_errs,
 
-/* Each retransmit increments this count. */
-#define IPMI_STAT_retransmitted_ipmb_commands		6
+	/* Each retransmit increments this count. */
+	IPMI_STAT_retransmitted_ipmb_commands,
 
-/* When a message times out (runs out of retransmits) this is incremented. */
-#define IPMI_STAT_timed_out_ipmb_commands		7
+	/*
+	 * When a message times out (runs out of retransmits) this is
+	 * incremented.
+	 */
+	IPMI_STAT_timed_out_ipmb_commands,
 
-/*
- * This is like above, but for broadcasts.  Broadcasts are
- * *not* included in the above count (they are expected to
- * time out).
- */
-#define IPMI_STAT_timed_out_ipmb_broadcasts		8
+	/*
+	 * This is like above, but for broadcasts.  Broadcasts are
+	 * *not* included in the above count (they are expected to
+	 * time out).
+	 */
+	IPMI_STAT_timed_out_ipmb_broadcasts,
 
-/* Responses I have sent to the IPMB bus. */
-#define IPMI_STAT_sent_ipmb_responses			9
+	/* Responses I have sent to the IPMB bus. */
+	IPMI_STAT_sent_ipmb_responses,
 
-/* The response was delivered to the user. */
-#define IPMI_STAT_handled_ipmb_responses		10
+	/* The response was delivered to the user. */
+	IPMI_STAT_handled_ipmb_responses,
 
-/* The response had invalid data in it. */
-#define IPMI_STAT_invalid_ipmb_responses		11
+	/* The response had invalid data in it. */
+	IPMI_STAT_invalid_ipmb_responses,
 
-/* The response didn't have anyone waiting for it. */
-#define IPMI_STAT_unhandled_ipmb_responses		12
+	/* The response didn't have anyone waiting for it. */
+	IPMI_STAT_unhandled_ipmb_responses,
 
-/* Commands we sent out to the IPMB bus. */
-#define IPMI_STAT_sent_lan_commands			13
+	/* Commands we sent out to the IPMB bus. */
+	IPMI_STAT_sent_lan_commands,
 
-/* Commands sent on the IPMB that had errors on the SEND CMD */
-#define IPMI_STAT_sent_lan_command_errs			14
+	/* Commands sent on the IPMB that had errors on the SEND CMD */
+	IPMI_STAT_sent_lan_command_errs,
 
-/* Each retransmit increments this count. */
-#define IPMI_STAT_retransmitted_lan_commands		15
+	/* Each retransmit increments this count. */
+	IPMI_STAT_retransmitted_lan_commands,
 
-/* When a message times out (runs out of retransmits) this is incremented. */
-#define IPMI_STAT_timed_out_lan_commands		16
+	/*
+	 * When a message times out (runs out of retransmits) this is
+	 * incremented.
+	 */
+	IPMI_STAT_timed_out_lan_commands,
 
-/* Responses I have sent to the IPMB bus. */
-#define IPMI_STAT_sent_lan_responses			17
+	/* Responses I have sent to the IPMB bus. */
+	IPMI_STAT_sent_lan_responses,
 
-/* The response was delivered to the user. */
-#define IPMI_STAT_handled_lan_responses			18
+	/* The response was delivered to the user. */
+	IPMI_STAT_handled_lan_responses,
 
-/* The response had invalid data in it. */
-#define IPMI_STAT_invalid_lan_responses			19
+	/* The response had invalid data in it. */
+	IPMI_STAT_invalid_lan_responses,
 
-/* The response didn't have anyone waiting for it. */
-#define IPMI_STAT_unhandled_lan_responses		20
+	/* The response didn't have anyone waiting for it. */
+	IPMI_STAT_unhandled_lan_responses,
 
-/* The command was delivered to the user. */
-#define IPMI_STAT_handled_commands			21
+	/* The command was delivered to the user. */
+	IPMI_STAT_handled_commands,
 
-/* The command had invalid data in it. */
-#define IPMI_STAT_invalid_commands			22
+	/* The command had invalid data in it. */
+	IPMI_STAT_invalid_commands,
 
-/* The command didn't have anyone waiting for it. */
-#define IPMI_STAT_unhandled_commands			23
+	/* The command didn't have anyone waiting for it. */
+	IPMI_STAT_unhandled_commands,
 
-/* Invalid data in an event. */
-#define IPMI_STAT_invalid_events			24
+	/* Invalid data in an event. */
+	IPMI_STAT_invalid_events,
 
-/* Events that were received with the proper format. */
-#define IPMI_STAT_events				25
+	/* Events that were received with the proper format. */
+	IPMI_STAT_events,
 
-/* When you add a statistic, you must update this value. */
-#define IPMI_NUM_STATS					26
+
+	/* This *must* remain last, add new values above this. */
+	IPMI_NUM_STATS
+};
 
 
 #define IPMI_IPMB_NUM_SEQ	64
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
ipmi-convert-locked-counters-to-atomics.patch
ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch
