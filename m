Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5524B847B
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755879; cv=none; b=iK5CsK+Odg2p6lT0qIc8/u/aGo4V1JQGmcprf3zMpkBN3ZnP0gcyF+X82Br0f5V2+p/ropmHL3gV3OkdWm3Tzh9luRQs+rSqOryLvFFPNz0ZJSVCEm5rrNBAUJJzf9Sdg+8nlOsR4pIkjVc702JaisIfUdqXg70CrPCMpxph9qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755879; c=relaxed/simple;
	bh=QCCVnagmaXF052YRwfV14ev1H6BtzlCApocFKyfu5Dw=;
	h=Date:To:From:Subject:Message-Id; b=XSqjgCLje0Ocx5UzluHUG3GG7PNvI8ss9JNrn+0mW8rPauzJBeis+nvGM0USih35bitxq6DzFm2yBt2n7dzVjUX7gWt+vMK4rYZSm7BEU7lkB3hhJSfig3LJ2aMTrhhjpBHLI/VNbxrRRbDRSb9U7lW/GMZPwSfhWmdtpyCmQpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1BM/iQq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1BM/iQq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DBFC4CECC;
	Thu, 28 Nov 2024 01:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755878;
	bh=QCCVnagmaXF052YRwfV14ev1H6BtzlCApocFKyfu5Dw=;
	h=Date:To:From:Subject:From;
	b=1BM/iQq8PtbsECwNMd6n+CFxOdbC1QJZlTJJsThaDIvF5u3OhmCK3ffjzJ3SIjOhH
	 eFJmKo6fhbhRm2gPFrMIu5SFLK3fGHWNuBmN54F8AJpdeJ3xjLdcP4Q6NYl5hOLm5a
	 1yZ/YOhiRJLkeZRa+a6O9B7rNY9WAjvOIHKBTvko=
Date: Wed, 27 Nov 2024 17:04:38 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch added to mm-unstable branch
Message-Id: <20241128010438.D6DBFC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_cpuset_fallback()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch

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
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_cpuset_fallback()
Date: Mon, 25 Nov 2024 21:01:39 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_cpuset_fallback().

Link: https://lkml.kernel.org/r/20241125210149.2976098-8-willy@infradead.org
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

 mm/page_alloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback
+++ a/mm/page_alloc.c
@@ -3564,9 +3564,6 @@ __alloc_pages_cpuset_fallback(gfp_t gfp_
 	if (!page)
 		page = get_page_from_freelist(gfp_mask, order,
 				alloc_flags, ac);
-
-	if (page)
-		set_page_refcounted(page);
 	return page;
 }
 
@@ -3653,6 +3650,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		if (gfp_mask & __GFP_NOFAIL)
 			page = __alloc_pages_cpuset_fallback(gfp_mask, order,
 					ALLOC_NO_WATERMARKS, ac);
+		if (page)
+			set_page_refcounted(page);
 	}
 out:
 	mutex_unlock(&oom_lock);
@@ -4481,8 +4480,10 @@ nopage:
 		 * the situation worse.
 		 */
 		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE, ac);
-		if (page)
+		if (page) {
+			set_page_refcounted(page);
 			goto got_pg;
+		}
 
 		cond_resched();
 		goto retry;
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

