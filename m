From: akpm@linux-foundation.org
Subject: + use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:47:33 -0700
Message-ID: <200708171847.l7HIlXHB024257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbXHQSsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:48:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, lomesh.agarwal@intel.com, manfred@colorfullife.com, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     Use ERESTART_RESTARTBLOCK if poll() is interrupted by a signal
has been added to the -mm tree.  Its filename is
     use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use ERESTART_RESTARTBLOCK if poll() is interrupted by a signal
From: Chris Wright <chrisw@sous-sol.org>

Lomesh reported poll returning EINTR during suspend/resume cycle.  This is
caused by the STOP/CONT cycle that the freezer uses, generating a pending
signal for what in effect is an ignored signal.  In general poll is a
little eager in returning EINTR, when it could try not bother userspace and
simply restart the syscall.  Both select and ppoll do use ERESTARTNOHAND to
restart the syscall.  Oleg points out that simply using ERESTARTNOHAND will
cause poll to restart with original timeout value.  which could ultimately
lead to process never returning to userspace.  Instead use
ERESTART_RESTARTBLOCK, and restart poll with updated timeout value. 
Inspired by Manfred's use ERESTARTNOHAND in poll patch.

Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletion(-)

diff -puN fs/select.c~use-erestart_restartblock-if-poll-is-interrupted-by-a-signal fs/select.c
--- a/fs/select.c~use-erestart_restartblock-if-poll-is-interrupted-by-a-signal
+++ a/fs/select.c
@@ -716,10 +716,28 @@ out_fds:
 	return err;
 }
 
+long do_restart_poll(struct restart_block *restart_block)
+{
+	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
+	int nfds = restart_block->arg1;
+	s64 timeout = ((s64)restart_block->arg3<<32) | (s64)restart_block->arg2;
+	int ret;
+
+	ret = do_sys_poll(ufds, nfds, &timeout);
+	if (ret == -EINTR) {
+		restart_block->fn = do_restart_poll;
+		restart_block->arg2 = timeout & 0xFFFFFFFF;
+		restart_block->arg3 = (u64)timeout >> 32;
+		ret = -ERESTART_RESTARTBLOCK;
+	}
+	return ret;
+}
+
 asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 			long timeout_msecs)
 {
 	s64 timeout_jiffies;
+	int ret;
 
 	if (timeout_msecs > 0) {
 #if HZ > 1000
@@ -734,7 +752,18 @@ asmlinkage long sys_poll(struct pollfd _
 		timeout_jiffies = timeout_msecs;
 	}
 
-	return do_sys_poll(ufds, nfds, &timeout_jiffies);
+	ret = do_sys_poll(ufds, nfds, &timeout_jiffies);
+	if (ret == -EINTR) {
+		struct restart_block *restart_block;
+		restart_block = &current_thread_info()->restart_block;
+		restart_block->fn = do_restart_poll;
+		restart_block->arg0 = (unsigned long)ufds;
+		restart_block->arg1 = nfds;
+		restart_block->arg2 = timeout_jiffies & 0xFFFFFFFF;
+		restart_block->arg3 = (u64)timeout_jiffies >> 32;
+		ret = -ERESTART_RESTARTBLOCK;
+	}
+	return ret;
 }
 
 #ifdef TIF_RESTORE_SIGMASK
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
file-capabilities-clear-fcaps-on-inode-change.patch
security-cleanups.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
whitespace-fixes-capability-syscalls.patch
