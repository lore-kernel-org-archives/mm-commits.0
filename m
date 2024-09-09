Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296DF18D647
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925254; cv=none; b=Em28Q50fPDbCRnznRIUN0oMcs6bVnBAbcej5jawvm4qNKfzsivybi5Mb5KsCqg/hH69yTx6TAA2AiW0a+1QUHVXpKk7nAxpNz2++dBkD0xk/BhGdPVd2LAiakEKDFlZ/Q0LLZX8dYFntTvwYZDjikPxNnpXCeLsQzRV7KhRcgiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925254; c=relaxed/simple;
	bh=TQyGsVDdgUIFDfuzJzg8NwUArKVZNeniPX4hwqVs/8k=;
	h=Date:To:From:Subject:Message-Id; b=cpZTvs1N1mRmD5uUTdEJMh9DcrtCJmv6XBQPJK4sTnhfqFmvZnSBzW+gMNEgZdSH3mgQUWtSn0/sDTMOqHzNbxrfBF6lmlp36e1jinrozplPYT5bjlDwAs0iPGouTpQ7+h8nvrN+k3Lb//dnHkStXnh7735yzIfeVaWY9HdVf5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g54CfujB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g54CfujB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3568C4CEC5;
	Mon,  9 Sep 2024 23:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925254;
	bh=TQyGsVDdgUIFDfuzJzg8NwUArKVZNeniPX4hwqVs/8k=;
	h=Date:To:From:Subject:From;
	b=g54CfujBfgE+sxxXS79IDO0ztBDzuMF3ElWxqLUjIrVkU30oZgABJgLXcXP41aeVD
	 eWLaajmyB0JK6lC3h0LipHQlMxQNylzyCHxn3QmW7Dm7UcWj+z08Z+0HLVEDA+cwqg
	 Vzgaudf/2PTwf/5Ua4WeL0yvw4R+z9v9yqXQzb2Q=
Date: Mon, 09 Sep 2024 16:40:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,link@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-simpify-page-del-and-expand.patch removed from -mm tree
Message-Id: <20240909234053.F3568C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: simpify page del and expand
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simpify-page-del-and-expand.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huan Yang <link@vivo.com>
Subject: mm: page_alloc: simpify page del and expand
Date: Mon, 26 Aug 2024 14:40:48 +0800

When page del from buddy and need expand, it will account free_pages in
zone's migratetype.

The current way is to subtract the page number of the current order when
deleting, and then add it back when expanding.

This is unnecessary, as when migrating the same type, we can directly
record the difference between the high-order pages and the expand added,
and then subtract it directly.

This patch merge that, only when del and expand done, then account
free_pages.

Link: https://lkml.kernel.org/r/20240826064048.187790-1-link@vivo.com
Signed-off-by: Huan Yang <link@vivo.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simpify-page-del-and-expand
+++ a/mm/page_alloc.c
@@ -1367,11 +1367,11 @@ struct page *__pageblock_pfn_to_page(uns
  *
  * -- nyc
  */
-static inline void expand(struct zone *zone, struct page *page,
-	int low, int high, int migratetype)
+static inline unsigned int expand(struct zone *zone, struct page *page, int low,
+				  int high, int migratetype)
 {
-	unsigned long size = 1 << high;
-	unsigned long nr_added = 0;
+	unsigned int size = 1 << high;
+	unsigned int nr_added = 0;
 
 	while (high > low) {
 		high--;
@@ -1391,7 +1391,19 @@ static inline void expand(struct zone *z
 		set_buddy_order(&page[size], high);
 		nr_added += size;
 	}
-	account_freepages(zone, nr_added, migratetype);
+
+	return nr_added;
+}
+
+static __always_inline void page_del_and_expand(struct zone *zone,
+						struct page *page, int low,
+						int high, int migratetype)
+{
+	int nr_pages = 1 << high;
+
+	__del_page_from_free_list(page, zone, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype);
+	account_freepages(zone, -nr_pages, migratetype);
 }
 
 static void check_new_page_bad(struct page *page)
@@ -1561,8 +1573,9 @@ struct page *__rmqueue_smallest(struct z
 		page = get_page_from_free_area(area, migratetype);
 		if (!page)
 			continue;
-		del_page_from_free_list(page, zone, current_order, migratetype);
-		expand(zone, page, order, current_order, migratetype);
+
+		page_del_and_expand(zone, page, order, current_order,
+				    migratetype);
 		trace_mm_page_alloc_zone_locked(page, order, migratetype,
 				pcp_allowed_order(order) &&
 				migratetype < MIGRATE_PCPTYPES);
@@ -1892,9 +1905,12 @@ steal_suitable_fallback(struct zone *zon
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
+		unsigned int nr_added;
+
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type);
+		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
 
@@ -1947,8 +1963,7 @@ steal_suitable_fallback(struct zone *zon
 	}
 
 single_page:
-	del_page_from_free_list(page, zone, current_order, block_type);
-	expand(zone, page, order, current_order, block_type);
+	page_del_and_expand(zone, page, order, current_order, block_type);
 	return page;
 }
 
_

Patches currently in -mm which might be from link@vivo.com are


