Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91E4847B
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755896; cv=none; b=E/lE7A+wzwZan1C0x4d9EFh8SgEtGTGP0R87bYtEzMCN0E2kRBK7KlDywp6E00+l7AizLwVBk5oS3sJCKxO0eGbrG7VxPlwqsQIAKOc9qMAG9x+gwMKl7NnVPoep/IQO1RhDe8OfuCrBbmMDd9MXoggKPhRt7rSLM4GxdBsbEW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755896; c=relaxed/simple;
	bh=pdagWl8dnXDPoM4uStdqaxXQUjnFugkVAHRiibHvdqI=;
	h=Date:To:From:Subject:Message-Id; b=Ta87wpzoEhFvL9sLCFw5q0My+rUVHWeDSwyh8uebxsp+sHvZUnzzwkkXEtR3/xN8mjwW+18pKqmVNbfHClIU0GtzpQgXxgo40uWG9Ytph7xF1t7UbbdA8etMALnbawphc6vGlauaCOmSY8A/wQF5sESe2DyMf3TMhIYk4MoQLiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gikbjy9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gikbjy9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5D2C4CECC;
	Thu, 28 Nov 2024 01:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755895;
	bh=pdagWl8dnXDPoM4uStdqaxXQUjnFugkVAHRiibHvdqI=;
	h=Date:To:From:Subject:From;
	b=Gikbjy9ASG+Vd8TVun/DKZuwGu33pcVAykS4oHoDk0xIzmwNkHcnRO/0vc4tJd/U9
	 gwDg5ASTSEOumWo1evbEhh9tOFownWoLcX36fYOonLuYj9iAlWhA+HlgpjKSuiAtH5
	 Mg6hGRLJ8b39JoeYJR6hq05zU07leY/AHphMEm94=
Date: Wed, 27 Nov 2024 17:04:54 -0800
To: mm-commits@vger.kernel.org,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsinguularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slab-allocate-frozen-pages.patch added to mm-unstable branch
Message-Id: <20241128010455.6C5D2C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slab: allocate frozen pages
has been added to the -mm mm-unstable branch.  Its filename is
     slab-allocate-frozen-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slab-allocate-frozen-pages.patch

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
Subject: slab: allocate frozen pages
Date: Mon, 25 Nov 2024 21:01:47 +0000

Since slab does not use the page refcount, it can allocate and free frozen
pages, saving one atomic operation per free.

Link: https://lkml.kernel.org/r/20241125210149.2976098-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsinguularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slub.c~slab-allocate-frozen-pages
+++ a/mm/slub.c
@@ -2405,9 +2405,9 @@ static inline struct slab *alloc_slab_pa
 	unsigned int order = oo_order(oo);
 
 	if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_pages(flags, order);
+		folio = (struct folio *)alloc_frozen_pages(flags, order);
 	else
-		folio = (struct folio *)__alloc_pages_node(node, flags, order);
+		folio = (struct folio *)__alloc_frozen_pages(flags, order, node, NULL);
 
 	if (!folio)
 		return NULL;
@@ -2641,7 +2641,7 @@ static void __free_slab(struct kmem_cach
 	__folio_clear_slab(folio);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
-	__free_pages(&folio->page, order);
+	free_frozen_pages(&folio->page, order);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
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

