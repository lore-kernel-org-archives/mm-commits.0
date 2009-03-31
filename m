From: akpm@linux-foundation.org
Subject: + signals-split-do_tkill.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:42:00 -0700
Message-ID: <200903312342.n2VNg0mD012174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757909AbZCaXrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, drepper@redhat.com, linux-abi@vger.kernel.org, linux-arch@vger.kernel.org, oleg@redhat.com, roland@redhat.com


The patch titled
     signals: split do_tkill
has been added to the -mm tree.  Its filename is
     signals-split-do_tkill.patch

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

