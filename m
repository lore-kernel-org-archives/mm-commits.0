Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274DA216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188395; cv=none; b=Rw4wjEjaUDwxamsNKoDd5KPrGTWrkVKlclqYKdggs8rE+d1+627q2NoIv6ZiQ1G0VnIuVsIY23bo0snYheWr7MCLE0fDwBw5+sS/EvUo0ZmwxDSIge1cp14rc8d9WTyfdtzd6qlCAgeNuVQyKoUsNR8TiMp7MJQZ9JzESzScHp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188395; c=relaxed/simple;
	bh=GdUQJ7jKUpHUbTKgp11regRbY00GrlXseiaNfnMpu9A=;
	h=Date:To:From:Subject:Message-Id; b=DJBd/RHG/qOG4Ix0SfyJDog+/1lOzm9C+R5rR8Rup4R3LAL2rtTY8G7MMqeGfuqAbdsuuaj+WBhhmTGlyRYWIESMK+QkT22Qb9He/5EDkew6nSUgVerBoFTjrY+rkLdiYnU1Y8iI6m563jL11/qlKKCa7Zmuvsdh6FHpP930YwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VncDhjXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VncDhjXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC846C4CEEC;
	Mon, 17 Mar 2025 05:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188395;
	bh=GdUQJ7jKUpHUbTKgp11regRbY00GrlXseiaNfnMpu9A=;
	h=Date:To:From:Subject:From;
	b=VncDhjXxKVC34lN9eF+ym+XfrSsGp9KQAXF6WoYQhWi0uSDY8KoE3f1OV/LH33koX
	 XjZVLiRIeMcRB1N19Ptw9ZRTENrnCjAh7971Uxv9BGhZT5qqm/VZkGrAEo5aMbvw+V
	 XOwdupf/vhQIgVLRphuFbfIrlx1Z/4i/Dq0XL6Rw=
Date: Sun, 16 Mar 2025 22:13:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-simplify-zone-intersection-check.patch removed from -mm tree
Message-Id: <20250317051314.EC846C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: simplify zone intersection check
has been removed from the -mm tree.  Its filename was
     mm-cma-simplify-zone-intersection-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: simplify zone intersection check
Date: Fri, 28 Feb 2025 18:29:23 +0000

cma_activate_area walks all pages in the area, checking their zone
individually to see if the area resides in more than one zone.

Make this a little more efficient by using the recently introduced
pfn_range_intersects_zones() function.  Store the NUMA node id (if any) in
the cma structure to facilitate this.

Link: https://lkml.kernel.org/r/20250228182928.2645936-23-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   13 ++++++-------
 mm/cma.h |    2 ++
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/mm/cma.c~mm-cma-simplify-zone-intersection-check
+++ a/mm/cma.c
@@ -103,7 +103,6 @@ static void __init cma_activate_area(str
 {
 	unsigned long pfn, base_pfn;
 	int allocrange, r;
-	struct zone *zone;
 	struct cma_memrange *cmr;
 
 	for (allocrange = 0; allocrange < cma->nranges; allocrange++) {
@@ -124,12 +123,8 @@ static void __init cma_activate_area(str
 		 * CMA resv range to be in the same zone.
 		 */
 		WARN_ON_ONCE(!pfn_valid(base_pfn));
-		zone = page_zone(pfn_to_page(base_pfn));
-		for (pfn = base_pfn + 1; pfn < base_pfn + cmr->count; pfn++) {
-			WARN_ON_ONCE(!pfn_valid(pfn));
-			if (page_zone(pfn_to_page(pfn)) != zone)
-				goto cleanup;
-		}
+		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count))
+			goto cleanup;
 
 		for (pfn = base_pfn; pfn < base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
@@ -261,6 +256,7 @@ int __init cma_init_reserved_mem(phys_ad
 	cma->ranges[0].base_pfn = PFN_DOWN(base);
 	cma->ranges[0].count = cma->count;
 	cma->nranges = 1;
+	cma->nid = NUMA_NO_NODE;
 
 	*res_cma = cma;
 
@@ -497,6 +493,7 @@ int __init cma_declare_contiguous_multi(
 	}
 
 	cma->nranges = nr;
+	cma->nid = nid;
 	*res_cma = cma;
 
 out:
@@ -684,6 +681,8 @@ static int __init __cma_declare_contiguo
 	if (ret)
 		memblock_phys_free(base, size);
 
+	(*res_cma)->nid = nid;
+
 	return ret;
 }
 
--- a/mm/cma.h~mm-cma-simplify-zone-intersection-check
+++ a/mm/cma.h
@@ -50,6 +50,8 @@ struct cma {
 	struct cma_kobject *cma_kobj;
 #endif
 	bool reserve_pages_on_error;
+	/* NUMA node (NUMA_NO_NODE if unspecified) */
+	int nid;
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
_

Patches currently in -mm which might be from fvdl@google.com are


