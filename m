Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D512397A4
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836923; cv=none; b=GkL0Dz3HqdhL4uma1vdDBUsPU3EtkKEXZlkQnbh9dHrm2NN/h+KNkZmRYHClQxnXAxGg2bjH1UNbv7z0nEBtGGd12e8GORlk1YUpl4zagB5AgnYE/Gj6l0riNAaEMyCs2IDEaIzQaKMyuF2ZecRwl5UU2yAYTuVy5+ws5AabhYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836923; c=relaxed/simple;
	bh=3R9P5UJkkktmzYn7ZP++hQxCV31xNdmAito3371Tf/M=;
	h=Date:To:From:Subject:Message-Id; b=eM0Vb8Tg1iekaIlj2QWy9rGPPum8J/6jV/rcF3rNtBIYsFsqxRNeE4LaAVm4RpNsovlZLlcCM1xNZN9uBxgddPQC5aCiPjLu38QZ8/aRxGLbgdEIJ9blVuxk5eNHiMVEF2KpdSI5PX73ba1yFguwJ+Qzw879DyN7e+SWk8V0Ti0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QzWx1SNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QzWx1SNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827A8C4CEDD;
	Tue, 14 Jan 2025 06:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836922;
	bh=3R9P5UJkkktmzYn7ZP++hQxCV31xNdmAito3371Tf/M=;
	h=Date:To:From:Subject:From;
	b=QzWx1SNqddChE5NgxLkaKtuWGuh/Ud5A92PB0WrbnsI1FhL4tAnYND8XFwQNteTHb
	 EUPdTyF0uzed0lmnBdXRB1a9AIbOQSyjABs1tquta/NTnfPVKOv2dqTW3sMPz+DWT9
	 fwaKR8mtKBrQoo0R340V7155InlJLkQU0ivTddRM=
Date: Mon, 13 Jan 2025 22:42:02 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch removed from -mm tree
Message-Id: <20250114064202.827A8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_may_oom()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_may_oom()
Date: Mon, 25 Nov 2024 21:01:40 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_may_oom().

Link: https://lkml.kernel.org/r/20241125210149.2976098-9-willy@infradead.org
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

 mm/page_alloc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom
+++ a/mm/page_alloc.c
@@ -3604,10 +3604,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	page = get_page_from_freelist((gfp_mask | __GFP_HARDWALL) &
 				      ~__GFP_DIRECT_RECLAIM, order,
 				      ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
-	if (page) {
-		set_page_refcounted(page);
+	if (page)
 		goto out;
-	}
 
 	/* Coredumps can quickly deplete all memory reserves */
 	if (current->flags & PF_DUMPCORE)
@@ -3652,8 +3650,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		if (gfp_mask & __GFP_NOFAIL)
 			page = __alloc_pages_cpuset_fallback(gfp_mask, order,
 					ALLOC_NO_WATERMARKS, ac);
-		if (page)
-			set_page_refcounted(page);
 	}
 out:
 	mutex_unlock(&oom_lock);
@@ -4437,8 +4433,10 @@ retry:
 
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto got_pg;
+	}
 
 	/* Avoid allocations with no watermarks from looping endlessly */
 	if (tsk_is_oom_victim(current) &&
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

