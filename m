From: akpm@linux-foundation.org
Subject: + mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch added to -mm tree
Date: Fri, 17 Feb 2012 16:12:10 -0800
Message-ID: <20120218001211.2417EA030C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:38896 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2BRAMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 19:12:12 -0500
Received: by ggnp1 with SMTP id p1so494358ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 16:12:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, mel@csn.ul.ie


The patch titled
     Subject: mm: move buffer_heads_over_limit check up
has been added to the -mm tree.  Its filename is
     mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: move buffer_heads_over_limit check up

Not a functional change, just a minor internal cleanup: move the
buffer_heads_over_limit processing up from move_active_pages_to_lru()
(where it has to drop lock and reloop) to its caller shrink_active_list().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix
+++ a/mm/vmscan.c
@@ -1642,18 +1642,6 @@ static void move_active_pages_to_lru(str
 	unsigned long pgmoved = 0;
 	struct page *page;
 
-	if (buffer_heads_over_limit) {
-		spin_unlock_irq(&zone->lru_lock);
-		list_for_each_entry(page, list, lru) {
-			if (page_has_private(page) && trylock_page(page)) {
-				if (page_has_private(page))
-					try_to_release_page(page, 0);
-				unlock_page(page);
-			}
-		}
-		spin_lock_irq(&zone->lru_lock);
-	}
-
 	while (!list_empty(list)) {
 		struct lruvec *lruvec;
 
@@ -1735,6 +1723,13 @@ static void shrink_active_list(unsigned 
 			continue;
 		}
 
+		if (buffer_heads_over_limit &&
+		    page_has_private(page) && trylock_page(page)) {
+			if (page_has_private(page))
+				try_to_release_page(page, 0);
+			unlock_page(page);
+		}
+
 		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
 			nr_rotated += hpage_nr_pages(page);
 			/*
_
Subject: Subject: mm: move buffer_heads_over_limit check up

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prio_tree-debugging-patch.patch

