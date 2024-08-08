Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AF98827
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 21:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723153906; cv=none; b=sgiTchqNmSybHi+x0fm9ONYA+cnipgc8SQjosYcbARG9lxhm1gOPDWJKXXvZ4EvZUDeZ2qFwy/t9qcp/spUElKcyd1B4YRiEeegGXU1O0OTSZxXbr3intUSuWN+l42DUumrrdoleJyA1pCR2CUdcpNqng2Td6tu13tRtRS2HEY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723153906; c=relaxed/simple;
	bh=9IpzJNdcuUtaerXwlq9lKqAlKHS14RIM6C5OX4VOcPs=;
	h=Date:To:From:Subject:Message-Id; b=LdHxGVkda3pctJhUaAl9/y143Yl+/voSYHM+MFSWaT7Qk3MhKHo/peyZU0ho6X+CPRBR0vmkifJ4/tBSJKGXnKTLAu7BR2gfciVHrH1rPp8sHIbwxmCjt63ZLc2FVKikJrC42mtBoAE+HgwDxGn8sgX83uuneED0YMkE/BH4+UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ohgS0YxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ohgS0YxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7F4C32782;
	Thu,  8 Aug 2024 21:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723153905;
	bh=9IpzJNdcuUtaerXwlq9lKqAlKHS14RIM6C5OX4VOcPs=;
	h=Date:To:From:Subject:From;
	b=ohgS0YxQEonkKKTWuKFKMScIDCKgJ9Vifvqb4Or30SGzCEsNzbPanv/03S0CSIPqS
	 5Ap8AY6b0c+PUkkZ7yikit7O/AvMKYg3xsdKaZUGhinusWtVJVt47wPT52QrxEhxnY
	 odCjTpbDKPexTedcOV/lI7ygFBQmplAW1LwRuwO8=
Date: Thu, 08 Aug 2024 14:51:44 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,fan.ni@samsung.com,david@redhat.com,dan.j.williams@intel.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-account-memmap-on-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20240808215145.7A7F4C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: don't account memmap on failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-dont-account-memmap-on-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-account-memmap-on-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Link: https://lkml.kernel.org/r/20240808213437.682006-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240808213437.682006-2-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
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

mm-dont-account-memmap-on-failure.patch
mm-add-system-wide-stats-items-category.patch
mm-dont-account-memmap-per-node.patch
memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

