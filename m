From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
 removed from -mm tree
Date: Wed, 03 Feb 2016 15:12:58 -0800
Message-ID: <56b2897a.UFS/Ma+vpUEEuEEK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbcBCXM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 18:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, andrea@kernel.org, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: don't ignore oom score on exiting tasks
has been removed from the -mm tree.  Its filename was
     mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/oom_kill.c: don't ignore oom score on exiting tasks

When the OOM killer scans tasks and encounters a PF_EXITING one, it
force-selects that one regardless of the score.  Is there a possibility
that the task might hang after it has set PF_EXITING?  In that case the
OOM killer should be able to move on to the next task.

Frankly, I don't even know why we check for exiting tasks in the OOM
killer.  We've tried direct reclaim at least 15 times by the time we
decide the system is OOM, there was plenty of time to exit and free
memory; and a task might exit voluntarily right after we issue a kill. 
This is testing pure noise.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim
+++ a/mm/oom_kill.c
@@ -292,9 +292,6 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task_will_free_mem(task) && !is_sysrq_oom(oc))
-		return OOM_SCAN_ABORT;
