Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823283D76
	for <mm-commits@vger.kernel.org>; Sat, 31 Aug 2024 00:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063534; cv=none; b=s1pduxf0Bz8rypH3Lk6eOYGEpBMDpBA4IUUomQP2CMTkbqlcC2XckcMFnopwzQfHW6Pnr3IyCTQZsG9MMXvyevydcqTfRNFxvxT4KKz00dZ4g2ZjER+yF5GrS//tjqv1WQCXoptIJaYioHFeDam7dap41YC7UfNgV9xMt7g7nM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063534; c=relaxed/simple;
	bh=tK26em3WlXvDJiteBMlyABYnqFmJGJ4KDHLJMfr/0CI=;
	h=Date:To:From:Subject:Message-Id; b=cnzglwFx+LaMsjvFE6P703XnFxhMo8avwEiMQimFwCFriBAxd2ob3CtZrex9z5GSDSnRWAgWAMQasaFojX1ed8EX6mRvjNNhBhOiDn3GWJBzFlHQV58iMvCjK0LtSCAuL9uY8PPs/Vho1/V0d1FyzBsqWgh6InThTOgv9urXRks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dWp8U0iM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dWp8U0iM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E85C4CEC2;
	Sat, 31 Aug 2024 00:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725063534;
	bh=tK26em3WlXvDJiteBMlyABYnqFmJGJ4KDHLJMfr/0CI=;
	h=Date:To:From:Subject:From;
	b=dWp8U0iM5ip62cLiufYPsBbXZ0t4uvo2k5LPt6fTA0ssjDU656aaNXjUmmiqtB2AC
	 ieDamTRdJWHyfmKxnpzuipbtryKFJVjH1+/y5PMyqmctzgnp/uQypC7llIydpnjcvU
	 sSZ5PwPQstOLkLCDTdyJs1fqeGyxfHWw7wjcMLgw=
Date: Fri, 30 Aug 2024 17:18:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,link@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simpify-page-del-and-expand.patch added to mm-unstable branch
Message-Id: <20240831001853.E6E85C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: simpify page del and expand
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-simpify-page-del-and-expand.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-simpify-page-del-and-expand.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -1374,11 +1374,11 @@ struct page *__pageblock_pfn_to_page(uns
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
@@ -1398,7 +1398,19 @@ static inline void expand(struct zone *z
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
@@ -1568,8 +1580,9 @@ struct page *__rmqueue_smallest(struct z
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
@@ -1899,9 +1912,12 @@ steal_suitable_fallback(struct zone *zon
 
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
 
@@ -1954,8 +1970,7 @@ steal_suitable_fallback(struct zone *zon
 	}
 
 single_page:
-	del_page_from_free_list(page, zone, current_order, block_type);
-	expand(zone, page, order, current_order, block_type);
+	page_del_and_expand(zone, page, order, current_order, block_type);
 	return page;
 }
 
_

Patches currently in -mm which might be from link@vivo.com are

mm-page_alloc-simpify-page-del-and-expand.patch

