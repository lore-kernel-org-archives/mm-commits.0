Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11614847B
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755877; cv=none; b=VMgGN6vy7druFaC/m2x/CKNBph16ipqGdpRE6AHX6R7qIWHB+beJL9yYTEz9Vwioc0H4c+oya7UgL/v3zkuwCIsq8feke+Bwzz6i3sMW4uAuwyvJloZ2XhzrpO8vqvQpWc/4fZ3oGZLS9J/IwHiXtXsF7mC/Xt+QWwL9yBFvdn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755877; c=relaxed/simple;
	bh=WYb5eYe/Nu1s37LaRZ11VYS8BR32WfezMnQn+dvoxLg=;
	h=Date:To:From:Subject:Message-Id; b=IdUJeJyaA2SPOoXUx/QagLujPrF95ltk/qasaWse3vf82IG3j55PlJq4EYmgY63rlFs3oG/EiCEoLffZDoiWvj+wae7NlaJvfkKJhYKWDJZlNO8fIrN29DPPeaEtRlPfh6LLAeNGnKlJBeOY3WhloIoVOr3WxmPUUQX7g6F64+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZG+LLDME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZG+LLDME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5738C4CED2;
	Thu, 28 Nov 2024 01:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755876;
	bh=WYb5eYe/Nu1s37LaRZ11VYS8BR32WfezMnQn+dvoxLg=;
	h=Date:To:From:Subject:From;
	b=ZG+LLDMESQKa6hbNntE50xosgmGbJTW3OU18lqEWeW/9wQLL45vAJDKOXYxi46jC9
	 ihfxBJKRxdBmLToJZlm2h20rweFagBSVwv+6o5p8OHfqz5R/kt+7xORYA2yz6mkAh2
	 gsAq9m2Xx6kB1bzuIieElMPimdfBUT5+sswsUebU=
Date: Wed, 27 Nov 2024 17:04:36 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch added to mm-unstable branch
Message-Id: <20241128010436.D5738C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of get_page_from_freelist()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: move set_page_refcounted() to callers of get_page_from_freelist()
Date: Mon, 25 Nov 2024 21:01:38 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in get_page_from_freelist().

Link: https://lkml.kernel.org/r/20241125210149.2976098-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsinguularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist
+++ a/mm/page_alloc.c
@@ -3471,7 +3471,6 @@ try_this_zone:
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
-			set_page_refcounted(page);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -3566,6 +3565,8 @@ __alloc_pages_cpuset_fallback(gfp_t gfp_
 		page = get_page_from_freelist(gfp_mask, order,
 				alloc_flags, ac);
 
+	if (page)
+		set_page_refcounted(page);
 	return page;
 }
 
@@ -3604,8 +3605,10 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
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
@@ -3696,10 +3699,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	count_vm_event(COMPACTSTALL);
 
 	/* Prep a captured page if available */
-	if (page) {
+	if (page)
 		prep_new_page(page, order, gfp_mask, alloc_flags);
-		set_page_refcounted(page);
-	}
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -3708,6 +3709,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	if (page) {
 		struct zone *zone = page_zone(page);
 
+		set_page_refcounted(page);
 		zone->compact_blockskip_flush = false;
 		compaction_defer_reset(zone, order, true);
 		count_vm_event(COMPACTSUCCESS);
@@ -3966,6 +3968,7 @@ retry:
 		drained = true;
 		goto retry;
 	}
+	set_page_refcounted(page);
 out:
 	psi_memstall_leave(&pflags);
 
@@ -4286,8 +4289,10 @@ restart:
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
@@ -4367,8 +4372,10 @@ retry:
 
 	/* Attempt with potentially adjusted zonelist and alloc_flags */
 	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto got_pg;
+	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
 	if (!can_direct_reclaim)
@@ -4752,8 +4759,10 @@ struct page *__alloc_pages_noprof(gfp_t
 
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

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch

