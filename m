From: akpm@linux-foundation.org
Subject: [merged] ipmi-simplify-locking.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:14:00 -0700
Message-ID: <20120329191400.52E0FA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61777 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751Ab2C2TOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:14:01 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so302652qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:14:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi: simplify locking
has been removed from the -mm tree.  Its filename was
     ipmi-simplify-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: ipmi: simplify locking

Now that the the IPMI driver is using a tasklet, we can simplify the
locking in the driver and get rid of the message lock.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   54 +++++++++++------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-simplify-locking drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-simplify-locking
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -171,7 +171,6 @@ struct smi_info {
 	struct si_sm_handlers  *handlers;
 	enum si_type           si_type;
 	spinlock_t             si_lock;
-	spinlock_t             msg_lock;
 	struct list_head       xmit_msgs;
 	struct list_head       hp_xmit_msgs;
 	struct ipmi_smi_msg    *curr_msg;
@@ -350,13 +349,6 @@ static enum si_sm_result start_next_msg(
 	struct timeval t;
 #endif
 
-	/*
-	 * No need to save flags, we aleady have interrupts off and we
-	 * already hold the SMI lock.
-	 */
-	if (!smi_info->run_to_completion)
-		spin_lock(&(smi_info->msg_lock));
-
 	/* Pick the high priority queue first. */
 	if (!list_empty(&(smi_info->hp_xmit_msgs))) {
 		entry = smi_info->hp_xmit_msgs.next;
@@ -394,9 +386,6 @@ static enum si_sm_result start_next_msg(
 		rv = SI_SM_CALL_WITHOUT_DELAY;
 	}
  out:
-	if (!smi_info->run_to_completion)
-		spin_unlock(&(smi_info->msg_lock));
-
 	return rv;
 }
 
@@ -879,19 +868,6 @@ static void sender(void                *
 	printk("**Enqueue: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 
-	/*
-	 * last_timeout_jiffies is updated here to avoid
-	 * smi_timeout() handler passing very large time_diff
-	 * value to smi_event_handler() that causes
-	 * the send command to abort.
-	 */
-	smi_info->last_timeout_jiffies = jiffies;
-
-	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
-
-	if (smi_info->thread)
-		wake_up_process(smi_info->thread);
-
 	if (smi_info->run_to_completion) {
 		/*
 		 * If we are running to completion, then throw it in
@@ -914,15 +890,26 @@ static void sender(void                *
 		return;
 	}
 
-	spin_lock_irqsave(&smi_info->msg_lock, flags);
+	spin_lock_irqsave(&smi_info->si_lock, flags);
 	if (priority > 0)
 		list_add_tail(&msg->link, &smi_info->hp_xmit_msgs);
 	else
 		list_add_tail(&msg->link, &smi_info->xmit_msgs);
-	spin_unlock_irqrestore(&smi_info->msg_lock, flags);
 
-	spin_lock_irqsave(&smi_info->si_lock, flags);
 	if (smi_info->si_state == SI_NORMAL && smi_info->curr_msg == NULL) {
+		/*
+		 * last_timeout_jiffies is updated here to avoid
+		 * smi_timeout() handler passing very large time_diff
+		 * value to smi_event_handler() that causes
+		 * the send command to abort.
+		 */
+		smi_info->last_timeout_jiffies = jiffies;
+
+		mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+
+		if (smi_info->thread)
+			wake_up_process(smi_info->thread);
+
 		start_next_msg(smi_info);
 		smi_event_handler(smi_info, 0);
 	}
@@ -1026,16 +1013,19 @@ static int ipmi_thread(void *data)
 static void poll(void *send_info)
 {
 	struct smi_info *smi_info = send_info;
-	unsigned long flags;
+	unsigned long flags = 0;
+	int run_to_completion = smi_info->run_to_completion;
 
 	/*
 	 * Make sure there is some delay in the poll loop so we can
 	 * drive time forward and timeout things.
 	 */
 	udelay(10);
-	spin_lock_irqsave(&smi_info->si_lock, flags);
+	if (!run_to_completion)
+		spin_lock_irqsave(&smi_info->si_lock, flags);
 	smi_event_handler(smi_info, 10);
-	spin_unlock_irqrestore(&smi_info->si_lock, flags);
+	if (!run_to_completion)
+		spin_unlock_irqrestore(&smi_info->si_lock, flags);
 }
 
 static void request_events(void *send_info)
@@ -1672,10 +1662,8 @@ static struct smi_info *smi_info_alloc(v
 {
 	struct smi_info *info = kzalloc(sizeof(*info), GFP_KERNEL);
 
-	if (info) {
+	if (info)
 		spin_lock_init(&info->si_lock);
-		spin_lock_init(&info->msg_lock);
-	}
 	return info;
 }
 
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

