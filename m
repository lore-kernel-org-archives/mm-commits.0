Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF421A76D4
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723588898; cv=none; b=BOyAnOn9UsqHQhOv+d2wDXh8zSZkq4foQ8qLe42j5Is9VWMrzitdTsI1uz6S9YkK/mpgdbbYuQnup4+5Uevc2nu6swS5Mt2AGNWDpx6Dy5881GHFdzTi9omiYhIv6J4oHc/rxWiEGb3h35NnNrfU+IE1ie73Ur6lpnOL8Gtsg/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723588898; c=relaxed/simple;
	bh=WWpq5GFTxuOv2pFh8FldRXXgRGBJozoSpW89cAMCl9U=;
	h=Date:To:From:Subject:Message-Id; b=eX3U97EfR86NE0Yh2Lw+zyYnSPPH2onDm4objWMrAJZa+miEfqQ0OII4qDDZSyvsXWY0sGcVNkK0FhWUxLYZVZaXTf6+CFcd9ApPKpZ3R4UXF0i6xjgG+NW8teEKFvf8aGvWR5npyQl2sOT3v5x1UPbnyG6C4nQ6hp1m4iJTPKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=arm0aZCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="arm0aZCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46580C32782;
	Tue, 13 Aug 2024 22:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723588898;
	bh=WWpq5GFTxuOv2pFh8FldRXXgRGBJozoSpW89cAMCl9U=;
	h=Date:To:From:Subject:From;
	b=arm0aZCn0D3gwCNlkIJ4cAjVDvBg6fUOzXzY7E3hLjVIV39peSr9Q1vJDnXN0i/Jt
	 zrl1Sv/gmfIVlMDYlNwutCHKcCBUMZxf0oQXA7kkwe4SBdP7QzA946s+gi+Bhz4dkX
	 20/2oFkYamwn+aDJ+jIajCewNbTU6aiHd/Z8VtTo=
Date: Tue, 13 Aug 2024 15:41:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch added to mm-unstable branch
Message-Id: <20240813224138.46580C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: support large folio allocation for shmem_replace_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: support large folio allocation for shmem_replace_folio()
Date: Mon, 12 Aug 2024 15:42:07 +0800

To support large folio swapin for shmem in the following patches, add
large folio allocation for the new replacement folio in
shmem_replace_folio().  Moreover large folios occupy N consecutive entries
in the swap cache instead of using multi-index entries like the page
cache, therefore we should replace each consecutive entries in the swap
cache instead of using the shmem_replace_entry().

As well as updating statistics and folio reference count using the number
of pages in the folio.

Link: https://lkml.kernel.org/r/a41138ecc857ef13e7c5ffa0174321e9e2c9970a.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   54 +++++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

--- a/mm/shmem.c~mm-shmem-support-large-folio-allocation-for-shmem_replace_folio
+++ a/mm/shmem.c
@@ -1885,28 +1885,24 @@ static bool shmem_should_replace_folio(s
 static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 				struct shmem_inode_info *info, pgoff_t index)
 {
-	struct folio *old, *new;
-	struct address_space *swap_mapping;
-	swp_entry_t entry;
-	pgoff_t swap_index;
-	int error;
-
-	old = *foliop;
-	entry = old->swap;
-	swap_index = swap_cache_index(entry);
-	swap_mapping = swap_address_space(entry);
+	struct folio *new, *old = *foliop;
+	swp_entry_t entry = old->swap;
+	struct address_space *swap_mapping = swap_address_space(entry);
+	pgoff_t swap_index = swap_cache_index(entry);
+	XA_STATE(xas, &swap_mapping->i_pages, swap_index);
+	int nr_pages = folio_nr_pages(old);
+	int error = 0, i;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
 	 * limit chance of success by further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-	VM_BUG_ON_FOLIO(folio_test_large(old), old);
-	new = shmem_alloc_folio(gfp, 0, info, index);
+	new = shmem_alloc_folio(gfp, folio_order(old), info, index);
 	if (!new)
 		return -ENOMEM;
 
-	folio_get(new);
+	folio_ref_add(new, nr_pages);
 	folio_copy(new, old);
 	flush_dcache_folio(new);
 
@@ -1916,18 +1912,25 @@ static int shmem_replace_folio(struct fo
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	/*
-	 * Our caller will very soon move newpage out of swapcache, but it's
-	 * a nice clean interface for us to replace oldpage by newpage there.
-	 */
+	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
-	error = shmem_replace_entry(swap_mapping, swap_index, old, new);
+	for (i = 0; i < nr_pages; i++) {
+		void *item = xas_load(&xas);
+
+		if (item != old) {
+			error = -ENOENT;
+			break;
+		}
+
+		xas_store(&xas, new);
+		xas_next(&xas);
+	}
 	if (!error) {
 		mem_cgroup_replace_folio(old, new);
-		__lruvec_stat_mod_folio(new, NR_FILE_PAGES, 1);
-		__lruvec_stat_mod_folio(new, NR_SHMEM, 1);
-		__lruvec_stat_mod_folio(old, NR_FILE_PAGES, -1);
-		__lruvec_stat_mod_folio(old, NR_SHMEM, -1);
+		__lruvec_stat_mod_folio(new, NR_FILE_PAGES, nr_pages);
+		__lruvec_stat_mod_folio(new, NR_SHMEM, nr_pages);
+		__lruvec_stat_mod_folio(old, NR_FILE_PAGES, -nr_pages);
+		__lruvec_stat_mod_folio(old, NR_SHMEM, -nr_pages);
 	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
@@ -1947,7 +1950,12 @@ static int shmem_replace_folio(struct fo
 	old->private = NULL;
 
 	folio_unlock(old);
-	folio_put_refs(old, 2);
+	/*
+	 * The old folio are removed from swap cache, drop the 'nr_pages'
+	 * reference, as well as one temporary reference getting from swap
+	 * cache.
+	 */
+	folio_put_refs(old, nr_pages + 1);
 	return error;
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch

