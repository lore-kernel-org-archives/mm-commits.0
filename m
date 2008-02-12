From: akpm@linux-foundation.org
Subject: + remove-unused-variable-from-send_signal.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:42:48 -0800
Message-ID: <200802122142.m1CLgm9R023730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55994 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbYBLVnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:43:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: remove unused variable from send_signal()
has been added to the -mm tree.  Its filename is
     remove-unused-variable-from-send_signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: remove unused variable from send_signal()
From: Pavel Emelyanov <xemul@openvz.org>

This function doesn't change the ret's value and thus always returns 0, with a
single exception of returning -EAGAIN explicitly.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/signal.c~remove-unused-variable-from-send_signal kernel/signal.c
--- a/kernel/signal.c~remove-unused-variable-from-send_signal
+++ a/kernel/signal.c
@@ -661,7 +661,6 @@ static int send_signal(int sig, struct s
 			struct sigpending *signals)
 {
 	struct sigqueue * q = NULL;
-	int ret = 0;
 
 	/*
 	 * Deliver the signal to listening signalfds. This must be called
@@ -719,7 +718,7 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&signals->signal, sig);
-	return ret;
+	return 0;
 }
 
 #define LEGACY_QUEUE(sigptr, sig) \
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
usbatm-switch-to-kthread-api-stop-using-kill_proc.patch
deprecate-find_task_by_pid-kgdb.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
