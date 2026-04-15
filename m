Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF72886334
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 05:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776231979; cv=none; b=dXUN+PqXUkBIXVeM8X8/zP2pcFSyIB6U4hCtt4AB9wIGIZ4SL64JHfvLxl6NhprveNj9HIA2tPkJj79za8M2bgaVSQZtVTIHqW19euXeu4cCwJoTs0WBbRe900+40rrPzfNqk4I6j1fzBr55fjQA7jLzD95Q3OkkQjYxW0srT9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776231979; c=relaxed/simple;
	bh=Hfuv+pl71XDwHDPnKRiW/MyUNsvjwCtFkIRQhchlaDI=;
	h=Date:To:From:Subject:Message-Id; b=Zd4RHNyliqu1jdg2z9A/Ay69PQPMUy7ru9lqwMPtdMM6eYeMBRGwPa20ydIZPTry49LbTaj4IDP8sjepvQSzUEHP4eGvo5YRcSgMU5CVTU4UMtnAFdms6qRdy+T5iE2qFOaEfCrvcO6uusgkEP7QQ19X30PSCwFoRcLfEiNWt68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjBWV+xN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjBWV+xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AD9C19424;
	Wed, 15 Apr 2026 05:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776231979;
	bh=Hfuv+pl71XDwHDPnKRiW/MyUNsvjwCtFkIRQhchlaDI=;
	h=Date:To:From:Subject:From;
	b=GjBWV+xNu6LasOzpoCLSEOA4YbHOyCbx4g+e0Zaj3GUin0WR7pnbGOwv8Ot/MgPNr
	 W9UZdng+QEgR5ciN+YICI9SDbdXz+x1MCw8GAWyOlDJhdKq290mLcVEwqhmmkkcr3w
	 22oNwTGBKlngXIoyVIRvLyHVHDE+fYPjLeVzkqQo=
Date: Tue, 14 Apr 2026 22:45:55 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,quic_charante@quicinc.com,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kasong@tencent.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-fix-race-on-mem_section-usage-in-pfn-walkers.patch added to mm-new branch
Message-Id: <20260415054619.07AD9C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: fix race on mem_section->usage in pfn walkers
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-fix-race-on-mem_section-usage-in-pfn-walkers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-fix-race-on-mem_section-usage-in-pfn-walkers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: fix race on mem_section->usage in pfn walkers
Date: Wed, 15 Apr 2026 10:23:26 +0800

When memory is hot-removed, section_deactivate() can tear down
mem_section->usage while concurrent pfn walkers still inspect the
subsection map via pfn_section_valid() or pfn_section_first_valid().

After commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
memory_section->usage") converted the teardown to an RCU-based scheme, the
code still relies on SECTION_HAS_MEM_MAP becoming visible to readers
before ms->usage is cleared and queued for freeing.

That ordering is not guaranteed.  section_deactivate() can clear ms->usage
and queue kfree_rcu() before another CPU observes the SECTION_HAS_MEM_MAP
clear.  A concurrent pfn walker can therefore see valid_section() return
true, enter its sched-RCU read-side critical section after kfree_rcu() has
already been queued, and then dereference a stale ms->usage pointer.

And pfn_to_online_page() can call pfn_section_valid() without its own
sched-RCU read-side critical section, which has similar problem.

The race looks like this:

  compact_zone()                    memunmap_pages
  ==============                    ==============
                                    __remove_pages()->
                                      sparse_remove_section()->
                                        section_deactivate():
                                          a) [ Clear SECTION_HAS_MEM_MAP
                                               is reordered to b) ]
                                          kfree_rcu(ms->usage)
      __pageblock_pfn_to_page
         ......
          pfn_valid():
            rcu_read_lock_sched()
            valid_section() // return true
            pfn_section_valid()
              [Access ms->usage which is UAF]
                                          WRITE_ONCE(ms->usage, NULL)
            rcu_read_unlock_sched()       b) Clear SECTION_HAS_MEM_MAP

Fix this by using rcu_replace_pointer() when clearing ms->usage in
section_deactivate(), then it does not rely on the order of clearing of
SECTION_HAS_MEM_MAP.

Link: https://lkml.kernel.org/r/20260415022326.53218-1-songmuchun@bytedance.com
Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 mm/memory_hotplug.c    |    6 +++++-
 mm/sparse-vmemmap.c    |    6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-fix-race-on-mem_section-usage-in-pfn-walkers
+++ a/include/linux/mmzone.h
@@ -2016,7 +2016,7 @@ struct mem_section {
 	 */
 	unsigned long section_mem_map;
 
-	struct mem_section_usage *usage;
+	struct mem_section_usage __rcu *usage;
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
@@ -2207,14 +2207,14 @@ static inline int subsection_map_index(u
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
 	int idx = subsection_map_index(pfn);
-	struct mem_section_usage *usage = READ_ONCE(ms->usage);
+	struct mem_section_usage *usage = rcu_dereference_sched(ms->usage);
 
 	return usage ? test_bit(idx, usage->subsection_map) : 0;
 }
 
 static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long *pfn)
 {
-	struct mem_section_usage *usage = READ_ONCE(ms->usage);
+	struct mem_section_usage *usage = rcu_dereference_sched(ms->usage);
 	int idx = subsection_map_index(*pfn);
 	unsigned long bit;
 
--- a/mm/memory_hotplug.c~mm-sparse-fix-race-on-mem_section-usage-in-pfn-walkers
+++ a/mm/memory_hotplug.c
@@ -340,6 +340,7 @@ struct page *pfn_to_online_page(unsigned
 	unsigned long nr = pfn_to_section_nr(pfn);
 	struct dev_pagemap *pgmap;
 	struct mem_section *ms;
+	bool valid;
 
 	if (nr >= NR_MEM_SECTIONS)
 		return NULL;
@@ -355,7 +356,10 @@ struct page *pfn_to_online_page(unsigned
 	if (IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) && !pfn_valid(pfn))
 		return NULL;
 
-	if (!pfn_section_valid(ms, pfn))
+	rcu_read_lock_sched();
+	valid = pfn_section_valid(ms, pfn);
+	rcu_read_unlock_sched();
+	if (!valid)
 		return NULL;
 
 	if (!online_device_section(ms))
--- a/mm/sparse-vmemmap.c~mm-sparse-fix-race-on-mem_section-usage-in-pfn-walkers
+++ a/mm/sparse-vmemmap.c
@@ -764,8 +764,10 @@ static void section_deactivate(unsigned
 		 * was allocated during boot.
 		 */
 		if (!PageReserved(virt_to_page(ms->usage))) {
-			kfree_rcu(ms->usage, rcu);
-			WRITE_ONCE(ms->usage, NULL);
+			struct mem_section_usage *usage;
+
+			usage = rcu_replace_pointer(ms->usage, NULL, true);
+			kfree_rcu(usage, rcu);
 		}
 		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-remove-dead-code-of-checking-parent-memory-cgroup.patch
mm-workingset-use-folio_lruvec-in-workingset_refault.patch
mm-rename-unlock_page_lruvec_irq-and-its-variants.patch
mm-vmscan-refactor-move_folios_to_lru.patch
mm-memcontrol-allocate-object-cgroup-for-non-kmem-case.patch
mm-memcontrol-return-root-object-cgroup-for-root-memory-cgroup.patch
mm-memcontrol-prevent-memory-cgroup-release-in-get_mem_cgroup_from_folio.patch
buffer-prevent-memory-cgroup-release-in-folio_alloc_buffers.patch
writeback-prevent-memory-cgroup-release-in-writeback-module.patch
mm-memcontrol-prevent-memory-cgroup-release-in-count_memcg_folio_events.patch
mm-page_io-prevent-memory-cgroup-release-in-page_io-module.patch
mm-migrate-prevent-memory-cgroup-release-in-folio_migrate_mapping.patch
mm-mglru-prevent-memory-cgroup-release-in-mglru.patch
mm-memcontrol-prevent-memory-cgroup-release-in-mem_cgroup_swap_full.patch
mm-workingset-prevent-memory-cgroup-release-in-lru_gen_eviction.patch
mm-workingset-prevent-lruvec-release-in-workingset_refault.patch
mm-zswap-prevent-lruvec-release-in-zswap_folio_swapin.patch
mm-swap-prevent-lruvec-release-in-lru_gen_clear_refs.patch
mm-workingset-prevent-lruvec-release-in-workingset_activation.patch
mm-memcontrol-prepare-for-reparenting-lru-pages-for-lruvec-lock.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-helpers.patch
mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path.patch
mm-sparse-fix-comment-for-section-map-alignment.patch
mm-sparse-fix-race-on-mem_section-usage-in-pfn-walkers.patch

