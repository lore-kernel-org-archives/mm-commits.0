Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A291EA7D6
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 22:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747261664; cv=none; b=PiuHszdk/Oy4KqCmc6LexvraHiOzTkqBcurEbYhtdVjSfxZwy1X37UXh+L+56Fu2ScB3nXNI8br18fUHc58IMIDfFW6gOLBJb+0t25M4QiVeTiRkqpg1fVALV13k4hD+eppsh4QEwmKt6DIdzg0lrmsnDOCPq4I/Z1gV5ABLl3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747261664; c=relaxed/simple;
	bh=XndIoRWn0k5H2UxJxYe/6Vz2RKBArs0GGsHcIp37e04=;
	h=Date:To:From:Subject:Message-Id; b=a+nOsSGstrz8TPbfn26dOYrpYEFm1tm05xdNYoINwX8F65g1att5UbbPemJ0X95+A62nTMifFyExh8MHoWhJJodLzlMqxeI03vsMDVNB165/xMgf32oiTa9cda+bAh2Bwd8C20GogKRxzhG2lecX2jZaQgNWfU2RO64awD4Ne+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ozaeVF3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ozaeVF3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC40C4CEE3;
	Wed, 14 May 2025 22:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747261663;
	bh=XndIoRWn0k5H2UxJxYe/6Vz2RKBArs0GGsHcIp37e04=;
	h=Date:To:From:Subject:From;
	b=ozaeVF3JsiswXWGK2u/PCemomHyVffkMcKGyY4h/rqSqEwzYFcDsQZk/DM/liASa3
	 jt6/9kbErtlfACjN+p7B7TFotjBQi8PYnHeezuWP6c751FnH1a1p5LHCBG+gFPhdZu
	 uEHRCH+vPZ/5cGkdrIKy8GlzHJu8rbK0mSQ0/4h0=
Date: Wed, 14 May 2025 15:27:42 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,hughd@google.com,almaz.alexandrovich@paragon-software.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs3-use-folios-more-in-ntfs_compress_write.patch added to mm-new branch
Message-Id: <20250514222743.5CC40C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ntfs3: use folios more in ntfs_compress_write()
has been added to the -mm mm-new branch.  Its filename is
     ntfs3-use-folios-more-in-ntfs_compress_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs3-use-folios-more-in-ntfs_compress_write.patch

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
Subject: ntfs3: use folios more in ntfs_compress_write()
Date: Wed, 14 May 2025 18:06:03 +0100

Remove the local 'page' variable and do everything in terms of folios. 
Removes the last user of copy_page_from_iter_atomic() and a hidden call to
compound_head() in ClearPageDirty().

Link: https://lkml.kernel.org/r/20250514170607.3000994-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/file.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

--- a/fs/ntfs3/file.c~ntfs3-use-folios-more-in-ntfs_compress_write
+++ a/fs/ntfs3/file.c
@@ -998,7 +998,8 @@ static ssize_t ntfs_compress_write(struc
 	struct ntfs_inode *ni = ntfs_i(inode);
 	u64 valid = ni->i_valid;
 	struct ntfs_sb_info *sbi = ni->mi.sbi;
-	struct page *page, **pages = NULL;
+	struct page **pages = NULL;
+	struct folio *folio;
 	size_t written = 0;
 	u8 frame_bits = NTFS_LZNT_CUNIT + sbi->cluster_bits;
 	u32 frame_size = 1u << frame_bits;
@@ -1008,7 +1009,6 @@ static ssize_t ntfs_compress_write(struc
 	u64 frame_vbo;
 	pgoff_t index;
 	bool frame_uptodate;
-	struct folio *folio;
 
 	if (frame_size < PAGE_SIZE) {
 		/*
@@ -1062,8 +1062,7 @@ static ssize_t ntfs_compress_write(struc
 					    pages_per_frame);
 			if (err) {
 				for (ip = 0; ip < pages_per_frame; ip++) {
-					page = pages[ip];
-					folio = page_folio(page);
+					folio = page_folio(pages[ip]);
 					folio_unlock(folio);
 					folio_put(folio);
 				}
@@ -1074,10 +1073,9 @@ static ssize_t ntfs_compress_write(struc
 		ip = off >> PAGE_SHIFT;
 		off = offset_in_page(valid);
 		for (; ip < pages_per_frame; ip++, off = 0) {
-			page = pages[ip];
-			folio = page_folio(page);
-			zero_user_segment(page, off, PAGE_SIZE);
-			flush_dcache_page(page);
+			folio = page_folio(pages[ip]);
+			folio_zero_segment(folio, off, PAGE_SIZE);
+			flush_dcache_folio(folio);
 			folio_mark_uptodate(folio);
 		}
 
@@ -1086,8 +1084,7 @@ static ssize_t ntfs_compress_write(struc
 		ni_unlock(ni);
 
 		for (ip = 0; ip < pages_per_frame; ip++) {
-			page = pages[ip];
-			folio = page_folio(page);
+			folio = page_folio(pages[ip]);
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 			folio_put(folio);
@@ -1131,8 +1128,7 @@ static ssize_t ntfs_compress_write(struc
 				if (err) {
 					for (ip = 0; ip < pages_per_frame;
 					     ip++) {
-						page = pages[ip];
-						folio = page_folio(page);
+						folio = page_folio(pages[ip]);
 						folio_unlock(folio);
 						folio_put(folio);
 					}
@@ -1150,10 +1146,10 @@ static ssize_t ntfs_compress_write(struc
 		for (;;) {
 			size_t cp, tail = PAGE_SIZE - off;
 
-			page = pages[ip];
-			cp = copy_page_from_iter_atomic(page, off,
+			folio = page_folio(pages[ip]);
+			cp = copy_folio_from_iter_atomic(folio, off,
 							min(tail, bytes), from);
-			flush_dcache_page(page);
+			flush_dcache_folio(folio);
 
 			copied += cp;
 			bytes -= cp;
@@ -1173,9 +1169,8 @@ static ssize_t ntfs_compress_write(struc
 		ni_unlock(ni);
 
 		for (ip = 0; ip < pages_per_frame; ip++) {
-			page = pages[ip];
-			ClearPageDirty(page);
-			folio = page_folio(page);
+			folio = page_folio(pages[ip]);
+			folio_clear_dirty(folio);
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 			folio_put(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

highmem-add-folio_test_partial_kmap.patch
mm-rename-page-index-to-page-__folio_index.patch
ntfs3-use-folios-more-in-ntfs_compress_write.patch
iov-remove-copy_page_from_iter_atomic.patch

