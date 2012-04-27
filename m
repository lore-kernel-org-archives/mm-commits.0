From: akpm@linux-foundation.org
Subject: + nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch added to -mm tree
Date: Fri, 27 Apr 2012 14:13:19 -0700
Message-ID: <20120427211320.19ABEA042D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:57407 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2D0VNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 17:13:22 -0400
Received: by wibhj13 with SMTP id hj13so60386wib.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 14:13:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snanda@chromium.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl


The patch titled
     Subject: NMI watchdog: fix for lockup detector breakage on resume
has been added to the -mm tree.  Its filename is
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sameer Nanda <snanda@chromium.org>
Subject: NMI watchdog: fix for lockup detector breakage on resume

On the suspend/resume path the boot CPU does not go though an
offline->online transition.  This breaks the NMI detector post-resume
since it depends on PMU state that is lost when the system gets suspended.

Fix this by forcing a CPU offline->online transition for the lockup
detector on the boot CPU during resume.

To provide more context, we enable NMI watchdog on Chrome OS.  We have
seen several reports of systems freezing up completely which indicated
that the NMI watchdog was not firing for some reason.

Debugging further, we found a simple way of repro'ing system freezes --
issuing the command 'tasket 1 sh -c "echo nmilockup > /proc/breakme"'
after the system has been suspended/resumed one or more times.

With this patch in place, the system freeze result in panics, as expected.
 These panics provide a nice stack trace for us to debug the actual issue
causing the freeze.

Signed-off-by: Sameer Nanda <snanda@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h  |    4 ++++
 kernel/power/suspend.c |    3 +++
 kernel/watchdog.c      |   16 ++++++++++++++++
 3 files changed, 23 insertions(+)

diff -puN include/linux/sched.h~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume include/linux/sched.h
--- a/include/linux/sched.h~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume
+++ a/include/linux/sched.h
@@ -317,6 +317,7 @@ extern int proc_dowatchdog_thresh(struct
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 void lockup_detector_init(void);
+void lockup_detector_bootcpu_resume(void);
 #else
 static inline void touch_softlockup_watchdog(void)
 {
@@ -330,6 +331,9 @@ static inline void touch_all_softlockup_
 static inline void lockup_detector_init(void)
 {
 }
+static inline void lockup_detector_bootcpu_resume(void)
+{
+}
 #endif
 
 #ifdef CONFIG_DETECT_HUNG_TASK
diff -puN kernel/power/suspend.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume kernel/power/suspend.c
--- a/kernel/power/suspend.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume
+++ a/kernel/power/suspend.c
@@ -177,6 +177,9 @@ static int suspend_enter(suspend_state_t
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
 
+	/* Kick the lockup detector */
+	lockup_detector_bootcpu_resume();
+
  Enable_cpus:
 	enable_nonboot_cpus();
 
diff -puN kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume
+++ a/kernel/watchdog.c
@@ -597,6 +597,22 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
+void lockup_detector_bootcpu_resume(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+
+	/*
+	 * On the suspend/resume path the boot CPU does not go though the
+	 * offline->online transition. This breaks the NMI detector post
+	 * resume. Force an offline->online transition for the boot CPU on
+	 * resume.
+	 */
+	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
+	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
+
+	return;
+}
+
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
_
Subject: Subject: NMI watchdog: fix for lockup detector breakage on resume

Patches currently in -mm which might be from snanda@chromium.org are

nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch

