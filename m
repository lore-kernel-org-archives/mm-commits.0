Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5745584D25
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066909; cv=none; b=ZsNVSRMAbLfmfHAQ254E8K06wfLstpqqaCvmE1ERmPzFDyq6babyj4BEsDyLGfbqLGl+qNAnRDrEAYvlPihGwZUfaG9A9cWJwnrnvYZ5kGhD3ipV3i3gO/O0j5aeW92w6BIlUK6yd129kPKI/pjC/ibjfumVcQFXccGQDNqxY3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066909; c=relaxed/simple;
	bh=daDkM2NtoNcHw/bgCPmeTDeSfb9igkRuybsq4gAVW+Y=;
	h=Date:To:From:Subject:Message-Id; b=qNWxQpPFDrklEMTei/mqMEADSw6CeLIUTvKC3iG6yN7IhcUvxo8nwzRJzlPIEt3fFvbEL0mV6kxNNIjEX0ARAdAIib06Ref10Km1SZ/xUmD4ALiBEgeVl4oT2ojzm7g4HhHJZpa49o1ef07VPivlwpW5yzYM6V6nnv3Cw5NCRiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XiwG7ULe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XiwG7ULe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9229C32781;
	Wed,  7 Aug 2024 21:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723066908;
	bh=daDkM2NtoNcHw/bgCPmeTDeSfb9igkRuybsq4gAVW+Y=;
	h=Date:To:From:Subject:From;
	b=XiwG7ULen5LsD0srk7agMtGeopoA51LtMPHAQYWiaXXx8+McO2/byFVLfqfbTCOR9
	 lnObVHDfRUMU5O57OaxFNJvRbyiPbbbLfuAMRgnBnEdzcV8JGTpam+wgDWAn9Hkg8X
	 +IvAwe8sITcmM5M5ILSIdN3eqkXaKAQrx1g7+swU=
Date: Wed, 07 Aug 2024 14:41:48 -0700
To: mm-commits@vger.kernel.org,yi.zhang@redhat.com,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,rppt@kernel.org,rientjes@google.com,nphamcs@gmail.com,muchun.song@linux.dev,lizhijian@fujitsu.com,j.granados@samsung.com,hannes@cmpxchg.org,david@redhat.com,cerasuolodomenico@gmail.com,alison.schofield@intel.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-the-memmap-stat-before-page-is-freed.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807214148.A9229C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update the memmap stat before page is freed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-update-the-memmap-stat-before-page-is-freed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-the-memmap-stat-before-page-is-freed.patch

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
Subject: mm: update the memmap stat before page is freed
Date: Wed, 7 Aug 2024 21:19:27 +0000

Patch series "Fixes for memmap accounting", v2.

Memmap accounting provides us with observability of how much memory is
used for per-page metadata: i.e.  "struct page"'s and "struct page_ext". 
It also provides with information of how much was allocated using boot
allocator (i.e.  not part of MemTotal), and how much was allocated using
buddy allocated (i.e.  part of MemTotal).

This small series fixes a few problems that were discovered with the
original patch which added the accounting of per-page metadata.


This patch (of 3):

It is more logical to update the stat before the page is freed, to avoid
use after free scenarios.

Link: https://lkml.kernel.org/r/20240807211929.3433304-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20240807211929.3433304-2-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    4 ++--
 mm/page_ext.c        |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-update-the-memmap-stat-before-page-is-freed
+++ a/mm/hugetlb_vmemmap.c
@@ -185,11 +185,11 @@ static int vmemmap_remap_range(unsigned
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
-		free_bootmem_page(page);
 		mod_node_page_state(page_pgdat(page), NR_MEMMAP_BOOT, -1);
+		free_bootmem_page(page);
 	} else {
-		__free_page(page);
 		mod_node_page_state(page_pgdat(page), NR_MEMMAP, -1);
+		__free_page(page);
 	}
 }
 
--- a/mm/page_ext.c~mm-update-the-memmap-stat-before-page-is-freed
+++ a/mm/page_ext.c
@@ -330,18 +330,18 @@ static void free_page_ext(void *addr)
 	if (is_vmalloc_addr(addr)) {
 		page = vmalloc_to_page(addr);
 		pgdat = page_pgdat(page);
+		mod_node_page_state(pgdat, NR_MEMMAP,
+				    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 		vfree(addr);
 	} else {
 		page = virt_to_page(addr);
 		pgdat = page_pgdat(page);
+		mod_node_page_state(pgdat, NR_MEMMAP,
+				    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 		BUG_ON(PageReserved(page));
 		kmemleak_free(addr);
 		free_pages_exact(addr, table_size);
 	}
-
-	mod_node_page_state(pgdat, NR_MEMMAP,
-			    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-
 }
 
 static void __free_page_ext(unsigned long pfn)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-update-the-memmap-stat-before-page-is-freed.patch
mm-dont-account-memmap-on-failure.patch
mm-dont-account-memmap-per-node.patch
memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

