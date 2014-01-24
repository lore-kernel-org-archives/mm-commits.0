From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-prefer-thread-group-leaders-for-display-purposes.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 10:59:37 -0800
Message-ID: <52e2b819.MaZji8qK90p3lPGT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, gthelen@google.com, rientjes@google.com

Subject: [merged] mm-oom-prefer-thread-group-leaders-for-display-purposes.patch removed from -mm tree
To: rientjes@google.com,gthelen@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:37 -0800


The patch titled
     Subject: mm, oom: prefer thread group leaders for display purposes
has been removed from the -mm tree.  Its filename was
     mm-oom-prefer-thread-group-leaders-for-display-purposes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: prefer thread group leaders for display purposes

When two threads have the same badness score, it's preferable to kill the
thread group leader so that the actual process name is printed to the
kernel log rather than the thread group name which may be shared amongst
several processes.

This was the behavior when select_bad_process() used to do
for_each_process(), but it now iterates threads instead and leads to
ambiguity.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 ++++++++++++-------
 mm/oom_kill.c   |   12 ++++++++----
 2 files changed, 20 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~mm-oom-prefer-thread-group-leaders-for-display-purposes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-prefer-thread-group-leaders-for-display-purposes
+++ a/mm/memcontrol.c
@@ -1841,13 +1841,18 @@ static void mem_cgroup_out_of_memory(str
 				break;
 			};
 			points = oom_badness(task, memcg, NULL, totalpages);
-			if (points > chosen_points) {
-				if (chosen)
-					put_task_struct(chosen);
-				chosen = task;
-				chosen_points = points;
-				get_task_struct(chosen);
-			}
+			if (!points || points < chosen_points)
+				continue;
+			/* Prefer thread group leaders for display purposes */
+			if (points == chosen_points &&
+			    thread_group_leader(chosen))
+				continue;
+
+			if (chosen)
+				put_task_struct(chosen);
+			chosen = task;
+			chosen_points = points;
+			get_task_struct(chosen);
 		}
 		css_task_iter_end(&it);
 	}
diff -puN mm/oom_kill.c~mm-oom-prefer-thread-group-leaders-for-display-purposes mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-prefer-thread-group-leaders-for-display-purposes
+++ a/mm/oom_kill.c
@@ -327,10 +327,14 @@ static struct task_struct *select_bad_pr
 			break;
 		};
 		points = oom_badness(p, NULL, nodemask, totalpages);
-		if (points > chosen_points) {
-			chosen = p;
-			chosen_points = points;
-		}
+		if (!points || points < chosen_points)
+			continue;
+		/* Prefer thread group leaders for display purposes */
+		if (points == chosen_points && thread_group_leader(chosen))
+			continue;
+
+		chosen = p;
+		chosen_points = points;
 	}
 	if (chosen)
 		get_task_struct(chosen);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch
firmware-google-drop-select-efi-to-avoid-recursive-dependency.patch

