From: akpm@linux-foundation.org
Subject: +
 ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch added to -mm tree
Date: Tue, 29 Jul 2014 15:03:22 -0700
Message-ID: <53d81a2a.IN6nxyiEi228nqIY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:48984 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbaG2WDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jul 2014 18:03:24 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so50928qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2014 15:03:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cpandya@codeaurora.org, hughd@google.com, john.stultz@linaro.org, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: provide support to use deferrable timers for scanner thread
has been added to the -mm tree.  Its filename is
     ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chintan Pandya <cpandya@codeaurora.org>
Subject: ksm: provide support to use deferrable timers for scanner thread

KSM thread to scan pages is scheduled on definite timeout.  That wakes up
CPU from idle state and hence may affect the power consumption.  Provide
an optional support to use deferrable timer which suites low-power
use-cases.

Typically, on our setup we observed, 10% less power consumption with some
use-cases in which CPU goes to power collapse frequently.  For example,
playing audio while typically CPU remains idle.

To enable deferrable timers,
$ echo 1 > /sys/kernel/mm/ksm/deferrable_timer

Signed-off-by: Chintan Pandya <cpandya@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/ksm.txt |    7 ++++++
 mm/ksm.c                 |   40 +++++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/ksm.txt~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread
+++ a/Documentation/vm/ksm.txt
@@ -87,6 +87,13 @@ pages_sharing    - how many more sites a
 pages_unshared   - how many pages unique but repeatedly checked for merging
 pages_volatile   - how many pages changing too fast to be placed in a tree
 full_scans       - how many times all mergeable areas have been scanned
+deferrable_timer - whether to use deferrable timers or not
+                 e.g. "echo 1 > /sys/kernel/mm/ksm/deferrable_timer"
+                 Default: 0 (means, we are not using deferrable timers. Users
+		 might want to set deferrable_timer option if they donot want
+		 ksm thread to wakeup CPU to carryout ksm activities thus
+		 gaining on battery while compromising slightly on memory
+		 that could have been saved.)
 
 A high ratio of pages_sharing to pages_shared indicates good sharing, but
 a high ratio of pages_unshared to pages_sharing indicates wasted effort.
diff -puN mm/ksm.c~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread mm/ksm.c
--- a/mm/ksm.c~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread
+++ a/mm/ksm.c
@@ -223,6 +223,9 @@ static unsigned int ksm_thread_pages_to_
 /* Milliseconds ksmd should sleep between batches */
 static unsigned int ksm_thread_sleep_millisecs = 20;
 
+/* Boolean to indicate whether to use deferrable timer or not */
+static bool use_deferrable_timer;
+
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
@@ -1705,6 +1708,11 @@ static void ksm_do_scan(unsigned int sca
 	}
 }
 
+static void process_timeout(unsigned long __data)
+{
+	wake_up_process((struct task_struct *)__data);
+}
+
 static int ksmd_should_run(void)
 {
 	return (ksm_run & KSM_RUN_MERGE) && !list_empty(&ksm_mm_head.mm_list);
@@ -1712,6 +1720,8 @@ static int ksmd_should_run(void)
 
 static int ksm_scan_thread(void *nothing)
 {
+	signed long to;
+
 	set_freezable();
 	set_user_nice(current, 5);
 
@@ -1725,8 +1735,11 @@ static int ksm_scan_thread(void *nothing
 		try_to_freeze();
 
 		if (ksmd_should_run()) {
-			schedule_timeout_interruptible(
-				msecs_to_jiffies(ksm_thread_sleep_millisecs));
+			timeout = msecs_to_jiffies(ksm_thread_sleep_millisecs);
+			if (use_deferrable_timer)
+				schedule_timeout_deferrable_interruptible(to);
+			else
+				schedule_timeout_interruptible(to);
 		} else {
 			wait_event_freezable(ksm_thread_wait,
 				ksmd_should_run() || kthread_should_stop());
@@ -2175,6 +2188,28 @@ static ssize_t run_store(struct kobject
 }
 KSM_ATTR(run);
 
+static ssize_t deferrable_timer_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	return snprintf(buf, 8, "%d\n", use_deferrable_timer);
+}
+
+static ssize_t deferrable_timer_store(struct kobject *kobj,
+				     struct kobj_attribute *attr,
+				     const char *buf, size_t count)
+{
+	unsigned long enable;
+	int err;
+
+	err = kstrtoul(buf, 10, &enable);
+
+	if (enable == 0 || enable == 1)
+		use_deferrable_timer = enable;
+
+	return count;
+}
+KSM_ATTR(deferrable_timer);
+
 #ifdef CONFIG_NUMA
 static ssize_t merge_across_nodes_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
@@ -2287,6 +2322,7 @@ static struct attribute *ksm_attrs[] = {
 	&pages_unshared_attr.attr,
 	&pages_volatile_attr.attr,
 	&full_scans_attr.attr,
+	&deferrable_timer_attr.attr,
 #ifdef CONFIG_NUMA
 	&merge_across_nodes_attr.attr,
 #endif
_

Patches currently in -mm which might be from cpandya@codeaurora.org are

timer-provide-an-api-for-deferrable-timeout.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch

