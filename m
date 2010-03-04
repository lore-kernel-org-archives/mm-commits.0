From: akpm@linux-foundation.org
Subject: [to-be-updated] ipmi-add-parameter-to-limit-cpu-usage-in-kipmid.patch removed from -mm tree
Date: Thu, 04 Mar 2010 13:03:46 -0800
Message-ID: <201003042103.o24L3kZ1029741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756474Ab0CDVEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:04:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martin.wilck@ts.fujitsu.com, cminyard@mvista.com, jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     ipmi: add parameter to limit CPU usage in kipmid
has been removed from the -mm tree.  Its filename was
     ipmi-add-parameter-to-limit-cpu-usage-in-kipmid.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: add parameter to limit CPU usage in kipmid
From: Martin Wilck <martin.wilck@ts.fujitsu.com>

In some cases kipmid can use a lot of CPU.  This is generally due to the
bad design of the hardware, it doesn't have interrupts and must be polled
constantly.  Different controllers run at different speeds and have
different latencies, so it is difficult to account for automatically.

This adds a way to tune the CPU used by kipmid to help in those cases.  By
setting kipmid_max_busy_us to a value between 100 and 500, it is possible
to bring down kipmid CPU load to practically 0.  This will cost some
performance, and that will vary from system to system.  Not setting the
value, or setting the value to zero, causes operation to be unaffected.

Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   89 ++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-parameter-to-limit-cpu-usage-in-kipmid drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-add-parameter-to-limit-cpu-usage-in-kipmid
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -295,6 +295,9 @@ struct smi_info {
 static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
 
+static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
+static int num_max_busy_us;
+
 static int unload_when_empty = 1;
 
 static int try_smi_init(struct smi_info *smi);
@@ -925,12 +928,88 @@ static void set_run_to_completion(void *
 	}
 }
 
+/*
+ * Handle busy waiting flags in the timespec.  We use a -1 in tv_nsec
+ * to mark that we are not currently busy waiting.
+ */
+static inline void ipmi_si_set_not_busy(struct timespec *ts)
+{
+	ts->tv_nsec = -1;
+}
+static inline int ipmi_si_is_busy(struct timespec *ts)
+{
+	return ts->tv_nsec != -1;
+}
+
+static inline int ipmi_result_allow_busy_wait(enum si_sm_result smi_result)
+{
+	/*
+	 * In these states we allow a busy wait.  SI_SM_CALL_WITHOUT_DELAY
+	 * is caught before here, so that will not be handled here.  In the
+	 * other results besides the ones below and SI_SM_CALL_WITHOUT_DELAY,
+	 * do a full tick delay before checking again in kipmid.
+	 */
+	switch (smi_result) {
+	case SI_SM_CALL_WITH_DELAY:
+	case SI_SM_TRANSACTION_COMPLETE:
+	case SI_SM_ATTN:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
+
+/*
+ * Return true if the kthread should busy wait, and false if not.  This is
+ * used to tune the operation of the kthread to not use too much CPU.
+ */
+static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
+				 const struct smi_info *smi_info,
+				 struct timespec *busy_until)
+{
+	unsigned int max_busy_us = 0;
+
+	if (!ipmi_result_allow_busy_wait(smi_result))
+		return 0;
+
+	if (smi_info->intf_num < num_max_busy_us)
+		max_busy_us = kipmid_max_busy_us[smi_info->intf_num];
+
+	if (max_busy_us <= 0)
+		/* Busy wait timing is disabled, just busy wait forever. */
+		ipmi_si_set_not_busy(busy_until);
+	else if (!ipmi_si_is_busy(busy_until)) {
+		/*
+		 * Need to start busy waiting.  Record the time to stop busy
+		 * waiting and do a full delay.
+		 */
+		getnstimeofday(busy_until);
+		timespec_add_ns(busy_until, max_busy_us * NSEC_PER_USEC);
+	} else {
+		struct timespec now;
+
+		/*
+		 * We are busy waiting.  If we have exceeded our time then
+		 * return false to do a full delay.
+		 */
+		getnstimeofday(&now);
+		if (unlikely(timespec_compare(&now, busy_until) > 0)) {
+			ipmi_si_set_not_busy(busy_until);
+			return 0;
+		}
+	}
+	return 1;
+}
+
 static int ipmi_thread(void *data)
 {
 	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
+	struct timespec busy_until;
 
+	ipmi_si_set_not_busy(&busy_until);
 	set_user_nice(current, 19);
 	while (!kthread_should_stop()) {
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
@@ -938,7 +1017,8 @@ static int ipmi_thread(void *data)
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY)
+		else if (ipmi_thread_busy_wait(smi_result, smi_info,
+					       &busy_until))
 			schedule();
 		else
 			schedule_timeout_interruptible(1);
@@ -1212,6 +1292,13 @@ module_param(unload_when_empty, int, 0);
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
+module_param_array(kipmid_max_busy_us, int, &num_max_busy_us, 0644);
+MODULE_PARM_DESC(kipmid_max_busy_us,
+		 "Max time (in microseconds) for kipmid to busy-wait for"
+		 " IPMI data before sleeping. 0 (default) means to wait"
+		 " forever. Set to a positive value, generally in the 100"
+		 " to 500 range, if kipmid is using up a lot of CPU time."
+		 " This will reduce performace, so balance is required.");
 
 
 static void std_irq_cleanup(struct smi_info *info)
_

Patches currently in -mm which might be from martin.wilck@ts.fujitsu.com are

ipmi-add-parameter-to-limit-cpu-usage-in-kipmid.patch

