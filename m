Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318F478C7F
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 05:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785410; cv=none; b=RzCxz8cuCw8zbJsNcF33neXqX/4SIv6SxI1D/1HSbYHnWipCmkOhM50GtrknqykLwBoFvWY+/XETqi4CkVdXuLqJ1Kdm3kYTT6Bj84sqt4NnhByIuZw8jRYIRgGAYVFGk7AWv0Ozbrc/oJzlU7s8tS6rMNB/5l0gE4rxBu1ZWNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785410; c=relaxed/simple;
	bh=/qdyBaF6eS9beIJgwT5ab0ttsHs0cHkcCJQf0C681Zw=;
	h=Date:To:From:Subject:Message-Id; b=EDDMaR9rjjoHzOajZdvtJ46/5dNa1DzdWq8RKwHjtnuEUuMkdfocrXUl/p2hmHJJtEOoZjHX+c7NPTZaBCNy0wmOcZHUczTasjjTlt5aLZ5dJ38nmWOBp5x6EpgupEena1R471eR2cbNmcARyFTHeXv314ZnlNhPypL1fWgadYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=naD+5CeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="naD+5CeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B6EC32782;
	Fri, 16 Aug 2024 05:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785410;
	bh=/qdyBaF6eS9beIJgwT5ab0ttsHs0cHkcCJQf0C681Zw=;
	h=Date:To:From:Subject:From;
	b=naD+5CeWcyU0cc7UBLDP0l6qIIEBsB5x8zAOAJ6Y/1JXDSE9dudyv/9wNXK5TxEBb
	 IrUUAPMe4gMQmJFwHJW/jBm31egYQp6LB7oe12zNzMyAIUrOJZbMAKmYqv8xlyftHR
	 OtBKa2PeOwCZlxrgD7wvVKXOQwIdE4Ypt4tq9gFY=
Date: Thu, 15 Aug 2024 22:16:49 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,fan.ni@samsung.com,david@redhat.com,dan.j.williams@intel.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-dont-account-memmap-on-failure.patch removed from -mm tree
Message-Id: <20240816051650.06B6EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't account memmap on failure
has been removed from the -mm tree.  Its filename was
     mm-dont-account-memmap-on-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: don't account memmap on failure
Date: Thu, 8 Aug 2024 21:34:34 +0000

Patch series "Fixes for memmap accounting", v4.

Memmap accounting provides us with observability of how much memory is
used for per-page metadata: i.e. "struct page"'s and "struct page_ext".
It also provides with information of how much was allocated using
boot allocator (i.e. not part of MemTotal), and how much was allocated
using buddy allocated (i.e. part of MemTotal).

This small series fixes a few problems that were discovered with the
original patch.


This patch (of 3):

When we fail to allocate the mmemmap in alloc_vmemmap_page_list(), do not
account any already-allocated pages: we're going to free all them before
we return from the function.

Link: https://lkml.kernel.org/r/20240809191020.1142142-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240808213437.682006-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240808213437.682006-2-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-dont-account-memmap-on-failure
+++ a/mm/hugetlb_vmemmap.c
@@ -392,13 +392,10 @@ static int alloc_vmemmap_page_list(unsig
 
 	for (i = 0; i < nr_pages; i++) {
 		page = alloc_pages_node(nid, gfp_mask, 0);
-		if (!page) {
-			mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, i);
+		if (!page)
 			goto out;
-		}
 		list_add(&page->lru, list);
 	}
-
 	mod_node_page_state(NODE_DATA(nid), NR_MEMMAP, nr_pages);
 
 	return 0;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

