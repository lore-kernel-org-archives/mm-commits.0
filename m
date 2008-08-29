From: akpm@linux-foundation.org
Subject: + pm_qos_requirement-might-sleep.patch added to -mm tree
Date: Thu, 28 Aug 2008 17:33:03 -0700
Message-ID: <200808290033.m7T0X4w8022458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757226AbYH2AdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 20:33:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkacur@gmail.com, mgross@linux.intel.com, rostedt@goodmis.org


The patch titled
     pm_qos_requirement might sleep
has been added to the -mm tree.  Its filename is
     pm_qos_requirement-might-sleep.patch

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
Subject: pm_qos_requirement might sleep
From: John Kacur <jkacur@gmail.com>

Make PM_QOS and CPU_IDLE play nicer when run with the RT-Preempt kernel. 
CPU_IDLE polls the target_value's of some of the pm_qos parameters from
the idle loop causing sleeping locking warnings.  Changing the
target_value to an atomic avoids this issue.

Remove the spinlock in pm_qos_requirement by making target_value an atomic
type.

Signed-off-by: mark gross <mgross@linux.intel.com>
Signed-off-by: John Kacur <jkacur@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pm_qos_params.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff -puN kernel/pm_qos_params.c~pm_qos_requirement-might-sleep kernel/pm_qos_params.c
--- a/kernel/pm_qos_params.c~pm_qos_requirement-might-sleep
+++ a/kernel/pm_qos_params.c
@@ -43,7 +43,7 @@
 #include <linux/uaccess.h>
 
 /*
- * locking rule: all changes to target_value or requirements or notifiers lists
+ * locking rule: all changes to requirements or notifiers lists
  * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
  * held, taken with _irqsave.  One lock to rule them all
  */
@@ -66,7 +66,7 @@ struct pm_qos_object {
 	struct miscdevice pm_qos_power_miscdev;
 	char *name;
 	s32 default_value;
-	s32 target_value;
+	atomic_t target_value;
 	s32 (*comparitor)(s32, s32);
 };
 
@@ -77,7 +77,7 @@ static struct pm_qos_object cpu_dma_pm_q
 	.notifiers = &cpu_dma_lat_notifier,
 	.name = "cpu_dma_latency",
 	.default_value = 2000 * USEC_PER_SEC,
-	.target_value = 2000 * USEC_PER_SEC,
+	.target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
 	.comparitor = min_compare
 };
 
@@ -87,7 +87,7 @@ static struct pm_qos_object network_lat_
 	.notifiers = &network_lat_notifier,
 	.name = "network_latency",
 	.default_value = 2000 * USEC_PER_SEC,
-	.target_value = 2000 * USEC_PER_SEC,
+	.target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
 	.comparitor = min_compare
 };
 
@@ -99,7 +99,7 @@ static struct pm_qos_object network_thro
 	.notifiers = &network_throughput_notifier,
 	.name = "network_throughput",
 	.default_value = 0,
-	.target_value = 0,
+	.target_value = ATOMIC_INIT(0),
 	.comparitor = max_compare
 };
 
@@ -150,11 +150,11 @@ static void update_target(int target)
 		extreme_value = pm_qos_array[target]->comparitor(
 				extreme_value, node->value);
 	}
-	if (pm_qos_array[target]->target_value != extreme_value) {
+	if (atomic_read(&pm_qos_array[target]->target_value) != extreme_value) {
 		call_notifier = 1;
-		pm_qos_array[target]->target_value = extreme_value;
+		atomic_set(&pm_qos_array[target]->target_value, extreme_value);
 		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
-			pm_qos_array[target]->target_value);
+			atomic_read(&pm_qos_array[target]->target_value));
 	}
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
@@ -193,14 +193,7 @@ static int find_pm_qos_object_by_minor(i
  */
 int pm_qos_requirement(int pm_qos_class)
 {
-	int ret_val;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pm_qos_lock, flags);
-	ret_val = pm_qos_array[pm_qos_class]->target_value;
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
