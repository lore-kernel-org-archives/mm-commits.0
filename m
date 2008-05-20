From: akpm@linux-foundation.org
Subject: + signals-introduce-sigqueue_cancelled.patch added to -mm tree
Date: Mon, 19 May 2008 23:33:05 -0700
Message-ID: <200805200633.m4K6X53f008989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756870AbYETGux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 02:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: introduce SIGQUEUE_CANCELLED
has been added to the -mm tree.  Its filename is
     signals-introduce-sigqueue_cancelled.patch

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
Subject: signals: introduce SIGQUEUE_CANCELLED
From: Oleg Nesterov <oleg@tv-sign.ru>

Suggested by Linus Torvalds.

Introduce SIGQUEUE_CANCELLED flag.  If it is set, the pending signal
should be ignored and collect_signal() should return 0.

Note that the new flag is completely orthogonal to SIGQUEUE_PREALLOC, and it
can be set without ->siglock held.

No users of this new flag yet, see the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 +
 kernel/signal.c        |   13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/signal.h~signals-introduce-sigqueue_cancelled include/linux/signal.h
--- a/include/linux/signal.h~signals-introduce-sigqueue_cancelled
+++ a/include/linux/signal.h
@@ -20,6 +20,7 @@ struct sigqueue {
 
 /* flags values. */
 #define SIGQUEUE_PREALLOC	1
+#define SIGQUEUE_CANCELLED	2
 
 struct sigpending {
 	struct list_head list;
diff -puN kernel/signal.c~signals-introduce-sigqueue_cancelled kernel/signal.c
--- a/kernel/signal.c~signals-introduce-sigqueue_cancelled
+++ a/kernel/signal.c
@@ -326,11 +326,13 @@ static int collect_signal(int sig, struc
 		}
 	}
 	if (first) {
-		list_del_init(&first->list);
-		copy_siginfo(info, &first->info);
-		__sigqueue_free(first);
 		if (!still_pending)
 			sigdelset(&list->signal, sig);
+		if (unlikely(first->flags & SIGQUEUE_CANCELLED))
+			sig = 0;
+		copy_siginfo(info, &first->info);
+		list_del_init(&first->list);
+		__sigqueue_free(first);
 	} else {
 
 		/* Ok, it wasn't in the queue.  This must be
@@ -344,7 +346,7 @@ static int collect_signal(int sig, struc
 		info->si_pid = 0;
 		info->si_uid = 0;
 	}
-	return 1;
+	return sig;
 }
 
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
@@ -362,8 +364,7 @@ static int __dequeue_signal(struct sigpe
 			}
 		}
 
-		if (!collect_signal(sig, pending, info))
-			sig = 0;
+		sig = collect_signal(sig, pending, info);
 	}
 
 	return sig;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

signals-fix-sigqueue_free-vs-__exit_signal-race.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued.patch
signals-introduce-sigqueue_cancelled.patch
posix-timers-use-sigqueue_cancelled-when-the-timer-is-destroyed.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

