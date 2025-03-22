Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F51B12F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619835; cv=none; b=ea1NA0lodH6dF1wr/BDxwuNzY5n5xIkPJNmypZR0DxWFDw9+v1ka4rck7k63KBv4yz+kpxrLimzDF3b5iZMOwpFpEt7ZN95iSkCwz/ETE7CLEiGsuSAR7zUNxbgl+iHXtzcFLMh6+ChRgZ95QmdlAYBNNG5z9UGjSxEo5PGu0qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619835; c=relaxed/simple;
	bh=lpVLiVTNFldZvb2EFoAH7AUD7RB3X9qvgcNb4ZL3UUU=;
	h=Date:To:From:Subject:Message-Id; b=KqSVZ5gIFGgQQiUAjejNEfBD118M4Ga48IxeApdls1bdlgj0cS3IujLet7YH4MvUKVO82G51LN9oD8QdmhjxGROKJBAcWJPhONPeyp+Eg0JF+Y+NwJc2Jzb0QIJgqcoZW2YmGd4zY103DeklbL5cv5p8KG6NgULcAeB6pvLddNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hu91jgVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hu91jgVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13725C4CEDD;
	Sat, 22 Mar 2025 05:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619835;
	bh=lpVLiVTNFldZvb2EFoAH7AUD7RB3X9qvgcNb4ZL3UUU=;
	h=Date:To:From:Subject:From;
	b=hu91jgVdp0FUUVFoRuvb68vf++T6mn5e/Y1nzqEkHE5H3uPsmMJPQsQ2jpU0la3Sf
	 aJqjpJABt5dvvGdalQQwsdBsz4569QhXzhS9ZZ6SqzQ3GBGa0regFxWhsfWq8XJDi6
	 VV/mgMmL5vGAukqMU1FjFG8OrQzMRmmStdYHF5mU=
Date: Fri, 21 Mar 2025 22:03:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch removed from -mm tree
Message-Id: <20250322050355.13725C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove references to folio in __memcg_kmem_uncharge_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove references to folio in __memcg_kmem_uncharge_page()
Date: Fri, 14 Mar 2025 13:36:15 +0000

This use of folios is misleading because these pages are not part of
a folio.  Remove an unnecessary call to page_folio(), saving 58 bytes
of text in a Debian kernel build.

Link: https://lkml.kernel.org/r/20250314133617.138071-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page
+++ a/mm/memcontrol.c
@@ -2726,16 +2726,14 @@ int __memcg_kmem_charge_page(struct page
  */
 void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	struct folio *folio = page_folio(page);
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *objcg = page_objcg(page);
 	unsigned int nr_pages = 1 << order;
 
-	if (!folio_memcg_kmem(folio))
+	if (!objcg)
 		return;
 
-	objcg = __folio_objcg(folio);
 	obj_cgroup_uncharge_pages(objcg, nr_pages);
-	folio->memcg_data = 0;
+	page->memcg_data = 0;
 	obj_cgroup_put(objcg);
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


