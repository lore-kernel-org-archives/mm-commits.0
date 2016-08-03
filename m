From: akpm@linux-foundation.org
Subject: [merged] proc_oom_score-remove-tasklist_lock-and-pid_alive.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:11:30 -0700
Message-ID: <57a233d2.71KeU/oVWj5CPS5Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbcHCSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@suse.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc_oom_score: remove tasklist_lock and pid_alive()
has been removed from the -mm tree.  Its filename was
     proc_oom_score-remove-tasklist_lock-and-pid_alive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc_oom_score: remove tasklist_lock and pid_alive()

This was needed before to ensure that ->signal != 0 and do_each_thread()
is safe, see b95c35e76b29b ("oom: fix the unsafe usage of badness() in
proc_oom_score()") for details.

Today tsk->signal can't go away and for_each_thread(tsk) is always safe.

Link: http://lkml.kernel.org/r/20160608211921.GA15508@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~proc_oom_score-remove-tasklist_lock-and-pid_alive fs/proc/base.c
--- a/fs/proc/base.c~proc_oom_score-remove-tasklist_lock-and-pid_alive
+++ a/fs/proc/base.c
@@ -579,11 +579,8 @@ static int proc_oom_score(struct seq_fil
 	unsigned long totalpages = totalram_pages + total_swap_pages;
 	unsigned long points = 0;
 
-	read_lock(&tasklist_lock);
-	if (pid_alive(task))
-		points = oom_badness(task, NULL, NULL, totalpages) *
-						1000 / totalpages;
-	read_unlock(&tasklist_lock);
+	points = oom_badness(task, NULL, NULL, totalpages) *
+					1000 / totalpages;
 	seq_printf(m, "%lu\n", points);
 
 	return 0;
_

Patches currently in -mm which might be from oleg@redhat.com are


