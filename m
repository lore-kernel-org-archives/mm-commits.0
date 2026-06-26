Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC2E64AA4;
	Fri, 26 Jun 2026 00:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434805; cv=none; b=UvthRB7jzGQyj1nGqAqjkYjcsMIAGpT+I0dbEnvmBmcshCcc09y+TIyTe1BlTugFxb1qzAlFIE94/5Y/fjwIdS8nmr90WnzKc5RhB6rKrgB/u+V0hrDhNH/aM7lQnxQg+M37JmvSWWqMIpM5eSFIWU0bVOsEaEYKdw4LUNjFuLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434805; c=relaxed/simple;
	bh=yktQmGAHquSq02GuLsLeNTscAi8DvFCnDel1wHsMS28=;
	h=Date:To:From:Subject:Message-Id; b=X6/jz3xb43JIrbjbTvKlkDLX3GXsMaCpBL1pBij9HfHdbz9spTzAP2EnfZHsDk0AW//2UNoycmgg8zE31/MZ7xdYqjUN4fYVJo7XKJ8h+Y90ChtwXpAN653ztceyjXheWvN63GRUvV47jBcQHKaVP1/2A6RX2RYdNcd6h/k9M9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QL1mPHAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QL1mPHAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3221F000E9;
	Fri, 26 Jun 2026 00:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434803;
	bh=KEukRefTHyO5CrlGIeWAAXB+3DCk726I+3/AN6vz+LI=;
	h=Date:To:From:Subject;
	b=QL1mPHAeZJTPe6euLbL21LDy8VGF6feH3JvC6/ac6SEqA5Gxj+QOaUvUMjXumNFg9
	 y+AvBw8JX7JMTh8BAAI5dO3XubZsr7UZZvLp3GcrPGPXbAvw/GnCqeye5U3gkefFPl
	 oKvnmseN98CNvSSLhiSdmM5cBaYKXmeNJCRu9DnI=
Date: Thu, 25 Jun 2026 17:46:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,kas@kernel.org,david@kernel.org,mclapinski@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-hugetlb-init-tails-before-init_migratetype.patch removed from -mm tree
Message-Id: <20260626004643.9F3221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: init tails before init_migratetype
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-init-tails-before-init_migratetype.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Michal Clapinski <mclapinski@google.com>
Subject: mm/hugetlb: init tails before init_migratetype
Date: Mon, 22 Jun 2026 12:19:01 +0200

Currently, if you enable HVO, DEFERRED_STRUCT_PAGE_INIT and VM_DEBUG the
kernel will crash with the following stack trace

get_pfnblock_bitmap_bitidx
__set_pfnblock_flags_mask
hugetlb_bootmem_init_migratetype
prep_and_add_bootmem_folios
gather_bootmem_prealloc_node
gather_bootmem_prealloc_parallel
padata_do_multithreaded
gather_bootmem_prealloc
hugetlb_init

on this code

VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

This code looks inside the struct page which will be uninitialized
for hugetlb tail pages, which will cause a false positive.

So let's initialize the tail pages before this happens.

Link: https://lore.kernel.org/20260622101901.223961-1-mclapinski@google.com
Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Clapinski <mclapinski@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |    1 +
 mm/hugetlb_vmemmap.c |   14 +++++++++-----
 mm/hugetlb_vmemmap.h |    5 +++++
 3 files changed, 15 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-init-tails-before-init_migratetype
+++ a/mm/hugetlb.c
@@ -4127,6 +4127,7 @@ static int __init hugetlb_init(void)
 	}
 
 	hugetlb_init_hstates();
+	hugetlb_vmemmap_init_tails();
 	gather_bootmem_prealloc();
 	report_hugepages();
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-init-tails-before-init_migratetype
+++ a/mm/hugetlb_vmemmap.c
@@ -867,14 +867,10 @@ static const struct ctl_table hugetlb_vm
 	},
 };
 
-static int __init hugetlb_vmemmap_init(void)
+void __init hugetlb_vmemmap_init_tails(void)
 {
-	const struct hstate *h;
 	struct zone *zone;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
-
 	for_each_zone(zone) {
 		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
 			struct page *tail, *p;
@@ -890,6 +886,14 @@ static int __init hugetlb_vmemmap_init(v
 				init_compound_tail(p + j, NULL, order, zone);
 		}
 	}
+}
+
+static int __init hugetlb_vmemmap_init(void)
+{
+	const struct hstate *h;
+
+	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb-init-tails-before-init_migratetype
+++ a/mm/hugetlb_vmemmap.h
@@ -20,6 +20,7 @@
 #define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+void hugetlb_vmemmap_init_tails(void);
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
@@ -72,6 +73,10 @@ static inline void hugetlb_vmemmap_optim
 {
 }
 
+static inline void hugetlb_vmemmap_init_tails(void)
+{
+}
+
 static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
 						struct list_head *folio_list)
 {
_

Patches currently in -mm which might be from mclapinski@google.com are


