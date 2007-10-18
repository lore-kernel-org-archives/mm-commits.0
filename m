From: akpm@linux-foundation.org
Subject: - use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:31 -0700
Message-ID: <200710180656.l9I6uVSv030708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932509AbXJRHoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, bunk@kernel.org, lomesh.agarwal@intel.com, manfred@colorfullife.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Use ERESTART_RESTARTBLOCK if poll() is interrupted by a signal
has been removed from the -mm tree.  Its filename was
     use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[bunk@kernel.org: do_restart_poll() can become static]
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff -puN fs/select.c~use-erestart_restartblock-if-poll-is-interrupted-by-a-signal fs/select.c
--- a/fs/select.c~use-erestart_restartblock-if-poll-is-interrupted-by-a-signal
+++ a/fs/select.c
@@ -714,10 +714,28 @@ out_fds:
 	return err;
 }
 
+static long do_restart_poll(struct restart_block *restart_block)
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
@@ -732,7 +750,18 @@ asmlinkage long sys_poll(struct pollfd _
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

origin.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
capabilities-clean-up-file-capability-reading.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
whitespace-fixes-capability-syscalls.patch
