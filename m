From: akpm@linux-foundation.org
Subject: + signals-work-around-random-wakeups-in-sigsuspend.patch added to -mm tree
Date: Mon, 25 Jan 2016 13:33:03 -0800
Message-ID: <56a6948f.joiG0d7OeFyiyQeA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbcAYVdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 16:33:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, oleg@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signals: avoid random wakeups in sigsuspend()
has been added to the -mm tree.  Its filename is
     signals-work-around-random-wakeups-in-sigsuspend.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-work-around-random-wakeups-in-sigsuspend.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-work-around-random-wakeups-in-sigsuspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: signals: avoid random wakeups in sigsuspend()

A random wakeup can get us out of sigsuspend() without TIF_SIGPENDING
being set.

Avoid that by making sure we were signaled, like sys_pause() does.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-work-around-random-wakeups-in-sigsuspend kernel/signal.c
--- a/kernel/signal.c~signals-work-around-random-wakeups-in-sigsuspend
+++ a/kernel/signal.c
@@ -3508,8 +3508,10 @@ static int sigsuspend(sigset_t *set)
 	current->saved_sigmask = current->blocked;
 	set_current_blocked(set);
 
-	__set_current_state(TASK_INTERRUPTIBLE);
-	schedule();
+	while (!signal_pending(current)) {
+		__set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
 	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

signals-work-around-random-wakeups-in-sigsuspend.patch

