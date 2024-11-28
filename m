Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E3817753
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755887; cv=none; b=iF6RfxCGnCJYPEMURVU7/4jduun02Mmh3x6XfiigOrWjmgmjNseBsZ3D5itYrMC56vmNgXdc+FQur8J7BTfahr5xrXkTtJXeMvq1uy2iH50IObl47X7UMuTY0Drnwcfy0gOvYtwvGtebo0zU8e5L/w+dcYhz1e08ueQdftAdgBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755887; c=relaxed/simple;
	bh=kTrK0gZX056gV7Syzg6Vd9RJpGk1kZtsIQWTLdneKsc=;
	h=Date:To:From:Subject:Message-Id; b=LJNFYdKymIsTfTLyIDD6j19OIyq9noy2d/4BSqsP8cTyAuS4wzQZdyqD5zKpXycZqS3BLDYKPaSdk0E+8YbGNAvY7CY/xAfJ3zkDQuLvVjmNRPbKcfYJayHnRt2IRq+BldAO05O+XjrPKvZyE/V+eJMzV6BaV9RpFmqDT8y6NKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pl6T612c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pl6T612c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A51AC4CECC;
	Thu, 28 Nov 2024 01:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755886;
	bh=kTrK0gZX056gV7Syzg6Vd9RJpGk1kZtsIQWTLdneKsc=;
	h=Date:To:From:Subject:From;
	b=pl6T612ckCNOKExZ0xIoZLiCRRGEsS8eEoUodz+cGybhMuHUNdD1ZIf+T0dT0AlE5
	 IHXSiuOpQQ+zFofXoQ8w+r3m5Za08f/2yt2ZcmiQXm9y9Pu/mb9hWwvVJjgNbKERcl
	 Hjd1jZKq/cThvDXGIkNSsict/HWdVzHPFq/Dlcu4=
Date: Wed, 27 Nov 2024 17:04:46 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch added to mm-unstable branch
Message-Id: <20241128010446.9A51AC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_slowpath()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch

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
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_slowpath()
Date: Mon, 25 Nov 2024 21:01:43 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_slowpath().

Link: https://lkml.kernel.org/r/20241125210149.2976098-12-willy@infradead.org
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

 mm/page_alloc.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath
+++ a/mm/page_alloc.c
@@ -4282,10 +4282,8 @@ restart:
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
@@ -4304,10 +4302,8 @@ restart:
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
@@ -4367,10 +4363,8 @@ retry:
 
 	/* Attempt with potentially adjusted zonelist and alloc_flags */
 	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
-	if (page) {
-		set_page_refcounted(page);
+	if (page)
 		goto got_pg;
-	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
 	if (!can_direct_reclaim)
@@ -4383,18 +4377,14 @@ retry:
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
@@ -4435,10 +4425,8 @@ retry:
 
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
-	if (page) {
-		set_page_refcounted(page);
+	if (page)
 		goto got_pg;
-	}
 
 	/* Avoid allocations with no watermarks from looping endlessly */
 	if (tsk_is_oom_victim(current) &&
@@ -4482,10 +4470,8 @@ nopage:
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
@@ -4777,6 +4763,8 @@ struct page *__alloc_pages_noprof(gfp_t
 	ac.nodemask = nodemask;
 
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
+	if (page)
+		set_page_refcounted(page);
 
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
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

