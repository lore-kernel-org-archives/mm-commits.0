Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962AB21348
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 21:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753739127; cv=none; b=id3/H2Gz+JM0KB3N5ZgWPiqtn8Jd8hAYCHoVqkVtxBuGWHoHLF70/v21kQ1C08FHmWP75FfyTt5RGWlfWK6S2BqK6/7n56n6CuFjCxRwODtdHUyI2WPkQhPrHnaT7NSpVN3F8Vq3VFGTx8MchMsLbb+UcBy8fY3swX/N6R/iH7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753739127; c=relaxed/simple;
	bh=oDjwyp7+5hWKImm18d80eYEbKtv9uZR2f4CC4csSnWY=;
	h=Date:To:From:Subject:Message-Id; b=Xe8scMVbb9iDawrQLsO4pcfHrqZgE8Udu/beHtEiizKRAIZbDb5th9pFCa8XcxVtHVvi4nqfsrpXbPFXpgXZYwpGjSRFYC+v/BUOgFEF4UFMxFdVIwwCzePz3PIOlJp6ien1xKFPEgwyYfOta5kEi39Kkj/hHcvMMbHwUbWXKSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANj93XST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANj93XST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C39CC4CEE7;
	Mon, 28 Jul 2025 21:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753739127;
	bh=oDjwyp7+5hWKImm18d80eYEbKtv9uZR2f4CC4csSnWY=;
	h=Date:To:From:Subject:From;
	b=ANj93XSTxVmiutohckvgZjaXguPTLPW6Rin2vLthg+IGY6KrohYY5iGlO8+9AYBd/
	 DATFH/HgUvKIffT2Xb0OelY+AQ1yFFdwqUm1bWBC9uJNIc/OxyXYJDsP8ofB39/X1E
	 /D7onjBxJsLP75L/gurowvjHLBMXgk5b7CEh7+b8=
Date: Mon, 28 Jul 2025 14:45:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ville.syrjala@linux.intel.com,tzimmermann@suse.de,tursulin@ursulin.net,rodrigo.vivi@intel.com,Ray.Huang@amd.com,patryk@kowalczyk.ws,mripard@kernel.org,matthew.brost@intel.com,matthew.auld@intel.com,maarten.lankhorst@linux.intel.com,joonas.lahtinen@linux.intel.com,jani.nikula@linux.intel.com,hughd@google.com,david@redhat.com,christian.koenig@amd.com,airlied@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch added to mm-new branch
Message-Id: <20250728214527.0C39CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix the shmem large folio allocation for the i915 driver
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix the shmem large folio allocation for the i915 driver
Date: Mon, 28 Jul 2025 16:03:53 +0800

After commit acd7ccb284b8 ("mm: shmem: add large folio support for
tmpfs"), we extend the 'huge=' option to allow any sized large folios for
tmpfs, which means tmpfs will allow getting a highest order hint based on
the size of write() and fallocate() paths, and then will try each
allowable large order.

However, when the i915 driver allocates shmem memory, it doesn't provide
hint information about the size of the large folio to be allocated,
resulting in the inability to allocate PMD-sized shmem, which in turn
affects GPU performance.

To fix this issue, add the 'end' information for shmem_read_folio_gfp() to
help allocate PMD-sized large folios.  Additionally, use the maximum
allocation chunk (via mapping_max_folio_size()) to determine the size of
the large folios to allocate in the i915 driver.

Link: https://lkml.kernel.org/r/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com
Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
Cc: Christan König <christian.koenig@amd.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c                 |    2 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    7 ++++++-
 drivers/gpu/drm/ttm/ttm_backup.c          |    2 +-
 include/linux/shmem_fs.h                  |    4 ++--
 mm/shmem.c                                |    7 ++++---
 5 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c~mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver
+++ a/drivers/gpu/drm/drm_gem.c
@@ -627,7 +627,7 @@ struct page **drm_gem_get_pages(struct d
 	i = 0;
 	while (i < npages) {
 		long nr;
-		folio = shmem_read_folio_gfp(mapping, i,
+		folio = shmem_read_folio_gfp(mapping, i, 0,
 				mapping_gfp_mask(mapping));
 		if (IS_ERR(folio))
 			goto fail;
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -69,6 +69,7 @@ int shmem_sg_alloc_table(struct drm_i915
 	struct scatterlist *sg;
 	unsigned long next_pfn = 0;	/* suppress gcc warning */
 	gfp_t noreclaim;
+	size_t chunk;
 	int ret;
 
 	if (overflows_type(size / PAGE_SIZE, page_count))
@@ -94,6 +95,7 @@ int shmem_sg_alloc_table(struct drm_i915
 	mapping_set_unevictable(mapping);
 	noreclaim = mapping_gfp_constraint(mapping, ~__GFP_RECLAIM);
 	noreclaim |= __GFP_NORETRY | __GFP_NOWARN;
+	chunk = mapping_max_folio_size(mapping);
 
 	sg = st->sgl;
 	st->nents = 0;
@@ -105,10 +107,13 @@ int shmem_sg_alloc_table(struct drm_i915
 			0,
 		}, *s = shrink;
 		gfp_t gfp = noreclaim;
+		loff_t bytes = (page_count - i) << PAGE_SHIFT;
+		loff_t pos = i << PAGE_SHIFT;
 
+		bytes = min_t(loff_t, chunk, bytes);
 		do {
 			cond_resched();
-			folio = shmem_read_folio_gfp(mapping, i, gfp);
+			folio = shmem_read_folio_gfp(mapping, i, pos + bytes, gfp);
 			if (!IS_ERR(folio))
 				break;
 
--- a/drivers/gpu/drm/ttm/ttm_backup.c~mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver
+++ a/drivers/gpu/drm/ttm/ttm_backup.c
@@ -100,7 +100,7 @@ ttm_backup_backup_page(struct file *back
 	struct folio *to_folio;
 	int ret;
 
-	to_folio = shmem_read_folio_gfp(mapping, idx, alloc_gfp);
+	to_folio = shmem_read_folio_gfp(mapping, idx, 0, alloc_gfp);
 	if (IS_ERR(to_folio))
 		return PTR_ERR(to_folio);
 
--- a/include/linux/shmem_fs.h~mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver
+++ a/include/linux/shmem_fs.h
@@ -156,12 +156,12 @@ enum sgp_type {
 int shmem_get_folio(struct inode *inode, pgoff_t index, loff_t write_end,
 		struct folio **foliop, enum sgp_type sgp);
 struct folio *shmem_read_folio_gfp(struct address_space *mapping,
-		pgoff_t index, gfp_t gfp);
+		pgoff_t index, loff_t end, gfp_t gfp);
 
 static inline struct folio *shmem_read_folio(struct address_space *mapping,
 		pgoff_t index)
 {
-	return shmem_read_folio_gfp(mapping, index, mapping_gfp_mask(mapping));
+	return shmem_read_folio_gfp(mapping, index, 0, mapping_gfp_mask(mapping));
 }
 
 static inline struct page *shmem_read_mapping_page(
--- a/mm/shmem.c~mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver
+++ a/mm/shmem.c
@@ -5960,6 +5960,7 @@ int shmem_zero_setup(struct vm_area_stru
  * shmem_read_folio_gfp - read into page cache, using specified page allocation flags.
  * @mapping:	the folio's address_space
  * @index:	the folio index
+ * @end:	end of a read if allocating a new folio
  * @gfp:	the page allocator flags to use if allocating
  *
  * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
@@ -5972,14 +5973,14 @@ int shmem_zero_setup(struct vm_area_stru
  * with the mapping_gfp_mask(), to avoid OOMing the machine unnecessarily.
  */
 struct folio *shmem_read_folio_gfp(struct address_space *mapping,
-		pgoff_t index, gfp_t gfp)
+		pgoff_t index, loff_t end, gfp_t gfp)
 {
 #ifdef CONFIG_SHMEM
 	struct inode *inode = mapping->host;
 	struct folio *folio;
 	int error;
 
-	error = shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
+	error = shmem_get_folio_gfp(inode, index, end, &folio, SGP_CACHE,
 				    gfp, NULL, NULL);
 	if (error)
 		return ERR_PTR(error);
@@ -5998,7 +5999,7 @@ EXPORT_SYMBOL_GPL(shmem_read_folio_gfp);
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					 pgoff_t index, gfp_t gfp)
 {
-	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
+	struct folio *folio = shmem_read_folio_gfp(mapping, index, 0, gfp);
 	struct page *page;
 
 	if (IS_ERR(folio))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch

