From: akpm@linux-foundation.org
Subject: + ipmi-reduce-polling.patch added to -mm tree
Date: Tue, 04 May 2010 15:54:17 -0700
Message-ID: <201005042254.o44MsHgK023812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934527Ab0EDWya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 18:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, cminyard@mvista.com


The patch titled
     ipmi: reduce polling
has been added to the -mm tree.  Its filename is
     ipmi-reduce-polling.patch

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
Subject: ipmi: reduce polling
From: Matthew Garrett <mjg@redhat.com>

We can reasonably alter the poll rate depending on whether we're
performing a transaction or merely waiting for an event.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-reduce-polling drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-reduce-polling
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -893,6 +893,9 @@ static void sender(void                *
 
 	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
 
+	if (smi_info->thread)
+		wake_up_process(smi_info->thread);
+
 	if (smi_info->run_to_completion) {
 		/*
 		 * If we are running to completion, then throw it in
@@ -1013,6 +1016,8 @@ static int ipmi_thread(void *data)
 			; /* do nothing */
 		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
 			schedule();
+		else if (smi_result == SI_SM_IDLE)
+			schedule_timeout_interruptible(100);
 		else
 			schedule_timeout_interruptible(0);
 	}
@@ -1055,6 +1060,7 @@ static void smi_timeout(unsigned long da
 	unsigned long     flags;
 	unsigned long     jiffies_now;
 	long              time_diff;
+	long		  timeout;
 #ifdef DEBUG_TIMING
 	struct timeval    t;
 #endif
@@ -1075,9 +1081,9 @@ static void smi_timeout(unsigned long da
 
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
 		/* Running with interrupts, only do long timeouts. */
-		smi_info->si_timer.expires = jiffies + SI_TIMEOUT_JIFFIES;
+		timeout = jiffies + SI_TIMEOUT_JIFFIES;
 		smi_inc_stat(smi_info, long_timeouts);
-		goto do_add_timer;
+		goto do_mod_timer;
 	}
 
 	/*
@@ -1086,15 +1092,15 @@ static void smi_timeout(unsigned long da
 	 */
 	if (smi_result == SI_SM_CALL_WITH_DELAY) {
 		smi_inc_stat(smi_info, short_timeouts);
-		smi_info->si_timer.expires = jiffies + 1;
+		timeout = jiffies + 1;
 	} else {
 		smi_inc_stat(smi_info, long_timeouts);
-		smi_info->si_timer.expires = jiffies + SI_TIMEOUT_JIFFIES;
+		timeout = jiffies + SI_TIMEOUT_JIFFIES;
 	}
 
- do_add_timer:
-	if ((smi_result != SI_SM_IDLE) || smi_info->interrupt_disabled)
-		add_timer(&(smi_info->si_timer));
+ do_mod_timer:
+	if (smi_result != SI_SM_IDLE)
+		mod_timer(&(smi_info->si_timer), timeout);
 }
 
 static irqreturn_t si_irq_handler(int irq, void *data)
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61.patch
ipmi-change-addr_source-to-an-enum-rather-than-strings.patch
ipmi-split-device-discovery-and-registration.patch
ipmi-only-register-one-si-per-bmc.patch
ipmi-change-device-discovery-order.patch
ipmi-reduce-polling-when-interrupts-are-available.patch
ipmi-reduce-polling.patch
ipmi-attempt-to-register-multiple-sis-of-the-same-type.patch

