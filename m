From: akpm@linux-foundation.org
Subject: + mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
 added to -mm tree
Date: Tue, 21 Jan 2014 11:26:07 -0800
Message-ID: <52dec9cf.2djkKUyuq6VpcuYw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaAUT0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, rientjes@google.com

Subject: + mm-oom-prefer-thread-group-leaders-for-display-purposes.patch added to -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:26:07 -0800


The patch titled
     Subject: mm, oom: prefer thread group leaders for display purposes
has been added to the -mm tree.  Its filename is
     mm-oom-prefer-thread-group-leaders-for-display-purposes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-prefer-thread-group-leaders-for-display-purposes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 ++++++++++++-------
 mm/oom_kill.c   |   12 ++++++++----
 2 files changed, 20 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~mm-oom-prefer-thread-group-leaders-for-display-purposes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-prefer-thread-group-leaders-for-display-purposes
+++ a/mm/memcontrol.c
@@ -1800,13 +1800,18 @@ static void mem_cgroup_out_of_memory(str
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
+			if (points < chosen_points)
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
+		if (points < chosen_points)
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
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch
mm-make-setpage_address-static-inline-if-want_page_virtual.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
x86-mm-memblock-switch-to-use-numa_no_node.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-nobootmem-free_all_bootmem-again-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
linux-next.patch

