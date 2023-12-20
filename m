Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3A94D124
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="09dqw1Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BF3C433C9;
	Wed, 20 Dec 2023 22:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112572;
	bh=y7IJTx0w3vixz0ClG4PJN4COrlmQ0FcBQM1Mty8zCm8=;
	h=Date:To:From:Subject:From;
	b=09dqw1FkTPmpa8VUqRFzRMkc6HcxGu2J4+rj1UXlzEUq/ul+m0xf3JC+kFmasAUjx
	 WK8bXn0+Eg67dm+gjvgBCQRxjUB0RiSzdzTzj/vyJJUMYdhKG4Yco9OxWAz38Uued6
	 70+sexFFOMn/R7T659zau8P0HpPVOkvbUQGzUuek=
Date: Wed, 20 Dec 2023 14:49:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-simplify-__free_pages_ok.patch removed from -mm tree
Message-Id: <20231220224932.C9BF3C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: simplify __free_pages_ok()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-__free_pages_ok.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm: page_alloc: simplify __free_pages_ok()
Date: Sat, 16 Dec 2023 11:05:03 +0800

There is redundant code in __free_pages_ok(). Use free_one_page()
simplify it.

Link: https://lkml.kernel.org/r/20231216030503.2126130-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-__free_pages_ok
+++ a/mm/page_alloc.c
@@ -1255,7 +1255,6 @@ static void free_one_page(struct zone *z
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags)
 {
-	unsigned long flags;
 	int migratetype;
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
@@ -1270,13 +1269,7 @@ static void __free_pages_ok(struct page
 	 */
 	migratetype = get_pfnblock_migratetype(page, pfn);
 
-	spin_lock_irqsave(&zone->lock, flags);
-	if (unlikely(has_isolate_pageblock(zone) ||
-		is_migrate_isolate(migratetype))) {
-		migratetype = get_pfnblock_migratetype(page, pfn);
-	}
-	__free_one_page(page, pfn, zone, order, migratetype, fpi_flags);
-	spin_unlock_irqrestore(&zone->lock, flags);
+	free_one_page(zone, page, pfn, order, migratetype, fpi_flags);
 
 	__count_vm_events(PGFREE, 1 << order);
 }
_

Patches currently in -mm which might be from yajun.deng@linux.dev are


