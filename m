From: akpm@linux-foundation.org
Subject: [merged] mmoom-fix-potentially-killing-unrelated-process.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:08:30 -0800
Message-ID: <563d08be.WP3c5LLeceI1GJEi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966367AbbKFUIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jp, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: fix potentially killing unrelated process
has been removed from the -mm tree.  Its filename was
     mmoom-fix-potentially-killing-unrelated-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: mm/oom_kill.c: fix potentially killing unrelated process

At the for_each_process() loop in oom_kill_process(), we are comparing
address of OOM victim's mm without holding a reference to that mm.  If
there are a lot of processes to compare or a lot of "Kill process %d (%s)
sharing same memory" messages to print, for_each_process() loop could take
very long time.

It is possible that meanwhile the OOM victim exits and releases its mm,
and then mm is allocated with the same address and assigned to some
unrelated process.  When we hit such race, the unrelated process will be
killed by error.  To make sure that the OOM victim's mm does not go away
until for_each_process() loop finishes, get a reference on the OOM
victim's mm before calling task_unlock(victim).

[oleg@redhat.com: several fixes]
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mmoom-fix-potentially-killing-unrelated-process mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-fix-potentially-killing-unrelated-process
+++ a/mm/oom_kill.c
@@ -552,8 +552,9 @@ void oom_kill_process(struct oom_control
 		victim = p;
 	}
 
-	/* mm cannot safely be dereferenced after task_unlock(victim) */
+	/* Get a reference to safely compare mm after task_unlock(victim) */
 	mm = victim->mm;
+	atomic_inc(&mm->mm_count);
 	/*
 	 * We should send SIGKILL before setting TIF_MEMDIE in order to prevent
 	 * the OOM victim from depleting the memory reserves from the user
@@ -591,6 +592,7 @@ void oom_kill_process(struct oom_control
 		}
 	rcu_read_unlock();
 
+	mmdrop(mm);
 	put_task_struct(victim);
 }
 #undef K
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are


