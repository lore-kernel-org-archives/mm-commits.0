Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DCD50276;
	Sat, 23 May 2026 21:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779572548; cv=none; b=VIBQQvGxn2FVlkehUvv6a8CEqNI9mxFSbi+vtyXYoEG5pqyVv+1ZLSQp9ddmm1NgCWTJh7VwJqtRpGp6+nGMBpxVp6Sr0VpaXz5eiFHrLln8nEtyhdchGf8gq7xD+1Z2PA4wKyXSS/Pt27I7SSX7SXP0dEarm8ZWzFVQ0X0/xFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779572548; c=relaxed/simple;
	bh=4St5n7uQpnLLZS4wy/1KrtoZ9sgr/sulNBs3hSwXy88=;
	h=Date:To:From:Subject:Message-Id; b=Pv8QTa7to5QCmlFVUrTc8On17o2RPtXrKoPHqEBo2gSGDKIR/xtzEzrgScL65T6Qtsa6faGcmZSWl0sXToT0iqhck+9QKZT8J++0iCXjatU/Smn0OKh6/HfTjQ3MLCeEA8qs2vilMV2YTvph4Haubu3IccKf2RXnXTPXEK09f2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ahPpe13O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ahPpe13O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA531F000E9;
	Sat, 23 May 2026 21:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779572547;
	bh=qeTQNXknogBa/HDC88qmLwfZ8zL+XhnZR6yL7/uVDGM=;
	h=Date:To:From:Subject;
	b=ahPpe13OGzXnV0Fdwi3ydXXdaMV2A+p7uIZRJEZaAZ+rD2Ej5eQNJn13e9gpJ0+i9
	 QcfRu/HK3k+OWaC3wLejYyY9x6C6hczJuVADfYOEPJNq73aa2Q8v8UtvE7SHj41/oG
	 4O799p5XWSSraHucBIogutHtss8+4OAk5iW4r4no=
Date: Sat, 23 May 2026 14:42:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-fix-reserved-page-leak-on-activation-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20260523214227.1EA531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: fix reserved page leak on activation failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma-fix-reserved-page-leak-on-activation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-fix-reserved-page-leak-on-activation-failure.patch

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

mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch
mm-cma-fix-reserved-page-leak-on-activation-failure.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

