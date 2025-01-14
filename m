Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB4C1C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836914; cv=none; b=UEjHRjeUZV3S09bzwj78sZ8JQRKe/Pce6vt9m2JF0fvbfsKNrfgQ3gHRaIPBY/IdD99trbd9avmpvjvxBIyZvr+T+E01UENMfmFZRJ5VtNufOwl7+Cm54QDjKuXOvQ4yCbEm3T1gmdnH6piqCS1vZawLk7fyg37oOsEI15RgxOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836914; c=relaxed/simple;
	bh=LFutiv4hBkdALdA8Pbvyv+Dz28Yi40+jO24Yvi8WX20=;
	h=Date:To:From:Subject:Message-Id; b=bg6QWs/de0wTERcFDWhq3EXtaF1ZgO8wnTpCU/npUQj1aF25I6PljhoPbxJSSjVrVgN58B4gKl7TDKnK+EJ9iRskvO7qAp4G9TYBFaQLhXd8M92DbqeIAj9ORExDRZSZh7ceOB7Z+qCr0ySoslsei8P8A4tXnn3Q6ATZDHihmfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hCN02z2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hCN02z2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9F5C4AF09;
	Tue, 14 Jan 2025 06:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836913;
	bh=LFutiv4hBkdALdA8Pbvyv+Dz28Yi40+jO24Yvi8WX20=;
	h=Date:To:From:Subject:From;
	b=hCN02z2XI9At6Dw7gBTBFtcuzjaBNzZi3KZjkDnj/UUwYY8xs/LbyT9roNyLcdfIf
	 FD/OsX2xoGJa+ZAF1OkbD4UYYqbU0pCJEuIsBjC+coLB77M0G1nAqOln2W7dD1gw45
	 rWcOr9J7PaSEY0lyYKDDh7YrByH7uXH71WjtZFJ4=
Date: Mon, 13 Jan 2025 22:41:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch removed from -mm tree
Message-Id: <20250114064153.9E9F5C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: cache page_zone() result in free_unref_page()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: cache page_zone() result in free_unref_page()
Date: Mon, 25 Nov 2024 21:01:33 +0000

Patch series "Allocate and free frozen pages", v3.

Slab does not need to use the page refcount at all, and it can avoid an
atomic operation on page free.  Hugetlb wants to delay setting the
refcount until it has assembled a complete gigantic page.  We already have
the ability to freeze a page (safely reduce its reference count to 0), so
this patchset adds APIs to allocate and free pages which are in a frozen
state.

This patchset is also a step towards the Glorious Future in which struct
page doesn't have a refcount; the users which need a refcount will have
one in their per-allocation memdesc.


This patch (of 15):

Save 17 bytes of text by calculating page_zone() once instead of twice.

Link: https://lkml.kernel.org/r/20241125210149.2976098-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20241125210149.2976098-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-cache-page_zone-result-in-free_unref_page
+++ a/mm/page_alloc.c
@@ -2666,16 +2666,16 @@ void free_unref_page(struct page *page,
 	 * get those areas back if necessary. Otherwise, we may have to free
 	 * excessively into the page allocator
 	 */
+	zone = page_zone(page);
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(page_zone(page), page, pfn, order, FPI_NONE);
+			free_one_page(zone, page, pfn, order, FPI_NONE);
 			return;
 		}
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	zone = page_zone(page);
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

