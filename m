Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1B73F788E
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777384140; cv=none; b=NAYfT7Hcf96IDrFGKZMYSamELIDHNtJLT+Y4UR5TwZT+g073R7pqLqX0LO/93zcz1TqCbQbaAphzE8Dy/d3R7cN4/22ksM0pSS8fQznnspGGIzLfS648weBDDJ4sxwa4HjrbSG579odJEyDmZuymJBxE/x7V4sSK/Pcx93VXpB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777384140; c=relaxed/simple;
	bh=z2QEUC9+w+9eqKalDa4lkzjpjDtVu7oSoy0DlzU6ivE=;
	h=Date:To:From:Subject:Message-Id; b=QMMP2Np7Bi1Fay1ArOTO4TwsYYDUbOclOlk/wBUyRY7HONCPEtQuRED4JOTvkO5IPRoGfE9ZxbwDkF9qq/hkgdCpgDIMBNlHzQpE34EdjsroUjr+LMuctx7h4+aSAKIqioSBx6IWgQjypoZQ8nI9lQMu/A+GgxBmOUFGD3PcN8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vdF0QxM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vdF0QxM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FD2C2BCAF;
	Tue, 28 Apr 2026 13:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777384139;
	bh=z2QEUC9+w+9eqKalDa4lkzjpjDtVu7oSoy0DlzU6ivE=;
	h=Date:To:From:Subject:From;
	b=vdF0QxM0ipPIGYrROJml09FBOuLjotnjVQhtqa+mr50Zc22TkdIp6N+uKvHhvQmfc
	 wst8tuTBUj+qXog7gmAEGOtsi7rtKjEhkDVCloTrfcNrKdzYa80UQoWYQTuEzRmG8V
	 yKonWAkKp9JFVI8z/4RpaJU1vo5qX/JqYrH/Ap8k=
Date: Tue, 28 Apr 2026 06:48:59 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch added to mm-new branch
Message-Id: <20260428134859.D4FD2C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: fix vmemmap accounting underflow
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/sparse-vmemmap: fix vmemmap accounting underflow
Date: Tue, 28 Apr 2026 16:18:50 +0800

Patch series "mm: Fix vmemmap optimization accounting and initialization",
v8.

The series fixes several bugs in vmemmap optimization, mainly around
incorrect page accounting and memmap initialization in DAX and memory
hotplug paths.  It also fixes pageblock migratetype initialization and
struct page initialization for ZONE_DEVICE compound pages.

Patches 1-4 fix vmemmap accounting issues.  Patch 1 fixes an accounting
underflow in the section activation failure path by moving vmemmap page
accounting into the lower-level allocation and freeing helpers.  Patch 2
fixes incorrect altmap passing in the memory hotplug error path.  Patch 3
passes pgmap through memory deactivation paths so the teardown side can
determine whether vmemmap optimization was in effect.  Patch 4 uses that
information to account the optimized DAX vmemmap size correctly.

Patches 5-6 fix initialization issues in mm/mm_init.  One makes sure all
pageblocks in ZONE_DEVICE compound pages get their migratetype
initialized.  The other fixes a case where DAX memory hotplug reuses an
unoptimized early-section memmap while compound_nr_pages() still assumes
vmemmap optimization, leaving tail struct pages uninitialized.


This patch (of 6):

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state.  This
causes a vmemmap accounting imbalance.

Since commit c3576889d87b ("mm: fix accounting of memmap pages"), memmap
pages are accounted for only after populate_section_memmap() succeeds. 
However, the failure path unconditionally calls section_deactivate(),
which decreases the vmemmap count.  Consequently, a failure in
populate_section_memmap() leads to an accounting underflow, incorrectly
reducing the system's tracked vmemmap usage.

Fix this more thoroughly by moving all accounting calls into the lower
level functions that actually perform the vmemmap allocation and freeing:

  - populate_section_memmap() accounts for newly allocated vmemmap pages -
depopulate_section_memmap() unaccounts when vmemmap is freed

This ensures proper accounting in all code paths, including error handling
and early section cases.

Link: https://lore.kernel.org/20260428081855.1249045-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260428081855.1249045-2-songmuchun@bytedance.com
Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-fix-vmemmap-accounting-underflow
+++ a/mm/sparse-vmemmap.c
@@ -651,7 +651,12 @@ static struct page * __meminit populate_
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						      pgmap);
+
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return page;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -660,13 +665,17 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
+
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						  PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
@@ -769,14 +778,10 @@ static void section_deactivate(unsigned
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+	else if (memmap)
 		free_map_bootmem(memmap);
-	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -821,7 +826,6 @@ static struct page * __meminit section_a
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch
drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

