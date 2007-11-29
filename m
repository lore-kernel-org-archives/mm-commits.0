From: akpm@linux-foundation.org
Subject: + timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch added to -mm tree
Date: Thu, 29 Nov 2007 14:53:15 -0800
Message-ID: <200711292253.lATMrFt6011459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763024AbXK2Wxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 17:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, mtk-manpages@gmx.net, tglx@linutronix.de


The patch titled
     update sys_ni.c with the new timerfd syscalls
has been added to the -mm tree.  Its filename is
     timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -153,7 +153,10 @@ cond_syscall(sys_ioprio_get);
 
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

timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-kvm.patch
use-wake_up_locked-in-eventpoll.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
