From: akpm@linux-foundation.org
Subject: + posix-cpu-timers-cleanup-rlimits-usage.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:08:16 -0800
Message-ID: <201002012008.o11K8Gcs009449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060Ab0BAUJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:09:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, johnstul@us.ibm.com, mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de


The patch titled
     posix-cpu-timers: cleanup rlimits usage
has been added to the -mm tree.  Its filename is
     posix-cpu-timers-cleanup-rlimits-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-cpu-timers: cleanup rlimits usage
From: Jiri Slaby <jslaby@suse.cz>

Fetch rlimit (both hard and soft) values only once and work on them.  It
removes many accesses through sig structure and makes the code cleaner.

Mostly a preparation for writable resource limits support.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix-cpu-timers-cleanup-rlimits-usage kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-cpu-timers-cleanup-rlimits-usage
+++ a/kernel/posix-cpu-timers.c
@@ -917,6 +917,7 @@ static void check_thread_timers(struct t
 	int maxfire;
 	struct list_head *timers = tsk->cpu_timers;
 	struct signal_struct *const sig = tsk->signal;
+	unsigned long soft;
 
 	maxfire = 20;
 	tsk->cputime_expires.prof_exp = cputime_zero;
@@ -965,9 +966,9 @@ static void check_thread_timers(struct t
 	/*
 	 * Check for the special case thread timers.
 	 */
-	if (sig->rlim[RLIMIT_RTTIME].rlim_cur != RLIM_INFINITY) {
+	soft = sig->rlim[RLIMIT_RTTIME].rlim_cur;
+	if (soft != RLIM_INFINITY) {
 		unsigned long hard = sig->rlim[RLIMIT_RTTIME].rlim_max;
-		unsigned long *soft = &sig->rlim[RLIMIT_RTTIME].rlim_cur;
 
 		if (hard != RLIM_INFINITY &&
 		    tsk->rt.timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
@@ -978,14 +979,13 @@ static void check_thread_timers(struct t
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
-		if (tsk->rt.timeout > DIV_ROUND_UP(*soft, USEC_PER_SEC/HZ)) {
+		if (tsk->rt.timeout > DIV_ROUND_UP(soft, USEC_PER_SEC/HZ)) {
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
-			if (sig->rlim[RLIMIT_RTTIME].rlim_cur
-			    < sig->rlim[RLIMIT_RTTIME].rlim_max) {
-				sig->rlim[RLIMIT_RTTIME].rlim_cur +=
-								USEC_PER_SEC;
+			if (soft < hard) {
+				soft += USEC_PER_SEC;
+				sig->rlim[RLIMIT_RTTIME].rlim_cur = soft;
 			}
 			printk(KERN_INFO
 				"RT Watchdog Timeout: %s[%d]\n",
@@ -1070,6 +1070,7 @@ static void check_process_timers(struct 
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
 	struct task_cputime cputime;
+	unsigned long soft;
 
 	/*
 	 * Collect the current process totals.
@@ -1129,11 +1130,12 @@ static void check_process_timers(struct 
 			 SIGPROF);
 	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
 			 SIGVTALRM);
-
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
+	soft = sig->rlim[RLIMIT_CPU].rlim_cur;
+	if (soft != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
+		unsigned long hard = sig->rlim[RLIMIT_CPU].rlim_max;
 		cputime_t x;
-		if (psecs >= sig->rlim[RLIMIT_CPU].rlim_max) {
+		if (psecs >= hard) {
 			/*
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
@@ -1141,17 +1143,17 @@ static void check_process_timers(struct 
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
-		if (psecs >= sig->rlim[RLIMIT_CPU].rlim_cur) {
+		if (psecs >= soft) {
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
-			if (sig->rlim[RLIMIT_CPU].rlim_cur
-			    < sig->rlim[RLIMIT_CPU].rlim_max) {
-				sig->rlim[RLIMIT_CPU].rlim_cur++;
+			if (soft < hard) {
+				soft++;
+				sig->rlim[RLIMIT_CPU].rlim_cur = soft;
 			}
 		}
-		x = secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+		x = secs_to_cputime(soft);
 		if (cputime_eq(prof_expires, cputime_zero) ||
 		    cputime_lt(x, prof_expires)) {
 			prof_expires = x;
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
gpu-drm-i915-fix-potential-null-dereference.patch
infiniband-use-rlimit-helpers.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
video-backlight-progear-fix-pci-device-refcounting.patch
mm-use-rlimit-helpers.patch
bootmem-avoid-dma32-zone-by-default.patch
fs-use-rlimit-helpers.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
ipc-use-rlimit-helpers.patch

