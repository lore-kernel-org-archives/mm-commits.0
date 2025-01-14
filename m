Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7981C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836924; cv=none; b=N8cjrFfxOhjh8+7g8A4nTgvb/Ukf8w6Ibri9EaHLGpLApZRPEsZU4ZUVxcAyKk5OtLwNys4oggW3rTWbUOxroqiL/NHJUiH4IC9SbM9lavhWI0d4Z8GgXVjypKG6v6Cg9/RPgXqjGEoAfsxjl98CNV9+nd84kpcJ4xdteV7dhPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836924; c=relaxed/simple;
	bh=wASL/SbTNN1hRW68smlI96s0Ocyrhodv7PjbQYtgiSk=;
	h=Date:To:From:Subject:Message-Id; b=eBVK78FDo5Z0vGdgqEERxlA7jk+TN4jw3i0YQFnJjdYBB89ezmdjJnfShbf3HAtjeLFWyGZ9aluSOfoRJAZKlUqu4R+VyGRKeXEmxmJe2Tgq5tIQAa+gA/Q5TMKpSjMOnacIdRgok9XS0dYgfn6afOSFiTPqGynvaT/orosqGRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ss7wyUsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ss7wyUsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DFCC4CEDD;
	Tue, 14 Jan 2025 06:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836923;
	bh=wASL/SbTNN1hRW68smlI96s0Ocyrhodv7PjbQYtgiSk=;
	h=Date:To:From:Subject:From;
	b=Ss7wyUscDbHgQdyBZgbCJMFFeo8UTlTUD4GbTmjA/fqKxk5AUoKpQbwrnwegDsEs/
	 yYZqARiA57ZHaizH7Q4Yq7/BvAmC/Q6yAnbDPqink4P/etPNd7Rsu6o9jHml6iG1Rw
	 3SfaBmeszPOAbiHaflM2JQnEJ4DBj0kJfkMa2zP4=
Date: Mon, 13 Jan 2025 22:42:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch removed from -mm tree
Message-Id: <20250114064203.A5DFCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_direct_compact()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_direct_compact()
Date: Mon, 25 Nov 2024 21:01:41 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_direct_compact().

Link: https://lkml.kernel.org/r/20241125210149.2976098-10-willy@infradead.org
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

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact
+++ a/mm/page_alloc.c
@@ -3706,7 +3706,6 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	if (page) {
 		struct zone *zone = page_zone(page);
 
-		set_page_refcounted(page);
 		zone->compact_blockskip_flush = false;
 		compaction_defer_reset(zone, order, true);
 		count_vm_event(COMPACTSUCCESS);
@@ -4308,8 +4307,10 @@ restart:
 						alloc_flags, ac,
 						INIT_COMPACT_PRIORITY,
 						&compact_result);
-		if (page)
+		if (page) {
+			set_page_refcounted(page);
 			goto got_pg;
+		}
 
 		/*
 		 * Checks for costly allocations with __GFP_NORETRY, which
@@ -4391,8 +4392,10 @@ retry:
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
 					compact_priority, &compact_result);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto got_pg;
+	}
 
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

