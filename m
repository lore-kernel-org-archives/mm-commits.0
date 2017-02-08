From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix.patch
 added to -mm tree
Date: Wed, 08 Feb 2017 13:38:50 -0800
Message-ID: <589b8fea.RsG/iUsVj9c9kyJF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbdBHViv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 16:38:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: only use per-cpu allocator for irq-safe requests -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: only use per-cpu allocator for irq-safe requests -fix

preempt_enable_no_resched() was used based on review feedback that had
no strong objection at the time. The thinking was that it avoided adding
a preemption point where one didn't exist before so the feedback was
applied. This reasoning was wrong.

There was an indirect preemption point as explained by Thomas Gleixner where
an interrupt could set_need_resched() followed by preempt_enable being
a preemption point that matters. This use of preempt_enable_no_resched
is bad from both a mainline and RT perspective and a violation of the
preemption mechanism. Peter Zijlstra noted that "the only acceptable use
of preempt_enable_no_resched() is if the next statement is a schedule()
variant".

The usage was outright broken and I should have stuck to preempt_enable()
as it was originally developed. It's known from previous tests
that there was no detectable difference to the performance by using
preempt_enable_no_resched().

This is a fix to the mmotm patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests.patch

Link: http://lkml.kernel.org/r/20170208143128.25ahymqlyspjcixu@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix
+++ a/mm/page_alloc.c
@@ -2517,7 +2517,7 @@ void free_hot_cold_page(struct page *pag
 	}
 
 out:
-	preempt_enable_no_resched();
+	preempt_enable();
 }
 
 /*
@@ -2683,7 +2683,7 @@ static struct page *rmqueue_pcplist(stru
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone);
 	}
-	preempt_enable_no_resched();
+	preempt_enable();
 	return page;
 }
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-buffered_rmqueue.patch
mm-page_alloc-split-buffered_rmqueue-fix.patch
mm-page_alloc-split-alloc_pages_nodemask.patch
mm-page_alloc-drain-per-cpu-pages-from-workqueue-context.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix.patch
mm-page_alloc-only-use-per-cpu-allocator-for-irq-safe-requests-fix-v2.patch
mm-page_alloc-use-static-global-work_struct-for-draining-per-cpu-pages.patch

