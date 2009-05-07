From: akpm@linux-foundation.org
Subject: [merged] signals-split-do_tkill.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:52 -0700
Message-ID: <200905071916.n47JGqrY020684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbZEGTWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:22:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, drepper@redhat.com, linux-abi@vger.kernel.org, linux-arch@vger.kernel.org, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: split do_tkill
has been removed from the -mm tree.  Its filename was
     signals-split-do_tkill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: split do_tkill
From: Thomas Gleixner <tglx@linutronix.de>

sys_kill() has a counterpart sys_tgkill which allows to send signals to a
particular thread.  sys_rt_sigqueueinfo is lacking such a counterpart.

Aside of the asymmetry it is a show stopper for migrating applications
from other unix-alike RTOSes.

The following patch series implements rt_tgsigqueueinfo and hooks it up
for x86.



This patch:

Split out the code from do_tkill to make it reusable by the follow up
patch which implements sys_rt_tgsigqueueinfo

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: <linux-abi@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN kernel/signal.c~signals-split-do_tkill kernel/signal.c
--- a/kernel/signal.c~signals-split-do_tkill
+++ a/kernel/signal.c
@@ -2278,24 +2278,17 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, s
 	return kill_something_info(sig, &info, pid);
 }
 
-static int do_tkill(pid_t tgid, pid_t pid, int sig)
+static int
+do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 {
-	int error;
-	struct siginfo info;
 	struct task_struct *p;
 	unsigned long flags;
-
-	error = -ESRCH;
-	info.si_signo = sig;
-	info.si_errno = 0;
-	info.si_code = SI_TKILL;
-	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = current_uid();
+	int error = -ESRCH;
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (p && (tgid <= 0 || task_tgid_vnr(p) == tgid)) {
-		error = check_kill_permission(sig, &info, p);
+		error = check_kill_permission(sig, info, p);
 		/*
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
@@ -2305,7 +2298,7 @@ static int do_tkill(pid_t tgid, pid_t pi
 		 * signal is private anyway.
 		 */
 		if (!error && sig && lock_task_sighand(p, &flags)) {
-			error = specific_send_sig_info(sig, &info, p);
+			error = specific_send_sig_info(sig, info, p);
 			unlock_task_sighand(p, &flags);
 		}
 	}
@@ -2314,6 +2307,19 @@ static int do_tkill(pid_t tgid, pid_t pi
 	return error;
 }
 
+static int do_tkill(pid_t tgid, pid_t pid, int sig)
+{
+	struct siginfo info;
+
+	info.si_signo = sig;
+	info.si_errno = 0;
+	info.si_code = SI_TKILL;
+	info.si_pid = task_tgid_vnr(current);
+	info.si_uid = current_uid();
+
+	return do_send_specific(tgid, pid, sig, &info);
+}
+
 /**
  *  sys_tgkill - send signal to one specific thread
  *  @tgid: the thread group ID of the thread
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
x86-simplify-highmem-related-kconfig-entries.patch
x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch
avr32-remove-obsolete-hw_interrupt_type.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
ia64-remove-obsolete-hw_interrupt_type.patch
drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch
parisc-remove-obsolete-hw_interrupt_type.patch
alpha-remove-obsolete-hw_interrupt_type.patch
m32r-remove-obsolete-hw_interrupt_type.patch
um-remove-obsolete-hw_interrupt_type.patch
kmap_types-make-most-arches-use-generic-header-file.patch
remove-put_cpu_no_resched.patch
remove-put_cpu_no_resched-fix.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch

