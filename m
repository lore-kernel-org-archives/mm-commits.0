Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCF736D9E0
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 05:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790487797; cv=none; b=YBxpzN/IwB4FJpfeDcXNVdHj9PpaDln4c60Yjeh/llz5gEUpOxDEttudL14ypAtoI07xvQ/1Bpb12tSmoOQVj6R1Fp9WwOa9wKvXflKmZg/k+psSIp7PIKVl8UUho7yVt1athf4WYIhE1CGuvSQ61DY9PCt78xbCMrcZ4SaMpYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790487797; c=relaxed/simple;
	bh=7XuGZKnuSBMAwdTxXM1rEJLkCYcwxQVhvgZldlrtql8=;
	h=Date:To:From:Subject:Message-Id; b=HCmNef2I2DrC3QruFz/na0qWeVjnSgdzrT+hGexwZI/JKDQL9cjjaQjbJ9ZWuc8qD4JZTUvqgYxE6UpinErU4UAUPh5v4nGDO+I+tKAyMhMdnpMaIQt03c4/SwUueMsJ0GUS3yf9Ezgjebxz+A0jSfxmXpZJgHEac9zbaNwCkzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xzbuHv1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xzbuHv1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D8C1F00893;
	Sun, 27 Sep 2026 05:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790487795;
	bh=in7gg10NbrFaGnZeUl065iitjGf8Hcz9pMexL0oBBYk=;
	h=Date:To:From:Subject;
	b=xzbuHv1gxbUONKHSX8H03xDvB8OIH6wyU7RSaBEEPQEpFJfrqFC8jwTHVxADrHZpr
	 YVDq+ZTqkj94yMgwxGPBmzARpjNYjQLWV8o4IsK1dKsq3gJNprWR4iCLhAZ/LyH2Pz
	 YvVxyBFBhEZUbQKniECf8s5lnamx0TM1SLmvS80M=
Date: Sat, 26 Sep 2026 22:43:15 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-introduce-config_vmemmap_optimization-fix.patch removed from -mm tree
Message-Id: <20260927054315.97D8C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-sparse-vmemmap-introduce-config_vmemmap_optimization-fix
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-introduce-config_vmemmap_optimization-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm-sparse-vmemmap-introduce-config_vmemmap_optimization-fix
Date: Wed, 16 Sep 2026 16:36:27 +0800

The section-based vmemmap optimization infrastructure is guarded by
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it can also be used by
ZONE_DEVICE users that set dev_pagemap::vmemmap_shift.  Introduce
CONFIG_VMEMMAP_OPTIMIZATION as a common config for the shared
infrastructure.

Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
ZONE_DEVICE when the architecture opts in to DAX vmemmap optimization,
and use it to guard the generic sparse-vmemmap state and helpers.

Link: https://lore.kernel.org/20260916083627.2145779-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 drivers/dax/Kconfig |    2 --
 mm/Kconfig          |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/dax/Kconfig~mm-sparse-vmemmap-introduce-config_vmemmap_optimization-fix
+++ a/drivers/dax/Kconfig
@@ -8,8 +8,6 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
-	depends on ZONE_DEVICE
-	select VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
--- a/mm/Kconfig~mm-sparse-vmemmap-introduce-config_vmemmap_optimization-fix
+++ a/mm/Kconfig
@@ -1224,6 +1224,7 @@ config ZONE_DMA32
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
 	depends on MEMORY_HOTREMOVE
+	select VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	select XARRAY_MULTI
 
 	help
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

