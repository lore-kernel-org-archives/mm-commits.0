From: akpm@linux-foundation.org
Subject: - signals-microoptimize-the-usage-of-curr_target.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:39 -0700
Message-ID: <200805010926.m419Qd7M030318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757474AbYEAJ1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: microoptimize the usage of ->curr_target
has been removed from the -mm tree.  Its filename was
     signals-microoptimize-the-usage-of-curr_target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: microoptimize the usage of ->curr_target
From: Oleg Nesterov <oleg@tv-sign.ru>

Suggested by Roland McGrath.

Initialize signal->curr_target in copy_signal().  This way ->curr_target is
never == NULL, we can kill the check in __group_complete_signal's hot path.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c   |    2 +-
 kernel/signal.c |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN kernel/fork.c~signals-microoptimize-the-usage-of-curr_target kernel/fork.c
--- a/kernel/fork.c~signals-microoptimize-the-usage-of-curr_target
+++ a/kernel/fork.c
@@ -892,7 +892,7 @@ static int copy_signal(unsigned long clo
 	sig->group_exit_code = 0;
 	sig->group_exit_task = NULL;
 	sig->group_stop_count = 0;
-	sig->curr_target = NULL;
+	sig->curr_target = tsk;
 	init_sigpending(&sig->shared_pending);
 	INIT_LIST_HEAD(&sig->posix_timers);
 
diff -puN kernel/signal.c~signals-microoptimize-the-usage-of-curr_target kernel/signal.c
--- a/kernel/signal.c~signals-microoptimize-the-usage-of-curr_target
+++ a/kernel/signal.c
@@ -863,10 +863,6 @@ __group_complete_signal(int sig, struct 
 		 * Otherwise try to find a suitable thread.
 		 */
 		t = signal->curr_target;
-		if (t == NULL)
-			/* restart balancing at this thread */
-			t = signal->curr_target = p;
