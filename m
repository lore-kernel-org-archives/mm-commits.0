Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F45F35286
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KzmVUFFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B61C433C8;
	Fri,  5 Jan 2024 18:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478723;
	bh=UzAw7XIItYYOY4opPjrxSqVnMDJ9Cpfs4M6Dka6A+qo=;
	h=Date:To:From:Subject:From;
	b=KzmVUFFgljoOJacOmLMF1/bqITFxgv5aalc1OrX+ophRRTYsf6ty7WRISkveE/3ZK
	 vouf5YSdR27RHUr+7qocsAdPnt4dze7k1+dV0KR7KLAMSB7J5SvgAIrQwb/rFer/w6
	 SD+UrtE7oT80qjsqs1Kl08Nh2ez/cOKxnK0dbgI8=
Date: Fri, 05 Jan 2024 10:18:42 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rientjes@google.com,hannes@cmpxchg.org,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] slub-use-alloc_pages_node-in-alloc_slab_page.patch removed from -mm tree
Message-Id: <20240105181842.E8B61C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: slub: use alloc_pages_node() in alloc_slab_page()
has been removed from the -mm tree.  Its filename was
     slub-use-alloc_pages_node-in-alloc_slab_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: slub: use alloc_pages_node() in alloc_slab_page()
Date: Thu, 28 Dec 2023 08:57:44 +0000

For no apparent reason, we were open-coding alloc_pages_node() in this
function.

Link: https://lkml.kernel.org/r/20231228085748.1083901-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/slub.c~slub-use-alloc_pages_node-in-alloc_slab_page
+++ a/mm/slub.c
@@ -1877,11 +1877,7 @@ static inline struct slab *alloc_slab_pa
 	struct slab *slab;
 	unsigned int order = oo_order(oo);
 
-	if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_pages(flags, order);
-	else
-		folio = (struct folio *)__alloc_pages_node(node, flags, order);
-
+	folio = (struct folio *)alloc_pages_node(node, flags, order);
 	if (!folio)
 		return NULL;
 
_

Patches currently in -mm which might be from willy@infradead.org are


