Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51C2146A68
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756815; cv=none; b=Yr4luXH3fc3YTr6sD8YkBBOg749ox4jBSaGvGW3RviMG7psIqkAtizsWoJ0hpL6jNbR+Ub65TTCF7dE5ePX40IpPWOM5xlftCRHemANuWBoI3Sje3zn7WYLGKUjvk5UtqK0A4eeCzha3c7Lc00h3cE2LLapHiOtL17/iJIoWv4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756815; c=relaxed/simple;
	bh=bEh8gml4bLq5XyaK7WgMqhlRyM3e9Tk5rbxx32G3MwQ=;
	h=Date:To:From:Subject:Message-Id; b=oKtMUydktCy2BV6/PhRCMvLin2OuoYAKKpmWExKz+qPLqw0DKPP+Jxy2Eod80AHv4XOLNpx1NH2Fp82hRVtNWwLf2mKGpL9Lgzqm4ZfOQH9xuUKSFDlWcSwRrg2szmPciDXH0p3ExaiOVimJ79MGR9dxMlTdqVt8NIdoN2JOyAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Q0kg6ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Q0kg6ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BE2C4CEED;
	Sun,  1 Jun 2025 05:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756815;
	bh=bEh8gml4bLq5XyaK7WgMqhlRyM3e9Tk5rbxx32G3MwQ=;
	h=Date:To:From:Subject:From;
	b=2Q0kg6yapz8FGVAM/YaEH5LF+iKcit2EYPpR1Nt+er4HTLJEh6ZEHZ5afE2RXlMrf
	 tViG3lMbscX1pyiUVucmvfU63S3U6cM3YzWjO1l3HZtLoMuzEA+XxIhc9/EJDbrF1u
	 /FOQ86U02P2nt6bwDrDRVbdPvMc0QONIvxRgfx7Q=
Date: Sat, 31 May 2025 22:46:54 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,hughd@google.com,almaz.alexandrovich@paragon-software.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ntfs3-use-folios-more-in-ntfs_compress_write.patch removed from -mm tree
Message-Id: <20250601054655.06BE2C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ntfs3: use folios more in ntfs_compress_write()
has been removed from the -mm tree.  Its filename was
     ntfs3-use-folios-more-in-ntfs_compress_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


