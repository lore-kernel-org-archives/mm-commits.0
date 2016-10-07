From: akpm@linux-foundation.org
Subject: [patch 015/127] mm/oom_kill.c: fix task_will_free_mem() comment
Date: Fri, 07 Oct 2016 16:57:32 -0700
Message-ID: <57f8366c.jDDfnqZDH4snj7lx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38842 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp

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
