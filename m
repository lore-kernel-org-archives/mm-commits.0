From: akpm@linux-foundation.org
Subject: + signals-do_signal_stop-use-signal_group_exit.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:49:58 -0800
Message-ID: <200802152049.m1FKnw71023128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764164AbYBOUuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:50:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: do_signal_stop(): use signal_group_exit()
has been added to the -mm tree.  Its filename is
     signals-do_signal_stop-use-signal_group_exit.patch

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
Subject: signals: do_signal_stop(): use signal_group_exit()
From: Oleg Nesterov <oleg@tv-sign.ru>

do_signal_stop() needs signal_group_exit() but checks sig->group_exit_task.
 This (optimization) is correct, SIGNAL_STOP_DEQUEUED and SIGNAL_GROUP_EXIT
are mutually exclusive, but looks confusing.  Use signal_group_exit(), this
is not fastpath, the code clarity is more important.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~signals-do_signal_stop-use-signal_group_exit kernel/signal.c
--- a/kernel/signal.c~signals-do_signal_stop-use-signal_group_exit
+++ a/kernel/signal.c
@@ -1711,7 +1711,7 @@ static int do_signal_stop(int signr)
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
-		    unlikely(sig->group_exit_task))
+		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*
 		 * There is no group stop already in progress.
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
