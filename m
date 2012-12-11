From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:50:39 -0800
Message-ID: <20121211235040.EDA1220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:48793 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2LKXuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:50:44 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so2076wib.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:50:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, andi@firstfloor.org, konrad.wilk@oracle.com, levinsasha928@gmail.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix balloon_page_movable() page->flags check
has been removed from the -mm tree.  Its filename was
     mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check.patch

This patch was dropped because it was folded into mm-introduce-a-common-interface-for-balloon-pages-mobility.patch

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: fix balloon_page_movable() page->flags check

Fix the following crash by fixing and enhancing the way page->flags are
tested to identify a ballooned page.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000194
IP: [<ffffffff8122b354>] isolate_migratepages_range+0x344/0x7b0

The NULL pointer deref was taking place because balloon_page_movable()
page->flags tests were incomplete and we ended up inadvertently poking at
private pages.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check
+++ a/include/linux/balloon_compaction.h
@@ -107,6 +107,23 @@ static inline void balloon_mapping_free(
 }
 
 /*
+ * __balloon_page_flags - helper to perform balloon @page ->flags tests.
+ *
+ * As balloon pages are got from Buddy, and we do not play with page->flags
+ * at driver level (exception made when we get the page lock for compaction),
+ * therefore we can safely identify a ballooned page by checking if the
+ * NR_PAGEFLAGS rightmost bits from the page->flags are all cleared.
+ * This approach also helps on skipping ballooned pages that are locked for
+ * compaction or release, thus mitigating their racy check at
+ * balloon_page_movable()
+ */
+#define BALLOON_PAGE_FLAGS_MASK       ((1UL << NR_PAGEFLAGS) - 1)
+static inline bool __balloon_page_flags(struct page *page)
+{
+	return page->flags & BALLOON_PAGE_FLAGS_MASK ? false : true;
+}
+
+/*
  * __is_movable_balloon_page - helper to perform @page mapping->flags tests
  */
 static inline bool __is_movable_balloon_page(struct page *page)
@@ -135,8 +152,8 @@ static inline bool balloon_page_movable(
 	 * Before dereferencing and testing mapping->flags, lets make sure
 	 * this is not a page that uses ->mapping in a different way
 	 */
-	if (!PageSlab(page) && !PageSwapCache(page) && !PageAnon(page) &&
-	    !page_mapped(page))
+	if (__balloon_page_flags(page) && !page_mapped(page) &&
+	    page_count(page) == 1)
 		return __is_movable_balloon_page(page);
 
 	return false;
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-adjust-address_space_operationsmigratepage-return-code.patch
mm-redefine-address_spaceassoc_mapping.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
mm-introduce-compaction-and-migration-for-ballooned-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-introduce-putback_movable_pages.patch

