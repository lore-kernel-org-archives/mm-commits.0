From: akpm@linux-foundation.org
Subject: [patch 008/101] mm, oom: task_will_free_mem should skip
 oom_reaped tasks
Date: Thu, 28 Jul 2016 15:44:55 -0700
Message-ID: <579a8ae7.2Ucgofbm6NdNSOSp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbcG1Wo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: task_will_free_mem should skip oom_reaped tasks

0-day robot has encountered the following:
[   82.694232] Out of memory: Kill process 3914 (trinity-c0) score 167 or sacrifice child
[   82.695110] Killed process 3914 (trinity-c0) total-vm:55864kB, anon-rss:1512kB, file-rss:1088kB, shmem-rss:25616kB
[   82.706724] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:26488kB
[   82.715540] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:26900kB
[   82.717662] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:26900kB
[   82.725804] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:27296kB
[   82.739091] oom_reaper: reaped process 3914 (trinity-c0), now anon-rss:0kB, file-rss:0kB, shmem-rss:28148kB

oom_reaper is trying to reap the same task again and again.  This is
possible only when the oom killer is bypassed because of
task_will_free_mem because we skip over tasks with MMF_OOM_REAPED already
set during select_bad_process.  Teach task_will_free_mem to skip over
MMF_OOM_REAPED tasks as well because they will be unlikely to free
anything more.

Analyzed by Tetsuo Handa.

Link: http://lkml.kernel.org/r/1466426628-15074-9-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/oom_kill.c~mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks
+++ a/mm/oom_kill.c
@@ -747,6 +747,16 @@ bool task_will_free_mem(struct task_stru
 		return false;
 
 	mm = p->mm;
+
+	/*
+	 * This task has already been drained by the oom reaper so there are
+	 * only small chances it will free some more
+	 */
+	if (test_bit(MMF_OOM_REAPED, &mm->flags)) {
+		task_unlock(p);
+		return false;
+	}
+
 	if (atomic_read(&mm->mm_users) <= 1) {
 		task_unlock(p);
 		return true;
_
