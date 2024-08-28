Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AE818D
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803508; cv=none; b=jNqNRpvZl+5wInZlkIFwtv6DjrcBcufbDpAUz20J470jwOwtMITaslEQlb30yWrfHxRWmc9BNS1OionxsncUlOtXxYsuXlgFWxlzVhtgF0aWlNS9hu2MNo9VlXmjDAv/X0j1RU2zS4pt/NV+OEBi9uQvDH+Q19AiEDvIJ3BU8Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803508; c=relaxed/simple;
	bh=jDTIPQEz+N1fUsFuqrvkU9Zt6V91k39CWHDE7FF+KFQ=;
	h=Date:To:From:Subject:Message-Id; b=CuAIb1ClqJZ+/rSEyWd/SGo+LT6i8oS5w1M2i/CFvt45YPT0EnRmYWSgcAUGEUaFM4yUHidMFID2ylR4Beq5ewmOAdDYZAmP9VawsVyzpxtFfIkDAcT9fQaOJnoM0aY2IW6SG2OGv/g/bopcAligAd0DsC73SNY0VluI4U1f/Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qp5AT4g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qp5AT4g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B8BC4AF12;
	Wed, 28 Aug 2024 00:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803507;
	bh=jDTIPQEz+N1fUsFuqrvkU9Zt6V91k39CWHDE7FF+KFQ=;
	h=Date:To:From:Subject:From;
	b=qp5AT4g41xCXz0cwE3sFYe5zo5iuB/k/wBjqLPejvZZNgXwj2Z5eCgdp9allz2Hh8
	 9vSECfMdBEDswbznMqhTuaNiLxrvKNM4+CgMQOYXYwmXoNxGyoxUIqvL1EBhycYsbt
	 VoQITHW6qCCCXb90KbFTipseVy61HWDDcrtmlp3M=
Date: Tue, 27 Aug 2024 17:05:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-convert-swapon-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240828000507.84B8BC4AF12@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: swap: convert swapon() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     swap-convert-swapon-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-convert-swapon-to-use-a-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap: convert swapon() to use a folio
Date: Mon, 26 Aug 2024 21:21:35 +0100

Retrieve a folio from the page cache rather than a page.  Saves a couple
of conversions between page & folio.

Link: https://lkml.kernel.org/r/20240826202138.3804238-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/swapfile.c~swap-convert-swapon-to-use-a-folio
+++ a/mm/swapfile.c
@@ -3355,7 +3355,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	unsigned char *swap_map = NULL;
 	unsigned long *zeromap = NULL;
 	struct swap_cluster_info *cluster_info = NULL;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
 
@@ -3413,12 +3413,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
-	page = read_mapping_page(mapping, 0, swap_file);
-	if (IS_ERR(page)) {
-		error = PTR_ERR(page);
+	folio = read_mapping_folio(mapping, 0, swap_file);
+	if (IS_ERR(folio)) {
+		error = PTR_ERR(folio);
 		goto bad_swap_unlock_inode;
 	}
-	swap_header = kmap(page);
+	swap_header = kmap_local_folio(folio, 0);
 
 	maxpages = read_swap_header(si, swap_header, inode);
 	if (unlikely(!maxpages)) {
@@ -3572,10 +3572,8 @@ bad_swap:
 	if (swap_file)
 		filp_close(swap_file, NULL);
 out:
-	if (page && !IS_ERR(page)) {
-		kunmap(page);
-		put_page(page);
-	}
+	if (!IS_ERR_OR_NULL(folio))
+		folio_release_kmap(folio, swap_header);
 	if (name)
 		putname(name);
 	if (inode)
_

Patches currently in -mm which might be from willy@infradead.org are

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch
swap-convert-swapon-to-use-a-folio.patch

