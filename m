From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-consider-zs_almost_full-as-migrate-source.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:54:09 -0700
Message-ID: <55f08e61.wj/+WnNtfao7pzQL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbbIITyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: consider ZS_ALMOST_FULL as migrate source
has been removed from the -mm tree.  Its filename was
     zsmalloc-consider-zs_almost_full-as-migrate-source.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan.kim@lge.com>
Subject: zsmalloc: consider ZS_ALMOST_FULL as migrate source

There is no reason to prevent select ZS_ALMOST_FULL as migration
source if we cannot find source from ZS_ALMOST_EMPTY.

With this patch, zs_can_compact will return more exact result.

Signed-off-by: Minchan Kim <minchan.kim@lge.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-consider-zs_almost_full-as-migrate-source mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-consider-zs_almost_full-as-migrate-source
+++ a/mm/zsmalloc.c
@@ -1691,11 +1691,17 @@ static enum fullness_group putback_zspag
 
 static struct page *isolate_source_page(struct size_class *class)
 {
-	struct page *page;
+	int i;
+	struct page *page = NULL;
 
-	page = class->fullness_list[ZS_ALMOST_EMPTY];
-	if (page)
-		remove_zspage(page, class, ZS_ALMOST_EMPTY);
+	for (i = ZS_ALMOST_EMPTY; i >= ZS_ALMOST_FULL; i--) {
+		page = class->fullness_list[i];
+		if (!page)
+			continue;
+
+		remove_zspage(page, class, i);
+		break;
+	}
 
 	return page;
 }
@@ -1711,9 +1717,6 @@ static unsigned long zs_can_compact(stru
 {
 	unsigned long obj_wasted;
 
-	if (!zs_stat_get(class, CLASS_ALMOST_EMPTY))
-		return 0;
