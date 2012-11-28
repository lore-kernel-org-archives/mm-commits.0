From: akpm@linux-foundation.org
Subject: + mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check.patch added to -mm tree
Date: Tue, 27 Nov 2012 16:06:44 -0800
Message-ID: <20121128000644.E4B94820055@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58005 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2K1AGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 19:06:46 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so425867ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 16:06:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aquini@redhat.com, andi@firstfloor.org, konrad.wilk@oracle.com, levinsasha928@gmail.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au


The patch titled
     Subject: mm: fix balloon_page_movable() page->flags check
has been added to the -mm tree.  Its filename is
     mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check.patch
mm-introduce-compaction-and-migration-for-ballooned-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-introduce-putback_movable_pages.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

