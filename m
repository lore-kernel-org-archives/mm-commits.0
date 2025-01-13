Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B899225761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742248; cv=none; b=K/8ZRgaWYB6X1PMa9Dh+lM4LUm5xaRSu3hfNsM2gGUmeKwN8/+dLmNw87qVIVWBFPIrCjW1TRkMN/KI2t97MSzGbV/yuie5hg1Ibj7o+xnTyo3sRsELl5TFWuSl2V1qg0vOeCgshOiZtPLDpgaoy3e1ZnIAGzeNCNLHno72eaPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742248; c=relaxed/simple;
	bh=b3n4cOvzKUHKNAFN1FxPtbaMGzeVUj2vNdb46dTlVp4=;
	h=Date:To:From:Subject:Message-Id; b=MwV5C/ITPWuaKP5yISYS96zyldYAE9XBRggHGIPq2GBuSMovcfMgddzFOc/vQd9ggvWmxLpR8GbjvNKTNKJmlvyiqtzULPYhs0sCwmsYjaK5sfm43XRw97i3o1dYUHrusvknTaoy/6UA6+e3xloQ2gMikqGvDAQCMmk4/KvnUU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ir187w3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ir187w3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D50EC4CED6;
	Mon, 13 Jan 2025 04:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742248;
	bh=b3n4cOvzKUHKNAFN1FxPtbaMGzeVUj2vNdb46dTlVp4=;
	h=Date:To:From:Subject:From;
	b=ir187w3iaCiBC8TmuxHVDUqCaJOp0yZ2TInF6S64xpgCxbiZJC0IJFNRSv6kZI48h
	 5iVR3LAtg7KoqKm2Pf+aJWyat1Y4PKK/VbDnLe4iO3fWnAGu41DdUk9oRW5MPXOtIH
	 kMnpTtz/hSFfZttTCq0kJQsmS4nO+a4TRCiN8mV8=
Date: Sun, 12 Jan 2025 20:24:07 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch removed from -mm tree
Message-Id: <20250113042408.3D50EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: pass a folio to squashfs_readpage_fragment()
has been removed from the -mm tree.  Its filename was
     squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: squashfs: pass a folio to squashfs_readpage_fragment()
Date: Fri, 20 Dec 2024 22:46:25 +0000

Remove an access to page->mapping.

Link: https://lkml.kernel.org/r/20241220224634.723899-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c~squashfs-pass-a-folio-to-squashfs_readpage_fragment
+++ a/fs/squashfs/file.c
@@ -417,9 +417,9 @@ skip_page:
 }
 
 /* Read datablock stored packed inside a fragment (tail-end packed block) */
-static int squashfs_readpage_fragment(struct page *page, int expected)
+static int squashfs_readpage_fragment(struct folio *folio, int expected)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct squashfs_cache_entry *buffer = squashfs_get_fragment(inode->i_sb,
 		squashfs_i(inode)->fragment_block,
 		squashfs_i(inode)->fragment_size);
@@ -430,7 +430,7 @@ static int squashfs_readpage_fragment(st
 			squashfs_i(inode)->fragment_block,
 			squashfs_i(inode)->fragment_size);
 	else
-		squashfs_copy_cache(page, buffer, expected,
+		squashfs_copy_cache(&folio->page, buffer, expected,
 			squashfs_i(inode)->fragment_offset);
 
 	squashfs_cache_put(buffer);
@@ -474,7 +474,7 @@ static int squashfs_read_folio(struct fi
 		else
 			res = squashfs_readpage_block(&folio->page, block, res, expected);
 	} else
-		res = squashfs_readpage_fragment(&folio->page, expected);
+		res = squashfs_readpage_fragment(folio, expected);
 
 	if (!res)
 		return 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
mm-remove-pagetranstail.patch

