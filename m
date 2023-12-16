Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548EF374CD
	for <mm-commits@vger.kernel.org>; Sat, 16 Dec 2023 22:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c6wNEWm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DE5C433C8;
	Sat, 16 Dec 2023 22:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702767187;
	bh=8jduTL1l5MgTLGnp9CUc8XIH4xDoDMyeMMvKekd4Rcc=;
	h=Date:To:From:Subject:From;
	b=c6wNEWm2WciZrpk+4dfezeTg0NL9sEkS2Yqd9iBw+h7lY11LPcdcywaeE6PQxy8pZ
	 iwmCsJoQXEwjBx7sLrsdLbys0kwFR5BThZHHrfophkLU6PaGxp1qpuakLrwf0+p3rr
	 omJg1focmGC7NDIkueerdLiWWuNw+le/sysTR+7M=
Date: Sat, 16 Dec 2023 14:53:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-__free_pages_ok.patch added to mm-unstable branch
Message-Id: <20231216225307.B5DE5C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: Simplify __free_pages_ok()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-simplify-__free_pages_ok.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-simplify-__free_pages_ok.patch

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
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm: page_alloc: Simplify __free_pages_ok()
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

mm-page_alloc-simplify-__free_pages_ok.patch

