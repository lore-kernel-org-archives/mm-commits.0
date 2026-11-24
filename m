Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514613;
	b=JO9ziRnNINVwyEJj3w/YD8zL8PoGBji/lfCBMgvJsOTIiVYXxZ+GqiKVvshyfSDfrRVV
	 /6lpWJB9ehR3RKSgj6xvtmLDCYz4XJVtSukZEgv5gAAHo6P7VKA5mJOQmZ2wYmUQHfl71
	 Je1EwXWykL05Xp82COqPUyb94qm5FKPSPRYfGaXvG3Ug0c5amoxe4kNnf8Rlh4lYY1lxN
	 2TXXKfEcW68eu0hcrEbcVYAshpKLey9en93mYSQc8pUo3Gpqu959+uu4fqMHwfvadwHn8
	 UKyc+tVN8B7GlHHWIqS4BUyS5jN+8gJN0eJqGR1r6vfvWrogyBbMHOG9/tJzoiu1v+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514613;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=XH0ny7pIWEJd8MyL7Mg/Bambc3oS3aW2nErg9jE1hq8=;
	b=rw0KWegKvN1G94AhtuHDTBL3W4ZO6kD3NDbvtQz5xJm3Tkc2uQ/Ff8PKTTNHiWUPuHdA
	 AMm6KAa6wdvmO871lyWdvSkDEB1lGtzF/0t2Z8qZdM8LdriRImmsgxNmWsHqZrVWFrSyF
	 Gcbjo0tpOtSE/cM7YYQAS7X3yyAEChrvJ0ZG9YGQZfiGK/mANsMc0g0WwBiLgEw9X1poL
	 C8++zxHApyeaYdXtlIKG/GPohFvnjvuE4f+12YpdZaI1seuUvkj+18sNRn6UYYmpIF09Q
	 T9DtMWME8fUrzGdh5fxpcXXSECSO3nU7lNKtkpksf/JTf6zYSFN5x4doQ+FdHdHiElw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=s7rlWmNJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D70606A327
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 10:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=s7rlWmNJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6947C1F000C6;
	Tue, 24 Nov 2026 10:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795514612;
	bh=XH0ny7pIWEJd8MyL7Mg/Bambc3oS3aW2nErg9jE1hq8=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=s7rlWmNJKQyBpNy01vGIGBGtedm+5TITEQiJoHbQ6Uwwrx6r6Z2JRKVkPL1GSoQqp
	 WWWAC2eSULJu2Tntbl8TE654LtV7pl8wDZxq0FsQhe5d9cDxpafmiB3j5ers1NLgJQ
	 X+EAzzOQDTChdNJ0GJ8kYI2Hc8GChaXEzm4S5JL8=
Date: Tue, 24 Nov 2026 02:03:31 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,smostafa@google.com,skhan@linuxfoundation.org,
	rppt@kernel.org,rdunlap@infradead.org,praan@google.com,mhocko@suse.com,
	liam@infradead.org,ketan.kishore@oss.qualcomm.com,joerg.roedel@amd.com,
	hannes@cmpxchg.org,glider@google.com,elver@google.com,ekffu200098@gmail.com,
	dvyukov@google.com,david@kernel.org,corbet@lwn.net,chris@chrisdown.name,
	brendan.jackman@linux.dev,baolu.lu@linux.intel.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119065812.89959-4-songmuchun@bytedance.com>
References: <20261119065812.89959-4-songmuchun@bytedance.com>
Subject: + mm-page_ext-always-use-vmalloc-for-section-page-extensions.patch added to mm-new branch
Message-Id: <20261124100332.6947C1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_ext: always use vmalloc for section page extensions
has been added to the -mm mm-new branch.  Its filename is
     mm-page_ext-always-use-vmalloc-for-section-page-extensions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-always-use-vmalloc-for-section-page-extensions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/page_ext: always use vmalloc for section page extensions
Date: Thu, 19 Nov 2026 14:58:08 +0800

SPARSEMEM currently tries to allocate each section's page extensions
from the buddy allocator before falling back to vmalloc.  Boot-time
section allocation happens after vmalloc is available, and memory
hotplug allocations do not require physically contiguous backing.

Use vzalloc_node() directly and remove the buddy-specific allocation,
free, and kmemleak bookkeeping.  This leaves one runtime backing type
and lets a later change add memblock as the distinct boot-time path
to simplify the code.

Link: https://patch.msgid.link/20261119065812.89959-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Pranjal Shrivastava <praan@google.com>
Cc: Ketan <ketan.kishore@oss.qualcomm.com>
Cc: Mostafa Saleh <smostafa@google.com>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>

 mm/page_ext.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

--- a/mm/page_ext.c~mm-page_ext-always-use-vmalloc-for-section-page-extensions
+++ a/mm/page_ext.c
@@ -290,15 +290,9 @@ static struct page_ext *lookup_page_ext(
 
 static void *__meminit alloc_page_ext(size_t size, int nid)
 {
-	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
-	void *addr = NULL;
-
-	addr = alloc_pages_exact_nid(nid, size, flags);
-	if (addr)
-		kmemleak_alloc(addr, size, 1, flags);
-	else
-		addr = vzalloc_node(size, nid);
+	void *addr;
 
+	addr = vzalloc_node(size, nid);
 	if (addr)
 		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
 
@@ -344,19 +338,10 @@ static int __meminit init_section_page_e
 static void free_page_ext(void *addr)
 {
 	size_t table_size;
-	struct page *page;
 
 	table_size = page_ext_size * PAGES_PER_SECTION;
 	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-
-	if (is_vmalloc_addr(addr)) {
-		vfree(addr);
-	} else {
-		page = virt_to_page(addr);
-		BUG_ON(PageReserved(page));
-		kmemleak_free(addr);
-		free_pages_exact(addr, table_size);
-	}
+	vfree(addr);
 }
 
 static void __free_page_ext(unsigned long pfn)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch
kmsan-encapsulate-per-page-metadata-access.patch
mm-page_ext-fix-client-data-alignment.patch
mm-page_ext-always-use-vmalloc-for-section-page-extensions.patch
mm-page_ext-use-common-allocation-and-initialization-entry-points.patch
mm-page_ext-allocate-page-extensions-early-for-sparsemem.patch
mm-page_ext-inline-unchecked-page-extension-lookup.patch
kmsan-fix-metadata-loss-during-hugetlb-struct-page-reinitialization.patch

