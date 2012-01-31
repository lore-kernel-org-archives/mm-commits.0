From: akpm@linux-foundation.org
Subject: + mm-compaction-check-pfn_valid-when-entering-a-new-max_order_nr_pages-block-during-isolation-for-migration.patch added to -mm tree
Date: Tue, 31 Jan 2012 12:40:38 -0800
Message-ID: <20120131204038.CDFFFA0159@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61933 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab2AaUkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 15:40:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, herbert.van.den.bergh@oracle.com, mina86@mina86.com, stable@vger.kernel.org


The patch titled
     Subject: mm: compaction: check pfn_valid when entering a new MAX_ORDER_NR_PAGES block during isolation for migration
has been added to the -mm tree.  Its filename is
     mm-compaction-check-pfn_valid-when-entering-a-new-max_order_nr_pages-block-during-isolation-for-migration.patch

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
Subject: mm: compaction: check pfn_valid when entering a new MAX_ORDER_NR_PAGES block during isolation for migration

When isolating for migration, migration starts at the start of a zone
which is not necessarily pageblock aligned.  Further, it stops isolating
when COMPACT_CLUSTER_MAX pages are isolated so migrate_pfn is generally
not aligned.

The problem is that pfn_valid is only called on the first PFN being
checked.  Lets say we have a case like this

H = MAX_ORDER_NR_PAGES boundary
| = pageblock boundary
m = cc->migrate_pfn
f = cc->free_pfn
o = memory hole

H------|------H------|----m-Hoooooo|ooooooH-f----|------H

The migrate_pfn is just below a memory hole and the free scanner is beyond
the hole.  When isolate_migratepages started, it scans from migrate_pfn to
migrate_pfn+pageblock_nr_pages which is now in a memory hole.  It checks
pfn_valid() on the first PFN but then scans into the hole where there are
not necessarily valid struct pages.

This patch ensures that isolate_migratepages calls pfn_valid when
necessary.

Reported-and-tested-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/compaction.c~mm-compaction-check-pfn_valid-when-entering-a-new-max_order_nr_pages-block-during-isolation-for-migration mm/compaction.c
--- a/mm/compaction.c~mm-compaction-check-pfn_valid-when-entering-a-new-max_order_nr_pages-block-during-isolation-for-migration
+++ a/mm/compaction.c
@@ -313,6 +313,19 @@ static isolate_migrate_t isolate_migrate
 		} else if (!locked)
 			spin_lock_irq(&zone->lru_lock);
 
+		/*
+		 * migrate_pfn does not necessarily start aligned to a
+		 * pageblock. Ensure that pfn_valid is called when moving
+		 * into a new MAX_ORDER_NR_PAGES range in case of large
+		 * memory holes within the zone
+		 */
+		if ((low_pfn & (MAX_ORDER_NR_PAGES - 1)) == 0) {
+			if (!pfn_valid(low_pfn)) {
+				low_pfn += MAX_ORDER_NR_PAGES - 1;
+				continue;
+			}
+		}
+
 		if (!pfn_valid_within(low_pfn))
 			continue;
 		nr_scanned++;
_
Subject: Subject: mm: compaction: check pfn_valid when entering a new MAX_ORDER_NR_PAGES block during isolation for migration

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-compaction-check-pfn_valid-when-entering-a-new-max_order_nr_pages-block-during-isolation-for-migration.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch

