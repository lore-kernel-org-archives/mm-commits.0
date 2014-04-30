From: akpm@linux-foundation.org
Subject: + memcg-document-memorylow_limit_in_bytes.patch added to -mm tree
Date: Wed, 30 Apr 2014 14:56:46 -0700
Message-ID: <5361719e.yyNdmH0GBJVh/zzI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965228AbaD3V4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 17:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: + memcg-document-memorylow_limit_in_bytes.patch added to -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 14:56:46 -0700


The patch titled
     Subject: memcg: document memory.low_limit_in_bytes
has been added to the -mm tree.  Its filename is
     memcg-document-memorylow_limit_in_bytes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-document-memorylow_limit_in_bytes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-document-memorylow_limit_in_bytes.patch

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
Subject: memcg: document memory.low_limit_in_bytes

Describe low_limit_in_bytes and its effect.

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

 Documentation/cgroups/memory.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-document-memorylow_limit_in_bytes Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-document-memorylow_limit_in_bytes
+++ a/Documentation/cgroups/memory.txt
@@ -57,6 +57,7 @@ Brief summary of control files.
  memory.memsw.usage_in_bytes	 # show current res_counter usage for memory+Swap
 				 (See 5.5 for details)
  memory.limit_in_bytes		 # set/show limit of memory usage
+ memory.low_limit_in_bytes	 # set/show low limit for memory reclaim
  memory.memsw.limit_in_bytes	 # set/show limit of memory+Swap usage
  memory.failcnt			 # show the number of memory usage hits limits
  memory.memsw.failcnt		 # show the number of memory+Swap hits limits
@@ -249,6 +250,14 @@ is the objective of the reclaim. The glo
 zones' watermarks while the limit reclaim frees some memory to allow new
 charges.
 
+Groups might be also protected from both global and limit reclaim by
+low_limit_in_bytes knob. If the limit is non-zero the reclaim logic
+doesn't include groups (and their subgroups - see 6. Hierarchy support)
+which are bellow the low limit if there is other eligible cgroup in the
+reclaimed hierarchy. If all groups which participate reclaim are under
+their low limits then all of them are reclaimed and the low limit is
+ignored.
+
 NOTE: Hard limit reclaim does not work for the root cgroup, since we cannot set
 any limits on the root cgroup.
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

slub-fix-memcg_propagate_slab_attrs.patch
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
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-document-memorylow_limit_in_bytes.patch

