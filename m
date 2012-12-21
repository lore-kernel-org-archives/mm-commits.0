From: akpm@linux-foundation.org
Subject: + mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix.patch added to -mm tree
Date: Fri, 21 Dec 2012 12:44:45 -0800
Message-ID: <20121221204445.88ACA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:58429 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2LUUoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:44:46 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so517207qch.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:44:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz


The patch titled
     Subject: mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix
has been added to the -mm tree.  Its filename is
     mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix.patch

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

origin.patch
mm-cond_resched-in-tlb_flush_mmu-to-fix-soft-lockups-on-config_preempt.patch
mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch
mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt.patch
mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix.patch
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
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

