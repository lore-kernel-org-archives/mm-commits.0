From: akpm@linux-foundation.org
Subject: +
 mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch added to
 -mm tree
Date: Tue, 21 Jan 2014 16:18:46 -0800
Message-ID: <52df0e66.4I7W9crnhLrruIPE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaAVASr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 19:18:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, gthelen@google.com, rientjes@google.com

Subject: + mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch added to -mm tree
To: rientjes@google.com,gthelen@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 16:18:46 -0800


The patch titled
     Subject: mm, oom: prefer thread group leaders for display purposes fix
has been added to the -mm tree.  Its filename is
     mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch

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
@@ -1800,7 +1800,7 @@ static void mem_cgroup_out_of_memory(str
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
mm-make-setpage_address-static-inline-if-want_page_virtual.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
x86-mm-memblock-switch-to-use-numa_no_node.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-remove-bug_on-from-mlock_vma_page.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-nobootmem-free_all_bootmem-again-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes.patch
mm-oom-prefer-thread-group-leaders-for-display-purposes-fix.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
linux-next.patch

