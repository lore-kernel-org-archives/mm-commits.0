From: akpm@linux-foundation.org
Subject: [merged] mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:21 -0700
Message-ID: <201105252027.p4PKRi7F014604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190Ab1EYU2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mem-hwpoison: fix page refcount around isolate_lru_page()
has been removed from the -mm tree.  Its filename was
     mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mem-hwpoison: fix page refcount around isolate_lru_page()
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Drop first page reference only after calling isolate_lru_page() to keep
page stable reference while isolating.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memory-failure.c~mem-hwpoison-fix-page-refcount-around-isolate_lru_page mm/memory-failure.c
--- a/mm/memory-failure.c~mem-hwpoison-fix-page-refcount-around-isolate_lru_page
+++ a/mm/memory-failure.c
@@ -1440,16 +1440,12 @@ int soft_offline_page(struct page *page,
 	 */
 	ret = invalidate_inode_page(page);
 	unlock_page(page);
-
 	/*
-	 * Drop count because page migration doesn't like raised
-	 * counts. The page could get re-allocated, but if it becomes
-	 * LRU the isolation will just fail.
 	 * RED-PEN would be better to keep it isolated here, but we
 	 * would need to fix isolation locking first.
 	 */
-	put_page(page);
 	if (ret == 1) {
+		put_page(page);
 		ret = 0;
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		goto done;
@@ -1461,6 +1457,11 @@ int soft_offline_page(struct page *page,
 	 * handles a large number of cases for us.
 	 */
 	ret = isolate_lru_page(page);
+	/*
+	 * Drop page reference which is came from get_any_page()
+	 * successful isolate_lru_page() already took another one.
+	 */
+	put_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch

