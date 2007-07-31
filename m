From: akpm@linux-foundation.org
Subject: - use-erestartnohand-if-poll-is-interrupted-by-a-signal.patch removed from -mm tree
Date: Tue, 31 Jul 2007 14:21:07 -0700
Message-ID: <200707312121.l6VLL7aD023224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbXGaVVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 17:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Use ERESTARTNOHAND if poll() is interrupted by a signal
has been removed from the -mm tree.  Its filename was
     use-erestartnohand-if-poll-is-interrupted-by-a-signal.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Use ERESTARTNOHAND if poll() is interrupted by a signal
From: Manfred Spraul <manfred@colorfullife.com>

poll() returns -EINTR if a signal is pending.  EINTR is a bad choice: it
means that poll returns to user space if the task is stopped by
SIGSTOP/SIGCONT or by the freezer.  select() and ppoll() both use
ERESTARTNOHAND, this avoids a return to user space for signals that are
handled by the kernel.

The patch switches poll() to ERESTARTNOHAND.  Tested with FC6.  Patch
against 2.6.23-rc1-mm1.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/select.c~use-erestartnohand-if-poll-is-interrupted-by-a-signal fs/select.c
--- a/fs/select.c~use-erestartnohand-if-poll-is-interrupted-by-a-signal
+++ a/fs/select.c
@@ -621,7 +621,7 @@ static int do_poll(unsigned int nfds,  s
 		if (!count) {
 			count = wait->error;
 			if (signal_pending(current))
-				count = -EINTR;
+				count = -ERESTARTNOHAND;
 		}
 		if (count || !*timeout)
 			break;
@@ -774,7 +774,7 @@ asmlinkage long sys_ppoll(struct pollfd 
 	ret = do_sys_poll(ufds, nfds, &timeout);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR) {
+	if (ret == -ERESTARTNOHAND) {
 		/*
 		 * Don't restore the signal mask yet. Let do_signal() deliver
 		 * the signal on the way back to userspace, before the signal
@@ -785,7 +785,6 @@ asmlinkage long sys_ppoll(struct pollfd 
 					sizeof(sigsaved));
 			set_thread_flag(TIF_RESTORE_SIGMASK);
 		}
-		ret = -ERESTARTNOHAND;
 	} else if (sigmask)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

use-erestartnohand-if-poll-is-interrupted-by-a-signal.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch
