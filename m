From: akpm@linux-foundation.org
Subject: - timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:19:49 -0800
Message-ID: <200802040319.m143JUo3011430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbYBDDTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:19:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mtk-manpages@gmx.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     update sys_ni.c with the new timerfd syscalls
has been removed from the -mm tree.  Its filename was
     timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch

This patch was dropped because it was folded into timerfd-v3-new-timerfd-api.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update sys_ni.c with the new timerfd syscalls
From: Davide Libenzi <davidel@xmailserver.org>

Update sys_ni.c with the new timerfd syscalls.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/sys_ni.c~timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls kernel/sys_ni.c
--- a/kernel/sys_ni.c~timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls
+++ a/kernel/sys_ni.c
@@ -154,7 +154,10 @@ cond_syscall(sys_ioprio_get);
 
 /* New file descriptors */
 cond_syscall(sys_signalfd);
-cond_syscall(sys_timerfd);
 cond_syscall(compat_sys_signalfd);
-cond_syscall(compat_sys_timerfd);
+cond_syscall(sys_timerfd_create);
+cond_syscall(sys_timerfd_settime);
+cond_syscall(sys_timerfd_gettime);
+cond_syscall(compat_sys_timerfd_settime);
+cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

lockdep-annotate-epoll.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-kvm.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
