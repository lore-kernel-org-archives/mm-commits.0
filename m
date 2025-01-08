Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD8C1802AB
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736307360; cv=none; b=rBGjjFiXyd/qfcACxnHiG3ORq0KSqx797WYusUqLFOhsB/EX924Gg/WJtOKr3+QItHGvTQrZocXBWgP8/gMV+K0fC3L7qAl+oFIRSBYpCDnNzrQQzF0+tLYkXOwdf65VLlUt3b0mG4xd9ti98pKQYwKdrf/eFegaXOzrO/uxlfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736307360; c=relaxed/simple;
	bh=DixVAwVW53814UYYe633pZrCLQUMzYjc4ZWpAS5nN7A=;
	h=Date:To:From:Subject:Message-Id; b=oirMbPcwRc6qFEeegNOtM6A+vdCuv7t53nDiMTZTvT2Y22PQsrDD/xDeUHyAjdtaaiO+BHpQnaGiSqLZTW+reSQeTAAhyZfhzUWAqG5X6e1ZIzENG3rIbqSB1huUmrmpY7dQY8xW+nN44B5N3vx05jMpS9jit+yI7hQiorPvzVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=afr9V7pV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="afr9V7pV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABEFC4CED0;
	Wed,  8 Jan 2025 03:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736307360;
	bh=DixVAwVW53814UYYe633pZrCLQUMzYjc4ZWpAS5nN7A=;
	h=Date:To:From:Subject:From;
	b=afr9V7pVyPlhYsgpPZYcV106ou+ujM8oCB8QW82MODcVdUK+3mKdI+/EVdGFCj30+
	 YXsqvuXSNtbLYzVg0WvODUUiW2dNLzcqFvXkttFPe/wB6rAObqPDMV8zDzYeB36LUm
	 Q5OScxSfSpflikmhGAC/K4d3uebjdkl0K35qz7Lo=
Date: Tue, 07 Jan 2025 19:35:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-add-folio_unmap_invalidate-helper.patch added to mm-unstable branch
Message-Id: <20250108033600.4ABEFC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: add folio_unmap_invalidate() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-add-folio_unmap_invalidate-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-add-folio_unmap_invalidate-helper.patch

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
From: Jens Axboe <axboe@kernel.dk>
Subject: mm/truncate: add folio_unmap_invalidate() helper
Date: Fri, 20 Dec 2024 08:47:44 -0700

Add a folio_unmap_invalidate() helper, which unmaps and invalidates a
given folio.  The caller must already have locked the folio.  Embed the
old invalidate_complete_folio2() helper in there as well, as nobody else
calls it.

Use this new helper in invalidate_inode_pages2_range(), rather than
duplicate the code there.

In preparation for using this elsewhere as well, have it take a gfp_t mask
rather than assume GFP_KERNEL is the right choice.  This bubbles back to
invalidate_complete_folio2() as well.

Link: https://lkml.kernel.org/r/20241220154831.1086649-7-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +
 mm/truncate.c |   53 +++++++++++++++++++++++++-----------------------
 2 files changed, 30 insertions(+), 25 deletions(-)

--- a/mm/internal.h~mm-truncate-add-folio_unmap_invalidate-helper
+++ a/mm/internal.h
@@ -392,6 +392,8 @@ void unmap_page_range(struct mmu_gather
 			     struct vm_area_struct *vma,
 			     unsigned long addr, unsigned long end,
 			     struct zap_details *details);
+int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
+			   gfp_t gfp);
 
 void page_cache_ra_order(struct readahead_control *, struct file_ra_state *,
 		unsigned int order);
--- a/mm/truncate.c~mm-truncate-add-folio_unmap_invalidate-helper
+++ a/mm/truncate.c
@@ -525,6 +525,15 @@ unsigned long invalidate_mapping_pages(s
 }
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
+static int folio_launder(struct address_space *mapping, struct folio *folio)
+{
+	if (!folio_test_dirty(folio))
+		return 0;
+	if (folio->mapping != mapping || mapping->a_ops->launder_folio == NULL)
+		return 0;
+	return mapping->a_ops->launder_folio(folio);
+}
+
 /*
  * This is like mapping_evict_folio(), except it ignores the folio's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
@@ -532,14 +541,26 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * shrink_folio_list() has a temp ref on them, or because they're transiently
  * sitting in the folio_add_lru() caches.
  */
-static int invalidate_complete_folio2(struct address_space *mapping,
-					struct folio *folio)
+int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
+			   gfp_t gfp)
 {
-	if (folio->mapping != mapping)
-		return 0;
+	int ret;
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	if (!filemap_release_folio(folio, GFP_KERNEL))
+	if (folio_test_dirty(folio))
 		return 0;
+	if (folio_mapped(folio))
+		unmap_mapping_folio(folio);
+	BUG_ON(folio_mapped(folio));
+
+	ret = folio_launder(mapping, folio);
+	if (ret)
+		return ret;
+	if (folio->mapping != mapping)
+		return -EBUSY;
+	if (!filemap_release_folio(folio, gfp))
+		return -EBUSY;
 
 	spin_lock(&mapping->host->i_lock);
 	xa_lock_irq(&mapping->i_pages);
@@ -558,16 +579,7 @@ static int invalidate_complete_folio2(st
 failed:
 	xa_unlock_irq(&mapping->i_pages);
 	spin_unlock(&mapping->host->i_lock);
-	return 0;
-}
-
-static int folio_launder(struct address_space *mapping, struct folio *folio)
-{
-	if (!folio_test_dirty(folio))
-		return 0;
-	if (folio->mapping != mapping || mapping->a_ops->launder_folio == NULL)
-		return 0;
-	return mapping->a_ops->launder_folio(folio);
+	return -EBUSY;
 }
 
 /**
@@ -631,16 +643,7 @@ int invalidate_inode_pages2_range(struct
 			}
 			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			folio_wait_writeback(folio);
-
-			if (folio_mapped(folio))
-				unmap_mapping_folio(folio);
-			BUG_ON(folio_mapped(folio));
-
-			ret2 = folio_launder(mapping, folio);
-			if (ret2 == 0) {
-				if (!invalidate_complete_folio2(mapping, folio))
-					ret2 = -EBUSY;
-			}
+			ret2 = folio_unmap_invalidate(mapping, folio, GFP_KERNEL);
 			if (ret2 < 0)
 				ret = ret2;
 			folio_unlock(folio);
_

Patches currently in -mm which might be from axboe@kernel.dk are

mm-filemap-change-filemap_create_folio-to-take-a-struct-kiocb.patch
mm-filemap-use-page_cache_sync_ra-to-kick-off-read-ahead.patch
mm-readahead-add-folio-allocation-helper.patch
mm-add-pg_dropbehind-folio-flag.patch
mm-readahead-add-readahead_control-dropbehind-member.patch
mm-truncate-add-folio_unmap_invalidate-helper.patch
fs-add-rwf_dontcache-iocb-and-fop_dontcache-file_operations-flag.patch
mm-filemap-add-read-support-for-rwf_dontcache.patch
mm-filemap-drop-streaming-uncached-pages-when-writeback-completes.patch
mm-filemap-add-filemap_fdatawrite_range_kick-helper.patch
mm-call-filemap_fdatawrite_range_kick-after-iocb_dontcache-issue.patch
mm-add-fgp_dontcache-folio-creation-flag.patch

