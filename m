From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-oom-schedule_timeout.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:26:56 -0800
Message-ID: <201111072026.pA7KQul6013215@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1KGU1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix oom schedule_timeout()
has been removed from the -mm tree.  Its filename was
     memcg-fix-oom-schedule_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: fix oom schedule_timeout()

Before calling schedule_timeout(), task state should be changed.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-oom-schedule_timeout mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-oom-schedule_timeout
+++ a/mm/memcontrol.c
@@ -1898,7 +1898,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
 		return false;
 	/* Give chance to dying process */
-	schedule_timeout(1);
+	schedule_timeout_uninterruptible(1);
 	return true;
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch

