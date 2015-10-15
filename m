From: akpm@linux-foundation.org
Subject: + watchdog-add-sysctl-knob-hardlockup_panic.patch added to -mm
 tree
Date: Thu, 15 Oct 2015 14:02:56 -0700
Message-ID: <56201480.F2P67dJSDPi8nYHr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbbJOVC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 17:02:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, atomlin@redhat.com, jkosina@suse.cz, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: add sysctl knob hardlockup_panic
has been added to the -mm tree.  Its filename is
     watchdog-add-sysctl-knob-hardlockup_panic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-add-sysctl-knob-hardlockup_panic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-add-sysctl-knob-hardlockup_panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: watchdog: add sysctl knob hardlockup_panic

The only way to enable a hardlockup to panic the machine is to set
'nmi_watchdog=panic' on the kernel command line.

This makes it awkward for end users and folks who want to run automate
tests (like myself).

Mimic the softlockup_panic knob and create a /proc/sys/kernel/hardlockup_panic
knob.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lockup-watchdogs.txt |    5 +++--
 include/linux/sched.h              |    1 +
 kernel/sysctl.c                    |   11 +++++++++++
 kernel/watchdog.c                  |    2 +-
 4 files changed, 16 insertions(+), 3 deletions(-)

diff -puN Documentation/lockup-watchdogs.txt~watchdog-add-sysctl-knob-hardlockup_panic Documentation/lockup-watchdogs.txt
--- a/Documentation/lockup-watchdogs.txt~watchdog-add-sysctl-knob-hardlockup_panic
+++ a/Documentation/lockup-watchdogs.txt
@@ -20,8 +20,9 @@ kernel mode for more than 10 seconds (se
 details), without letting other interrupts have a chance to run.
 Similarly to the softlockup case, the current stack trace is displayed
 upon detection and the system will stay locked up unless the default
-behavior is changed, which can be done through a compile time knob,
-"BOOTPARAM_HARDLOCKUP_PANIC", and a kernel parameter, "nmi_watchdog"
+behavior is changed, which can be done through a sysctl,
+'hardlockup_panic', a compile time knob, "BOOTPARAM_HARDLOCKUP_PANIC",
+and a kernel parameter, "nmi_watchdog"
 (see "Documentation/kernel-parameters.txt" for details).
 
 The panic option can be used in combination with panic_timeout (this
diff -puN include/linux/sched.h~watchdog-add-sysctl-knob-hardlockup_panic include/linux/sched.h
--- a/include/linux/sched.h~watchdog-add-sysctl-knob-hardlockup_panic
+++ a/include/linux/sched.h
@@ -384,6 +384,7 @@ extern int proc_dowatchdog_thresh(struct
 				  void __user *buffer,
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
+extern unsigned int  hardlockup_panic;
 void lockup_detector_init(void);
 #else
 static inline void touch_softlockup_watchdog(void)
diff -puN kernel/sysctl.c~watchdog-add-sysctl-knob-hardlockup_panic kernel/sysctl.c
--- a/kernel/sysctl.c~watchdog-add-sysctl-knob-hardlockup_panic
+++ a/kernel/sysctl.c
@@ -887,6 +887,17 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#ifdef CONFIG_HARDLOCKUP_DETECTOR
+	{
+		.procname	= "hardlockup_panic",
+		.data		= &hardlockup_panic,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_SMP
 	{
 		.procname	= "softlockup_all_cpu_backtrace",
diff -puN kernel/watchdog.c~watchdog-add-sysctl-knob-hardlockup_panic kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-add-sysctl-knob-hardlockup_panic
+++ a/kernel/watchdog.c
@@ -112,7 +112,7 @@ static unsigned long soft_lockup_nmi_war
  * Should we panic when a soft-lockup or hard-lockup occurs:
  */
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
-static int hardlockup_panic =
+unsigned int __read_mostly hardlockup_panic =
 			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
 static unsigned long hardlockup_allcpu_dumped;
 /*
_

Patches currently in -mm which might be from dzickus@redhat.com are

watchdog-add-sysctl-knob-hardlockup_panic.patch

