Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CA717753
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755888; cv=none; b=Cdf5KDD8fhXmRqvKkT3xfIYZ+sTIM7q53CCtXEPbfSVZv93i+m9BX/PwC89CJFozdIcQXbHiffXhVRwHelEwwDt9AcaTd8q3iqO4Xi8MgKWG9Ks7QetHzvL4Y9K/ioeqOtg9S6WB8XckjMMNzOs+a1hM8mTDyU7WDYKCgYZgyNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755888; c=relaxed/simple;
	bh=1WUCLe7bDMKkgZOmqjhbJQ7azugLmPn6SP5S+DYMyEY=;
	h=Date:To:From:Subject:Message-Id; b=b+PD9yJ60H7FhPtqc2UeWWXf6XmB5m4JPusQP7ENM8/YFv0MZOhT3pmGGTlpj9M7pTffOIjf2qHNpgl4mW1WlFA2TjSEPx0OFVb91k/NVQfwv6t3Smf2zSyI6xNeqUFInXukXu+b2cmvMsqrV4zudaY3dEpileJLNjmEjWvNtHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FQe5CPQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FQe5CPQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F63DC4CECC;
	Thu, 28 Nov 2024 01:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755888;
	bh=1WUCLe7bDMKkgZOmqjhbJQ7azugLmPn6SP5S+DYMyEY=;
	h=Date:To:From:Subject:From;
	b=FQe5CPQGa3HeDuEfcDoZGin80rMHiL9qFYvqWf5iP12VB8M0EOEwG6874zMhfARxp
	 SnQgasW2LX/lclhM6nmWP+yW+iXUGpEcknQbT/BzGxaj/NonbMBJaQquXMcvigqR+K
	 7gOR4G07WyO/PqXpZ+N4k7yIv9egoeSVNvN0PJvY=
Date: Wed, 27 Nov 2024 17:04:48 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch added to mm-unstable branch
Message-Id: <20241128010448.8F63DC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to end of __alloc_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch

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
Subject: mm/page_alloc: move set_page_refcounted() to end of __alloc_pages()
Date: Mon, 25 Nov 2024 21:01:44 +0000

Remove some code duplication by calling set_page_refcounted() at the end
of __alloc_pages() instead of after each call that can allocate a page. 
That means that we free a frozen page if we've exceeded the allowed memcg
memory.

Link: https://lkml.kernel.org/r/20241125210149.2976098-13-willy@infradead.org
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

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages
+++ a/mm/page_alloc.c
@@ -4748,10 +4748,8 @@ struct page *__alloc_pages_noprof(gfp_t
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
-	if (likely(page)) {
-		set_page_refcounted(page);
+	if (likely(page))
 		goto out;
-	}
 
 	alloc_gfp = gfp;
 	ac.spread_dirty_pages = false;
@@ -4763,15 +4761,15 @@ struct page *__alloc_pages_noprof(gfp_t
 	ac.nodemask = nodemask;
 
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
-	if (page)
-		set_page_refcounted(page);
 
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
-		__free_pages(page, order);
+		free_frozen_pages(page, order);
 		page = NULL;
 	}
+	if (page)
+		set_page_refcounted(page);
 
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 	kmsan_alloc_page(page, order, alloc_gfp);
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

