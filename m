From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-add-vm-event-counters-for-balloon-pages-compaction.patch removed from -mm tree
Date: Thu, 15 Nov 2012 11:57:29 -0800
Message-ID: <20121115195729.C469D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36603 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768751Ab2KOT5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 14:57:30 -0500
Received: by mail-gh0-f202.google.com with SMTP id z15so215328ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 11:57:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, andi@firstfloor.org, konrad.wilk@oracle.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add vm event counters for balloon pages compaction
has been removed from the -mm tree.  Its filename was
     mm-add-vm-event-counters-for-balloon-pages-compaction.patch

This patch was dropped because an updated version will be merged

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

 drivers/virtio/virtio_balloon.c |    1 +
 include/linux/vm_event_item.h   |    8 +++++++-
 mm/balloon_compaction.c         |    2 ++
 mm/migrate.c                    |    1 +
 mm/vmstat.c                     |   10 +++++++++-
 5 files changed, 20 insertions(+), 2 deletions(-)

diff -puN drivers/virtio/virtio_balloon.c~mm-add-vm-event-counters-for-balloon-pages-compaction drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/drivers/virtio/virtio_balloon.c
@@ -404,6 +404,7 @@ int virtballoon_migratepage(struct addre
 	tell_host(vb, vb->deflate_vq);
 
 	mutex_unlock(&vb->balloon_lock);
+	balloon_event_count(COMPACTBALLOONMIGRATED);
 
 	return MIGRATEPAGE_BALLOON_SUCCESS;
 }
diff -puN include/linux/vm_event_item.h~mm-add-vm-event-counters-for-balloon-pages-compaction include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/include/linux/vm_event_item.h
@@ -41,7 +41,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_COMPACTION
 		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
-#endif
+#ifdef CONFIG_BALLOON_COMPACTION
+		COMPACTBALLOONISOLATED, /* isolated from balloon pagelist */
+		COMPACTBALLOONMIGRATED, /* balloon page sucessfully migrated */
+		COMPACTBALLOONRELEASED, /* old-page released after migration */
+		COMPACTBALLOONRETURNED, /* putback to pagelist, not-migrated */
+#endif /* CONFIG_BALLOON_COMPACTION */
+#endif /* CONFIG_COMPACTION */
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
diff -puN mm/balloon_compaction.c~mm-add-vm-event-counters-for-balloon-pages-compaction mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/mm/balloon_compaction.c
@@ -215,6 +215,7 @@ bool balloon_page_isolate(struct page *p
 			if (__is_movable_balloon_page(page) &&
 			    page_count(page) == 2) {
 				__isolate_balloon_page(page);
+				balloon_event_count(COMPACTBALLOONISOLATED);
 				unlock_page(page);
 				return true;
 			}
@@ -237,6 +238,7 @@ void balloon_page_putback(struct page *p
 	if (__is_movable_balloon_page(page)) {
 		__putback_balloon_page(page);
 		put_page(page);
+		balloon_event_count(COMPACTBALLOONRETURNED);
 	} else {
 		WARN_ON(1);
 		dump_page(page);
diff -puN mm/migrate.c~mm-add-vm-event-counters-for-balloon-pages-compaction mm/migrate.c
--- a/mm/migrate.c~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/mm/migrate.c
@@ -896,6 +896,7 @@ static int unmap_and_move(new_page_t get
 				    page_is_file_cache(page));
 		put_page(page);
 		__free_page(page);
+		balloon_event_count(COMPACTBALLOONRELEASED);
 		return 0;
 	}
 out:
diff -puN mm/vmstat.c~mm-add-vm-event-counters-for-balloon-pages-compaction mm/vmstat.c
--- a/mm/vmstat.c~mm-add-vm-event-counters-for-balloon-pages-compaction
+++ a/mm/vmstat.c
@@ -781,7 +781,15 @@ const char * const vmstat_text[] = {
 	"compact_stall",
 	"compact_fail",
 	"compact_success",
-#endif
+
+#ifdef CONFIG_BALLOON_COMPACTION
+	"compact_balloon_isolated",
+	"compact_balloon_migrated",
+	"compact_balloon_released",
+	"compact_balloon_returned",
+#endif /* CONFIG_BALLOON_COMPACTION */
+
+#endif /* CONFIG_COMPACTION */
 
 #ifdef CONFIG_HUGETLB_PAGE
 	"htlb_buddy_alloc_success",
_

Patches currently in -mm which might be from aquini@redhat.com are


