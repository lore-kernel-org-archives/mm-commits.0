From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch removed from -mm tree
Date: Thu, 19 May 2016 16:50:23 -0700
Message-ID: <573e513f.nuSkWtkiCPfScp4f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbcESXuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: clear oom_reaper_list before clearing TIF_MEMDIE
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch

This patch was dropped because it was folded into mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: clear oom_reaper_list before clearing TIF_MEMDIE

As per Tetsuo:
: oom_reaper() will need to do "tsk->oom_reaper_list = NULL;" due to
:
:         if (tsk == oom_reaper_list || tsk->oom_reaper_list)
:                 return;
:
: test in wake_oom_reaper() if "[PATCH 3/3] mm, oom_reaper: clear
: TIF_MEMDIE for all tasks queued for oom_reaper" will select the same
: thread again

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/oom_kill.c~mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie
+++ a/mm/oom_kill.c
@@ -540,6 +540,7 @@ static void oom_reap_task(struct task_st
 	 * for the oom victim right now because it cannot release its memory
 	 * itself nor by the oom reaper.
 	 */
+	tsk->oom_reaper_list = NULL;
 	exit_oom_victim(tsk);
 
 	/* Drop a reference taken by wake_oom_reaper */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch

