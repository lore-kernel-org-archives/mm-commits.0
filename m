From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-do-not-compact-pgdat-for-order-0.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:37 -0700
Message-ID: <523219a5.wEafs92Lfb3qQSk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3ILToi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, dhillf@gmail.com, mgorman@suse.de

Subject: [merged] mm-compaction-do-not-compact-pgdat-for-order-0.patch removed from -mm tree
To: mgorman@suse.de,dhillf@gmail.com,minchan@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:37 -0700


The patch titled
     Subject: mm: compaction: do not compact pgdat for order-0
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-compact-pgdat-for-order-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: do not compact pgdat for order-0

If kswapd was reclaiming for a high order and resets it to 0 due to
fragmentation it will still call compact_pgdat.  For the most part, this
will fail a compaction_suitable() test and not compact but it is
unnecessarily sloppy.  It could be fixed in the caller but fix it in the
API instead.

[dhillf@gmail.com: pointed out that it was a potential problem]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <dhillf@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/compaction.c~mm-compaction-do-not-compact-pgdat-for-order-0 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-compact-pgdat-for-order-0
+++ a/mm/compaction.c
@@ -1131,6 +1131,9 @@ void compact_pgdat(pg_data_t *pgdat, int
 		.sync = false,
 	};
 
+	if (!order)
+		return;
+
 	__compact_pgdat(pgdat, &cc);
 }
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch

