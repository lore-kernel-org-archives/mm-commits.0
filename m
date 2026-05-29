Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FE936A37E;
	Fri, 29 May 2026 03:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026673; cv=none; b=FrZEU7B7pmO/eF/LCI+OJkaL6BCHHs/QMKTDdr/3KbYETbtvOX2WcRp/Pom/kLEGlfyIHNHc6eB5hWRfXlAYlNhgr3BdDTndtiTOocEhDlrDZY3v4svY+5faLnVNHZrSCTs7QXry1RfHUzl5xD1/PBVgsDg0g7+ZQamreaX2n5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026673; c=relaxed/simple;
	bh=6v/KOBeeAf4ie3J9g1LoBrP6xqmnPKtuT+DYW9ljtiI=;
	h=Date:To:From:Subject:Message-Id; b=BsJZUlMysqsiOuw7rnQaPbK0apYLcug3Iti91nqHlbtN7nA8vrB2NoV2QQOrAhUfSP4zYP+zZHZOW8P0lAdRBis0RlFtPJpHs/68ahhhcBQ4vr9s8/w0oCkG/9oyCxq51ExbJGjiwsb+Ee2Ekh+7kD3HxcOqUgptLtxsp/Llb5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FjOaz2wn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FjOaz2wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D011F000E9;
	Fri, 29 May 2026 03:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026672;
	bh=Gb1oSpgUt1jx4ZPFfsMwqpEwHalv0GeOcq5egAntZRc=;
	h=Date:To:From:Subject;
	b=FjOaz2wnHRoTwWnrtwWPxkl68KSJLa2gPTFIQ7bM52c+xj4klOmOH2KlnIyRT81rj
	 Sr4dNT2fRA8Dx1yixXnTTN0jwq0ckVqBFLEj0Uy5k87gtT1e/K4WAHEKMW2Cmb8dT+
	 WbrQOSfXzE1/dtIymcv6U2j+3JPPcqZ1ZnHvMCfE=
Date: Thu, 28 May 2026 20:51:12 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cma-fix-reserved-page-leak-on-activation-failure.patch removed from -mm tree
Message-Id: <20260529035112.A7D011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: fix reserved page leak on activation failure
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-reserved-page-leak-on-activation-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/cma: fix reserved page leak on activation failure
Date: Sat, 23 May 2026 14:01:23 +0800

If cma_activate_area() fails after allocating only part of the range
bitmaps, the cleanup path still has to release the reserved pages when
CMA_RESERVE_PAGES_ON_ERROR is clear.

That is still worth doing even in this __init path.  A bitmap_zalloc()
failure does not necessarily mean the system cannot make further progress:
freeing the reserved CMA pages can return a substantial amount of memory
to the buddy allocator and may relieve the temporary memory shortage that
caused the allocation failure in the first place.

However, the cleanup path currently uses the bitmap-freeing bound for page
release as well.  That is only correct for ranges whose bitmap allocation
already succeeded.  The failed range and all later ranges still keep their
reserved pages, so a partial bitmap allocation failure can permanently
leak them.

Fix this by releasing reserved pages for all ranges.  Use the saved
early_pfn[] value for ranges whose bitmap allocation already succeeded and
for the failed range, and use cmr->early_pfn for later ranges whose bitmap
allocation was never attempted.

Link: https://lore.kernel.org/20260523060123.2207992-1-songmuchun@bytedance.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-fix-reserved-page-leak-on-activation-failure
+++ a/mm/cma.c
@@ -188,10 +188,13 @@ cleanup:
 
 	/* Expose all pages to the buddy, they are useless for CMA. */
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
-		for (r = 0; r < allocrange; r++) {
+		for (r = 0; r < cma->nranges; r++) {
+			unsigned long start_pfn;
+
 			cmr = &cma->ranges[r];
+			start_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = early_pfn[r]; pfn < end_pfn; pfn++)
+			for (pfn = start_pfn; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

