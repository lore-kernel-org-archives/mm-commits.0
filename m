From: akpm@linux-foundation.org
Subject: [merged] ipmi-add-parameter-to-limit-cpu-usage-in-kipmid.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:34 -0400
Message-ID: <201003150702.o2F727Kt016838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935892Ab0COHCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martin.wilck@ts.fujitsu.com, cminyard@mvista.com, jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     ipmi: add parameter to limit CPU usage in kipmid
has been removed from the -mm tree.  Its filename was
     ipmi-add-parameter-to-limit-cpu-usage-in-kipmid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: add parameter to limit CPU usage in kipmid
From: Martin Wilck <martin.wilck@ts.fujitsu.com>

In some cases kipmid can use a lot of CPU.  This adds a way to tune the
CPU used by kipmid to help in those cases.  By setting kipmid_max_busy_us
to a value between 100 and 500, it is possible to bring down kipmid CPU
load to practically 0 without loosing too much ipmi throughput
performance.  Not setting the value, or setting the value to zero,
operation is unaffected.

Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/IPMI.txt           |   12 +++++
 drivers/char/ipmi/ipmi_si_intf.c |   66 ++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 2 deletions(-)

diff -puN Documentation/IPMI.txt~ipmi-add-parameter-to-limit-cpu-usage-in-kipmid Documentation/IPMI.txt
--- a/Documentation/IPMI.txt~ipmi-add-parameter-to-limit-cpu-usage-in-kipmid
+++ a/Documentation/IPMI.txt
@@ -365,6 +365,7 @@ You can change this at module load time 
        regshifts=<shift1>,<shift2>,...
        slave_addrs=<addr1>,<addr2>,...
        force_kipmid=<enable1>,<enable2>,...
+       kipmid_max_busy_us=<ustime1>,<ustime2>,...
        unload_when_empty=[0|1]
 
 Each of these except si_trydefaults is a list, the first item for the
@@ -433,6 +434,7 @@ kernel command line as:
        ipmi_si.regshifts=<shift1>,<shift2>,...
        ipmi_si.slave_addrs=<addr1>,<addr2>,...
        ipmi_si.force_kipmid=<enable1>,<enable2>,...
+       ipmi_si.kipmid_max_busy_us=<ustime1>,<ustime2>,...
 
 It works the same as the module parameters of the same names.
 
@@ -450,6 +452,16 @@ force this thread on or off.  If you for
 interrupts, the driver will run VERY slowly.  Don't blame me,
 these interfaces suck.
 
+Unfortunately, this thread can use a lot of CPU depending on the
+interface's performance.  This can waste a lot of CPU and cause
+various issues with detecting idle CPU and using extra power.  To
+avoid this, the kipmid_max_busy_us sets the maximum amount of time, in
+microseconds, that kipmid will spin before sleeping for a tick.  This
+value sets a balance between performance and CPU waste and needs to be
+tuned to your needs.  Maybe, someday, auto-tuning will be added, but
+that's not a simple thing and even the auto-tuning would need to be
+tuned to the user's desired performance.
+
 The driver supports a hot add and remove of interfaces.  This way,
 interfaces can be added or removed after the kernel is up and running.
 This is done using /sys/modules/ipmi_si/parameters/hotmod, which is a
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
@@ -925,23 +928,77 @@ static void set_run_to_completion(void *
 	}
 }
 
+/*
+ * Use -1 in the nsec value of the busy waiting timespec to tell that
+ * we are spinning in kipmid looking for something and not delaying
+ * between checks
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
+static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
+				 const struct smi_info *smi_info,
+				 struct timespec *busy_until)
+{
+	unsigned int max_busy_us = 0;
+
+	if (smi_info->intf_num < num_max_busy_us)
+		max_busy_us = kipmid_max_busy_us[smi_info->intf_num];
+	if (max_busy_us == 0 || smi_result != SI_SM_CALL_WITH_DELAY)
+		ipmi_si_set_not_busy(busy_until);
+	else if (!ipmi_si_is_busy(busy_until)) {
+		getnstimeofday(busy_until);
+		timespec_add_ns(busy_until, max_busy_us*NSEC_PER_USEC);
+	} else {
+		struct timespec now;
+		getnstimeofday(&now);
+		if (unlikely(timespec_compare(&now, busy_until) > 0)) {
+			ipmi_si_set_not_busy(busy_until);
+			return 0;
+		}
+	}
+	return 1;
+}
+
+
+/*
+ * A busy-waiting loop for speeding up IPMI operation.
+ *
+ * Lousy hardware makes this hard.  This is only enabled for systems
+ * that are not BT and do not have interrupts.  It starts spinning
+ * when an operation is complete or until max_busy tells it to stop
+ * (if that is enabled).  See the paragraph on kimid_max_busy_us in
+ * Documentation/IPMI.txt for details.
+ */
 static int ipmi_thread(void *data)
 {
 	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
+	struct timespec busy_until;
 
+	ipmi_si_set_not_busy(&busy_until);
 	set_user_nice(current, 19);
 	while (!kthread_should_stop()) {
+		int busy_wait;
+
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
 		smi_result = smi_event_handler(smi_info, 0);
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
+		busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
+						  &busy_until);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY)
+		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
 			schedule();
 		else
-			schedule_timeout_interruptible(1);
+			schedule_timeout_interruptible(0);
 	}
 	return 0;
 }
@@ -1212,6 +1269,11 @@ module_param(unload_when_empty, int, 0);
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
+module_param_array(kipmid_max_busy_us, uint, &num_max_busy_us, 0644);
+MODULE_PARM_DESC(kipmid_max_busy_us,
+		 "Max time (in microseconds) to busy-wait for IPMI data before"
+		 " sleeping. 0 (default) means to wait forever. Set to 100-500"
+		 " if kipmid is using up a lot of CPU time.");
 
 
 static void std_irq_cleanup(struct smi_info *info)
_

Patches currently in -mm which might be from martin.wilck@ts.fujitsu.com are

origin.patch

