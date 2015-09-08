From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-introduce-watchdog_suspend-and-watchdog_resume.patch removed from
 -mm tree
Date: Tue, 08 Sep 2015 11:03:13 -0700
Message-ID: <55ef22e1.SFKZAAb3Md4S6V5z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, a.p.zijlstra@chello.nl, atomlin@redhat.com, cmetcalf@ezchip.com, dzickus@redhat.com, eranian@google.com, fweisbec@gmail.com, jolsa@kernel.org, linux@roeck-us.net, mhocko@suse.cz, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: introduce watchdog_suspend() and watchdog_resume()
has been removed from the -mm tree.  Its filename was
     watchdog-introduce-watchdog_suspend-and-watchdog_resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: introduce watchdog_suspend() and watchdog_resume()

This interface can be utilized to deactivate the hard and soft lockup
detector temporarily.  Callers are expected to minimize the duration of
deactivation.  Multiple deactivations are allowed to occur in parallel but
should be rare in practice.

[akpm@linux-foundation.org: remove unneeded static initialization]
Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Stephane Eranian <eranian@google.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 +
 kernel/watchdog.c   |   65 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff -puN include/linux/nmi.h~watchdog-introduce-watchdog_suspend-and-watchdog_resume include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-introduce-watchdog_suspend-and-watchdog_resume
+++ a/include/linux/nmi.h
@@ -82,6 +82,8 @@ extern int proc_watchdog_thresh(struct c
 				void __user *, size_t *, loff_t *);
 extern int proc_watchdog_cpumask(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
+extern int watchdog_suspend(void);
+extern void watchdog_resume(void);
 #endif
 
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
diff -puN kernel/watchdog.c~watchdog-introduce-watchdog_suspend-and-watchdog_resume kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-introduce-watchdog_suspend-and-watchdog_resume
+++ a/kernel/watchdog.c
@@ -67,6 +67,7 @@ unsigned long *watchdog_cpumask_bits = c
 #define for_each_watchdog_cpu(cpu) \
 	for_each_cpu_and((cpu), cpu_online_mask, &watchdog_cpumask)
 
+static int __read_mostly watchdog_suspended;
 static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
@@ -700,6 +701,50 @@ static void watchdog_unpark_threads(void
 	put_online_cpus();
 }
 
+/*
+ * Suspend the hard and soft lockup detector by parking the watchdog threads.
+ */
+int watchdog_suspend(void)
+{
+	int ret = 0;
+
+	mutex_lock(&watchdog_proc_mutex);
+	/*
+	 * Multiple suspend requests can be active in parallel (counted by
+	 * the 'watchdog_suspended' variable). If the watchdog threads are
+	 * running, the first caller takes care that they will be parked.
+	 * The state of 'watchdog_running' cannot change while a suspend
+	 * request is active (see related changes in 'proc' handlers).
+	 */
+	if (watchdog_running && !watchdog_suspended)
+		ret = watchdog_park_threads();
+
+	if (ret == 0)
+		watchdog_suspended++;
+
+	mutex_unlock(&watchdog_proc_mutex);
+
+	return ret;
+}
+
+/*
+ * Resume the hard and soft lockup detector by unparking the watchdog threads.
+ */
+void watchdog_resume(void)
+{
+	mutex_lock(&watchdog_proc_mutex);
+
+	watchdog_suspended--;
+	/*
+	 * The watchdog threads are unparked if they were previously running
+	 * and if there is no more active suspend request.
+	 */
+	if (watchdog_running && !watchdog_suspended)
+		watchdog_unpark_threads();
+
+	mutex_unlock(&watchdog_proc_mutex);
+}
+
 static void restart_watchdog_hrtimer(void *info)
 {
 	struct hrtimer *hrtimer = raw_cpu_ptr(&watchdog_hrtimer);
@@ -818,6 +863,12 @@ static int proc_watchdog_common(int whic
 
 	mutex_lock(&watchdog_proc_mutex);
 
+	if (watchdog_suspended) {
+		/* no parameter changes allowed while watchdog is suspended */
+		err = -EAGAIN;
+		goto out;
+	}
+
 	/*
 	 * If the parameter is being read return the state of the corresponding
 	 * bit(s) in 'watchdog_enabled', else update 'watchdog_enabled' and the
@@ -903,6 +954,12 @@ int proc_watchdog_thresh(struct ctl_tabl
 
 	mutex_lock(&watchdog_proc_mutex);
 
+	if (watchdog_suspended) {
+		/* no parameter changes allowed while watchdog is suspended */
+		err = -EAGAIN;
+		goto out;
+	}
+
 	old = ACCESS_ONCE(watchdog_thresh);
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
@@ -934,6 +991,13 @@ int proc_watchdog_cpumask(struct ctl_tab
 	int err;
 
 	mutex_lock(&watchdog_proc_mutex);
+
+	if (watchdog_suspended) {
+		/* no parameter changes allowed while watchdog is suspended */
+		err = -EAGAIN;
+		goto out;
+	}
+
 	err = proc_do_large_bitmap(table, write, buffer, lenp, ppos);
 	if (!err && write) {
 		/* Remove impossible cpus to keep sysctl output cleaner. */
@@ -951,6 +1015,7 @@ int proc_watchdog_cpumask(struct ctl_tab
 				pr_err("cpumask update failed\n");
 		}
 	}
+out:
 	mutex_unlock(&watchdog_proc_mutex);
 	return err;
 }
_

Patches currently in -mm which might be from uobergfe@redhat.com are


