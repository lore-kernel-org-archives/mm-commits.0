Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287732F36
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101562; cv=none; b=MyXmShpqj5m+xcPFqLjB/h7f63tHmGcL5zOPWnGE6FEvctEwlW2SJ+Jb9m6Pa9soKHTCAVk7O9zysrlsHtpvAVNqB62poHKfYaexhkVY7tFoHDu0lxiOXpIJXybSZGZR4CoBIqRUZ1e+O8Qy97UszORuZmz75adLwwmxHV7SBpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101562; c=relaxed/simple;
	bh=RAYdhZdbk8xMdOc+FG+JmhCxBLF1orZ0aPVdoA64nC4=;
	h=Date:To:From:Subject:Message-Id; b=KFjInBmO4hF4ac3S09e2fqL+TWuVXZcBWtN6ZRZNu0P38iM4ZZkbtVJetlEAuv12p8k9witHrm7+xTVeBu4ydDFVhI1u7BYfgO82Pt+O/R5C29S3WEKGGMcmU1C1x9CdY7k6DPN4yb9/TmTVriEhbpYuJskJUq0NAEMej/nCGc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HxQRaqJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HxQRaqJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F7CC116B1;
	Fri, 26 Apr 2024 03:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101561;
	bh=RAYdhZdbk8xMdOc+FG+JmhCxBLF1orZ0aPVdoA64nC4=;
	h=Date:To:From:Subject:From;
	b=HxQRaqJ3H/+pGEXb70E9W35Ug25OYEJjNUOiqVFmkwhkH7QnJIWnmLkrthXZ1wNTF
	 Momy8zyJe+i2WQeQkp5LenBL44/ILYn1lv7jcRpVAU3Zup8UjueIEz8jYRX7DxqIL5
	 fbBQF2v2eqmO60vl7oSLHSm90Gj2hmmjhQLM1ozE=
Date: Thu, 25 Apr 2024 20:19:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,linux@rasmusvillemoes.dk,linmiaohe@huawei.com,hannes@cmpxchg.org,baolin.wang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-consolidate-free-page-accounting-fix-4.patch removed from -mm tree
Message-Id: <20240426031921.D5F7CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: avoid defining unused function
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-consolidate-free-page-accounting-fix-4.patch

This patch was dropped because it was folded into mm-page_alloc-consolidate-free-page-accounting.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm: page_alloc: avoid defining unused function
Date: Tue, 23 Apr 2024 19:14:43 +0300

In some configurations I got mm/page_alloc.c:656:20: warning: unused
function 'add_to_free_list' [-Wunused-function] Because the only user is
guarded with a certain ifdeffery, do the same for add_to_free_list().

Link: https://lkml.kernel.org/r/20240423161506.2637177-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-consolidate-free-page-accounting-fix-4
+++ a/mm/page_alloc.c
@@ -673,14 +673,6 @@ static inline void __add_to_free_list(st
 	area->nr_free++;
 }
 
-static inline void add_to_free_list(struct page *page, struct zone *zone,
-				    unsigned int order, int migratetype,
-				    bool tail)
-{
-	__add_to_free_list(page, zone, order, migratetype, tail);
-	account_freepages(zone, 1 << order, migratetype);
-}
-
 /*
  * Used for pages which are on another list. Move the pages to the tail
  * of the list - so the moved pages won't immediately be considered for
@@ -6770,6 +6762,14 @@ bool is_free_buddy_page(struct page *pag
 EXPORT_SYMBOL(is_free_buddy_page);
 
 #ifdef CONFIG_MEMORY_FAILURE
+static inline void add_to_free_list(struct page *page, struct zone *zone,
+				    unsigned int order, int migratetype,
+				    bool tail)
+{
+	__add_to_free_list(page, zone, order, migratetype, tail);
+	account_freepages(zone, 1 << order, migratetype);
+}
+
 /*
  * Break down a higher-order page in sub-pages, and keep our target out of
  * buddy allocator.
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-page_alloc-consolidate-free-page-accounting.patch
xarray-use-bits_per_longs.patch
xarray-dont-use-proxy-headers.patch
devres-switch-to-use-dev_err_probe-for-unification.patch
devres-dont-use-proxy-headers.patch
media-rc-add-missing-ioh.patch
media-stih-cec-add-missing-ioh.patch
kfifo-dont-use-proxy-headers.patch

