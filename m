Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514610;
	b=EF3LQtX/CT3iCXAPDlNJ4wz6YGIQfwK2LlXYRbkL1vwJi2XimLDnXdK1Uo/rNOGT0d3f
	 V9Ni5kphlLUoQcBvEPyPJmeRJU1bZyMZkrwqrcPRM6w2alktAiacxdWeMz0oKJQqYJZ3Q
	 xQ8RosHpLGeaKotTFRXFkU8kUovUr8tMDsCeBwOv5WzaKLP/YDCWWx9hW302HcfIvhD0/
	 Cge6HGA3ODS/yqjcnFzyzLtnNv6VndEfNaAmmupQxccXg7It9ig26UkJ2LOBWcz4XyvE9
	 XOucp1/YBgUa6oA4Psl9IgoYtrR9NW8Mdw+DJaVJYCHvPD8rgqLNVMXxmqlAv6LnJmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514610;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Zs4IQJdt1MUCGooQgNWHR6bq9SXtPhZkZYy5NXmYBEs=;
	b=PN9uM9q1pfrMS64S4jD5yXOOiJ2fLhiyB+SGiK3SKQJiBBNAbh/Mmk0bhCnON9bGF7iA
	 DYoVfbrus9LGM8mYsr/5azeVvCrMpk+3B04lllVrh1MCvPi69gypNCRcEzJ7NWLbpsqPW
	 OJ4DftvSbeEOygoJJCy8bgyekZ7N7r4ujTpXtsczhUab+K2VtJrbOJbx79JQHiJI1EIfV
	 08pRHLJLZtJV0Z5h9nv4ywmWyxzq/AUM7XarV2veaO38ZD4h/Xc8dwNLG3VVS2llqw3gC
	 3apkZrCSj1+TZf5Ip53YciPxfWaBFXCjjJB0Lfkus8+TFMtfYReEk1Dlo1gsHcseT+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mdJ2Zrcr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1F1606A32D
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 10:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mdJ2Zrcr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BAC1F000C6;
	Tue, 24 Nov 2026 10:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795514610;
	bh=Zs4IQJdt1MUCGooQgNWHR6bq9SXtPhZkZYy5NXmYBEs=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=mdJ2Zrcrc6GhWKfeK9yR42bTRhxm4BoP+WavYEzW/LYQzgi3J3CH7zIsi1AqimkvV
	 bIFbus8ujby/jzOcgh0MOg6GkhLpRTDiU6UoCHe9i6RnBTRK2M9ky8tfXTXOkGe3DZ
	 sCAOLE/R6q5ZZXgCvjV3kURVXFt35USEmrvrh2KI=
Date: Tue, 24 Nov 2026 02:03:29 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,smostafa@google.com,skhan@linuxfoundation.org,
	rppt@kernel.org,rdunlap@infradead.org,praan@google.com,mhocko@suse.com,
	liam@infradead.org,ketan.kishore@oss.qualcomm.com,joerg.roedel@amd.com,
	hannes@cmpxchg.org,glider@google.com,elver@google.com,ekffu200098@gmail.com,
	dvyukov@google.com,david@kernel.org,corbet@lwn.net,chris@chrisdown.name,
	brendan.jackman@linux.dev,baolu.lu@linux.intel.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119065812.89959-3-songmuchun@bytedance.com>
References: <20261119065812.89959-3-songmuchun@bytedance.com>
Subject: + mm-page_ext-fix-client-data-alignment.patch added to mm-new branch
Message-Id: <20261124100329.E2BAC1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_ext: fix client data alignment
has been added to the -mm mm-new branch.  Its filename is
     mm-page_ext-fix-client-data-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-fix-client-data-alignment.patch

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
Subject: mm/page_ext: fix client data alignment
Date: Thu, 19 Nov 2026 14:58:07 +0800

page_ext lays out client payloads consecutively without aligning their
offsets or the final entry size. This happened to work while the active
payload sizes kept the stride naturally aligned, but IOMMU debug page
allocation added a four-byte payload after data requiring eight-byte
alignment.

When page owner and IOMMU debug page allocation are both enabled on
x86-64, struct page_ext, struct page_owner, and the IOMMU payload use
8, 64, and 4 bytes respectively. This produces a 76-byte entry stride,
leaving struct page_ext and page_owner data in every other entry only
four-byte aligned instead of eight-byte aligned.

Align each client offset and round the final entry size to the largest
active alignment so every page_ext entry preserves the alignment
required by all active clients.

Link: https://patch.msgid.link/20261119065812.89959-3-songmuchun@bytedance.com
Fixes: 466ae6978a5b ("iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

 mm/page_ext.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/mm/page_ext.c~mm-page_ext-fix-client-data-alignment
+++ a/mm/page_ext.c
@@ -116,8 +116,27 @@ static int __init setup_early_page_ext(c
 }
 early_param("early_page_ext", setup_early_page_ext);
 
+static inline size_t page_ext_data_alignment(size_t size)
+{
+	const size_t align = __alignof__(u64);
+
+	if (!size)
+		return 1;
+
+	/* u64 has the strictest alignment required by page_ext clients. */
+	if (IS_ALIGNED(size, align))
+		return align;
+
+	/*
+	 * A type's size is a multiple of its natural alignment, so its
+	 * lowest set bit is at least that alignment.
+	 */
+	return size & -size;
+}
+
 static bool __init invoke_need_callbacks(void)
 {
+	size_t max_align = 1;
 	int i;
 	int entries = ARRAY_SIZE(page_ext_ops);
 	bool need = false;
@@ -126,6 +145,7 @@ static bool __init invoke_need_callbacks
 		if (page_ext_ops[i]->need()) {
 			if (page_ext_ops[i]->need_shared_flags) {
 				page_ext_size = sizeof(struct page_ext);
+				max_align = __alignof__(struct page_ext);
 				break;
 			}
 		}
@@ -133,11 +153,17 @@ static bool __init invoke_need_callbacks
 
 	for (i = 0; i < entries; i++) {
 		if (page_ext_ops[i]->need()) {
+			size_t align;
+
+			align = page_ext_data_alignment(page_ext_ops[i]->size);
+			page_ext_size = ALIGN(page_ext_size, align);
 			page_ext_ops[i]->offset = page_ext_size;
 			page_ext_size += page_ext_ops[i]->size;
+			max_align = max(max_align, align);
 			need = true;
 		}
 	}
+	page_ext_size = ALIGN(page_ext_size, max_align);
 
 	return need;
 }
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

