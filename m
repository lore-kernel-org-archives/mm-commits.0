Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BC614A4E0
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 02:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739847385; cv=none; b=Bv/iWFrZ8B9jslAgdeh+Xr/upj5xKfKm89GF/YY1V+i2cABWSJg9QL2l24S7RORY3Uy4N7bi5qdUC/LALAbokD1rCyG76vMBYiYIu5DJ+/ymR1f63sPUNSwsv5VJk4+UD7l/JhVhwrz3KX5Bh+Ib9uGm1SUQpun4Kdzm8WvcmYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739847385; c=relaxed/simple;
	bh=vqQdCjfTUtUqDuZx7/dwOOCRqDTbwrEhauWbhTIZT5Y=;
	h=Date:To:From:Subject:Message-Id; b=tOYWSAl2ILqD5ktOWLd9qO/GqAtA/7bdrM8Vcl3lq4ubgxKKofRefPhwTYVg9u8FQMywgjZwzP3arNTfWjqDktkSNB24vD19QSczmsvf0UrZmnkThiVo70s8nhQ4NRsYmZ9Krf1dvSbSFTScy3rCVluGuG1jr2I8LhV8q/LEWxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtWE/XB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtWE/XB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2CFC4CED1;
	Tue, 18 Feb 2025 02:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739847385;
	bh=vqQdCjfTUtUqDuZx7/dwOOCRqDTbwrEhauWbhTIZT5Y=;
	h=Date:To:From:Subject:From;
	b=rtWE/XB0n1SEGxcf+blXLgT5HOVuezOstxpBXQmiSl9DUzbtGTsiv+yigxCorIEIy
	 X0cnIuOkGBqb5ld8wTKRlF1QWzx4yww0fXHPIrC0tGi0EmW8G1k1WSV6RHyzlAkgLg
	 PWlpWLcUNbaww/P6pggNegXBqkdrzov5QYelMu50=
Date: Mon, 17 Feb 2025 18:56:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-remove-folio_file_mapping.patch added to mm-unstable branch
Message-Id: <20250218025625.9C2CFC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: remove folio_file_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-remove-folio_file_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-remove-folio_file_mapping.patch

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
Subject: fs: remove folio_file_mapping()
Date: Mon, 17 Feb 2025 19:20:08 +0000

No callers of this function remain as filesystems no longer see swapfile
pages through their normal read/write paths.

Link: https://lkml.kernel.org/r/20250217192009.437916-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/include/linux/pagemap.h~fs-remove-folio_file_mapping
+++ a/include/linux/pagemap.h
@@ -536,26 +536,6 @@ struct address_space *folio_mapping(stru
 struct address_space *swapcache_mapping(struct folio *);
 
 /**
- * folio_file_mapping - Find the mapping this folio belongs to.
- * @folio: The folio.
- *
- * For folios which are in the page cache, return the mapping that this
- * page belongs to.  Folios in the swap cache return the mapping of the
- * swap file or swap device where the data is stored.  This is different
- * from the mapping returned by folio_mapping().  The only reason to
- * use it is if, like NFS, you return 0 from ->activate_swapfile.
- *
- * Do not call this for folios which aren't in the page cache or swap cache.
- */
-static inline struct address_space *folio_file_mapping(struct folio *folio)
-{
-	if (unlikely(folio_test_swapcache(folio)))
-		return swapcache_mapping(folio);
-
-	return folio->mapping;
-}
-
-/**
  * folio_flush_mapping - Find the file mapping this folio belongs to.
  * @folio: The folio.
  *
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

