Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B67F1879
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567685; cv=none; b=s5jP5AQX12AN8eqZjgLkoy2Vx4YPBNoKhHltN7RWK/w9avMYu2wWYHV+1ClBnXjKm4gk8FziZIh77swCQCC8bBontJN75Kow/btUTkudgOEEVo8hp4CwfzIgUw/QRB5vF9L6Ur/JeyJ4dyiqigrSV/s3LUGTU4iX2JShO4bjJJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567685; c=relaxed/simple;
	bh=uqj25+BvUW7AyJjJ7BPqv5eiKfmMuoJt5plOdTJe12U=;
	h=Date:To:From:Subject:Message-Id; b=telzbLO8T1VaCfKFuqDmwrQ6mwYA0KUtXmawOmXsbnfYM109x7d3gp2CqDcJMAGqbSRgv5aPfPO5aLoDfxyEJbE1FHPk3GYKDC/L6FGy3tkFx5A68k/8Rp8+wzcckQlpt+ToKdLeczQOpvJNZXksM+PlcsJZ1gAnElPNszdW7Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyJh4yzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyJh4yzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C90C433F1;
	Wed, 27 Mar 2024 19:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711567684;
	bh=uqj25+BvUW7AyJjJ7BPqv5eiKfmMuoJt5plOdTJe12U=;
	h=Date:To:From:Subject:From;
	b=gyJh4yzMmOQgTcAS8PWvLbBbYFeanrbnVl3zVLqela2bbeh5W9xC7OeTE9dMPR1tK
	 CjDu0dqN0g95hIxxahf24NAuzASPjYNxAikJK86k6KRF7XeUeSdEUnkFyuNwHkV518
	 M4oulTeebJKru9jpFUe/zUvJ6vqXu2ffuPae5a+o=
Date: Wed, 27 Mar 2024 12:28:03 -0700
To: mm-commits@vger.kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch added to mm-unstable branch
Message-Id: <20240327192804.86C90C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch

This patch will later appear in the mm-unstable branch at
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
@@ -5285,12 +5285,9 @@ static void setup_min_slab_ratio(void);
 
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
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

