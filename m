Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E878BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337147; cv=none; b=BJDgH1UYH9c3tnPT9DDUGfUFfm3OS014gaKLd3oeVwk5NyLnjfXfq8ZQjHqxrBGJa0XdIDSJAsKFITCs4h7qC7Ex181lqMzO+vBypDpDvC0yospIKDWC5fcIwDgbcBieu79FXLNohkesuw0C2Dt/hpLRr+lHSK7B7IIGeYPbz7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337147; c=relaxed/simple;
	bh=ALeIoUs+E6GJPwBVSX7X/4k5t7NCT8djSJ9mXKMBhzI=;
	h=Date:To:From:Subject:Message-Id; b=IFeBiR/RmwF4YpJTM/PMRjxrCDbenhD6T1Kul9Ppq3fbEbFILI9NoHP8M1af4BDyLOHlWs6b0RLB5ArTOs39BwSc3e6heCMOSYMLsy7nKCJgENPNXyWh7boFDQHfWB2drah9xAdPapEw2oW5f71uYDlEQu+2csP6umBv2mrNFzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=imOhyI3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="imOhyI3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03D4C4CED6;
	Mon, 20 Jan 2025 01:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337146;
	bh=ALeIoUs+E6GJPwBVSX7X/4k5t7NCT8djSJ9mXKMBhzI=;
	h=Date:To:From:Subject:From;
	b=imOhyI3+ZtkfaLcGa9ASVIMj82YRpLXtBtsgsM+FcCITvjKaBS3NfNeR2rbreQDfO
	 cOx46qBPWLicAQeGci+yzOaLDMIhNz9KECn4NvZqt2ilolEz0lfKBdEbSx/uYEPvBG
	 OL3C28iPhRkLF9f+48EEhcX7x2I+Ik2Xm/RXVMXE=
Date: Sun, 19 Jan 2025 17:39:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-truncate-add-folio_unmap_invalidate-helper.patch removed from -mm tree
Message-Id: <20250120013906.B03D4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/truncate: add folio_unmap_invalidate() helper
has been removed from the -mm tree.  Its filename was
     mm-truncate-add-folio_unmap_invalidate-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


