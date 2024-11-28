Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3064B17758
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755885; cv=none; b=PjrH1n6stCed6/i6OIDkNdQf5bkQpABOf5LQYYrxHBdqe51ORDnECdaYOVztRUElzybyUq+ti+skOV5r1Oj+OBdoeNfBEPZmBvAy6lro9MowsL2jxrSx/oQZVTXZ70YXmYdCPumftIdlQDuCVJDL1e4l/mv+rq9ivLlY7cKHLGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755885; c=relaxed/simple;
	bh=EN8+0QVKVkWhrEs4OJo3r6FJ3eoZ/Eh0iu7ykajexxs=;
	h=Date:To:From:Subject:Message-Id; b=HcHGiqYjLA/3Sd3Z+z7S0mnvRghTjqVenKCwevTueUQRdFeHW1nrsn5tXwwCzbwjqhiFWLTBc8o7mAd/S5ak5ffd1+Xu8+hM4jrBHaKORIIj2282SO3zIZYkt7zmxTt9oVViw0aJV/RXpYeq+wN9g970WpbktUYGlXeLlH3GeCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bcyJV3//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bcyJV3//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EEBC4CECC;
	Thu, 28 Nov 2024 01:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755884;
	bh=EN8+0QVKVkWhrEs4OJo3r6FJ3eoZ/Eh0iu7ykajexxs=;
	h=Date:To:From:Subject:From;
	b=bcyJV3//rwdYAaO7kWp/pysGTljjP6Q8ywCluqrIVJagnVfQBcbSg8WhfjywFvcwb
	 8ar/qbiDZ5UFzSZAPwOXFJT1y7A8oR1ji3E1cQ6PG20CxbmkkbwJVctNG3SO+XZMAW
	 e84L2l+o4CstfrRtRYUJ4v1KKzm8ORihowse3VB0=
Date: Wed, 27 Nov 2024 17:04:44 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch added to mm-unstable branch
Message-Id: <20241128010444.A2EEBC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_direct_reclaim()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch

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
Subject: mm/page_alloc: move set_page_refcounted() to callers of __alloc_pages_direct_reclaim()
Date: Mon, 25 Nov 2024 21:01:42 +0000

In preparation for allocating frozen pages, stop initialising the page
refcount in __alloc_pages_direct_reclaim().

Link: https://lkml.kernel.org/r/20241125210149.2976098-11-willy@infradead.org
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

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim
+++ a/mm/page_alloc.c
@@ -3962,7 +3962,6 @@ retry:
 		drained = true;
 		goto retry;
 	}
-	set_page_refcounted(page);
 out:
 	psi_memstall_leave(&pflags);
 
@@ -4384,8 +4383,10 @@ retry:
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
 							&did_some_progress);
-	if (page)
+	if (page) {
+		set_page_refcounted(page);
 		goto got_pg;
+	}
 
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
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

