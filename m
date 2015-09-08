From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:42:30 -0700
Message-ID: <55ef5646.txREGBOG0RZTrVyS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbbIHVmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix.patch

This patch was dropped because it was folded into mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix
+++ a/mm/page_alloc.c
@@ -788,7 +788,11 @@ static void free_pcppages_bulk(struct zo
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
+
 			mt = get_freepage_migratetype(page);
+			/* MIGRATE_ISOLATE page should not go to pcplists */
+			VM_BUG_ON_PAGE(is_migrate_isolate(mt), page);
+			/* Pageblock could have been isolated meanwhile */
 			if (unlikely(has_isolate_pageblock(zone)))
 				mt = get_pageblock_migratetype(page);
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-rename-and-move-get-set_freepage_migratetype-v2.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
mm-rename-alloc_pages_exact_node-to-__alloc_pages_node.patch
mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch
mm-use-numa_mem_id-in-alloc_pages_node.patch

