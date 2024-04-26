Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E017602B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101836; cv=none; b=nsoh/hwmZdD/xwBl8flJK6ZZ4li/Kg9TsnhRurHMsmUtsvR5DNjx8871QdDAa+2QaTkD96XFd6h0giF2f1lulRldlet1hpSEOBxR+2qp6tOqSiNul1xlaIGhWEowNTnBSsG4Wb5nq1JPLvd0dbQLASHyS5zgDH0lZ9rD/fBTlDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101836; c=relaxed/simple;
	bh=BJQ7suxxPL/YtELUKtLxLLy4/ufSjAcrCh1huc3o9ls=;
	h=Date:To:From:Subject:Message-Id; b=LtJT/4ysyTHxLT7po4EgjzMqbRb7wbcsaE2vkBukWvvMJykiMrCr7jyIwe3hwp/+yADjfmpU1oAFRRmGH4KfBQrp6B7ZPA9Si71Z/v7ktX2NMPnQ+NGRjjKsPa7nsNQ1JsReBJ2YncWknuey8c0CCfQa1mPK128pmf5jvjCJiZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d0BzkWV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d0BzkWV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B11CC113CD;
	Fri, 26 Apr 2024 03:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101836;
	bh=BJQ7suxxPL/YtELUKtLxLLy4/ufSjAcrCh1huc3o9ls=;
	h=Date:To:From:Subject:From;
	b=d0BzkWV+LDk95dMmsXCalpuM01M0GRAl9u1EO0k0OgThudU32B1EWkHBRR6zL3SL2
	 wy25M9x6p16547ny17WIivOG1q/DIU3Z8uO/nZv75lPukmVRNvSiql0blPRUg7jLCW
	 FpnzbOr9FOR2ALAk3/0XxoTDWIzG/I4sxdtehk/s=
Date: Thu, 25 Apr 2024 20:23:55 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch removed from -mm tree
Message-Id: <20240426032356.4B11CC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: remove meaningless calculation of zone->managed_pages in free_area_init_core()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch

This patch was dropped because it was folded into mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove meaningless calculation of zone->managed_pages in free_area_init_core()
Date: Thu, 28 Mar 2024 17:12:14 +0800

Change to initialize zone->managed_pages as zone->present_pages for now
because later page_group_by_mobility_disabled need be set according to
zone->managed_pages.  Otherwise it will cause setting
page_group_by_mobility_disabled to 1 always.

Link: https://lkml.kernel.org/r/ZgU0bsJ2FEjykvju@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3
+++ a/mm/mm_init.c
@@ -1582,7 +1582,7 @@ static void __init free_area_init_core(s
 		 * Initialize zone->managed_pages as 0 , it will be reset
 		 * when memblock allocator frees pages into buddy system.
 		 */
-		zone_init_internals(zone, j, nid, 0);
+		zone_init_internals(zone, j, nid, zone->present_pages);
 
 		if (!size)
 			continue;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch
documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

