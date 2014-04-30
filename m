From: akpm@linux-foundation.org
Subject: + memcg-allow-setting-low_limit.patch added to -mm tree
Date: Wed, 30 Apr 2014 14:56:43 -0700
Message-ID: <5361719b.lKtc/6bDXKrFVr4a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041AbaD3V4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 17:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: + memcg-allow-setting-low_limit.patch added to -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 14:56:43 -0700


The patch titled
     Subject: memcg: allow setting low_limit
has been added to the -mm tree.  Its filename is
     memcg-allow-setting-low_limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-allow-setting-low_limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-allow-setting-low_limit.patch

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
Subject: memcg: allow setting low_limit

Export memory.low_limit_in_bytes knob with the same rules as the hard
limit represented by limit_in_bytes knob (e.g.  no limit to be set for the
root cgroup).  There is no memsw alternative for low_limit_in_bytes
because the primary motivation behind this limit is to protect the working
set of the group and so considering swap doesn't make much sense.  There
is also no kmem variant exported because we do not have any easy way to
protect kernel allocations now.

Please note that the low limit might exceed the hard limit which basically
means that the group is not reclaimable if there is other reclaim target
in the hierarchy under pressure.

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

 include/linux/res_counter.h |   13 +++++++++++++
 kernel/res_counter.c        |    2 ++
 mm/memcontrol.c             |   27 ++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff -puN include/linux/res_counter.h~memcg-allow-setting-low_limit include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-allow-setting-low_limit
+++ a/include/linux/res_counter.h
@@ -93,6 +93,7 @@ enum {
 	RES_LIMIT,
 	RES_FAILCNT,
 	RES_SOFT_LIMIT,
+	RES_LOW_LIMIT,
 };
 
 /*
@@ -246,5 +247,17 @@ res_counter_set_soft_limit(struct res_co
 	spin_unlock_irqrestore(&cnt->lock, flags);
 	return 0;
 }
+
+static inline int
+res_counter_set_low_limit(struct res_counter *cnt,
+				unsigned long long low_limit)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->low_limit = low_limit;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return 0;
+}
 
 #endif
diff -puN kernel/res_counter.c~memcg-allow-setting-low_limit kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-allow-setting-low_limit
+++ a/kernel/res_counter.c
@@ -136,6 +136,8 @@ res_counter_member(struct res_counter *c
 		return &counter->failcnt;
 	case RES_SOFT_LIMIT:
 		return &counter->soft_limit;
+	case RES_LOW_LIMIT:
+		return &counter->low_limit;
 	};
 
 	BUG();
diff -puN mm/memcontrol.c~memcg-allow-setting-low_limit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-allow-setting-low_limit
+++ a/mm/memcontrol.c
@@ -1695,8 +1695,9 @@ void mem_cgroup_print_oom_info(struct me
 
 	rcu_read_unlock();
 
-	pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
+	pr_info("memory: usage %llukB, low_limit %llukB limit %llukB, failcnt %llu\n",
 		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
+		res_counter_read_u64(&memcg->res, RES_LOW_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->res, RES_FAILCNT));
 	pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %llu\n",
@@ -5134,6 +5135,24 @@ static int mem_cgroup_write(struct cgrou
 		else
 			return -EINVAL;
 		break;
+	case RES_LOW_LIMIT:
+		if (mem_cgroup_is_root(memcg)) { /* Can't set limit on root */
+			ret = -EINVAL;
+			break;
+		}
+		ret = res_counter_memparse_write_strategy(buffer, &val);
+		if (ret)
+			break;
+		if (type == _MEM) {
+			ret = res_counter_set_low_limit(&memcg->res, val);
+			break;
+		}
+		/*
+		 * memsw low limit doesn't make any sense and kmem is not
+		 * implemented yet - if ever
+		 */
+		return -EINVAL;
+
 	case RES_SOFT_LIMIT:
 		ret = res_counter_memparse_write_strategy(buffer, &val);
 		if (ret)
@@ -6055,6 +6074,12 @@ static struct cftype mem_cgroup_files[]
 		.write_string = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+	{
+		.name = "low_limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEM, RES_LOW_LIMIT),
+		.write_string = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
 	{
 		.name = "soft_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
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

