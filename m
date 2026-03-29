Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8154F279DCA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744969; cv=none; b=QBCnNCjhZVDCkfKLI4RilnF2cz29mhic3+z0FLhNbuIdq8itk0EhoLSEz562uH0XJYAm0/yF61010NA8u3VbEadpHCtlmY5YB2OXIHnprvl/nKz8Qrss+m8xcpi6myVeYVLzHrfGVFQI+qabFRblxTI1h60G/onATjGK5A1FSos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744969; c=relaxed/simple;
	bh=AgOYrIvT6Oi+FYFoAOMHSl00hbgDcVOLyrhmM0/oELI=;
	h=Date:To:From:Subject:Message-Id; b=VBrFAuNp60t7ccbKetJrFaOnMc6tis/r9HLehR9hGjw2Th5hWlMT3wDKKp4RQYmzmiWwCp7MRdMB1YPJSvTlWccHtBhvHSzfaV+adhUab9Jj24UGzqBjpq25MhwgXFY6GNStnVvsE4gkD4tHDCq0l5Bmclpi66vWQFDvTPDdm0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=laHhwspa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="laHhwspa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FB1C4CEF7;
	Sun, 29 Mar 2026 00:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744969;
	bh=AgOYrIvT6Oi+FYFoAOMHSl00hbgDcVOLyrhmM0/oELI=;
	h=Date:To:From:Subject:From;
	b=laHhwspa1UzQeq2LYh5tkw0XLMLQyTdKKeaPuIjJkvE7o9InNDOccBqXGuXEmYIYD
	 ZlOVls2GAmoVu6R2wzW6NdHu/TpSlqgqqJYlep9hWfCwD4dkvcgyedM1SeOUgLT4f7
	 4Wag5jzYlgP3379RzZWctMeeoRBYFpXcJBmfqk0E=
Date: Sat, 28 Mar 2026 17:42:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@kernel.org,justinjiang@vivo.com,jackmanb@google.com,hannes@cmpxchg.org,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dont-increase-highatomic-reserve-after-pcp-alloc.patch removed from -mm tree
Message-Id: <20260329004249.58FB1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: don't increase highatomic reserve after pcp alloc
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-increase-highatomic-reserve-after-pcp-alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/page_alloc: don't increase highatomic reserve after pcp alloc
Date: Fri, 20 Mar 2026 17:34:25 +0000

Higher order GFP_ATOMIC allocations can be served through a PCP list with
ALLOC_HIGHATOMIC set.  Such an allocation can e.g.  happen if a zone is
between the low and min watermarks, and get_page_from_freelist is retried
after the alloc_flags are relaxed.

The call to reserve_highatomic_pageblock() after such a PCP allocation
will result in an increase every single time: the page from the
(unmovable) PCP list will never have migrate type MIGRATE_HIGHATOMIC,
since MIGRATE_HIGHATOMIC pages do not appear on the unmovable PCP list. 
So a new pageblock is converted to MIGRATE_HIGHATOMIC.

Eventually that leads to the maximum of 1% of the zone being used up by
(often mostly free) MIGRATE_HIGHATOMIC pageblocks, for no good reason. 
Since this space is not available for normal allocations, this wastes
memory and will push things in to reclaim too soon.

This was observed on a system that ran a test with bursts of memory
activity, paired with GFP_ATOMIC SLUB activity.  These would lead to a new
slab being allocated with GFP_ATOMIC, sometimes hitting the
get_page_from_freelist retry path by being below the low watermark.  While
the frequency of those allocations was low, it kept adding up over time,
and the number of MIGRATE_ATOMIC pageblocks kept increasing.

If a higher order atomic allocation can be served by the unmovable PCP
list, there is probably no need yet to extend the reserves.  So, move the
check and possible extension of the highatomic reserves to the buddy case
only, and do not refill the PCP list for ALLOC_HIGHATOMIC if it's empty. 
This way, the PCP list is tried for ALLOC_HIGHATOMIC for a fast atomic
allocation.  But it will immediately fall back to rmqueue_buddy() if it's
empty.  In rmqueue_buddy(), the MIGRATE_HIGHATOMIC buddy lists are tried
first (as before), and the reserves are extended only if that fails.

With this change, the test was stable.  Highatomic reserves were built up,
but to a normal level.  No highatomic failures were seen.

This is similar to the patch proposed in [1] by Zhiguo Jiang, but
re-arranged a bit.

Link: https://lkml.kernel.org/r/20260320173426.1831267-1-fvdl@google.com
Link: https://lore.kernel.org/all/20231122013925.1507-1-justinjiang@vivo.com/ [1]
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zhiguo Jiang <justinjiang@vivo.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-increase-highatomic-reserve-after-pcp-alloc
+++ a/mm/page_alloc.c
@@ -207,6 +207,8 @@ unsigned int pageblock_order __read_most
 
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
+static void reserve_highatomic_pageblock(struct page *page, int order,
+					 struct zone *zone);
 
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
@@ -3239,6 +3241,13 @@ struct page *rmqueue_buddy(struct zone *
 		spin_unlock_irqrestore(&zone->lock, flags);
 	} while (check_new_pages(page, order));
 
+	/*
+	 * If this is a high-order atomic allocation then check
+	 * if the pageblock should be reserved for the future
+	 */
+	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
+		reserve_highatomic_pageblock(page, order, zone);
+
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone, 1);
 
@@ -3310,6 +3319,20 @@ struct page *__rmqueue_pcplist(struct zo
 			int batch = nr_pcp_alloc(pcp, zone, order);
 			int alloced;
 
+			/*
+			 * Don't refill the list for a higher order atomic
+			 * allocation under memory pressure, as this would
+			 * not build up any HIGHATOMIC reserves, which
+			 * might be needed soon.
+			 *
+			 * Instead, direct it towards the reserves by
+			 * returning NULL, which will make the caller fall
+			 * back to rmqueue_buddy. This will try to use the
+			 * reserves first and grow them if needed.
+			 */
+			if (alloc_flags & ALLOC_HIGHATOMIC)
+				return NULL;
+
 			alloced = rmqueue_bulk(zone, order,
 					batch, list,
 					migratetype, alloc_flags);
@@ -3924,13 +3947,6 @@ try_this_zone:
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
 
-			/*
-			 * If this is a high-order atomic allocation then check
-			 * if the pageblock should be reserved for the future
-			 */
-			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
-				reserve_highatomic_pageblock(page, order, zone);
-
 			return page;
 		} else {
 			if (cond_accept_memory(zone, order, alloc_flags))
_

Patches currently in -mm which might be from fvdl@google.com are


