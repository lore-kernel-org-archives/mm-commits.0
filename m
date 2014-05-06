From: akpm@linux-foundation.org
Subject: + memcg-doc-clarify-global-vs-limit-reclaims-fix.patch added to
 -mm tree
Date: Tue, 06 May 2014 13:13:03 -0700
Message-ID: <5369424f.M7/Wu/OsR+R5/bcm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaEFUNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 16:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: + memcg-doc-clarify-global-vs-limit-reclaims-fix.patch added to -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 13:13:03 -0700


The patch titled
     Subject: memcg-doc-clarify-global-vs-limit-reclaims-fix
has been added to the -mm tree.  Its filename is
     memcg-doc-clarify-global-vs-limit-reclaims-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-doc-clarify-global-vs-limit-reclaims-fix.patch

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
Subject: memcg-doc-clarify-global-vs-limit-reclaims-fix

update doc as per Johannes

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-doc-clarify-global-vs-limit-reclaims-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-doc-clarify-global-vs-limit-reclaims-fix
+++ a/Documentation/cgroups/memory.txt
@@ -241,17 +241,9 @@ global VM. Cgroups can get reclaimed bas
    proportionally wrt. their LRU size in a round robin fashion
  - when a cgroup or its hierarchical parent (see 6. Hierarchical support)
    hits hard limit. If the reclaim is unsuccessful, an OOM routine is invoked
-   to select and kill the bulkiest task in the cgroup. (See 10. OOM Control
+   to select and kill the bulkiest task in the hiearchy. (See 10. OOM Control
    below.)
 
-Global and hard-limit reclaims share the same code the only difference
-is the objective of the reclaim. The global reclaim aims at balancing
-zones' watermarks while the limit reclaim frees some memory to allow new
-charges.
-
-NOTE: Hard limit reclaim does not work for the root cgroup, since we cannot set
-any limits on the root cgroup.
-
 Note2: When panic_on_oom is set to "2", the whole system will panic.
 
 When oom event notifier is registered, event will be delivered to the root
_

Patches currently in -mm which might be from mhocko@suse.cz are

slub-fix-memcg_propagate_slab_attrs.patch
mmwriteback-fix-divide-by-zero-in-pos_ratio_polynom.patch
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
linux-next.patch

