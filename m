Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B9D37C93F
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081261; cv=none; b=MEvjQ/j5OQ14jE8xO9BXAaYqIqkeLFOQ0zfCwRY+a+1rMdai9Mv/0AA6w8cmhc9H2Xs8GHVMaRfCo1JY2oMZY3Co2UT2Xjdpx8P32hG3ZRDNsVNLATDfHQa36ZC+rAx2XxYlJ1iKV45Rk7U34xTTja9PUYNRo7YaGE2bYWjnFaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081261; c=relaxed/simple;
	bh=7lkZ7I2pwFgDiIPJPMsmNwgTgPTwSCYRoPkk5ildvBc=;
	h=Date:To:From:Subject:Message-Id; b=g9/OZMzF5pvbakycSczL4A7ExDcRU4BrkBAsIdp4A3xxRMkneJL9aTPFw0+hyYp5Vf3SEQRXBwRg8fxOdMzjyF0n1qaI2DJioaK7sGk6C/IfDLngB5lNiP5kmk/VcTIX5Rx/RR+FPPJ8Hs2tNiaj6ySkFTn9sYU8/teVcdU2sUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fTZdWnTl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fTZdWnTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A685C1F00893;
	Thu, 10 Sep 2026 23:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081259;
	bh=9NsbSVSuYl+X5n8Trgrf8eUQixAY38O5Mg0raRddijM=;
	h=Date:To:From:Subject;
	b=fTZdWnTleYE3bvcE/zaBiqZaXpJyDeoa0IdGOPJwFwZOc5ps9wthNZNrBxr5eED3T
	 vJdcPDJj13sV3HS+SybyShFYPbMbUE509taYIAtRRColQI9K/Y23JXLmDjYHYechR0
	 JVRARUowjw/7PQ70b3WZvkJ4dW/WKcTM7OfyLjVE=
Date: Thu, 10 Sep 2026 16:00:59 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-localize-huge_bootmem_zones_valid.patch removed from -mm tree
Message-Id: <20260910230059.A685C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-localize-huge_bootmem_zones_valid.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
Date: Tue, 25 Aug 2026 16:46:08 +0800

HUGE_BOOTMEM_ZONES_VALID is only used by the huge_bootmem_page flag
handling in mm/hugetlb.c.  Keep the definition next to that private data
structure instead of exposing it through the public hugetlb header.

No functional change is intended.

Link: https://lore.kernel.org/20260825084608.47437-18-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 --
 mm/hugetlb.c            |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-localize-huge_bootmem_zones_valid
+++ a/include/linux/hugetlb.h
@@ -675,8 +675,6 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
--- a/mm/hugetlb.c~mm-hugetlb-localize-huge_bootmem_zones_valid
+++ a/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-vmemmap-introduce-config_sparsemem_vmemmap_optimization.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

