From: akpm@linux-foundation.org
Subject: [merged] signals-implement-sys_rt_tgsigqueueinfo.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:54 -0700
Message-ID: <200905071916.n47JGspF020689__9732.61187687076$1241724153$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754967AbZEGTWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, drepper@redhat.com, linux-abi@vger.kernel.org, linux-arch@vger.kernel.org, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: implement sys_rt_tgsigqueueinfo
has been removed from the -mm tree.  Its filename was
     signals-implement-sys_rt_tgsigqueueinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: implement sys_rt_tgsigqueueinfo
From: Thomas Gleixner <tglx@linutronix.de>

sys_kill has the per thread counterpart sys_tgkill.  sigqueueinfo is
missing a thread directed counterpart.  Such an interface is important for
migrating applications from other OSes which have the per thread delivery
implemented.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Ulrich Drepper <drepper@redhat.com>
Cc: <linux-abi@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    2 ++
 include/linux/signal.h |    2 ++
 kernel/compat.c        |   11 +++++++++++
 kernel/signal.c        |   26 ++++++++++++++++++++++++++
 4 files changed, 41 insertions(+)

diff -puN include/linux/compat.h~signals-implement-sys_rt_tgsigqueueinfo include/linux/compat.h
--- a/include/linux/compat.h~signals-implement-sys_rt_tgsigqueueinfo
+++ a/include/linux/compat.h
@@ -222,6 +222,8 @@ int copy_siginfo_from_user32(siginfo_t *
 int copy_siginfo_to_user32(struct compat_siginfo __user *to, siginfo_t *from);
 int get_compat_sigevent(struct sigevent *event,
 		const struct compat_sigevent __user *u_event);
+long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
+				  struct compat_siginfo __user *uinfo);
 
 static inline int compat_timeval_compare(struct compat_timeval *lhs,
 					struct compat_timeval *rhs)
diff -puN include/linux/signal.h~signals-implement-sys_rt_tgsigqueueinfo include/linux/signal.h
--- a/include/linux/signal.h~signals-implement-sys_rt_tgsigqueueinfo
+++ a/include/linux/signal.h
@@ -235,6 +235,8 @@ static inline int valid_signal(unsigned 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
+extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
+				 siginfo_t *info);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int show_unhandled_signals;
diff -puN kernel/compat.c~signals-implement-sys_rt_tgsigqueueinfo kernel/compat.c
--- a/kernel/compat.c~signals-implement-sys_rt_tgsigqueueinfo
+++ a/kernel/compat.c
@@ -882,6 +882,17 @@ compat_sys_rt_sigtimedwait (compat_sigse
 
 }
 
+asmlinkage long
+compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid, compat_pid_t pid, int sig,
+			     struct compat_siginfo __user *uinfo)
+{
+	siginfo_t info;
+
+	if (copy_siginfo_from_user32(&info, uinfo))
+		return -EFAULT;
+	return do_rt_tgsigqueueinfo(tgid, pid, sig, &info);
+}
+
 #ifdef __ARCH_WANT_COMPAT_SYS_TIME
 
 /* compat_time_t is a 32 bit "long" and needs to get converted. */
diff -puN kernel/signal.c~signals-implement-sys_rt_tgsigqueueinfo kernel/signal.c
--- a/kernel/signal.c~signals-implement-sys_rt_tgsigqueueinfo
+++ a/kernel/signal.c
@@ -2369,6 +2369,32 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, 
 	return kill_proc_info(sig, &info, pid);
 }
 
+long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
+{
+	/* This is only valid for single tasks */
+	if (pid <= 0 || tgid <= 0)
+		return -EINVAL;
+
+	/* Not even root can pretend to send signals from the kernel.
+	   Nor can they impersonate a kill(), which adds source info.  */
+	if (info->si_code >= 0)
+		return -EPERM;
+	info->si_signo = sig;
+
+	return do_send_specific(tgid, pid, sig, info);
+}
+
+SYSCALL_DEFINE4(rt_tgsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig,
+		siginfo_t __user *, uinfo)
+{
+	siginfo_t info;
+
+	if (copy_from_user(&info, uinfo, sizeof(siginfo_t)))
+		return -EFAULT;
+
+	return do_rt_tgsigqueueinfo(tgid, pid, sig, &info);
+}
+
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
 	struct task_struct *t = current;
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

