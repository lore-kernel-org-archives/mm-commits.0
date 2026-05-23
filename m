Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030EA145A1F;
	Sat, 23 May 2026 21:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779572493; cv=none; b=siZeoYzpgbqMhIhhWfKrNjkMP1IQI35x+ZXFB/+ECosxyX9ypO/xSc0dNcKEfykI7LeaU7wPulKc8tKAas3TKCimoXwr/qzwhf9sXCpgHMQCEd3xCORcCVLDXpEb7s7XwVChRiIF7lggy40A34Ea5PhghpdI5pdxgnVhb/9075k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779572493; c=relaxed/simple;
	bh=ZT8t7AurM53NlPAvDRCiPCc6yvQ+SAYgwCaHrvX3luw=;
	h=Date:To:From:Subject:Message-Id; b=H9uAQQohGvm3Gf2UASE2faA3yOqRkpdx11GZRjqUK0Cs/wJ9U2JjUQpGLfpqutxcp8i3XUB238ka07g8GPNx8I1t7sojkA9u2H4d+HYFSHNpW9MEy8OeUNC7+1UXLwFqF8HSkHzQ5DByMLbHZfjydg02ppbA0sOiBLlVAev3Ma0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yTlwQLvk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yTlwQLvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E191F000E9;
	Sat, 23 May 2026 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779572491;
	bh=uCJAzXgOF9ooqQWc5VT4vyESjhgLF+54ckR+JQiNpCg=;
	h=Date:To:From:Subject;
	b=yTlwQLvkfDVnellg4jLE8V9stnvFJlw6ztUyIWaf/w+dlc7oqJ2kV0U4WKsXSNxO7
	 YbYrUBoS+EvULjpt0+sZSFKviXePmyWSUAykxmyaPR2RwDvD8XTY5CjorFs70SFtOs
	 J7yYLUwxHnFzJgvGVJh4ywDsSoPaCbevLaBsYWpM=
Date: Sat, 23 May 2026 14:41:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-cma-fix-reserved-page-leak-on-activation-failure.patch removed from -mm tree
Message-Id: <20260523214131.92E191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: fix reserved page leak on activation failure
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-reserved-page-leak-on-activation-failure.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/cma: fix reserved page leak on activation failure
Date: Fri, 22 May 2026 14:26:58 +0800

If cma_activate_area() fails after allocating only part of the range
bitmaps, its cleanup path frees the bitmaps for the ranges below
allocrange and then releases reserved pages using the same bound.

That bound is only correct for bitmap freeing.  Pages in ranges that did
not reach bitmap allocation are still reserved and should also be returned
to the buddy when CMA_RESERVE_PAGES_ON_ERROR is clear.  As a result, a
partial bitmap allocation failure can permanently leak the reserved pages
from the failed range and all later ranges.

Fix this by releasing reserved pages for all ranges.  For ranges whose
bitmap allocation succeeded, use the early_pfn[] snapshot saved before the
bitmap pointer overwrote the union field.  For later ranges, continue to
use cmr->early_pfn directly.

Link: https://lore.kernel.org/20260522062658.4095405-1-songmuchun@bytedance.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
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
+			start_pfn = r < allocrange ? early_pfn[r] : cmr->early_pfn;
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = early_pfn[r]; pfn < end_pfn; pfn++)
+			for (pfn = start_pfn; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

