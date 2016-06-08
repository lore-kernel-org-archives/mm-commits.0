From: akpm@linux-foundation.org
Subject: + proc_oom_score-remove-tasklist_lock-and-pid_alive.patch added
 to -mm tree
Date: Wed, 08 Jun 2016 14:33:21 -0700
Message-ID: <57588f21.Bn3tPlxK1JR9Bd0q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbcFHVdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 17:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@kernel.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc_oom_score: remove tasklist_lock and pid_alive()
has been added to the -mm tree.  Its filename is
     proc_oom_score-remove-tasklist_lock-and-pid_alive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc_oom_score-remove-tasklist_lock-and-pid_alive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc_oom_score-remove-tasklist_lock-and-pid_alive.patch

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
Subject: proc_oom_score: remove tasklist_lock and pid_alive()

This was needed before to ensure that ->signal != 0 and do_each_thread()
is safe, see b95c35e76b29b ("oom: fix the unsafe usage of badness() in
proc_oom_score()") for details.

Today tsk->signal can't go away and for_each_thread(tsk) is always safe.

Link: http://lkml.kernel.org/r/20160608211921.GA15508@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
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

proc_oom_score-remove-tasklist_lock-and-pid_alive.patch

