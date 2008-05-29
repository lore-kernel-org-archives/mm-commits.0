From: akpm@linux-foundation.org
Subject: + signals-change-collect_signal-to-return-void.patch added to -mm tree
Date: Wed, 28 May 2008 17:32:15 -0700
Message-ID: <200805290032.m4T0WF2O008111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754615AbYE2Ac0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 20:32:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru


The patch titled
     signals: change collect_signal() to return void
has been added to the -mm tree.  Its filename is
     signals-change-collect_signal-to-return-void.patch

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
Subject: signals: change collect_signal() to return void
From: Oleg Nesterov <oleg@tv-sign.ru>

With the recent changes collect_signal() always returns true.  Change it
to return void and update the single caller.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/signal.c~signals-change-collect_signal-to-return-void kernel/signal.c
--- a/kernel/signal.c~signals-change-collect_signal-to-return-void
+++ a/kernel/signal.c
@@ -338,7 +338,7 @@ unblock_all_signals(void)
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
-static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
+static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
 
@@ -372,7 +372,6 @@ still_pending:
 		info->si_pid = 0;
 		info->si_uid = 0;
 	}
-	return 1;
 }
 
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
@@ -390,8 +389,7 @@ static int __dequeue_signal(struct sigpe
 			}
 		}
 
-		if (!collect_signal(sig, pending, info))
-			sig = 0;
+		collect_signal(sig, pending, info);
 	}
 
 	return sig;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

vt-fix-vc_resize-locking.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
distinct-tgid-tid-i-o-statistics.patch

