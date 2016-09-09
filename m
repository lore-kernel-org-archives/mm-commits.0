From: akpm@linux-foundation.org
Subject: + mm-dont-emit-warning-from-pagefault_out_of_memory.patch added
 to -mm tree
Date: Fri, 09 Sep 2016 13:48:54 -0700
Message-ID: <57d32036.gN0JShWWwvX1tb7Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50775 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754606AbcIIUsz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2016 16:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't emit warning from pagefault_out_of_memory()
has been added to the -mm tree.  Its filename is
     mm-dont-emit-warning-from-pagefault_out_of_memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-emit-warning-from-pagefault_out_of_memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-emit-warning-from-pagefault_out_of_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: don't emit warning from pagefault_out_of_memory()

Commit c32b3cbe0d067a9c ("oom, PM: make OOM detection in the freezer path
raceless") inserted a WARN_ON() into pagefault_out_of_memory() in order to
warn when we raced with disabling the OOM killer.  But emitting same
backtrace forever after the OOM killer/reaper are disabled is pointless
because the system is already OOM livelocked.

Now, patch "oom, suspend: fix oom_killer_disable vs.  pm suspend properly"
introduced a timeout for oom_killer_disable().  Even if we raced with
disabling the OOM killer and the system is OOM livelocked, the OOM killer
will be enabled eventually (in 20 seconds by default) and the OOM livelock
will be solved.  Therefore, we no longer need to warn when we raced with
disabling the OOM killer.

Link: http://lkml.kernel.org/r/1473442120-7246-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN mm/oom_kill.c~mm-dont-emit-warning-from-pagefault_out_of_memory mm/oom_kill.c
--- a/mm/oom_kill.c~mm-dont-emit-warning-from-pagefault_out_of_memory
+++ a/mm/oom_kill.c
@@ -1069,16 +1069,6 @@ void pagefault_out_of_memory(void)
 
 	if (!mutex_trylock(&oom_lock))
 		return;
-
-	if (!out_of_memory(&oc)) {
-		/*
-		 * There shouldn't be any user tasks runnable while the
-		 * OOM killer is disabled, so the current task has to
-		 * be a racing OOM victim for which oom_killer_disable()
-		 * is waiting for.
-		 */
-		WARN_ON(test_thread_flag(TIF_MEMDIE));
-	}
