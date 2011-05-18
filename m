From: akpm@linux-foundation.org
Subject: [to-be-updated] include-linux-signalh-fix-timespec-declared-inside-parameter-list-warning.patch removed from -mm tree
Date: Wed, 18 May 2011 16:37:50 -0700
Message-ID: <201105182337.p4INbpSw031843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756623Ab1ERXiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 19:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/signal.h: fix "timespec declared inside parameter list" warning
has been removed from the -mm tree.  Its filename was
     include-linux-signalh-fix-timespec-declared-inside-parameter-list-warning.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/signal.h: fix "timespec declared inside parameter list" warning
From: Oleg Nesterov <oleg@redhat.com>

Fix the compile warning, do_sigtimedwait(struct timespec *) in signal.h
needs the forward declaration of timespec.

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/signal.h~include-linux-signalh-fix-timespec-declared-inside-parameter-list-warning include/linux/signal.h
--- a/include/linux/signal.h~include-linux-signalh-fix-timespec-declared-inside-parameter-list-warning
+++ a/include/linux/signal.h
@@ -234,6 +234,9 @@ static inline int valid_signal(unsigned 
 	return sig <= _NSIG ? 1 : 0;
 }
 
+struct timespec;
+struct pt_regs;
+
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int do_send_sig_info(int sig, struct siginfo *info,
 				struct task_struct *p, bool group);
@@ -248,7 +251,6 @@ extern int sigprocmask(int, sigset_t *, 
 extern void set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
 
-struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 extern void exit_signals(struct task_struct *tsk);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

