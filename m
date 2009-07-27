From: akpm@linux-foundation.org
Subject: + mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch added to -mm tree
Date: Mon, 27 Jul 2009 15:35:50 -0700
Message-ID: <200907272235.n6RMZoQT015893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957AbZG0Wgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 18:36:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, hannes@cmpxchg.org


The patch titled
     mm: warn once when a page is freed with PG_mlocked set
has been added to the -mm tree.  Its filename is
     mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

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
Subject: mm: warn once when a page is freed with PG_mlocked set
From: Mel Gorman <mel@csn.ul.ie>

When a page is freed with the PG_mlocked set, it is considered an
unexpected but recoverable situation.  A counter records how often this
event happens but it is easy to miss that this event has occured at
all.  This patch warns once when PG_mlocked is set to prompt debuggers
to check the counter to see how often it is happening.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/page_alloc.c~mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set mm/page_alloc.c
--- a/mm/page_alloc.c~mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set
+++ a/mm/page_alloc.c
@@ -488,6 +488,11 @@ static inline void __free_one_page(struc
  */
 static inline void free_page_mlock(struct page *page)
 {
+	WARN_ONCE(1, KERN_WARNING
+		"Page flag mlocked set for process %s at pfn:%05lx\n"
+		"page:%p flags:%#lx\n",
+		current->comm, page_to_pfn(page),
+		page, page->flags|__PG_MLOCKED);
 	__dec_zone_page_state(page, NR_MLOCK);
 	__count_vm_event(UNEVICTABLE_MLOCKFREED);
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
mm-avoid-endless-looping-for-oom-killed-tasks.patch
page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
profile-suppress-warning-about-large-allocations-when-profile=1-is-specified.patch
net-dccp-suppress-warning-about-large-allocations-from-dccp.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

