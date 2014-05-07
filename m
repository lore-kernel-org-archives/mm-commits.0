From: akpm@linux-foundation.org
Subject: +
 mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
 added to -mm tree
Date: Wed, 07 May 2014 14:20:47 -0700
Message-ID: <536aa3af.h16u7RTBfQZaSISv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaEGVUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:20:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, gthelen@google.com, rientjes@google.com

Subject: + mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch added to -mm tree
To: rientjes@google.com,gthelen@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:20:47 -0700


The patch titled
     Subject: mm, compaction: return failed migration target pages back to freelist
has been added to the -mm tree.  Its filename is
     mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: return failed migration target pages back to freelist

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
@@ -787,23 +787,32 @@ static struct page *compaction_alloc(str
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
@@ -1013,8 +1022,8 @@ static int compact_zone(struct zone *zon
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

mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

