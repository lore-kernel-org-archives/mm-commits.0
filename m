Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D251C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836920; cv=none; b=bDBs6eQuMFLxByEEEAQdMaop/kOep8Oob0Jt1PGi0DJ7k4fD+oG0W6+WceJ9xFp9lzmWcX7ebsQoJ2bqPhbTJDPWnEZDCbTfu9XeZJEEEhPB/vs3NeTMGPnVp8m+43O05CZ8fzz+i4NCTwkvtRikhG+jAtAIEBHHkMSDnFgMGyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836920; c=relaxed/simple;
	bh=sgU40GDJ7phn44ZXobPi6Glv4kKDux//fBwQFNGxUoI=;
	h=Date:To:From:Subject:Message-Id; b=ek/zvblJJCyu/LKFjYLspMkBdrgA//CA6HA5OCP66evSqs1GMPl5XLHMjNIs15AW9JwxNDY5ymdSux2SN233mkyE6ygHl/DZQ7WEO+RhO3bsXKpYrMU0TSAI54TlUyVEeTrATJn8/fhwEWEHOAhndRv8aPlj5qfBPUTIZfz/+Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oPbeItel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oPbeItel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3D7C4CEDD;
	Tue, 14 Jan 2025 06:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836920;
	bh=sgU40GDJ7phn44ZXobPi6Glv4kKDux//fBwQFNGxUoI=;
	h=Date:To:From:Subject:From;
	b=oPbeItelYCJbhjlCulu+nM5Qc2tKu1k1N7gAWzFYT+Z84bsK4MtxIRcbB6PiiOv9E
	 fMxrUhsJn5y9G+yxcSs4khzhFDfOgUPGzv2nDfqFcaFAUMIOwhuQh5uv2mIgqGRX9d
	 MQKJv049dAVC0ZCaX7ZePBmqjU5vOdkHAKOkx50o=
Date: Mon, 13 Jan 2025 22:41:59 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch removed from -mm tree
Message-Id: <20250114064200.3E3D7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of get_page_from_freelist()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of get_page_from_freelist()
Date: Mon, 25 Nov 2024 21:01:38 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in get_page_from_freelist().

Link: https://lkml.kernel.org/r/20241125210149.2976098-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist
+++ a/mm/page_alloc.c
@@ -3473,7 +3473,6 @@ try_this_zone:
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
-			set_page_refcounted(page);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -3568,6 +3567,8 @@ __alloc_pages_cpuset_fallback(gfp_t gfp_
 		page = get_page_from_freelist(gfp_mask, order,
 				alloc_flags, ac);
 
+	if (page)
+		set_page_refcounted(page);
 	return page;
 }
 
@@ -3606,8 +3607,10 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	page = get_page_from_freelist((gfp_mask | __GFP_HARDWALL) &
 				      ~__GFP_DIRECT_RECLAIM, order,
 				      ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto out;
+	}
 
 	/* Coredumps can quickly deplete all memory reserves */
 	if (current->flags & PF_DUMPCORE)
@@ -3698,10 +3701,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	count_vm_event(COMPACTSTALL);
 
 	/* Prep a captured page if available */
-	if (page) {
+	if (page)
 		prep_new_page(page, order, gfp_mask, alloc_flags);
-		set_page_refcounted(page);
-	}
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -3710,6 +3711,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	if (page) {
 		struct zone *zone = page_zone(page);
 
+		set_page_refcounted(page);
 		zone->compact_blockskip_flush = false;
 		compaction_defer_reset(zone, order, true);
 		count_vm_event(COMPACTSUCCESS);
@@ -3968,6 +3970,7 @@ retry:
 		drained = true;
 		goto retry;
 	}
+	set_page_refcounted(page);
 out:
 	psi_memstall_leave(&pflags);
 
@@ -4288,8 +4291,10 @@ restart:
 	 * that first
 	 */
 	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto got_pg;
+	}
 
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
@@ -4369,8 +4374,10 @@ retry:
 
 	/* Attempt with potentially adjusted zonelist and alloc_flags */
 	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto got_pg;
+	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
 	if (!can_direct_reclaim)
@@ -4754,8 +4761,10 @@ struct page *__alloc_pages_noprof(gfp_t
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
-	if (likely(page))
+	if (likely(page)) {
+		set_page_refcounted(page);
 		goto out;
+	}
 
 	alloc_gfp = gfp;
 	ac.spread_dirty_pages = false;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

