From: akpm@linux-foundation.org
Subject: + memcg-deprecate-memoryforce_empty-knob.patch added to -mm tree
Date: Tue, 13 May 2014 14:40:05 -0700
Message-ID: <53729135.GlsPQXA8ntqVbvTH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbaEMVkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 17:40:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz

Subject: + memcg-deprecate-memoryforce_empty-knob.patch added to -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 14:40:05 -0700


The patch titled
     Subject: memcg: deprecate memory.force_empty knob
has been added to the -mm tree.  Its filename is
     memcg-deprecate-memoryforce_empty-knob.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-deprecate-memoryforce_empty-knob.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-deprecate-memoryforce_empty-knob.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: deprecate memory.force_empty knob

force_empty has been introduced primarily to drop memory before it gets
reparented on the group removal.  This alone doesn't sound fully justified
because reparented pages which are not in use can be reclaimed also later
when there is a memory pressure on the parent level.

Mark the knob CFTYPE_INSANE which tells the cgroup core that it shouldn't
create the knob with the experimental sane_behavior.  Other users will get
informed about the deprecation and asked to tell us more because I do not
expect most users will use sane_behavior cgroups mode very soon.

Anyway I expect that most users will be simply cgroup remove handlers
which do that since ever without having any good reason for it.

If somebody really cares because reparented pages, which would be dropped
otherwise, push out more important ones then we should fix the reparenting
code and put pages to the tail.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    3 +++
 mm/memcontrol.c                  |    5 +++++
 2 files changed, 8 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-deprecate-memoryforce_empty-knob Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-deprecate-memoryforce_empty-knob
+++ a/Documentation/cgroups/memory.txt
@@ -481,6 +481,9 @@ About use_hierarchy, see Section 6.
   write will still return success. In this case, it is expected that
   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
 
+  Please note that this knob is considered deprecated and will be removed
+  in future.
+
   About use_hierarchy, see Section 6.
 
 5.2 stat file
diff -puN mm/memcontrol.c~memcg-deprecate-memoryforce_empty-knob mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-deprecate-memoryforce_empty-knob
+++ a/mm/memcontrol.c
@@ -4799,6 +4799,10 @@ static int mem_cgroup_force_empty_write(
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
+	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
+			current->comm, task_pid_nr(current));
+	pr_cont(" Let us know if you know if it needed in your usecase at");
+	pr_cont(" linux-mm@kvack.org\n");
 	return mem_cgroup_force_empty(memcg);
 }
 
@@ -6043,6 +6047,7 @@ static struct cftype mem_cgroup_files[]
 	},
 	{
 		.name = "force_empty",
+		.flags = CFTYPE_INSANE,
 		.trigger = mem_cgroup_force_empty_write,
 	},
 	{
_

Patches currently in -mm which might be from mhocko@suse.cz are

slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
memcg-fold-mem_cgroup_stolen.patch
memcg-fold-mem_cgroup_stolen-fix.patch
memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch
memcg-get-rid-of-memcg_create_cache_name.patch
memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
linux-next.patch

