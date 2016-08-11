From: akpm@linux-foundation.org
Subject: + mm-oom_killc-fix-task_will_free_mem-comment.patch added to -mm
 tree
Date: Thu, 11 Aug 2016 13:54:35 -0700
Message-ID: <57ace60b.cfLRlWEjtD//qySK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbcHKUyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 16:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: fix task_will_free_mem() comment
has been added to the -mm tree.  Its filename is
     mm-oom_killc-fix-task_will_free_mem-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_killc-fix-task_will_free_mem-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_killc-fix-task_will_free_mem-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm/oom_kill.c: fix task_will_free_mem() comment

Attempt to demystify the task_will_free_mem() loop.

Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_killc-fix-task_will_free_mem-comment mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_killc-fix-task_will_free_mem-comment
+++ a/mm/oom_kill.c
@@ -803,8 +803,9 @@ static bool task_will_free_mem(struct ta
 		return true;
 
 	/*
-	 * This is really pessimistic but we do not have any reliable way
-	 * to check that external processes share with our mm
+	 * Make sure that all tasks which share the mm with the given tasks
+	 * are dying as well to make sure that a) nobody pins its mm and
+	 * b) the task is also reapable by the oom reaper.
 	 */
 	rcu_read_lock();
 	for_each_process(p) {
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-oom_killc-fix-task_will_free_mem-comment.patch

