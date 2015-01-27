From: akpm@linux-foundation.org
Subject: [merged]
 memcg-remove-extra-newlines-from-memcg-oom-kill-log.patch removed from -mm
 tree
Date: Tue, 27 Jan 2015 12:22:31 -0800
Message-ID: <54c7f387.2WHEaWaYksxeMhmq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbbA0UWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 15:22:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove extra newlines from memcg oom kill log
has been removed from the -mm tree.  Its filename was
     memcg-remove-extra-newlines-from-memcg-oom-kill-log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: remove extra newlines from memcg oom kill log

Commit e61734c55c24 ("cgroup: remove cgroup->name") added two extra
newlines to memcg oom kill log messages.  This makes dmesg hard to read
and parse.  The issue affects 3.15+.

Example:
  Task in /t                          <<< extra #1
   killed as a result of limit of /t
                                      <<< extra #2
  memory: usage 102400kB, limit 102400kB, failcnt 274712

Remove the extra newlines from memcg oom kill messages, so the messages
look like:
  Task in /t killed as a result of limit of /t
  memory: usage 102400kB, limit 102400kB, failcnt 240649

Fixes: e61734c55c24 ("cgroup: remove cgroup->name")
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-extra-newlines-from-memcg-oom-kill-log mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-extra-newlines-from-memcg-oom-kill-log
+++ a/mm/memcontrol.c
@@ -1477,9 +1477,9 @@ void mem_cgroup_print_oom_info(struct me
 
 	pr_info("Task in ");
 	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
-	pr_info(" killed as a result of limit of ");
+	pr_cont(" killed as a result of limit of ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
-	pr_info("\n");
+	pr_cont("\n");
 
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch

