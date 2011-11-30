From: akpm@linux-foundation.org
Subject: + mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch added to -mm tree
Date: Wed, 30 Nov 2011 15:01:29 -0800
Message-ID: <201111302301.pAUN1TCa028903@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61135 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1K3XBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 18:01:32 -0500
Received: by yenq8 with SMTP id q8so22247yen.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 15:01:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: memcg: lookup_page_cgroup (almost) never returns NULL
has been added to the -mm tree.  Its filename is
     mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: lookup_page_cgroup (almost) never returns NULL

Pages have their corresponding page_cgroup descriptors set up before they
are used in userspace, and thus managed by a memory cgroup.

The only time where lookup_page_cgroup() can return NULL is in the
CONFIG_DEBUG_VM-only page sanity checking code that executes while feeding
pages into the page allocator for the first time.

Remove the NULL checks against lookup_page_cgroup() results from all
callsites where we know that corresponding page_cgroup descriptors must be
allocated, and add a comment to the callsite that actually does have to
check the return value.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-lookup_page_cgroup-almost-never-returns-null mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-lookup_page_cgroup-almost-never-returns-null
+++ a/mm/memcontrol.c
@@ -1894,9 +1894,6 @@ void mem_cgroup_update_page_stat(struct 
 	bool need_unlock = false;
 	unsigned long uninitialized_var(flags);
 
-	if (unlikely(!pc))
-		return;
-
 	rcu_read_lock();
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
@@ -2669,8 +2666,6 @@ static int mem_cgroup_charge_common(stru
 	}
 
 	pc = lookup_page_cgroup(page);
-	BUG_ON(!pc); /* XXX: remove this and move pc lookup into commit */
-
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret || !memcg)
 		return ret;
@@ -2942,7 +2937,7 @@ __mem_cgroup_uncharge_common(struct page
 	 * Check if our page_cgroup is valid
 	 */
 	pc = lookup_page_cgroup(page);
-	if (unlikely(!pc || !PageCgroupUsed(pc)))
+	if (unlikely(!PageCgroupUsed(pc)))
 		return NULL;
 
 	lock_page_cgroup(pc);
@@ -3326,6 +3321,10 @@ static struct page_cgroup *lookup_page_c
 	struct page_cgroup *pc;
 
 	pc = lookup_page_cgroup(page);
+	/*
+	 * Can be NULL while feeding pages into the page allocator for
+	 * the first time, i.e. during boot or memory hotplug.
+	 */
 	if (likely(pc) && PageCgroupUsed(pc))
 		return pc;
 	return NULL;
_
Subject: Subject: mm: memcg: lookup_page_cgroup (almost) never returns NULL

Patches currently in -mm which might be from jweiner@redhat.com are

mm-add-extra-free-kbytes-tunable.patch
mm-migrate-one-less-atomic-operation.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch

