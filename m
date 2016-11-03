From: akpm@linux-foundation.org
Subject: + watchdog-move-shared-definitions-to-nmih.patch added to -mm
 tree
Date: Thu, 03 Nov 2016 16:46:37 -0700
Message-ID: <581bcc5d.AsjBGVJXLlM2xWBa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933240AbcKCXqj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2016 19:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: babu.moger@oracle.com, andi@firstfloor.org, atomlin@redhat.com, baiyaowei@cmss.chinamobile.com, davem@davemloft.net, dzickus@redhat.com, hidehiro.kawai.ez@hitachi.com, jkosina@suse.cz, johunt@akamai.com, mingo@kernel.org, tj@kernel.org, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: move shared definitions to nmi.h
has been added to the -mm tree.  Its filename is
     watchdog-move-shared-definitions-to-nmih.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-move-shared-definitions-to-nmih.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-move-shared-definitions-to-nmih.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Babu Moger <babu.moger@oracle.com>
Subject: kernel/watchdog.c: move shared definitions to nmi.h

Patch series "Clean up watchdog handlers", v2.

This is an attempt to cleanup watchdog handlers.  Right now,
kernel/watchdog.c implements both softlockup and hardlockup detectors. 
Softlockup code is generic.  Hardlockup code is arch specific.  Some
architectures don't use hardlockup detectors.  They use their own watchdog
detectors.  To make both these combination work, we have numerous #ifdefs
in kernel/watchdog.c.

We are trying here to make these handlers independent of each other.  Also
provide an interface for architectures to implement their own handlers. 
watchdog_nmi_enable and watchdog_nmi_disable will be defined as weak such
that architectures can override its definitions.

Thanks to Don Zickus for his suggestions.
Here are our previous discussions
http://www.spinics.net/lists/sparclinux/msg16543.html
http://www.spinics.net/lists/sparclinux/msg16441.html


This patch (of 3):

Move shared macros and definitions to nmi.h so that watchdog.c, new file
watchdog_hld.c or any other architecture specific handler can use those
definitions.

Link: http://lkml.kernel.org/r/1478034826-43888-2-git-send-email-babu.moger@oracle.com
Signed-off-by: Babu Moger <babu.moger@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Josh Hunt <johunt@akamai.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |   24 ++++++++++++++++++++++++
 kernel/watchdog.c   |   28 ++++------------------------
 2 files changed, 28 insertions(+), 24 deletions(-)

diff -puN include/linux/nmi.h~watchdog-move-shared-definitions-to-nmih include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-move-shared-definitions-to-nmih
+++ a/include/linux/nmi.h
@@ -7,6 +7,23 @@
 #include <linux/sched.h>
 #include <asm/irq.h>
 
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
 /**
  * touch_nmi_watchdog - restart NMI watchdog timeout.
  * 
@@ -91,9 +108,16 @@ extern int nmi_watchdog_enabled;
 extern int soft_watchdog_enabled;
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
+extern unsigned long watchdog_enabled;
 extern unsigned long *watchdog_cpumask_bits;
+#ifdef CONFIG_SMP
 extern int sysctl_softlockup_all_cpu_backtrace;
 extern int sysctl_hardlockup_all_cpu_backtrace;
+#else
+#define sysctl_softlockup_all_cpu_backtrace 0
+#define sysctl_hardlockup_all_cpu_backtrace 0
+#endif
+extern bool is_hardlockup(void);
 struct ctl_table;
 extern int proc_watchdog(struct ctl_table *, int ,
 			 void __user *, size_t *, loff_t *);
diff -puN kernel/watchdog.c~watchdog-move-shared-definitions-to-nmih kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-move-shared-definitions-to-nmih
+++ a/kernel/watchdog.c
@@ -27,29 +27,12 @@
 #include <linux/perf_event.h>
 #include <linux/kthread.h>
 
-/*
- * The run state of the lockup detectors is controlled by the content of the
- * 'watchdog_enabled' variable. Each lockup detector has its dedicated bit -
- * bit 0 for the hard lockup detector and bit 1 for the soft lockup detector.
- *
- * 'watchdog_user_enabled', 'nmi_watchdog_enabled' and 'soft_watchdog_enabled'
- * are variables that are only used as an 'interface' between the parameters
- * in /proc/sys/kernel and the internal state bits in 'watchdog_enabled'. The
- * 'watchdog_thresh' variable is handled differently because its value is not
- * boolean, and the lockup detectors are 'suspended' while 'watchdog_thresh'
- * is equal zero.
- */
-#define NMI_WATCHDOG_ENABLED_BIT   0
-#define SOFT_WATCHDOG_ENABLED_BIT  1
-#define NMI_WATCHDOG_ENABLED      (1 << NMI_WATCHDOG_ENABLED_BIT)
-#define SOFT_WATCHDOG_ENABLED     (1 << SOFT_WATCHDOG_ENABLED_BIT)
-
 static DEFINE_MUTEX(watchdog_proc_mutex);
 
-#ifdef CONFIG_HARDLOCKUP_DETECTOR
-static unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED|NMI_WATCHDOG_ENABLED;
+#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
+unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED|NMI_WATCHDOG_ENABLED;
 #else
-static unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED;
+unsigned long __read_mostly watchdog_enabled = SOFT_WATCHDOG_ENABLED;
 #endif
 int __read_mostly nmi_watchdog_enabled;
 int __read_mostly soft_watchdog_enabled;
@@ -59,9 +42,6 @@ int __read_mostly watchdog_thresh = 10;
 #ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
 int __read_mostly sysctl_hardlockup_all_cpu_backtrace;
-#else
-#define sysctl_softlockup_all_cpu_backtrace 0
-#define sysctl_hardlockup_all_cpu_backtrace 0
 #endif
 static struct cpumask watchdog_cpumask __read_mostly;
 unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
@@ -289,7 +269,7 @@ void touch_softlockup_watchdog_sync(void
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 /* watchdog detector functions */
-static bool is_hardlockup(void)
+bool is_hardlockup(void)
 {
 	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
 
_

Patches currently in -mm which might be from babu.moger@oracle.com are

watchdog-move-shared-definitions-to-nmih.patch
watchdog-move-hardlockup-detector-to-separate-file.patch
sparc-implement-watchdog_nmi_enable-and-watchdog_nmi_disable.patch

