Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6995917FF
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102187; cv=none; b=h0PaA0LgTK5Yh7iJY1oMIocjsf/6nhELESaFVERQt52VZ6bb9OGzCWyWedqM1rBHSm4SDeJxYIgm8NeDKpA8rcJ5CteUzIzytx9U18Kw8CD27fW/7391HLmdGKHmQ0EamkUAnoRT8iJhPw3l6PLX5QdbZ/8LBCcRxidCnTXts7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102187; c=relaxed/simple;
	bh=x/savVbq/OXxT44vOhoJs17OnDwSxDAFwzcfTmlG+/w=;
	h=Date:To:From:Subject:Message-Id; b=NHyD2v98mk8gkQCo4NtY/0R5ebYrSHIXbibLQjfMOzHuNrhrBwcTtMXDi+R7JMT9ZTLmT/covT+vLx1GRCMSyn9hvUKh1G9VY2jM/W5GWfOXt4pOt9LHMd1VWJh+Lf3o4v1IidaxtLnCZXWcvHw3GC3MfHGCKL6+m1UnPzFpQIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1enXon4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1enXon4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2D1C113CD;
	Fri, 26 Apr 2024 03:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102187;
	bh=x/savVbq/OXxT44vOhoJs17OnDwSxDAFwzcfTmlG+/w=;
	h=Date:To:From:Subject:From;
	b=1enXon4D6UZWtmfHX5YzwpyzTjNJ63uo3fEBSo8nrDiL7Ptxke7g/ssrLQjGzVrB1
	 w5FH3/P/f89KKnAR8oVahIUmrjqsAkqNeXoql1fuPRrlWkbALlGeONdQLjsR1Fw1pr
	 MKXAak+3S3C4r5vu0MlCyFjD6PvzrKBjQXslmRhA=
Date: Thu, 25 Apr 2024 20:29:46 -0700
To: mm-commits@vger.kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch removed from -mm tree
Message-Id: <20240426032947.2A2D1C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch

This patch was dropped because it was folded into mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2
Date: Wed, 27 Mar 2024 20:06:45 +0800

remove unused locals

Link: https://lkml.kernel.org/r/ZgQL1WOf9K88nLpQ@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2
+++ a/mm/page_alloc.c
@@ -5280,12 +5280,9 @@ static void setup_min_slab_ratio(void);
 
 static void build_zonelists(pg_data_t *pgdat)
 {
-	int node, local_node;
 	struct zoneref *zonerefs;
 	int nr_zones;
 
-	local_node = pgdat->node_id;
-
 	zonerefs = pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
 	nr_zones = build_zonerefs_node(pgdat, zonerefs);
 	zonerefs += nr_zones;
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
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch
documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

