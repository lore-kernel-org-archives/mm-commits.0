From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:43 -0700
Message-ID: <5390ca4f.xsVG+yhtUmDeepRj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaFETvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, gthelen@google.com, rientjes@google.com

Subject: [merged] mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch removed from -mm tree
To: rientjes@google.com,gthelen@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:43 -0700


The patch titled
     Subject: mm, compaction: return failed migration target pages back to freelist
has been removed from the -mm tree.  Its filename was
     mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: return failed migration target pages back to freelist

Greg reported that he found isolated free pages were returned back to the
VM rather than the compaction freelist.  This will cause holes behind the
free scanner and cause it to reallocate additional memory if necessary
later.

He detected the problem at runtime seeing that ext4 metadata pages (esp
the ones read by "sbi->s_group_desc[i] = sb_bread(sb, block)") were
constantly visited by compaction calls of migrate_pages().  These pages
had a non-zero b_count which caused fallback_migrate_page() ->
try_to_release_page() -> try_to_free_buffers() to fail.



Memory compaction works by having a "freeing scanner" scan from one end of
a zone which isolates pages as migration targets while another "migrating
scanner" scans from the other end of the same zone which isolates pages
for migration.

When page migration fails for an isolated page, the target page is
returned to the system rather than the freelist built by the freeing
scanner.  This may require the freeing scanner to continue scanning memory
after suitable migration targets have already been returned to the system
needlessly.

This patch returns destination pages to the freeing scanner freelist when
page migration fails.  This prevents unnecessary work done by the freeing
scanner but also encourages memory to be as compacted as possible at the
end of the zone.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Greg Thelen <gthelen@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN mm/compaction.c~mm-compaction-return-failed-migration-target-pages-back-to-freelist mm/compaction.c
--- a/mm/compaction.c~mm-compaction-return-failed-migration-target-pages-back-to-freelist
+++ a/mm/compaction.c
@@ -790,23 +790,32 @@ static struct page *compaction_alloc(str
 }
 
 /*
- * We cannot control nr_migratepages and nr_freepages fully when migration is
- * running as migrate_pages() has no knowledge of compact_control. When
- * migration is complete, we count the number of pages on the lists by hand.
+ * This is a migrate-callback that "frees" freepages back to the isolated
+ * freelist.  All pages on the freelist are from the same zone, so there is no
+ * special handling needed for NUMA.
+ */
+static void compaction_free(struct page *page, unsigned long data)
+{
+	struct compact_control *cc = (struct compact_control *)data;
+
+	list_add(&page->lru, &cc->freepages);
+	cc->nr_freepages++;
+}
+
+/*
+ * We cannot control nr_migratepages fully when migration is running as
+ * migrate_pages() has no knowledge of of compact_control.  When migration is
+ * complete, we count the number of pages on the list by hand.
  */
 static void update_nr_listpages(struct compact_control *cc)
 {
 	int nr_migratepages = 0;
-	int nr_freepages = 0;
 	struct page *page;
 
 	list_for_each_entry(page, &cc->migratepages, lru)
 		nr_migratepages++;
-	list_for_each_entry(page, &cc->freepages, lru)
-		nr_freepages++;
 
 	cc->nr_migratepages = nr_migratepages;
-	cc->nr_freepages = nr_freepages;
 }
 
 /* possible outcome of isolate_migratepages */
@@ -1016,8 +1025,8 @@ static int compact_zone(struct zone *zon
 		}
 
 		nr_migrate = cc->nr_migratepages;
-		err = migrate_pages(&cc->migratepages, compaction_alloc, NULL,
-				(unsigned long)cc,
+		err = migrate_pages(&cc->migratepages, compaction_alloc,
+				compaction_free, (unsigned long)cc,
 				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
 				MR_COMPACTION);
 		update_nr_listpages(cc);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

