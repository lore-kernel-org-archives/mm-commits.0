From: akpm@linux-foundation.org
Subject: + mm-migrate-check-page_count-of-thp-before-migrating-accounting-fix.patch added to -mm tree
Date: Thu, 10 Jan 2013 14:26:12 -0800
Message-ID: <20130110222613.46DF982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:40253 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab3AJW0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jan 2013 17:26:14 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so136436yhr.2
        for <mm-commits@vger.kernel.org>; Thu, 10 Jan 2013 14:26:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, hughd@google.com


The patch titled
     Subject: mm: migrate: Check page_count of THP before migrating accounting fix
has been added to the -mm tree.  Its filename is
     mm-migrate-check-page_count-of-thp-before-migrating-accounting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: migrate: Check page_count of THP before migrating accounting fix

As pointed out by Hugh Dickins, "mm: migrate: Check page_count of THP
before migrating" can leave nr_isolated_anon elevated, correct it. This
is a fix to mm-migrate-check-page_count-of-thp-before-migrating.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-check-page_count-of-thp-before-migrating-accounting-fix mm/migrate.c
--- a/mm/migrate.c~mm-migrate-check-page_count-of-thp-before-migrating-accounting-fix
+++ a/mm/migrate.c
@@ -1689,8 +1689,11 @@ int migrate_misplaced_transhuge_page(str
 	if (!isolated || page_count(page) != 2) {
 		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 		put_page(new_page);
-		if (isolated)
+		if (isolated) {
 			putback_lru_page(page);
+			isolated = 0;
+			goto out;
+		}
 		goto out_keep_locked;
 	}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-migrate-check-page_count-of-thp-before-migrating.patch
mm-migrate-check-page_count-of-thp-before-migrating-accounting-fix.patch
mm-compaction-fix-echo-1-compact_memory-return-error-issue.patch
mm-use-aligned-zone-start-for-pfn_to_bitidx-calculation.patch
mm-thp-acquire-the-anon_vma-rwsem-for-write-during-split.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
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
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mmksm-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-memmap_init_zone-performance-improvement.patch

