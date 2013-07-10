From: akpm@linux-foundation.org
Subject: [-] mm-add-vm-event-counters-for-balloon-pages-compaction.patch
 removed from -mm tree
Date: Wed, 10 Jul 2013 13:25:09 -0700
Message-ID: <51ddc325.lm9x2dC0tUQ00tIH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3GJUZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 16:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, riel@redhat.com, mst@redhat.com, minchan@kernel.org, mel@csn.ul.ie, konrad.wilk@oracle.com, andi@firstfloor.org, aquini@redhat.com

Subject: [-] mm-add-vm-event-counters-for-balloon-pages-compaction.patch removed from -mm tree
To: aquini@redhat.com,andi@firstfloor.org,konrad.wilk@oracle.com,mel@csn.ul.ie,minchan@kernel.org,mst@redhat.com,riel@redhat.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 13:25:09 -0700


The patch titled
     Subject: mm: add vm event counters for balloon pages compaction
has been removed from the -mm tree.  Its filename was
     mm-add-vm-event-counters-for-balloon-pages-compaction.patch

This patch was dropped because it has gone stale

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: add vm event counters for balloon pages compaction

Introduce a new set of vm event counters to keep track of ballooned pages
compaction activity.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    7 +++++++
 include/linux/vm_event_item.h      |    7 ++++++-
 mm/balloon_compaction.c            |    2 ++
 mm/migrate.c                       |    1 +
 mm/vmstat.c                        |    9 ++++++++-
 5 files changed, 24 insertions(+), 2 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-add-vm-event-counters-for-balloon-pages-compaction include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/include/linux/balloon_compaction.h
@@ -213,8 +213,15 @@ static inline bool balloon_compaction_ch
 	return true;
 }
 
+static inline void balloon_event_count(enum vm_event_item item)
+{
+	count_vm_event(item);
+}
 #else /* !CONFIG_BALLOON_COMPACTION */
 
+/* A macro, to avoid generating references to the undefined COMPACTBALLOON* */
+#define balloon_event_count(item) do { } while (0)
+
 static inline void *balloon_mapping_alloc(void *balloon_device,
 				const struct address_space_operations *a_ops)
 {
diff -puN include/linux/vm_event_item.h~mm-add-vm-event-counters-for-balloon-pages-compaction include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/include/linux/vm_event_item.h
@@ -50,7 +50,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		COMPACTMIGRATE_SCANNED, COMPACTFREE_SCANNED,
 		COMPACTISOLATED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
-#endif
+#ifdef CONFIG_BALLOON_COMPACTION
+		COMPACTBALLOONISOLATED, /* isolated from balloon pagelist */
+		COMPACTBALLOONMIGRATED, /* balloon page sucessfully migrated */
+		COMPACTBALLOONRETURNED, /* putback to pagelist, not-migrated */
+#endif /* CONFIG_BALLOON_COMPACTION */
+#endif /* CONFIG_COMPACTION */
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
diff -puN mm/balloon_compaction.c~mm-add-vm-event-counters-for-balloon-pages-compaction mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/mm/balloon_compaction.c
@@ -242,6 +242,7 @@ bool balloon_page_isolate(struct page *p
 			if (__is_movable_balloon_page(page) &&
 			    page_count(page) == 2) {
 				__isolate_balloon_page(page);
+				balloon_event_count(COMPACTBALLOONISOLATED);
 				unlock_page(page);
 				return true;
 			}
@@ -265,6 +266,7 @@ void balloon_page_putback(struct page *p
 		__putback_balloon_page(page);
 		/* drop the extra ref count taken for page isolation */
 		put_page(page);
+		balloon_event_count(COMPACTBALLOONRETURNED);
 	} else {
 		WARN_ON(1);
 		dump_page(page);
diff -puN mm/migrate.c~mm-add-vm-event-counters-for-balloon-pages-compaction mm/migrate.c
--- a/mm/migrate.c~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/mm/migrate.c
@@ -889,6 +889,7 @@ static int unmap_and_move(new_page_t get
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				    page_is_file_cache(page));
 		balloon_page_free(page);
+		balloon_event_count(COMPACTBALLOONMIGRATED);
 		return MIGRATEPAGE_SUCCESS;
 	}
 out:
diff -puN mm/vmstat.c~mm-add-vm-event-counters-for-balloon-pages-compaction mm/vmstat.c
--- a/mm/vmstat.c~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/mm/vmstat.c
@@ -794,7 +794,14 @@ const char * const vmstat_text[] = {
 	"compact_stall",
 	"compact_fail",
 	"compact_success",
-#endif
+
+#ifdef CONFIG_BALLOON_COMPACTION
+	"compact_balloon_isolated",
+	"compact_balloon_migrated",
+	"compact_balloon_returned",
+#endif /* CONFIG_BALLOON_COMPACTION */
+
+#endif /* CONFIG_COMPACTION */
 
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
_

Patches currently in -mm which might be from aquini@redhat.com are

origin.patch
linux-next.patch

