Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE5230999
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836926; cv=none; b=aMQf5DTJVPBW8YVUVqLGjWvzdcmHoqzHzI+r8TJBm1JTRWmxe393akxuX7/64TjmebDO0vMMSZ7lLRQKvgNx4t+QA+ecIGO/oaGZn8thbAP+tBSofxhdjDERwjlwXxrqkhUtC0NeA4F+e4nc9yvlkUMkRKQ8xP/XWeGKBJDQuYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836926; c=relaxed/simple;
	bh=JuJTh8ipgnMGMSp1XlnJooovfuR+KQcw4Z+PT1xho1A=;
	h=Date:To:From:Subject:Message-Id; b=NF+o2YOppqV7CwtjGEVbJOd9ORTpxL0EkDLdbUv9mq9oAYcjcocuZ0J4dpKMtRPD5Dptt4LM4a4VW6ZAEl4jJJAtZr87dhk994625KPP6mKlwpWLdg4O+lyBAWE0Ej5xGa8kpY1/I8P+ttnE43UQIqjYJeyWh2AZ+Qu60X4mWJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dT4gD+yb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dT4gD+yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B0FC4CEDD;
	Tue, 14 Jan 2025 06:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836926;
	bh=JuJTh8ipgnMGMSp1XlnJooovfuR+KQcw4Z+PT1xho1A=;
	h=Date:To:From:Subject:From;
	b=dT4gD+ybZHaFuDpyye6G70m8c017Ps1MrqiWY66HQUyksKDx0yzdyGF1sBZr8MveO
	 0L0YvI2Auu3jEk5d5MQ0pxK5ICulZ7oBu0SJcEsisbP/cNE3F46kqhG2FvN/RdZ5yX
	 v7eoUklyOiZGbIE5EZCPx0+aTKdNvmt6N4GZ945k=
Date: Mon, 13 Jan 2025 22:42:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch removed from -mm tree
Message-Id: <20250114064205.E6B0FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_slowpath()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_slowpath()
Date: Mon, 25 Nov 2024 21:01:43 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_slowpath().

Link: https://lkml.kernel.org/r/20241125210149.2976098-12-willy@infradead.org
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

 mm/page_alloc.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath
+++ a/mm/page_alloc.c
@@ -4284,10 +4284,8 @@ restart:
 	 * that first
 	 */
 	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
-	if (page) {
-		set_page_refcounted(page);
+	if (page)
 		goto got_pg;
-	}
 
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
@@ -4306,10 +4304,8 @@ restart:
 						alloc_flags, ac,
 						INIT_COMPACT_PRIORITY,
 						&compact_result);
-		if (page) {
-			set_page_refcounted(page);
+		if (page)
 			goto got_pg;
-		}
 
 		/*
 		 * Checks for costly allocations with __GFP_NORETRY, which
@@ -4369,10 +4365,8 @@ retry:
 
 	/* Attempt with potentially adjusted zonelist and alloc_flags */
 	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
-	if (page) {
-		set_page_refcounted(page);
+	if (page)
 		goto got_pg;
-	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
 	if (!can_direct_reclaim)
@@ -4385,18 +4379,14 @@ retry:
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
 							&did_some_progress);
-	if (page) {
-		set_page_refcounted(page);
+	if (page)
 		goto got_pg;
-	}
 
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
 					compact_priority, &compact_result);
-	if (page) {
-		set_page_refcounted(page);
+	if (page)
 		goto got_pg;
-	}
 
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
@@ -4437,10 +4427,8 @@ retry:
 
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
-	if (page) {
-		set_page_refcounted(page);
+	if (page)
 		goto got_pg;
-	}
 
 	/* Avoid allocations with no watermarks from looping endlessly */
 	if (tsk_is_oom_victim(current) &&
@@ -4484,10 +4472,8 @@ nopage:
 		 * the situation worse.
 		 */
 		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE, ac);
-		if (page) {
-			set_page_refcounted(page);
+		if (page)
 			goto got_pg;
-		}
 
 		cond_resched();
 		goto retry;
@@ -4779,6 +4765,8 @@ struct page *__alloc_pages_noprof(gfp_t
 	ac.nodemask = nodemask;
 
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
+	if (page)
+		set_page_refcounted(page);
 
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

