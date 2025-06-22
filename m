Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C3F1F542E
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 18:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750617816; cv=none; b=ZFt2rILVIYMl/eXuAhc4BRxqv4Lshx1Vsv7WCI5+wi4tLSTpF/e53xzS587/S8BMVOnzvBygnfC+azQYWZcKsdHLo1PhyIwKU5Qj17spiCtT7MK+c/9N0HJC4X8F9iwrsMLmYipaqJXWOOD9DIHDj4e3TDZI5NP0mBukRkIRF70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750617816; c=relaxed/simple;
	bh=rBcBm3idtgzO/tJUVnA7EXGbvVMYPi4rYtW57ImZrik=;
	h=Date:To:From:Subject:Message-Id; b=FiFEKeDpPPKY1OwhxwTPNJGKumT7eeRhoRD53wmgV1KgrtlyYC1wchNIPuCLB+AXzLoJ6L1m0HDaOzbbnYn1UTlVQ5CFcOFh7Vqq5hRCisW0jfBwi+aZ1SK02NY2LUZ7Y1r91JxlKAXDGytUIlu/JOOGKFQhapY9XWpOEzoVnYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kYoqyyYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kYoqyyYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9F6C4CEE3;
	Sun, 22 Jun 2025 18:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750617816;
	bh=rBcBm3idtgzO/tJUVnA7EXGbvVMYPi4rYtW57ImZrik=;
	h=Date:To:From:Subject:From;
	b=kYoqyyYUuWEDdoJ1/xwNEwWe9R3dEq71clDGNnlHPX0yrldQPU7QWO/d3C7HfcB3W
	 9KdQ33dO02Czd6RW9h06Y77juQF6UdoKPbCV1dg2DzzLegM1HAhN021+v3qFwXaZAF
	 E9Ff/5jwjlkTfr00/M1YwIq1tLxGK0oiBxvn0a48=
Date: Sun, 22 Jun 2025 11:43:35 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-add-__filemap_get_folio_mpol.patch added to mm-new branch
Message-Id: <20250622184336.8A9F6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: Add __filemap_get_folio_mpol()
has been added to the -mm mm-new branch.  Its filename is
     filemap-add-__filemap_get_folio_mpol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-add-__filemap_get_folio_mpol.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: Add __filemap_get_folio_mpol()
Date: Fri, 20 Jun 2025 15:34:47 +0100

This allows guest_memfd to pass in a memory policy.

Link: https://lkml.kernel.org/r/20250620143502.3055777-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   10 ++++++++--
 mm/filemap.c            |   10 ++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/linux/pagemap.h~filemap-add-__filemap_get_folio_mpol
+++ a/include/linux/pagemap.h
@@ -745,11 +745,17 @@ static inline fgf_t fgf_set_order(size_t
 }
 
 void *filemap_get_entry(struct address_space *mapping, pgoff_t index);
-struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
-		fgf_t fgp_flags, gfp_t gfp);
+struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
+		pgoff_t index, fgf_t fgf_flags, gfp_t gfp, struct mempolicy *);
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
 		fgf_t fgp_flags, gfp_t gfp);
 
+static inline struct folio *__filemap_get_folio(struct address_space *mapping,
+		pgoff_t index, fgf_t fgf_flags, gfp_t gfp)
+{
+	return __filemap_get_folio_mpol(mapping, index, fgf_flags, gfp, NULL);
+}
+
 /**
  * filemap_get_folio - Find and get a folio.
  * @mapping: The address_space to search.
--- a/mm/filemap.c~filemap-add-__filemap_get_folio_mpol
+++ a/mm/filemap.c
@@ -1897,11 +1897,12 @@ out:
 }
 
 /**
- * __filemap_get_folio - Find and get a reference to a folio.
+ * __filemap_get_folio_mpol - Find and get a reference to a folio.
  * @mapping: The address_space to search.
  * @index: The page index.
  * @fgp_flags: %FGP flags modify how the folio is returned.
  * @gfp: Memory allocation flags to use if %FGP_CREAT is specified.
+ * @policy: NUMA memory allocation policy to follow.
  *
  * Looks up the page cache entry at @mapping & @index.
  *
@@ -1912,8 +1913,9 @@ out:
  *
  * Return: The found folio or an ERR_PTR() otherwise.
  */
-struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
-		fgf_t fgp_flags, gfp_t gfp)
+struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
+		pgoff_t index, fgf_t fgp_flags, gfp_t gfp,
+		struct mempolicy *policy)
 {
 	struct folio *folio;
 
@@ -1983,7 +1985,7 @@ no_page:
 			err = -ENOMEM;
 			if (order > min_order)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
-			folio = filemap_alloc_folio(alloc_gfp, order, NULL);
+			folio = filemap_alloc_folio(alloc_gfp, order, policy);
 			if (!folio)
 				continue;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch
bio-use-memzero_page-in-bio_truncate.patch
null_blk-use-memzero_page.patch
direct-io-use-memzero_page.patch
ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch
mm-remove-zero_user.patch
secretmem-remove-uses-of-struct-page.patch
highmem-remove-a-use-of-folio-page.patch
filemap-add-a-mempolicy-argument-to-filemap_alloc_folio.patch
filemap-add-__filemap_get_folio_mpol.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

