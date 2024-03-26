Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8970F200CB
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482773; cv=none; b=A90nkWoNTKeoX7hfZ2dkAn9xhZVVoobBhDcks0Exyil4bWA0YrfCOwnc1KapdtZTtBa/5Cl/5u9rN3yekrN0FeU5Aw/927M4EFkePluWrbwEsPSF2Fl+1cXR91Rd1Y42o9smmAaM6uploCGW+Oa61rCixtwqkam46irZ0kdXX9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482773; c=relaxed/simple;
	bh=BU3w2fKmnVon/eNXKk+PEApvSh1wnIhHJkq5QmimHeU=;
	h=Date:To:From:Subject:Message-Id; b=FR7bCo4HJ86nuCwelx4LJI9poYq+50JgOoSpiTJsT8qtVqI5cuSIXs8EL6nCESz65VEfZvdY/Y89v1Z6riQB12ifJVJpHuMSDTmnw8w1TXZ75wt6LfJ+g2CJH7xILnwcVqDErY1Hct96cWnGyJhxn3bBb86p80gcUZ60Cf4DVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0uLR6vnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0uLR6vnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341DEC433C7;
	Tue, 26 Mar 2024 19:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711482773;
	bh=BU3w2fKmnVon/eNXKk+PEApvSh1wnIhHJkq5QmimHeU=;
	h=Date:To:From:Subject:From;
	b=0uLR6vnLAwcD3csQB/7/hNuxYDqlV3+EjYVyPf639iwD049VUaEO6FnwXV4ppqSFI
	 b7ViJ4ygqyFX/aEhpCgLYOWhQxgHFferjffeM6URyYA04zVbrqZumsUhcyd9SCCWhO
	 GCGygewak/92VZxOOjI/JTxXcz12FVcq9hlZYe44=
Date: Tue, 26 Mar 2024 12:52:52 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-array-mem_section-init-code-out-of-memory_present.patch added to mm-unstable branch
Message-Id: <20240326195253.341DEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move array mem_section init code out of memory_present()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-array-mem_section-init-code-out-of-memory_present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-array-mem_section-init-code-out-of-memory_present.patch

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
Subject: mm: move array mem_section init code out of memory_present()
Date: Tue, 26 Mar 2024 14:11:27 +0800

Patch series "mm/init: minor clean up and improvement".

These are all observed when going through code flow during mm init.


This patch (of 7):

When CONFIG_SPARSEMEM_EXTREME is enabled, mem_section need be initialized
to point at a two-dimensional array, and its 1st dimension of length
NR_SECTION_ROOTS will be dynamically allocated.  Once the allocation is
done, it's available for all nodes.

So take the 1st dimension of mem_section initialization out of
memory_present()(), and put it into memblocks_present() which is a more
appripriate place.

Link: https://lkml.kernel.org/r/20240326061134.1055295-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20240326061134.1055295-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/sparse.c~mm-move-array-mem_section-init-code-out-of-memory_present
+++ a/mm/sparse.c
@@ -226,19 +226,6 @@ static void __init memory_present(int ni
 {
 	unsigned long pfn;
 
-#ifdef CONFIG_SPARSEMEM_EXTREME
-	if (unlikely(!mem_section)) {
-		unsigned long size, align;
-
-		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
-		align = 1 << (INTERNODE_CACHE_SHIFT);
-		mem_section = memblock_alloc(size, align);
-		if (!mem_section)
-			panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
-			      __func__, size, align);
-	}
-#endif
-
 	start &= PAGE_SECTION_MASK;
 	mminit_validate_memmodel_limits(&start, &end);
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
@@ -267,6 +254,19 @@ static void __init memblocks_present(voi
 	unsigned long start, end;
 	int i, nid;
 
+#ifdef CONFIG_SPARSEMEM_EXTREME
+	if (unlikely(!mem_section)) {
+		unsigned long size, align;
+
+		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
+		align = 1 << (INTERNODE_CACHE_SHIFT);
+		mem_section = memblock_alloc(size, align);
+		if (!mem_section)
+			panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
+			      __func__, size, align);
+	}
+#endif
+
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
 		memory_present(nid, start, end);
 }
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

