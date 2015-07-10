From: akpm@linux-foundation.org
Subject: + zsmalloc-consider-zs_almost_full-as-migrate-source.patch added
 to -mm tree
Date: Fri, 10 Jul 2015 15:23:11 -0700
Message-ID: <55a045cf.yKIneruR7vnw2pli%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbbGJWXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 18:23:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: consider ZS_ALMOST_FULL as migrate source
has been added to the -mm tree.  Its filename is
     zsmalloc-consider-zs_almost_full-as-migrate-source.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-consider-zs_almost_full-as-migrate-source.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-consider-zs_almost_full-as-migrate-source.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
