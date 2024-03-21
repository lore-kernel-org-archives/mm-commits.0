Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D65379CB
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711062776; cv=none; b=pAx21E5lkHeZNK4uMheKHDOSlw+0miZYt0wnZXIWQj5p4m8sjOW3EIRW5Y02nrGpzLk7kA69HMABxskvoYUxU4ABaOkucAcH8AjEXgmTI54mm2Qm8S45TRiMZkkifZDvlegEwR/XkQxULt1iXZUbCAIYgjrnwRoLLnJ8A13SV7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711062776; c=relaxed/simple;
	bh=mzKrzcjYiDHenRoygkRZeUsCbb7oZP84TzHIiFdlpd0=;
	h=Date:To:From:Subject:Message-Id; b=kns2LKule1Qfm262X/kBijta4RxmOe6W5sVa0bMxFUQKGD15a5do7Qk3F3ZqM+PI4wj5aVBDBV5XuHne5v+X4+ig9JSO/4g2jiTNjkAfuBQzZlu95CmanySU+c5MqmlKzb02Rtghg2vTFiHL0o5hDYYvuAL95a4T1/0Ksy0orew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RGMB25Sc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RGMB25Sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9000BC433C7;
	Thu, 21 Mar 2024 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711062775;
	bh=mzKrzcjYiDHenRoygkRZeUsCbb7oZP84TzHIiFdlpd0=;
	h=Date:To:From:Subject:From;
	b=RGMB25Sc99EwEWm52mwqR/sMe/M3TPUalegBYzhkWl4NTBG8WLo4MVlueXQy78j3C
	 mDY2k5G2p2jbXghmvGc+v1EzeX/1qv6kqw1mXfVaCacgKMpIEjGf4iQGMyoBCjqArL
	 rdMLGqzI7HGYTEqLgTCMfBVTKDoU011CWayzfvLk=
Date: Thu, 21 Mar 2024 16:12:55 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,hannes@cmpxchg.org,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-set-migratetype-inside-move_freepages.patch added to mm-unstable branch
Message-Id: <20240321231255.9000BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: set migratetype inside move_freepages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-set-migratetype-inside-move_freepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-set-migratetype-inside-move_freepages.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm: page_alloc: set migratetype inside move_freepages()
Date: Wed, 20 Mar 2024 14:02:13 -0400

This avoids changing migratetype after move_freepages() or
move_freepages_block(), which is error prone.  It also prepares for
upcoming changes to fix move_freepages() not moving free pages partially
in the range.

Link: https://lkml.kernel.org/r/20240320180429.678181-9-hannes@cmpxchg.org
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |   27 +++++++++++++--------------
 mm/page_isolation.c |    7 +++----
 2 files changed, 16 insertions(+), 18 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-set-migratetype-inside-move_freepages
+++ a/mm/page_alloc.c
@@ -1586,9 +1586,8 @@ static inline struct page *__rmqueue_cma
 #endif
 
 /*
- * Move the free pages in a range to the freelist tail of the requested type.
- * Note that start_page and end_pages are not aligned on a pageblock
- * boundary. If alignment is required, use move_freepages_block()
+ * Change the type of a block and move all its free pages to that
+ * type's freelist.
  */
 static int move_freepages(struct zone *zone, unsigned long start_pfn,
 			  unsigned long end_pfn, int migratetype)
@@ -1598,6 +1597,9 @@ static int move_freepages(struct zone *z
 	unsigned int order;
 	int pages_moved = 0;
 
+	VM_WARN_ON(start_pfn & (pageblock_nr_pages - 1));
+	VM_WARN_ON(start_pfn + pageblock_nr_pages - 1 != end_pfn);
+
 	for (pfn = start_pfn; pfn <= end_pfn;) {
 		page = pfn_to_page(pfn);
 		if (!PageBuddy(page)) {
@@ -1615,6 +1617,8 @@ static int move_freepages(struct zone *z
 		pages_moved += 1 << order;
 	}
 
+	set_pageblock_migratetype(pfn_to_page(start_pfn), migratetype);
+
 	return pages_moved;
 }
 
@@ -1842,7 +1846,6 @@ steal_suitable_fallback(struct zone *zon
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
 		move_freepages(zone, start_pfn, end_pfn, start_type);
-		set_pageblock_migratetype(page, start_type);
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
@@ -1916,12 +1919,10 @@ static void reserve_highatomic_pageblock
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
-	if (migratetype_is_mergeable(mt)) {
-		if (move_freepages_block(zone, page, MIGRATE_HIGHATOMIC) != -1) {
-			set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
+	if (migratetype_is_mergeable(mt))
+		if (move_freepages_block(zone, page,
+					 MIGRATE_HIGHATOMIC) != -1)
 			zone->nr_reserved_highatomic += pageblock_nr_pages;
-		}
-	}
 
 out_unlock:
 	spin_unlock_irqrestore(&zone->lock, flags);
@@ -2000,7 +2001,6 @@ static bool unreserve_highatomic_pageblo
 			 * not fail on zone boundaries.
 			 */
 			WARN_ON_ONCE(ret == -1);
-			set_pageblock_migratetype(page, ac->migratetype);
 			if (ret > 0) {
 				spin_unlock_irqrestore(&zone->lock, flags);
 				return ret;
@@ -2681,10 +2681,9 @@ int __isolate_free_page(struct page *pag
 			 * Only change normal pageblocks (i.e., they can merge
 			 * with others)
 			 */
-			if (migratetype_is_mergeable(mt) &&
-			    move_freepages_block(zone, page,
-						 MIGRATE_MOVABLE) != -1)
-				set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			if (migratetype_is_mergeable(mt))
+				move_freepages_block(zone, page,
+						     MIGRATE_MOVABLE);
 		}
 	}
 
--- a/mm/page_isolation.c~mm-page_alloc-set-migratetype-inside-move_freepages
+++ a/mm/page_isolation.c
@@ -188,7 +188,6 @@ static int set_migratetype_isolate(struc
 			return -EBUSY;
 		}
 		__mod_zone_freepage_state(zone, -nr_pages, mt);
-		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 		zone->nr_isolate_pageblock++;
 		spin_unlock_irqrestore(&zone->lock, flags);
 		return 0;
@@ -262,10 +261,10 @@ static void unset_migratetype_isolate(st
 		 */
 		WARN_ON_ONCE(nr_pages == -1);
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
-	}
-	set_pageblock_migratetype(page, migratetype);
-	if (isolated_page)
+	} else {
+		set_pageblock_migratetype(page, migratetype);
 		__putback_isolated_page(page, order, migratetype);
+	}
 	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch
mm-page_alloc-set-migratetype-inside-move_freepages.patch

