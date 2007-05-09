From: akpm@linux-foundation.org
Subject: - ipmi-allow-shared-interrupts.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:15 -0700
Message-ID: <200705090244.l492iFN0008566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970098AbXEICo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: allow shared interrupts
has been removed from the -mm tree.  Its filename was
     ipmi-allow-shared-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipmi: allow shared interrupts
From: Corey Minyard <minyard@acm.org>

The IPMI driver used enable_irq and disable_irq when it got into situations
where it couldn't allocate memory; it did this to avoid having the interrupt
just lock the machine when it couldn't get memory to perform the transaction
to disable the interrupt.

This patch modifies the driver to not use disable_irq and enable_irq.  It
instead sends the messages to the BMC to perform this operation.  It also
makes sure interrupts are cleanly disabled when the interface is shut down and
cleans up some shutdown things that are no longer necessary.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |  124 ++++++++++++++++++++---------
 1 file changed, 89 insertions(+), 35 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-allow-shared-interrupts drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-allow-shared-interrupts
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -82,6 +82,12 @@
 #define SI_SHORT_TIMEOUT_USEC  250 /* .25ms when the SM request a
                                        short timeout */
 
+/* Bit for BMC global enables. */
+#define IPMI_BMC_RCV_MSG_INTR     0x01
+#define IPMI_BMC_EVT_MSG_INTR     0x02
+#define IPMI_BMC_EVT_MSG_BUFF     0x04
+#define IPMI_BMC_SYS_LOG          0x08
+
 enum si_intf_state {
 	SI_NORMAL,
 	SI_GETTING_FLAGS,
@@ -90,7 +96,9 @@ enum si_intf_state {
 	SI_CLEARING_FLAGS_THEN_SET_IRQ,
 	SI_GETTING_MESSAGES,
 	SI_ENABLE_INTERRUPTS1,
-	SI_ENABLE_INTERRUPTS2
+	SI_ENABLE_INTERRUPTS2,
+	SI_DISABLE_INTERRUPTS1,
+	SI_DISABLE_INTERRUPTS2
 	/* FIXME - add watchdog stuff. */
 };
 
@@ -339,6 +347,17 @@ static void start_enable_irq(struct smi_
 	smi_info->si_state = SI_ENABLE_INTERRUPTS1;
 }
 
+static void start_disable_irq(struct smi_info *smi_info)
+{
+	unsigned char msg[2];
+
+	msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
+	msg[1] = IPMI_GET_BMC_GLOBAL_ENABLES_CMD;
+
+	smi_info->handlers->start_transaction(smi_info->si_sm, msg, 2);
+	smi_info->si_state = SI_DISABLE_INTERRUPTS1;
+}
+
 static void start_clear_flags(struct smi_info *smi_info)
 {
 	unsigned char msg[3];
@@ -359,7 +378,7 @@ static void start_clear_flags(struct smi
 static inline void disable_si_irq(struct smi_info *smi_info)
 {
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
-		disable_irq_nosync(smi_info->irq);
+		start_disable_irq(smi_info);
 		smi_info->interrupt_disabled = 1;
 	}
 }
@@ -367,7 +386,7 @@ static inline void disable_si_irq(struct
 static inline void enable_si_irq(struct smi_info *smi_info)
 {
 	if ((smi_info->irq) && (smi_info->interrupt_disabled)) {
-		enable_irq(smi_info->irq);
+		start_enable_irq(smi_info);
 		smi_info->interrupt_disabled = 0;
 	}
 }
@@ -589,7 +608,9 @@ static void handle_transaction_done(stru
 		} else {
 			msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
 			msg[1] = IPMI_SET_BMC_GLOBAL_ENABLES_CMD;
-			msg[2] = msg[3] | 1; /* enable msg queue int */
+			msg[2] = (msg[3] |
+				  IPMI_BMC_RCV_MSG_INTR |
+				  IPMI_BMC_EVT_MSG_INTR);
 			smi_info->handlers->start_transaction(
 				smi_info->si_sm, msg, 3);
 			smi_info->si_state = SI_ENABLE_INTERRUPTS2;
@@ -611,6 +632,45 @@ static void handle_transaction_done(stru
 		smi_info->si_state = SI_NORMAL;
 		break;
 	}
+
+	case SI_DISABLE_INTERRUPTS1:
+	{
+		unsigned char msg[4];
+
+		/* We got the flags from the SMI, now handle them. */
+		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
+		if (msg[2] != 0) {
+			printk(KERN_WARNING
+			       "ipmi_si: Could not disable interrupts"
+			       ", failed get.\n");
+			smi_info->si_state = SI_NORMAL;
+		} else {
+			msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
+			msg[1] = IPMI_SET_BMC_GLOBAL_ENABLES_CMD;
+			msg[2] = (msg[3] &
+				  ~(IPMI_BMC_RCV_MSG_INTR |
+				    IPMI_BMC_EVT_MSG_INTR));
+			smi_info->handlers->start_transaction(
+				smi_info->si_sm, msg, 3);
+			smi_info->si_state = SI_DISABLE_INTERRUPTS2;
+		}
+		break;
+	}
+
+	case SI_DISABLE_INTERRUPTS2:
+	{
+		unsigned char msg[4];
+
+		/* We got the flags from the SMI, now handle them. */
+		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
+		if (msg[2] != 0) {
+			printk(KERN_WARNING
+			       "ipmi_si: Could not disable interrupts"
+			       ", failed set.\n");
+		}
+		smi_info->si_state = SI_NORMAL;
+		break;
+	}
 	}
 }
 
@@ -864,9 +924,6 @@ static void smi_timeout(unsigned long da
 	struct timeval    t;
 #endif
 
-	if (atomic_read(&smi_info->stop_operation))
-		return;
-
 	spin_lock_irqsave(&(smi_info->si_lock), flags);
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
@@ -922,15 +979,11 @@ static irqreturn_t si_irq_handler(int ir
 	smi_info->interrupts++;
 	spin_unlock(&smi_info->count_lock);
 
-	if (atomic_read(&smi_info->stop_operation))
-		goto out;
-
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
 	printk("**Interrupt: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 	smi_event_handler(smi_info, 0);
- out:
 	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 	return IRQ_HANDLED;
 }
@@ -1118,7 +1171,7 @@ static int std_irq_setup(struct smi_info
 	if (info->si_type == SI_BT) {
 		rv = request_irq(info->irq,
 				 si_bt_irq_handler,
-				 IRQF_DISABLED,
+				 IRQF_SHARED | IRQF_DISABLED,
 				 DEVICE_NAME,
 				 info);
 		if (!rv)
@@ -1128,7 +1181,7 @@ static int std_irq_setup(struct smi_info
 	} else
 		rv = request_irq(info->irq,
 				 si_irq_handler,
-				 IRQF_DISABLED,
+				 IRQF_SHARED | IRQF_DISABLED,
 				 DEVICE_NAME,
 				 info);
 	if (rv) {
@@ -1708,15 +1761,11 @@ static u32 ipmi_acpi_gpe(void *context)
 	smi_info->interrupts++;
 	spin_unlock(&smi_info->count_lock);
 
-	if (atomic_read(&smi_info->stop_operation))
-		goto out;
-
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
 	printk("**ACPI_GPE: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 	smi_event_handler(smi_info, 0);
- out:
 	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 
 	return ACPI_INTERRUPT_HANDLED;
@@ -2942,28 +2991,33 @@ static void cleanup_one_si(struct smi_in
 
 	list_del(&to_clean->link);
 
-	/* Tell the timer and interrupt handlers that we are shutting
-	   down. */
-	spin_lock_irqsave(&(to_clean->si_lock), flags);
-	spin_lock(&(to_clean->msg_lock));
-
+	/* Tell the driver that we are shutting down. */
 	atomic_inc(&to_clean->stop_operation);
 
-	if (to_clean->irq_cleanup)
-		to_clean->irq_cleanup(to_clean);
-
-	spin_unlock(&(to_clean->msg_lock));
-	spin_unlock_irqrestore(&(to_clean->si_lock), flags);
-
-	/* Wait until we know that we are out of any interrupt
-	   handlers might have been running before we freed the
-	   interrupt. */
-	synchronize_sched();
-
+	/* Make sure the timer and thread are stopped and will not run
+	   again. */
 	wait_for_timer_and_thread(to_clean);
 
-	/* Interrupts and timeouts are stopped, now make sure the
-	   interface is in a clean state. */
+	/* Timeouts are stopped, now make sure the interrupts are off
+	   for the device.  A little tricky with locks to make sure
+	   there are no races. */
+	spin_lock_irqsave(&to_clean->si_lock, flags);
+	while (to_clean->curr_msg || (to_clean->si_state != SI_NORMAL)) {
+		spin_unlock_irqrestore(&to_clean->si_lock, flags);
+		poll(to_clean);
+		schedule_timeout_uninterruptible(1);
+		spin_lock_irqsave(&to_clean->si_lock, flags);
+	}
+	disable_si_irq(to_clean);
+	spin_unlock_irqrestore(&to_clean->si_lock, flags);
+	while (to_clean->curr_msg || (to_clean->si_state != SI_NORMAL)) {
+		poll(to_clean);
+		schedule_timeout_uninterruptible(1);
+	}
+
+	/* Clean up interrupts and make sure that everything is done. */
+	if (to_clean->irq_cleanup)
+		to_clean->irq_cleanup(to_clean);
 	while (to_clean->curr_msg || (to_clean->si_state != SI_NORMAL)) {
 		poll(to_clean);
 		schedule_timeout_uninterruptible(1);
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch
