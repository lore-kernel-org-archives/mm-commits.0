From: akpm@linux-foundation.org
Subject: + watchdog-introduce-the-proc_watchdog_common-function.patch
 added to -mm tree
Date: Mon, 23 Feb 2015 13:20:45 -0800
Message-ID: <54eb99ad.JOvITAK4c8pWdtMI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbbBWVUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: introduce proc_watchdog_common()
has been added to the -mm tree.  Its filename is
     watchdog-introduce-the-proc_watchdog_common-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-introduce-the-proc_watchdog_common-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-introduce-the-proc_watchdog_common-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: introduce proc_watchdog_common()

Three of four handlers for the watchdog parameters in /proc/sys/kernel
essentially have to do the same thing.

  if the parameter is being read {
    return the state of the corresponding bit(s) in 'watchdog_enabled'
  } else {
    set/clear the state of the corresponding bit(s) in 'watchdog_enabled'
    update the run state of the lockup detector(s)
  }

Hence, introduce a common function that can be called by those handlers. 
The callers pass a 'bit mask' to this function to indicate which bit(s)
should be set/cleared in 'watchdog_enabled'.

This function handles an uncommon race with watchdog_nmi_enable() where a
concurrent update of 'watchdog_enabled' is possible.  We use 'cmpxchg' to
detect the concurrency.  [This avoids introducing a new spinlock or a
mutex to synchronize updates of 'watchdog_enabled'.  Using the same lock
or mutex in watchdog thread context and in system call context needs to be
considered carefully because it can make the code prone to deadlock
situations in connection with parking/unparking the watchdog threads.]

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   65 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff -puN kernel/watchdog.c~watchdog-introduce-the-proc_watchdog_common-function kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-introduce-the-proc_watchdog_common-function
+++ a/kernel/watchdog.c
@@ -704,6 +704,71 @@ static int proc_watchdog_update(void)
 static DEFINE_MUTEX(watchdog_proc_mutex);
 
 /*
+ * common function for watchdog, nmi_watchdog and soft_watchdog parameter
+ *
+ * caller             | table->data points to | 'which' contains the flag(s)
+ * -------------------|-----------------------|-----------------------------
+ * proc_watchdog      | watchdog_user_enabled | NMI_WATCHDOG_ENABLED or'ed
+ *                    |                       | with SOFT_WATCHDOG_ENABLED
+ * -------------------|-----------------------|-----------------------------
+ * proc_nmi_watchdog  | nmi_watchdog_enabled  | NMI_WATCHDOG_ENABLED
+ * -------------------|-----------------------|-----------------------------
+ * proc_soft_watchdog | soft_watchdog_enabled | SOFT_WATCHDOG_ENABLED
+ */
+static int proc_watchdog_common(int which, struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err, old, new;
+	int *watchdog_param = (int *)table->data;
+
+	mutex_lock(&watchdog_proc_mutex);
+
+	/*
+	 * If the parameter is being read return the state of the corresponding
+	 * bit(s) in 'watchdog_enabled', else update 'watchdog_enabled' and the
+	 * run state of the lockup detectors.
+	 */
+	if (!write) {
+		*watchdog_param = (watchdog_enabled & which) != 0;
+		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	} else {
+		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+		if (err)
+			goto out;
+
+		/*
+		 * There is a race window between fetching the current value
+		 * from 'watchdog_enabled' and storing the new value. During
+		 * this race window, watchdog_nmi_enable() can sneak in and
+		 * clear the NMI_WATCHDOG_ENABLED bit in 'watchdog_enabled'.
+		 * The 'cmpxchg' detects this race and the loop retries.
+		 */
+		do {
+			old = watchdog_enabled;
+			/*
+			 * If the parameter value is not zero set the
+			 * corresponding bit(s), else clear it(them).
+			 */
+			if (*watchdog_param)
+				new = old | which;
+			else
+				new = old & ~which;
+		} while (cmpxchg(&watchdog_enabled, old, new) != old);
+
+		/*
+		 * Update the run state of the lockup detectors.
+		 * Restore 'watchdog_enabled' on failure.
+		 */
+		err = proc_watchdog_update();
+		if (err)
+			watchdog_enabled = old;
+	}
+out:
+	mutex_unlock(&watchdog_proc_mutex);
+	return err;
+}
+
+/*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
 
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-new-definitions-and-variables-initialization.patch
watchdog-introduce-the-proc_watchdog_update-function.patch
watchdog-move-definition-of-watchdog_proc_mutex-outside-of-proc_dowatchdog.patch
watchdog-introduce-the-proc_watchdog_common-function.patch
watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch
watchdog-implement-error-handling-for-failure-to-set-up-hardware-perf-events.patch
watchdog-enable-the-new-user-interface-of-the-watchdog-mechanism.patch
watchdog-clean-up-some-function-names-and-arguments.patch
watchdog-introduce-the-hardlockup_detector_disable-function.patch

