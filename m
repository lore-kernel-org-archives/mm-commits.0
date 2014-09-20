From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2.patch removed from -mm tree
Date: Fri, 19 Sep 2014 23:20:10 -0700
Message-ID: <541d1c9a.uRZdaiwC9NB1+pWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaITGUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 20 Sep 2014 02:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2.patch

This patch was dropped because it was folded into mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path.patch

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2 include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-v2
+++ a/include/linux/balloon_compaction.h
@@ -258,6 +258,11 @@ static inline void balloon_page_delete(s
 	list_del(&page->lru);
 }
 
+static inline bool __is_movable_balloon_page(struct page *page)
+{
+	return false;
+}
+
 static inline bool balloon_page_movable(struct page *page)
 {
 	return false;
@@ -293,11 +298,5 @@ static inline bool balloon_compaction_ch
 {
 	return false;
 }
-
-static inline bool __is_movable_balloon_page(struct page *page)
-{
-	return false;
-}
