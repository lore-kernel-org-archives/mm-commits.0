Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8457F462
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104021; cv=none; b=RI7EiJ/l5zRwQx6fStPp4o+XERFk68T70H3/K6TWO6FEvIQc5ENTOUeOuk4+GNqM5hXrnyXM9CZe7eOF1MT92OxFFrmDuFqjhxjuE3luLAO4XkN7T8D0zOGqIz49qxpKfZJrMTjtvvo7DmXejWJpzpZxbB4InCDEyXyrQNYDhs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104021; c=relaxed/simple;
	bh=1lAvTLtLFqEGALvQBL6K2sVO6qbEBT4LV7WJENfTWDs=;
	h=Date:To:From:Subject:Message-Id; b=MXhbfVkLcseDbiLFqT8Rd26DthQCUJpmxc9ZksCpqX0frwo+QCBvrM09gEbI9gqVejvfUgreHN2CMwIWnJnKL7cZmdyhwkrHtCbI3OLXmR0wBW7GoEiNNYaqXX6ls1CiW8/Y9DsERa1EOvPRWHZ/mO/2yEixQQUrki//3d2vxfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q9FEqev3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q9FEqev3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C37AC113CD;
	Fri, 26 Apr 2024 04:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104021;
	bh=1lAvTLtLFqEGALvQBL6K2sVO6qbEBT4LV7WJENfTWDs=;
	h=Date:To:From:Subject:From;
	b=Q9FEqev3PuJvkBJVMC7uC5Z11h3/iFfTjXyi0Q68+YJDE0TTMp5ZZPgXXghFjjES8
	 gliStDIYHlrsc7JUE1ncCIY5OOibzenJcU1Kq05QfwF+TZ2xnCuzTS1xsitgGVDz3r
	 aoKl6H03pYI5BijkVFmAGcdRboIlcWy1Cfk9U6Oc=
Date: Thu, 25 Apr 2024 21:00:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] slub-remove-use-of-page-flags.patch removed from -mm tree
Message-Id: <20240426040021.1C37AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: slub: remove use of page->flags
has been removed from the -mm tree.  Its filename was
     slub-remove-use-of-page-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: slub: remove use of page->flags
Date: Tue, 26 Mar 2024 17:10:30 +0000

Use slub->__page_flags instead.  We can also remove the assertion that
it's not a tail page as struct slab never points to a tail page.

Link: https://lkml.kernel.org/r/20240326171045.410737-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/slub.c~slub-remove-use-of-page-flags
+++ a/mm/slub.c
@@ -616,18 +616,12 @@ slub_set_cpu_partial(struct kmem_cache *
  */
 static __always_inline void slab_lock(struct slab *slab)
 {
-	struct page *page = slab_page(slab);
-
-	VM_BUG_ON_PAGE(PageTail(page), page);
-	bit_spin_lock(PG_locked, &page->flags);
+	bit_spin_lock(PG_locked, &slab->__page_flags);
 }
 
 static __always_inline void slab_unlock(struct slab *slab)
 {
-	struct page *page = slab_page(slab);
-
-	VM_BUG_ON_PAGE(PageTail(page), page);
-	bit_spin_unlock(PG_locked, &page->flags);
+	bit_spin_unlock(PG_locked, &slab->__page_flags);
 }
 
 static inline bool
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

