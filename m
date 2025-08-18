Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003A23176F1
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 02:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755485163; cv=none; b=oc2TFO5FHGz0BQHL5Q/nprfvyWfwo5pSzegpbemHkhOhfN7FQvewuHxzoj2gmqC7ehdIpYiXYHhLSo/UYfC1f3wBGP9BirdM0+ogWq+0JRQN4cyWNru5sPz/1lsdQGCCFWBZcMkpEMES4M6frrJuWkxfIrGDVPmg4sGCd/dJQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755485163; c=relaxed/simple;
	bh=RgUUpUmIPaHwsS2cYUhJW5dum3eUdYNhys5i4HWPX/E=;
	h=Date:To:From:Subject:Message-Id; b=iNJTtbAP0qs1AJwggAmmI8uuBQSe2M8Q7vP4oqfOqPXLwSVJsZBdZ8iPLHKYyy5WqBHB12nRj4S6Rbnpu4duSy4BE3Jj67DQ6RcEz4931S9thK78rowV5uyrUFF18A/kpbiGWmMCyB66ZbjIAQ7AkAFcnEPNSxUJdu4g1K6DmsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dBQOmOjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dBQOmOjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57068C4CEEB;
	Mon, 18 Aug 2025 02:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755485162;
	bh=RgUUpUmIPaHwsS2cYUhJW5dum3eUdYNhys5i4HWPX/E=;
	h=Date:To:From:Subject:From;
	b=dBQOmOjCyY2Sj27JTIqwD1b5Z0DedLSxdGN/dc5iMYBs8c6NnyffnXLOS+p75HSwn
	 KtTytzpA4JO2TOmgFDogm9guyHmPuvjOARCx+fUlYwA5YNhHNjIdtnCTG+ocHb8OmP
	 m76Tylm5qV52CFtADedWXeftuA7B+08+uM5FpMVI=
Date: Sun, 17 Aug 2025 19:46:01 -0700
To: mm-commits@vger.kernel.org,Yuezhang.Mo@sony.com,willy@infradead.org,viro@zeniv.linux.org.uk,sj1557.seo@samsung.com,linkinjeon@kernel.org,jack@suse.cz,brauner@kernel.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mpage-clean-up-do_mpage_readpage.patch added to mm-new branch
Message-Id: <20250818024602.57068C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mpage: clean up do_mpage_readpage()
has been added to the -mm mm-new branch.  Its filename is
     mpage-clean-up-do_mpage_readpage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mpage-clean-up-do_mpage_readpage.patch

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
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: mpage: clean up do_mpage_readpage()
Date: Tue, 12 Aug 2025 15:22:24 +0800

Replace two loop iterations with direct calculations.  The variable
nblocks now represents the number of avalid blocks we can obtain from
map_bh.  no functional change.

Link: https://lkml.kernel.org/r/20250812072225.181798-2-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>
Cc: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

--- a/fs/mpage.c~mpage-clean-up-do_mpage_readpage
+++ a/fs/mpage.c
@@ -158,7 +158,6 @@ static struct bio *do_mpage_readpage(str
 	struct buffer_head *map_bh = &args->map_bh;
 	sector_t block_in_file;
 	sector_t last_block;
-	sector_t last_block_in_file;
 	sector_t first_block;
 	unsigned page_block;
 	unsigned first_hole = blocks_per_folio;
@@ -180,9 +179,8 @@ static struct bio *do_mpage_readpage(str
 
 	block_in_file = folio_pos(folio) >> blkbits;
 	last_block = block_in_file + ((args->nr_pages * PAGE_SIZE) >> blkbits);
-	last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
-	if (last_block > last_block_in_file)
-		last_block = last_block_in_file;
+	last_block = min_t(sector_t, last_block,
+			   (i_size_read(inode) + blocksize - 1) >> blkbits);
 	page_block = 0;
 
 	/*
@@ -193,19 +191,15 @@ static struct bio *do_mpage_readpage(str
 			block_in_file > args->first_logical_block &&
 			block_in_file < (args->first_logical_block + nblocks)) {
 		unsigned map_offset = block_in_file - args->first_logical_block;
-		unsigned last = nblocks - map_offset;
 
 		first_block = map_bh->b_blocknr + map_offset;
-		for (relative_block = 0; ; relative_block++) {
-			if (relative_block == last) {
-				clear_buffer_mapped(map_bh);
-				break;
-			}
-			if (page_block == blocks_per_folio)
-				break;
-			page_block++;
-			block_in_file++;
-		}
+		nblocks -= map_offset;
+		if (nblocks > blocks_per_folio - page_block)
+			nblocks = blocks_per_folio - page_block;
+		else
+			clear_buffer_mapped(map_bh);
+		page_block += nblocks;
+		block_in_file += nblocks;
 		bdev = map_bh->b_bdev;
 	}
 
@@ -243,7 +237,7 @@ static struct bio *do_mpage_readpage(str
 			map_buffer_to_folio(folio, map_bh, page_block);
 			goto confused;
 		}
-	
+
 		if (first_hole != blocks_per_folio)
 			goto confused;		/* hole -> non-hole */
 
@@ -252,16 +246,14 @@ static struct bio *do_mpage_readpage(str
 			first_block = map_bh->b_blocknr;
 		else if (first_block + page_block != map_bh->b_blocknr)
 			goto confused;
+
 		nblocks = map_bh->b_size >> blkbits;
-		for (relative_block = 0; ; relative_block++) {
-			if (relative_block == nblocks) {
-				clear_buffer_mapped(map_bh);
-				break;
-			} else if (page_block == blocks_per_folio)
-				break;
-			page_block++;
-			block_in_file++;
-		}
+		if (nblocks > blocks_per_folio - page_block)
+			nblocks = blocks_per_folio - page_block;
+		else
+			clear_buffer_mapped(map_bh);
+		page_block += nblocks;
+		block_in_file += nblocks;
 		bdev = map_bh->b_bdev;
 	}
 
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch
mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch
mpage-terminate-read-ahead-on-read-error.patch
mpage-clean-up-do_mpage_readpage.patch
mpage-convert-do_mpage_readpage-to-return-int-type.patch

