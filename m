From: akpm@linux-foundation.org
Subject: + exit_state-kill-task_is_dead.patch added to -mm tree
Date: Wed, 20 Nov 2013 14:03:55 -0800
Message-ID: <528d31cb.vsT+pnB3Hkx8tI+a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab3KTWD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:03:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, peterz@infradead.org, mingo@kernel.org, geert@linux-m68k.org, David.Laight@ACULAB.COM, oleg@redhat.com

Subject: + exit_state-kill-task_is_dead.patch added to -mm tree
To: oleg@redhat.com,David.Laight@ACULAB.COM,geert@linux-m68k.org,mingo@kernel.org,peterz@infradead.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:03:55 -0800


The patch titled
     Subject: exit_state: kill task_is_dead()
has been added to the -mm tree.  Its filename is
     exit_state-kill-task_is_dead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit_state-kill-task_is_dead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit_state-kill-task_is_dead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit_state: kill task_is_dead()

task_is_dead() has no users since commit 43e13cc107cf "cred: remove
task_is_dead() from __task_cred() validation", and nobody except exit.c
should rely on ->exit_state (we still have the users which should be
changed).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/sched.h~exit_state-kill-task_is_dead include/linux/sched.h
--- a/include/linux/sched.h~exit_state-kill-task_is_dead
+++ a/include/linux/sched.h
@@ -168,7 +168,6 @@ extern char ___assert_task_state[1 - 2*!
 
 #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
 #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
-#define task_is_dead(task)	((task)->exit_state != 0)
 #define task_is_stopped_or_traced(task)	\
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
linux-next.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
fork-no-need-to-initialize-child-exit_state.patch
exit_state-kill-task_is_dead.patch

