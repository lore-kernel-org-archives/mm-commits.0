Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1467113AC1
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745799496; cv=none; b=F+7M+1PjKXcbamxKY0Of4HU+JOo22mviD9skwowVtRt27T6DHuFR8wURXVTqa/b/Z2le8wxnDjz1zYIT3LDMaEmTvxauDTb2OM01AMxMqKgyVScXBhAniVycmZzdKPQHS7IhlT5JKo9IIs97+Rta2vd1xT2TizjzcXZhz8tWJug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745799496; c=relaxed/simple;
	bh=Pek9ACQYDBQXFqnnTuE/OOIiUwzN5BKki38ZjSV6Deg=;
	h=Date:To:From:Subject:Message-Id; b=JHfVh8F+kgccekxOOPV7vrtmzTHoKezrFM21mdJx1HwmgJjjRmw1ilt+cFKRC9zNjOenzFOxPDr8DryKPBIaWzKOyTWRkqOjDvx4WFqTcFoym8ByTYWCwe+cvoqYW3jPlbLHrcbtd0K5bY4RhBAvfAlRxydrhqw2uJ16g1OPIFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kFb7Przx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kFb7Przx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D8CC4CEE3;
	Mon, 28 Apr 2025 00:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745799495;
	bh=Pek9ACQYDBQXFqnnTuE/OOIiUwzN5BKki38ZjSV6Deg=;
	h=Date:To:From:Subject:From;
	b=kFb7PrzxIIu30lNH3fdBCktp47+kYpT/Xl1WEcAWPBdZ3HuKVlY76j5/GwWWNYw4W
	 ZDli5p9BWD0x2XkX4RcMfOAn4j6GR0WWC7bn6GOwYUHlCT4uFiiW2BEdUmxWcSbYsC
	 p1mjc/2ie0gpamglQwzzvMVtQaZoZ1oO7GPBL8Gw=
Date: Sun, 27 Apr 2025 17:18:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rppt@kernel.org,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch added to mm-unstable branch
Message-Id: <20250428001815.60D8CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/io-mapping: precompute remap protection flags for clarity
has been added to the -mm mm-unstable branch.  Its filename is
     mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/io-mapping: precompute remap protection flags for clarity
Date: Sun, 27 Apr 2025 18:04:40 +0800

Patch series "mm: small cleanups for io-mapping, debug_page_alloc and
numa".

This series includes three small cleanups to mm/:

- io-mapping: simplify remap protection flag calculation
- debug_page_alloc: improve error message by printing invalid input
- numa: remove unnecessary variable for clarity

No functional changes.


This patch (of 3):

In io_mapping_map_user(), precompute the page protection flags in a local
variable before calling remap_pfn_range_notrack().

No functional change.

Link: https://lkml.kernel.org/r/20250427100442.958352-1-ye.liu@linux.dev
Link: https://lkml.kernel.org/r/20250427100442.958352-2-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/io-mapping.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/io-mapping.c~mm-io-mapping-precompute-remap-protection-flags-for-clarity
+++ a/mm/io-mapping.c
@@ -21,9 +21,10 @@ int io_mapping_map_user(struct io_mappin
 	if (WARN_ON_ONCE((vma->vm_flags & expected_flags) != expected_flags))
 		return -EINVAL;
 
+	pgprot_t remap_prot = __pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
+				       (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK));
+
 	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
-	return remap_pfn_range_notrack(vma, addr, pfn, size,
-		__pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
-			 (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK)));
+	return remap_pfn_range_notrack(vma, addr, pfn, size, remap_prot);
 }
 EXPORT_SYMBOL_GPL(io_mapping_map_user);
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch
mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch
fs-proc-page-refactoring-to-reduce-code-duplication.patch
mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch
mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch
mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch
mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

