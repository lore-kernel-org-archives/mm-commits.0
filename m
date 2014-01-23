From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch removed
 from -mm tree
Date: Thu, 23 Jan 2014 15:20:52 -0800
Message-ID: <52e1a3d4.46BVSUxayfaObJAS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaAWXUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:20:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, gthelen@google.com, rientjes@google.com

Subject: [folded-merged] mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch removed from -mm tree
To: rientjes@google.com,gthelen@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:20:52 -0800


The patch titled
     Subject: mm, oom: prefer thread group leaders for display purposes fix
has been removed from the -mm tree.  Its filename was
     mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch

This patch was dropped because it was folded into mm-oom-prefer-thread-group-leaders-for-display-purposes.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: prefer thread group leaders for display purposes fix

If oom_badness() returns 0 for an oom disabled process before a process
has actually been chosen for kill, there will be a NULL pointer
dereference when doing thread_group_leader(chosen).

Make sure oom disabled processes aren't even considered to prevent the
bug.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 mm/oom_kill.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-oom-prefer-thread-group-leaders-for-display-purposes-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-prefer-thread-group-leaders-for-display-purposes-fix
+++ a/mm/memcontrol.c
@@ -1841,7 +1841,7 @@ static void mem_cgroup_out_of_memory(str
 				break;
 			};
 			points = oom_badness(task, memcg, NULL, totalpages);
-			if (points < chosen_points)
+			if (!points || points < chosen_points)
 				continue;
 			/* Prefer thread group leaders for display purposes */
 			if (points == chosen_points &&
diff -puN mm/oom_kill.c~mm-oom-prefer-thread-group-leaders-for-display-purposes-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-prefer-thread-group-leaders-for-display-purposes-fix
+++ a/mm/oom_kill.c
@@ -327,7 +327,7 @@ static struct task_struct *select_bad_pr
 			break;
 		};
 		points = oom_badness(p, NULL, nodemask, totalpages);
-		if (points < chosen_points)
+		if (!points || points < chosen_points)
 			continue;
 		/* Prefer thread group leaders for display purposes */
 		if (points == chosen_points && thread_group_leader(chosen))
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
uapi-convert-u64-to-__u64-in-exported-headers.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch

