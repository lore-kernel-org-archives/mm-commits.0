Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403064;
	b=RdwCfmjJkXHUeglvuF7fsT8LddJ4uYygFGAGeGVm3x5et/6easTFUbYHs7Nh16PFmUhj
	 FlGExrMSYuzSA9kVjYUkz68Aaxph96E5CtupNYlbE08oBA0O5l+EgfNK+ZJZM+k2B1RE3
	 lCnWBL5ZX3OQYn1lgELaZPhf/antYhqErFpq4p4+pm1p7DeQBrJIanorFQM/xPf113O8q
	 WxLPrjbA6/YiKkAuCW2nC8D9btdn1jSG5xv5MwyJBQAnhqNPo4GfbPufu0UyPrljbZhor
	 R5mb/SycWbjTHOSZbDhUN6he3PpoWCbSLdxBtCqZ/VQqQNSBDU8LodqgsqI3wRckJSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403064;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=cJO2DuA+Tb0hS/OistkL0+vFlBdR5ybq/z1ZEjPPo1o=;
	b=YyccEf1r7cjIomVP468w5UvqG/d1gD+Y08TtbE4VWEXYdI4GX/64YkwxUMx+WJF/ajQd
	 Koqy+p9yluSYOuYmrzyD3Tqw3Fdykpf+W/bEOtngO8jmokBPYPbX6DEUAW35HCa098z6I
	 HY8P6blysDEvKXhx3wLpNyC35zbwtXngMVNwN0uwOGwNY37J/k/ogrSb2ptWhVsejkr5W
	 m4qvxgT1R4hDAud60Q17Wb5bLIRJrrZz1ieWrgrVnE7ELhWXzCALF5/Zcz8wW2TvKNA9p
	 kKg7MPDhiMlNVVUhzXTbVtJCT2PwR6I4DHwHowHWi9da5brT4UVS6U1Cd40vw3Pw5GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IHg9uCp6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E379606A320
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IHg9uCp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BF61F000C4;
	Mon, 23 Nov 2026 03:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403064;
	bh=cJO2DuA+Tb0hS/OistkL0+vFlBdR5ybq/z1ZEjPPo1o=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=IHg9uCp6UUgbG0P7yAORoIQQpahlTOVXsWklfha42meUNDZ+QYNl76qha5k55u2CP
	 1GU48qVfj+H9VIkY10hFZN9QCOHQI2R5bpplc6BGpQc2X/nWdsIG7C6vf84EU19brL
	 MkLzGfuV7eDkGV0dr7wyYnEQiBDApMcRgO1Mbk2U=
Date: Sun, 22 Nov 2026 19:04:23 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-9-songmuchun@bytedance.com>
References: <20261120100856.16929-9-songmuchun@bytedance.com>
Subject: + mm-mm_init-make-__init_single_page-static.patch added to mm-new branch
Message-Id: <20261123030423.D9BF61F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mm_init: make __init_single_page() static
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-make-__init_single_page-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-make-__init_single_page-static.patch

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
Subject: mm/mm_init: make __init_single_page() static
Date: Fri, 20 Nov 2026 18:08:53 +0800

__init_single_page() is only used within mm/mm_init.c, so make it
static.

Link: https://patch.msgid.link/20261120100856.16929-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/mm_init.c |    2 +-
 mm/mm_init.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-make-__init_single_page-static
+++ a/mm/mm_init.c
@@ -617,7 +617,7 @@ void memmap_init_page(struct page *page,
 #endif
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
+static __meminit void __init_single_page(struct page *page, unsigned long pfn,
 		unsigned long zone, int nid)
 {
 	memmap_init_page(page, zone, nid);
--- a/mm/mm_init.h~mm-mm_init-make-__init_single_page-static
+++ a/mm/mm_init.h
@@ -110,8 +110,6 @@ bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
 void memmap_init_page(struct page *page, enum zone_type zone, int nid);
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid);
 void __meminit memmap_init_compound_page(struct page *head, unsigned long pfn,
 		const struct zone *zone, unsigned int order);
 
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

