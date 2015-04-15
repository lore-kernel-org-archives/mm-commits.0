From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:46 -0700
Message-ID: <552eb73e.8T76jUCEI5+4R2Lg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbbDOTIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: introduce separate handlers for parameters in /proc/sys/kernel
has been removed from the -mm tree.  Its filename was
     watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: introduce separate handlers for parameters in /proc/sys/kernel

Separate handlers for each watchdog parameter in /proc/sys/kernel replace
the proc_dowatchdog() function.  Three of those handlers merely call
proc_watchdog_common() with one different argument.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    8 +++++
 kernel/watchdog.c   |   59 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff -puN include/linux/nmi.h~watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel
+++ a/include/linux/nmi.h
@@ -74,6 +74,14 @@ extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern int sysctl_softlockup_all_cpu_backtrace;
 struct ctl_table;
+extern int proc_watchdog(struct ctl_table *, int ,
+			 void __user *, size_t *, loff_t *);
+extern int proc_nmi_watchdog(struct ctl_table *, int ,
+			     void __user *, size_t *, loff_t *);
+extern int proc_soft_watchdog(struct ctl_table *, int ,
+			      void __user *, size_t *, loff_t *);
+extern int proc_watchdog_thresh(struct ctl_table *, int ,
+				void __user *, size_t *, loff_t *);
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
 #endif
diff -puN kernel/watchdog.c~watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-introduce-separate-handlers-for-parameters-in-proc-sys-kernel
+++ a/kernel/watchdog.c
@@ -769,6 +769,65 @@ out:
 }
 
 /*
+ * /proc/sys/kernel/watchdog
+ */
+int proc_watchdog(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(NMI_WATCHDOG_ENABLED|SOFT_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
+
+/*
+ * /proc/sys/kernel/nmi_watchdog
+ */
+int proc_nmi_watchdog(struct ctl_table *table, int write,
+		      void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(NMI_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
+
+/*
+ * /proc/sys/kernel/soft_watchdog
+ */
+int proc_soft_watchdog(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_watchdog_common(SOFT_WATCHDOG_ENABLED,
+				    table, write, buffer, lenp, ppos);
+}
+
+/*
+ * /proc/sys/kernel/watchdog_thresh
+ */
+int proc_watchdog_thresh(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err, old;
+
+	mutex_lock(&watchdog_proc_mutex);
+
+	old = ACCESS_ONCE(watchdog_thresh);
+	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (err || !write)
+		goto out;
+
+	/*
+	 * Update the sample period.
+	 * Restore 'watchdog_thresh' on failure.
+	 */
+	set_sample_period();
+	err = proc_watchdog_update();
+	if (err)
+		watchdog_thresh = old;
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

origin.patch
linux-next.patch

