Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EE935280
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0crhL02v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10767C433C9;
	Fri,  5 Jan 2024 18:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478725;
	bh=45j0ez44A9qVcOzLv23MDUG56IOU7yk8jm/3uVUPRF0=;
	h=Date:To:From:Subject:From;
	b=0crhL02v5D2KOnbncBc0ZcZj/8PP6ltfqyfI1luH9iHd/2KfIoN0fv3CvbwfVBKFM
	 8Nn1mwHy6zouaARllMPQ+ot8/3erLsHgg2snU5H6WS6HKTyFvfjjhD8ar6zU4vQFKb
	 UVIETypDvSr1wFE6XKtotxlSNgsV2Grg5HO36Hcw=
Date: Fri, 05 Jan 2024 10:18:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rientjes@google.com,hannes@cmpxchg.org,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] slub-use-a-folio-in-__kmalloc_large_node.patch removed from -mm tree
Message-Id: <20240105181845.10767C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: slub: use a folio in __kmalloc_large_node
has been removed from the -mm tree.  Its filename was
     slub-use-a-folio-in-__kmalloc_large_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: slub: use a folio in __kmalloc_large_node
Date: Thu, 28 Dec 2023 08:57:46 +0000

Mirror the code in free_large_kmalloc() and alloc_pages_node() and use a
folio directly.  Avoid the use of folio_alloc() as that will set up an
rmappable folio which we do not want here.

Link: https://lkml.kernel.org/r/20231228085748.1083901-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/slab_common.c~slub-use-a-folio-in-__kmalloc_large_node
+++ a/mm/slab_common.c
@@ -1137,7 +1137,7 @@ gfp_t kmalloc_fix_flags(gfp_t flags)
 
 static void *__kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct page *page;
+	struct folio *folio;
 	void *ptr = NULL;
 	unsigned int order = get_order(size);
 
@@ -1145,10 +1145,10 @@ static void *__kmalloc_large_node(size_t
 		flags = kmalloc_fix_flags(flags);
 
 	flags |= __GFP_COMP;
-	page = alloc_pages_node(node, flags, order);
-	if (page) {
-		ptr = page_address(page);
-		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+	folio = (struct folio *)alloc_pages_node(node, flags, order);
+	if (folio) {
+		ptr = folio_address(folio);
+		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
 				      PAGE_SIZE << order);
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are


