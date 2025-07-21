Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4F81D63E8
	for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2025 22:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753137260; cv=none; b=enEOPCnxZNhVy8VPf5fBrGo0T0nyuA89rcPIFbRBV3KGcl3jofn4JyxNa4D1Z/R3+CCKRXf4QDZq49jNTN9caf3vDiUd4w7FPRUFIXZcUK1wLCNKlVLfXZk6/fgjHB3HcFAH6fFo5GdXvOQUUbwmerZa3BeM0bezexy+lnZ32xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753137260; c=relaxed/simple;
	bh=z1EVqtz94oQPvd9EOVypaKSufJObC0fOMLwv6PSsw1E=;
	h=Date:To:From:Subject:Message-Id; b=JsBq7GO3yg9H0YT1zQZRrrT0Ve8+fZ+OCugKyL9Wv/HJ+ChaLc34az921wR7gKWHj5qM8zrAsbunwNvcxr4rh3grScirY1ZgVuxgxhfd+hOmHqfVYOhTxM4NgUdLgdHfO+uVcAJ5HnaP559zToGI2GSpRgUbAa3pTs9944Oml+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K1c8j3Af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K1c8j3Af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF1BC4CEED;
	Mon, 21 Jul 2025 22:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753137259;
	bh=z1EVqtz94oQPvd9EOVypaKSufJObC0fOMLwv6PSsw1E=;
	h=Date:To:From:Subject:From;
	b=K1c8j3AfdqziAiatL4L3yGtKWP66PD30y3Jh0liO8kmDurfQIJx+G4380yi72Uukq
	 XZ4MJcqe41JYwWMZ+MKaKCZx97iuSovwh7IJCtAgB/duiFqtUVY9tK4KhMAmtgnPTr
	 RKyIci1vpgIRwN32Su8mFhmMR+nc9Gjn7YhwiAvk=
Date: Mon, 21 Jul 2025 15:34:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-grab_cache_page.patch added to mm-new branch
Message-Id: <20250721223419.2FF1BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove grab_cache_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-grab_cache_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-grab_cache_page.patch

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
Subject: mm: remove grab_cache_page()
Date: Mon, 21 Jul 2025 21:46:18 +0100

All callers have been converted to use filemap_grab_folio().

Link: https://lkml.kernel.org/r/20250721204619.163883-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-grab_cache_page
+++ a/include/linux/pagemap.h
@@ -884,7 +884,8 @@ static inline struct page *find_or_creat
  * @mapping: target address_space
  * @index: the page index
  *
- * Same as grab_cache_page(), but do not wait if the page is unavailable.
+ * Returns locked page at given index in given cache, creating it if
+ * needed, but do not wait if the page is locked or to reclaim memory.
  * This is intended for speculative data generators, where the data can
  * be regenerated if the page couldn't be grabbed.  This routine should
  * be safe to call while holding the lock for another page.
@@ -948,15 +949,6 @@ unsigned filemap_get_folios_contig(struc
 unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, xa_mark_t tag, struct folio_batch *fbatch);
 
-/*
- * Returns locked page at given index in given cache, creating it if needed.
- */
-static inline struct page *grab_cache_page(struct address_space *mapping,
-								pgoff_t index)
-{
-	return find_or_create_page(mapping, index, mapping_gfp_mask(mapping));
-}
-
 struct folio *read_cache_folio(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
 struct folio *mapping_read_folio_gfp(struct address_space *, pgoff_t index,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-grab_cache_page.patch

