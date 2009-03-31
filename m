From: akpm@linux-foundation.org
Subject: + signals-implement-sys_rt_tgsigqueueinfo.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:42:02 -0700
Message-ID: <200903312342.n2VNg3da012224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760187AbZCaXrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:47:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, drepper@redhat.com, linux-abi@vger.kernel.org, linux-arch@vger.kernel.org, oleg@redhat.com, roland@redhat.com


The patch titled
     signals: implement sys_rt_tgsigqueueinfo
has been added to the -mm tree.  Its filename is
     signals-implement-sys_rt_tgsigqueueinfo.patch

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
Subject: signals: implement sys_rt_tgsigqueueinfo
From: Thomas Gleixner <tglx@linutronix.de>

sys_kill has the per thread counterpart sys_tgkill.  sigqueueinfo is
missing a thread directed counterpart.  Such an interface is important for
migrating applications from other OSes which have the per thread delivery
implemented.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
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
@@ -216,6 +216,8 @@ int copy_siginfo_from_user32(siginfo_t *
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
introduce-debug_kmap_atomic.patch
use-debug_kmap_atomic.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
x86-simplify-highmem-related-kconfig-entries.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch
scsi-mpt-suppress-debugobjects-warning.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch

