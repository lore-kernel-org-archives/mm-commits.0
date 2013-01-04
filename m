From: akpm@linux-foundation.org
Subject: [folded-merged] mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix.patch removed from -mm tree
Date: Fri, 04 Jan 2013 15:19:55 -0800
Message-ID: <20130104231955.7DFCC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:56673 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab3ADXT4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jan 2013 18:19:56 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so1815703ggm.4
        for <mm-commits@vger.kernel.org>; Fri, 04 Jan 2013 15:19:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix
has been removed from the -mm tree.  Its filename was
     mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix.patch

This patch was dropped because it was folded into mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix mm/memory.c
--- a/mm/memory.c~mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix
+++ a/mm/memory.c
@@ -220,6 +220,7 @@ void tlb_gather_mmu(struct mmu_gather *t
 	tlb->local.nr   = 0;
 	tlb->local.max  = ARRAY_SIZE(tlb->__pages);
 	tlb->active     = &tlb->local;
+	tlb->batch_count = 0;
 
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb->batch = NULL;
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch
mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

