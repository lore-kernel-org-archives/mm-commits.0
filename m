Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2420135286
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WYe/MulA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01B2C433C9;
	Fri,  5 Jan 2024 18:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478724;
	bh=tU8kOZXDwYA4jHCyk28fyGdvheTuiNFdeis9j9Z5Mv4=;
	h=Date:To:From:Subject:From;
	b=WYe/MulAyIHpE9w9/BVfvsDm9GDMw6EoE6HhvvCpQKxStAZLiQ0ZBZqvSQBbteyMG
	 9X96//O/dx//mg1qPOZAnBsV4g0xJrLb9QzaYvxCQj2gGC+Kfnwe+20BnT1igft9Rp
	 6QSk9P+xPqpyRZVo3Z1Yo2z9GHe3cdXL7eoT9RlI=
Date: Fri, 05 Jan 2024 10:18:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rientjes@google.com,hannes@cmpxchg.org,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] slub-use-folio-apis-in-free_large_kmalloc.patch removed from -mm tree
Message-Id: <20240105181843.E01B2C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: slub: use folio APIs in free_large_kmalloc()
has been removed from the -mm tree.  Its filename was
     slub-use-folio-apis-in-free_large_kmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: slub: use folio APIs in free_large_kmalloc()
Date: Thu, 28 Dec 2023 08:57:45 +0000

Save a few calls to compound_head() by using the folio APIs directly.

Link: https://lkml.kernel.org/r/20231228085748.1083901-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slab_common.c~slub-use-folio-apis-in-free_large_kmalloc
+++ a/mm/slab_common.c
@@ -979,9 +979,9 @@ void free_large_kmalloc(struct folio *fo
 	kasan_kfree_large(object);
 	kmsan_kfree_large(object);
 
-	mod_lruvec_page_state(folio_page(folio, 0), NR_SLAB_UNRECLAIMABLE_B,
+	lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
 			      -(PAGE_SIZE << order));
-	__free_pages(folio_page(folio, 0), order);
+	folio_put(folio);
 }
 
 static void *__kmalloc_large_node(size_t size, gfp_t flags, int node);
_

Patches currently in -mm which might be from willy@infradead.org are


