From: akpm@linux-foundation.org
Subject: + ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:08:16 -0800
Message-ID: <200802152108.m1FL8Ghw024068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754968AbYBOVK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:10:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com, peterz@infradead.org


The patch titled
     IPMI: Convert system interface defines to an enum
has been added to the -mm tree.  Its filename is
     ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch

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
Subject: IPMI: Convert system interface defines to an enum
From: Corey Minyard <cminyard@mvista.com>

Convert the #defines for statistics into an enum in the IPMI system interface
and remove the unused timeout_restart statistic.  And comment what these
statistics mean.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   58 +++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 16 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -124,22 +124,50 @@ static struct device_driver ipmi_driver 
 /*
  * Indexes into stats[] in smi_info below.
  */
+enum si_stat_indexes {
+	/*
+	 * Number of times the driver requested a timer while an operation
+	 * was in progress.
+	 */
+	SI_STAT_short_timeouts = 0,
+
+	/*
+	 * Number of times the driver requested a timer while nothing was in
+	 * progress.
+	 */
+	SI_STAT_long_timeouts,
+
+	/* Number of times the interface was idle while being polled. */
+	SI_STAT_idles,
+
+	/* Number of interrupts the driver handled. */
+	SI_STAT_interrupts,
+
+	/* Number of time the driver got an ATTN from the hardware. */
+	SI_STAT_attentions,
 
-#define SI_STAT_short_timeouts		0
-#define SI_STAT_long_timeouts		1
-#define SI_STAT_timeout_restarts	2
-#define SI_STAT_idles			3
-#define SI_STAT_interrupts		4
-#define SI_STAT_attentions		5
-#define SI_STAT_flag_fetches		6
-#define SI_STAT_hosed_count		7
-#define SI_STAT_complete_transactions	8
-#define SI_STAT_events			9
-#define SI_STAT_watchdog_pretimeouts	10
-#define SI_STAT_incoming_messages	11
+	/* Number of times the driver requested flags from the hardware. */
+	SI_STAT_flag_fetches,
 
-/* If you add a stat, you must update this value. */
-#define SI_NUM_STATS			12
+	/* Number of times the hardware didn't follow the state machine. */
+	SI_STAT_hosed_count,
+
+	/* Number of completed messages. */
+	SI_STAT_complete_transactions,
+
+	/* Number of IPMI events received from the hardware. */
+	SI_STAT_events,
+
+	/* Number of watchdog pretimeouts. */
+	SI_STAT_watchdog_pretimeouts,
+
+	/* Number of asyncronous messages received. */
+	SI_STAT_incoming_messages,
+
+
+	/* This *must* remain last, add new values above this. */
+	SI_NUM_STATS
+};
 
 struct smi_info
 {
@@ -2399,8 +2427,6 @@ static int stat_file_read_proc(char *pag
 		       smi_get_stat(smi, short_timeouts));
 	out += sprintf(out, "long_timeouts:         %u\n",
 		       smi_get_stat(smi, long_timeouts));
-	out += sprintf(out, "timeout_restarts:      %u\n",
-		       smi_get_stat(smi, timeout_restarts));
 	out += sprintf(out, "idles:                 %u\n",
 		       smi_get_stat(smi, idles));
 	out += sprintf(out, "interrupts:            %u\n",
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
ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch
