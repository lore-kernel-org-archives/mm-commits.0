From: akpm@linux-foundation.org
Subject: [patch 079/127] mm: don't emit warning from
 pagefault_out_of_memory()
Date: Fri, 07 Oct 2016 17:00:49 -0700
Message-ID: <57f83731.uos/vtmVpQ1pc7Jo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753735AbcJHAAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: don't emit warning from pagefault_out_of_memory()

Commit c32b3cbe0d067a9c ("oom, PM: make OOM detection in the freezer path
raceless") inserted a WARN_ON() into pagefault_out_of_memory() in order to
warn when we raced with disabling the OOM killer.

Now, patch "oom, suspend: fix oom_killer_disable vs.  pm suspend properly"
introduced a timeout for oom_killer_disable().  Even if we raced with
disabling the OOM killer and the system is OOM livelocked, the OOM killer
will be enabled eventually (in 20 seconds by default) and the OOM livelock
will be solved.  Therefore, we no longer need to warn when we raced with
disabling the OOM killer.

Link: http://lkml.kernel.org/r/1473442120-7246-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.cz>
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
