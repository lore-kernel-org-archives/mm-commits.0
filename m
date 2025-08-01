Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88E219F121;
	Fri,  1 Aug 2025 21:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754084598; cv=none; b=ue4xZWGasisKmYxmKFVkG82RiMiM8fUp/ZiWMeZ7Qg4KPwR/7jBaSMOelPLWrbB1Q2iQG5dt22x/hYBHpDjgJUpJjPpUWpCj7o7uBYny3boL6zFWVxJCGRBbCKcPD4Mih3pXyLxOZQlofjvF5Kta0fJlaFLdWHMGL0Ppkhsb55k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754084598; c=relaxed/simple;
	bh=Xiwy4ScgP7j84te4JGd+4Gr5fis8hv7c267ijEI3f40=;
	h=Date:To:From:Subject:Message-Id; b=QlZkxXdrVG2meITtZsfehFNb6BeKgT2wkeeA8HWr3+aNh8dBoKdOKBauasDhp7tUwrqf/sgiuX8qG/W2JjK4aoUJT/sOzfnRzJU6FucgewMk2hDO1gOQ2oc91iXZkPa9thI2s2Nnl8jEOm94/vs570pj8n1iQdMAqpCU+y4/Gro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xp7KauDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xp7KauDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D911C4CEE7;
	Fri,  1 Aug 2025 21:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754084598;
	bh=Xiwy4ScgP7j84te4JGd+4Gr5fis8hv7c267ijEI3f40=;
	h=Date:To:From:Subject:From;
	b=xp7KauDF3sNDjWm8vec6o03iM4FcmP7EVUyv1a+MbR1pk0YPnNL3z8SK7MBghoTYf
	 e6NTzYcrMMAMlqsyBsyggD7X4KkuBHuiulUzPfHKE+bB+ttQf/Lsm+jZ19DzC1qzQp
	 nQCvTIRtZAoNY9bFDshXnWKuF9cMNjOvftP+VV8E=
Date: Fri, 01 Aug 2025 14:43:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ville.syrjala@linux.intel.com,tzimmermann@suse.de,tursulin@ursulin.net,stable@vger.kernel.org,rodrigo.vivi@intel.com,Ray.Huang@amd.com,patryk@kowalczyk.ws,mripard@kernel.org,matthew.brost@intel.com,matthew.auld@intel.com,maarten.lankhorst@linux.intel.com,joonas.lahtinen@linux.intel.com,jani.nikula@linux.intel.com,hughd@google.com,david@redhat.com,christian.koenig@amd.com,airlied@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch removed from -mm tree
Message-Id: <20250801214318.6D911C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix the shmem large folio allocation for the i915 driver
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch

This patch was dropped because an alternative patch was or shall be merged

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

Patryk added:

: In my tests, the performance drop ranges from a few percent up to 13%
: in Unigine Superposition under heavy memory usage on the CPU Core Ultra
: 155H with the Xe 128 EU GPU.  Other users have reported performance
: impact up to 30% on certain workloads.  Please find more in the
: regressions reports:
: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845
: 
: I believe the change should be backported to all active kernel branches
: after version 6.12.

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
Cc: <stable@vger.kernel.org>
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
@@ -153,12 +153,12 @@ enum sgp_type {
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
@@ -5930,6 +5930,7 @@ int shmem_zero_setup(struct vm_area_stru
  * shmem_read_folio_gfp - read into page cache, using specified page allocation flags.
  * @mapping:	the folio's address_space
  * @index:	the folio index
+ * @end:	end of a read if allocating a new folio
  * @gfp:	the page allocator flags to use if allocating
  *
  * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
@@ -5942,14 +5943,14 @@ int shmem_zero_setup(struct vm_area_stru
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
@@ -5968,7 +5969,7 @@ EXPORT_SYMBOL_GPL(shmem_read_folio_gfp);
 struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 					 pgoff_t index, gfp_t gfp)
 {
-	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
+	struct folio *folio = shmem_read_folio_gfp(mapping, index, 0, gfp);
 	struct page *page;
 
 	if (IS_ERR(folio))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


