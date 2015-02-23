From: akpm@linux-foundation.org
Subject: + watchdog-new-definitions-and-variables-initialization.patch
 added to -mm tree
Date: Mon, 23 Feb 2015 13:20:39 -0800
Message-ID: <54eb99a7.RcGZOWp4QByZ9PdN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbbBWVUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 16:20:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: new definitions and variables, initialization
has been added to the -mm tree.  Its filename is
     watchdog-new-definitions-and-variables-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-new-definitions-and-variables-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-new-definitions-and-variables-initialization.patch

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
Subject: watchdog: new definitions and variables, initialization

The hardlockup and softockup had always been tied together.  Due to the
request of KVM folks, they had a need to have one enabled but not the
other.  Internally rework the code to split things apart more cleanly.

There is a bunch of churn here, but the end result should be code that
should be easier to maintain and fix without knowing the internals of what
is going on.



This patch (of 9):

Introduce new definitions and variables to separate the user interface in
/proc/sys/kernel from the internal run state of the lockup detectors.  The
internal run state is represented by two bits in a new variable that is
named 'watchdog_enabled'.  This helps simplify the code, for example:

- In order to check if any of the two lockup detectors is enabled,
  it is sufficient to check if 'watchdog_enabled' is not zero.

- In order to enable/disable one or both lockup detectors,
  it is sufficient to set/clear one or both bits in 'watchdog_enabled'.

- Concurrent updates of 'watchdog_enabled' need not be synchronized via
  a spinlock or a mutex. Updates can either be atomic or concurrency can
  be detected by using 'cmpxchg'.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    2 ++
 kernel/watchdog.c   |   27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff -puN include/linux/nmi.h~watchdog-new-definitions-and-variables-initialization include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-new-definitions-and-variables-initialization
+++ a/include/linux/nmi.h
@@ -68,6 +68,8 @@ static inline bool trigger_allbutself_cp
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
+extern int nmi_watchdog_enabled;
+extern int soft_watchdog_enabled;
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern int sysctl_softlockup_all_cpu_backtrace;
diff -puN kernel/watchdog.c~watchdog-new-definitions-and-variables-initialization kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-new-definitions-and-variables-initialization
+++ a/kernel/watchdog.c
@@ -24,8 +24,33 @@
 #include <linux/kvm_para.h>
 #include <linux/perf_event.h>
 
-int watchdog_user_enabled = 1;
+/*
+ * The run state of the lockup detectors is controlled by the content of the
+ * 'watchdog_enabled' variable. Each lockup detector has its dedicated bit -
+ * bit 0 for the hard lockup detector and bit 1 for the soft lockup detector.
+ *
+ * 'watchdog_user_enabled', 'nmi_watchdog_enabled' and 'soft_watchdog_enabled'
+ * are variables that are only used as an 'interface' between the parameters
+ * in /proc/sys/kernel and the internal state bits in 'watchdog_enabled'. The
+ * 'watchdog_thresh' variable is handled differently because its value is not
+ * boolean, and the lockup detectors are 'suspended' while 'watchdog_thresh'
+ * is equal zero.
+ */
+#define NMI_WATCHDOG_ENABLED_BIT   0
+#define SOFT_WATCHDOG_ENABLED_BIT  1
+#define NMI_WATCHDOG_ENABLED      (1 << NMI_WATCHDOG_ENABLED_BIT)
+#define SOFT_WATCHDOG_ENABLED     (1 << SOFT_WATCHDOG_ENABLED_BIT)
+
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+static unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED|NMI_WATCHDOG_ENABLED;
+#else
+static unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED;
+#endif
+int __read_mostly nmi_watchdog_enabled;
+int __read_mostly soft_watchdog_enabled;
+int __read_mostly watchdog_user_enabled;
 int __read_mostly watchdog_thresh = 10;
+
 #ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
 #else
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

