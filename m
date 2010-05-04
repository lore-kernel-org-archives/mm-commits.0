From: akpm@linux-foundation.org
Subject: + ipmi-reduce-polling-when-interrupts-are-available.patch added to -mm tree
Date: Tue, 04 May 2010 15:54:15 -0700
Message-ID: <201005042254.o44MsFEq023809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934441Ab0EDWy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 18:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, cminyard@mvista.com


The patch titled
     ipmi: reduce polling when interrupts are available
has been added to the -mm tree.  Its filename is
     ipmi-reduce-polling-when-interrupts-are-available.patch

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
Subject: ipmi: reduce polling when interrupts are available
From: Matthew Garrett <mjg@redhat.com>

If we're not currently in the middle of a transaction, and if we have
interrupts, there's no real reason to poll the controller more frequently
than the core IPMI code does.  Set the interrupt_disabled flag
appropriately as the interrupt state changes, and make the timeout code
reset itself only if the transaction is incomplete or we have no
interrupts.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-reduce-polling-when-interrupts-are-available drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-reduce-polling-when-interrupts-are-available
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -454,6 +454,9 @@ static inline void disable_si_irq(struct
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
 		start_disable_irq(smi_info);
 		smi_info->interrupt_disabled = 1;
+		if (!atomic_read(&smi_info->stop_operation))
+			mod_timer(&smi_info->si_timer,
+				  jiffies + SI_TIMEOUT_JIFFIES);
 	}
 }
 
@@ -706,6 +709,8 @@ static void handle_transaction_done(stru
 			printk(KERN_WARNING
 			       "ipmi_si: Could not enable interrupts"
 			       ", failed set, using polled mode.\n");
+		} else {
+			smi_info->interrupt_disabled = 0;
 		}
 		smi_info->si_state = SI_NORMAL;
 		break;
@@ -886,6 +891,8 @@ static void sender(void                *
 	printk("**Enqueue: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 
+	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+
 	if (smi_info->run_to_completion) {
 		/*
 		 * If we are running to completion, then throw it in
@@ -1086,7 +1093,8 @@ static void smi_timeout(unsigned long da
 	}
 
  do_add_timer:
-	add_timer(&(smi_info->si_timer));
+	if ((smi_result != SI_SM_IDLE) || smi_info->interrupt_disabled)
+		add_timer(&(smi_info->si_timer));
 }
 
 static irqreturn_t si_irq_handler(int irq, void *data)
@@ -3114,7 +3122,7 @@ static int try_smi_init(struct smi_info 
 	for (i = 0; i < SI_NUM_STATS; i++)
 		atomic_set(&new_smi->stats[i], 0);
 
-	new_smi->interrupt_disabled = 0;
+	new_smi->interrupt_disabled = 1;
 	atomic_set(&new_smi->stop_operation, 0);
 	new_smi->intf_num = smi_num;
 	smi_num++;
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

