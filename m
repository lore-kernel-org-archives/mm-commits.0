From: akpm@linux-foundation.org
Subject: +
 mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch added to
 -mm tree
Date: Tue, 04 Aug 2015 16:24:58 -0700
Message-ID: <55c149ca.scrKifn+6asxEkYx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbbHDXY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 19:24:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: skip compound pages by order in free scanner
has been added to the -mm tree.  Its filename is
     mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: skip compound pages by order in free scanner

The compaction free scanner is looking for PageBuddy() pages and skipping
all others.  For large compound pages such as THP or hugetlbfs, we can
save a lot of iterations if we skip them at once using their
compound_order().  This is generally unsafe and we can read a bogus value
of order due to a race, but if we are careful, the only danger is skipping
too much.

When tested with stress-highalloc from mmtests on 4GB system with 1GB
hugetlbfs pages, the vmstat compact_free_scanned count decreased by at
least 15%.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN mm/compaction.c~mm-compaction-skip-compound-pages-by-order-in-free-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-compound-pages-by-order-in-free-scanner
+++ a/mm/compaction.c
@@ -437,6 +437,24 @@ static unsigned long isolate_freepages_b
 
 		if (!valid_page)
 			valid_page = page;
+
+		/*
+		 * For compound pages such as THP and hugetlbfs, we can save
+		 * potentially a lot of iterations if we skip them at once.
+		 * The check is racy, but we can consider only valid values
+		 * and the only danger is skipping too much.
+		 */
+		if (PageCompound(page)) {
+			unsigned int comp_order = compound_order(page);
+
+			if (likely(comp_order < MAX_ORDER)) {
+				blockpfn += (1UL << comp_order) - 1;
+				cursor += (1UL << comp_order) - 1;
+			}
+
+			goto isolate_fail;
+		}
+
 		if (!PageBuddy(page))
 			goto isolate_fail;
 
@@ -496,6 +514,13 @@ isolate_fail:
 
 	}
 
+	/*
+	 * There is a tiny chance that we have read bogus compound_order(),
+	 * so be careful to not go outside of the pageblock.
+	 */
+	if (unlikely(blockpfn > end_pfn))
+		blockpfn = end_pfn;
+
 	trace_mm_compaction_isolate_freepages(*start_pfn, blockpfn,
 					nr_scanned, total_isolated);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-dont-wait-for-high-order-page-allocation.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-rename-and-move-get-set_freepage_migratetype-v2.patch
mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-vmscan-never-isolate-more-pages-than-necessary.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
linux-next.patch

