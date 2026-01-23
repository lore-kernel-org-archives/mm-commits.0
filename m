Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6836E462
	for <mm-commits@vger.kernel.org>; Fri, 23 Jan 2026 01:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769131644; cv=none; b=rfdCdU9i7E6wJXGaFaYX/d0oA0FTNS2kn7ImLXujI1fL497dSLRPxCR6msyu7oGoZsqvmrfT6WDvI9GZI3lajuRnkYPl9QyTTP5joevdLHY0ZQWPcjUahB+EVq9u1Oxp6komZla65wmsYzbF3s2MT4pyDL9+W1vi6vjSxzxBpps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769131644; c=relaxed/simple;
	bh=c0lBE6HHtnmV/3oBLeE9vgfYQqStwbhGCYdTSf/EA7M=;
	h=Date:To:From:Subject:Message-Id; b=E0nSmeNuoau2JD3x8HrQtCsfl1oKKW20u1Qk5LB5Vd3yCZK4sCwgThRnl/883Kq6rzLPwRjRPImwue/4NqvcnypMBMqGe6YjRqjgxme5B/TZTDVjl4+GB0N9Qnh8VXQ/jIOPM+BwrDaIk2+HJhGW6KOv9OWn1E1V+C6kO4q/rQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SJff6F76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SJff6F76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F96C116C6;
	Fri, 23 Jan 2026 01:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769131643;
	bh=c0lBE6HHtnmV/3oBLeE9vgfYQqStwbhGCYdTSf/EA7M=;
	h=Date:To:From:Subject:From;
	b=SJff6F765KXGmIb4WXDbVCO4q/ewPKMPGVmYosOoo+hR0kxW99b7RIqqqEGYaTRJi
	 ixF6KtEeuSy5Z3B9Ytl7rkHowCN4sQC1K2u3lR34rmsAuRzfiAWXbQ/CCOuHVumK2y
	 CGUtnaM4LOdzs38XlHBvnn065Fu/cMoF4B3aySAs=
Date: Thu, 22 Jan 2026 17:27:23 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,tzimmermann@suse.de,surenb@google.com,simona@ffwll.ch,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mripard@kernel.org,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,leon@kernel.org,jgg@ziepe.ca,francois.dugast@intel.com,felix.kuehling@amd.com,david@kernel.org,dakr@kernel.org,christian.koenig@amd.com,chleroy@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,alexander.deucher@amd.com,akpm@linux-foundation.org,airlied@gmail.com,matthew.brost@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zone_device-reinitialize-large-zone-device-private-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20260123012723.D1F96C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zone_device: reinitialize large zone device private folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zone_device-reinitialize-large-zone-device-private-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zone_device-reinitialize-large-zone-device-private-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Matthew Brost <matthew.brost@intel.com>
Subject: mm/zone_device: reinitialize large zone device private folios
Date: Fri, 16 Jan 2026 12:10:16 +0100

Reinitialize metadata for large zone device private folios in
zone_device_page_init prior to creating a higher-order zone device private
folio.  This step is necessary when the folio's order changes dynamically
between zone_device_page_init calls to avoid building a corrupt folio.  As
part of the metadata reinitialization, the dev_pagemap must be passed in
from the caller because the pgmap stored in the folio page may have been
overwritten with a compound head.

Without this fix, individual pages could have invalid pgmap fields and
flags (with PG_locked being notably problematic) due to prior different
order allocations, which can, and will, result in kernel crashes.

Link: https://lkml.kernel.org/r/20260116111325.1736137-2-francois.dugast@intel.com
Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: adhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c       |    2 -
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    2 -
 drivers/gpu/drm/drm_pagemap.c            |    2 -
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |    2 -
 include/linux/memremap.h                 |    9 +++--
 lib/test_hmm.c                           |    4 +-
 mm/memremap.c                            |   35 ++++++++++++++++++++-
 7 files changed, 47 insertions(+), 9 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-zone_device-reinitialize-large-zone-device-private-folios
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -723,7 +723,7 @@ static struct page *kvmppc_uvmem_get_pag
 
 	dpage = pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data = pvt;
-	zone_device_page_init(dpage, 0);
+	zone_device_page_init(dpage, &kvmppc_uvmem_pgmap, 0);
 	return dpage;
 out_clear:
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-zone_device-reinitialize-large-zone-device-private-folios
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -217,7 +217,7 @@ svm_migrate_get_vram_page(struct svm_ran
 	page = pfn_to_page(pfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	zone_device_page_init(page, 0);
+	zone_device_page_init(page, page_pgmap(page), 0);
 }
 
 static void
--- a/drivers/gpu/drm/drm_pagemap.c~mm-zone_device-reinitialize-large-zone-device-private-folios
+++ a/drivers/gpu/drm/drm_pagemap.c
@@ -197,7 +197,7 @@ static void drm_pagemap_get_devmem_page(
 					struct drm_pagemap_zdd *zdd)
 {
 	page->zone_device_data = drm_pagemap_zdd_get(zdd);
-	zone_device_page_init(page, 0);
+	zone_device_page_init(page, page_pgmap(page), 0);
 }
 
 /**
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-zone_device-reinitialize-large-zone-device-private-folios
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -425,7 +425,7 @@ nouveau_dmem_page_alloc_locked(struct no
 			order = ilog2(DMEM_CHUNK_NPAGES);
 	}
 
-	zone_device_folio_init(folio, order);
+	zone_device_folio_init(folio, page_pgmap(folio_page(folio, 0)), order);
 	return page;
 }
 
--- a/include/linux/memremap.h~mm-zone_device-reinitialize-large-zone-device-private-folios
+++ a/include/linux/memremap.h
@@ -224,7 +224,8 @@ static inline bool is_fsdax_page(const s
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page, unsigned int order);
+void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
+			   unsigned int order);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
@@ -234,9 +235,11 @@ bool pgmap_pfn_valid(struct dev_pagemap
 
 unsigned long memremap_compat_align(void);
 
-static inline void zone_device_folio_init(struct folio *folio, unsigned int order)
+static inline void zone_device_folio_init(struct folio *folio,
+					  struct dev_pagemap *pgmap,
+					  unsigned int order)
 {
-	zone_device_page_init(&folio->page, order);
+	zone_device_page_init(&folio->page, pgmap, order);
 	if (order)
 		folio_set_large_rmappable(folio);
 }
--- a/lib/test_hmm.c~mm-zone_device-reinitialize-large-zone-device-private-folios
+++ a/lib/test_hmm.c
@@ -662,7 +662,9 @@ static struct page *dmirror_devmem_alloc
 			goto error;
 	}
 
-	zone_device_folio_init(page_folio(dpage), order);
+	zone_device_folio_init(page_folio(dpage),
+			       page_pgmap(folio_page(page_folio(dpage), 0)),
+			       order);
 	dpage->zone_device_data = rpage;
 	return dpage;
 
--- a/mm/memremap.c~mm-zone_device-reinitialize-large-zone-device-private-folios
+++ a/mm/memremap.c
@@ -477,10 +477,43 @@ void free_zone_device_folio(struct folio
 	}
 }
 
-void zone_device_page_init(struct page *page, unsigned int order)
+void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
+			   unsigned int order)
 {
+	struct page *new_page = page;
+	unsigned int i;
+
 	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
 
+	for (i = 0; i < (1UL << order); ++i, ++new_page) {
+		struct folio *new_folio = (struct folio *)new_page;
+
+		/*
+		 * new_page could have been part of previous higher order folio
+		 * which encodes the order, in page + 1, in the flags bits. We
+		 * blindly clear bits which could have set my order field here,
+		 * including page head.
+		 */
+		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
+
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+		/*
+		 * This pointer math looks odd, but new_page could have been
+		 * part of a previous higher order folio, which sets _nr_pages
+		 * in page + 1 (new_page). Therefore, we use pointer casting to
+		 * correctly locate the _nr_pages bits within new_page which
+		 * could have modified by previous higher order folio.
+		 */
+		((struct folio *)(new_page - 1))->_nr_pages = 0;
+#endif
+
+		new_folio->mapping = NULL;
+		new_folio->pgmap = pgmap;	/* Also clear compound head */
+		new_folio->share = 0;   /* fsdax only, unused for device private */
+		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
+		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
+	}
+
 	/*
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
_

Patches currently in -mm which might be from matthew.brost@intel.com are

mm-zone_device-reinitialize-large-zone-device-private-folios.patch

