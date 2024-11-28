Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568AFF9DD
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755881; cv=none; b=e4lXoCr8R9Z1t2+XwFCo5RaW/mL1fLG6cJiE9Ov2lAzZQL88V+Ob+V9SZ3BxuabkWVThBslFo+G/ZEuRtSJYx3/9uxfTCo76Xh/D1X4u+DB6dDp+Fss5yAPeHFqO30QvaJATZz+num6hb2Lwu0POPWsLAKJTO41pWl5STi+LIQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755881; c=relaxed/simple;
	bh=T8xvIaqiFoj9qNxETRF5k9KhMyApKrreyKWzCz+g/1w=;
	h=Date:To:From:Subject:Message-Id; b=nAxH8BQXhUwdS+83vvc7SJnDXYz0l2LKTsl0GoK/GZ1ooxpSJCbOYzYaNT6WUhylErQ0FJlvV3N2oFAMqacOOdlP4ee51Stf0ujPxVyhhhVgknp99dkEclEHMR/0mO7S6f0m48N2vviLVenIey+lzloj2EyL2pZeNU5XlIA7eS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fll+PKE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fll+PKE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEA9C4CECC;
	Thu, 28 Nov 2024 01:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755880;
	bh=T8xvIaqiFoj9qNxETRF5k9KhMyApKrreyKWzCz+g/1w=;
	h=Date:To:From:Subject:From;
	b=Fll+PKE7UvNfgQiQ9v+QfYN/NhTzP1rAYkyXs3/qFh5ZyRdsgU+ctZWohM2pzvHDd
	 ctGQ9MdJWTIyHPSPU9Q4SFcuHI7ipDFbT2vDYevE/8VXQTjumLeiYhkeFGADo+zBbG
	 yuTg6xM5Osp2ic4GjGe4ufP8huG94ZB3THNpJ+UA=
Date: Wed, 27 Nov 2024 17:04:40 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch added to mm-unstable branch
Message-Id: <20241128010440.CBEA9C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_may_oom()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch

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
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_may_oom()
Date: Mon, 25 Nov 2024 21:01:40 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_may_oom().

Link: https://lkml.kernel.org/r/20241125210149.2976098-9-willy@infradead.org
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

 mm/page_alloc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom
+++ a/mm/page_alloc.c
@@ -3602,10 +3602,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
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
@@ -3650,8 +3648,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		if (gfp_mask & __GFP_NOFAIL)
 			page = __alloc_pages_cpuset_fallback(gfp_mask, order,
 					ALLOC_NO_WATERMARKS, ac);
-		if (page)
-			set_page_refcounted(page);
 	}
 out:
 	mutex_unlock(&oom_lock);
@@ -4435,8 +4431,10 @@ retry:
 
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

