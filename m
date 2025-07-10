Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006C6286893
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127152; cv=none; b=koDPsfPe/0iPZjuUbUXmIxK39Azws7lKv441toPWnreHuzJlzEWm4hEmP9w4y2MzzYMIC5ZwfApQ/ya0tvsP92iGXNjX24FHG4IpC31h7omvEwIR3NGo1QuPDVlrQiP/tVsfUfoITELNulnu21zC+lZIDR+n2DMGGq/8IgZ7ZTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127152; c=relaxed/simple;
	bh=DtywTBfgk6vJUVbTDbpePaWXPm3dCjEPkqHPRfX4Pqg=;
	h=Date:To:From:Subject:Message-Id; b=eXykhNV5WMsBA/79JKbpSdKGraHobh4qFicJof5pbL1aK315lucoEczTDqW1JZDCUxocl2XtRjd8fq8uJrukcTTiTJGJ1QHstOVEHukUvu0q+nbvaqcqr0GuQ7xy6VxLB0vxY4ZQ7x2QdrT0/FXBw8Kdq2wiMe/ZWiGysQw8M/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t/WncoT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t/WncoT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EB3C4CEE3;
	Thu, 10 Jul 2025 05:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127151;
	bh=DtywTBfgk6vJUVbTDbpePaWXPm3dCjEPkqHPRfX4Pqg=;
	h=Date:To:From:Subject:From;
	b=t/WncoT4mwQePEM3Cf5tBKet+xVAD0CjkSb3VBCvuT7QlE06zMROLwkGsZrrYYxUV
	 iGFEu1GjjY/x765uLNk1QNikaF/Li/dWpMlhqf5Z5NNORUSRYf0ekDLJQBns6ZKtAV
	 ZeeqkUshgguOAinrZ6KiPiiHrE4D6fptycPaPPGE=
Date: Wed, 09 Jul 2025 22:59:10 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch removed from -mm tree
Message-Id: <20250710055911.70EB3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: pass the inode to squashfs_readahead_fragment()
has been removed from the -mm tree.  Its filename was
     squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: squashfs: pass the inode to squashfs_readahead_fragment()
Date: Thu, 12 Jun 2025 15:39:00 +0100

Patch series "squashfs: Remove page->mapping references".

We're close to being able to kill page->mapping.  These two patches get us
a little bit closer.


This patch (of 2):

Eliminate a reference to page->mapping by passing the inode from the
caller.

Link: https://lkml.kernel.org/r/20250612143903.2849289-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250612143903.2849289-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c~squashfs-pass-the-inode-to-squashfs_readahead_fragment
+++ a/fs/squashfs/file.c
@@ -493,10 +493,9 @@ out:
 	return res;
 }
 
-static int squashfs_readahead_fragment(struct page **page,
+static int squashfs_readahead_fragment(struct inode *inode, struct page **page,
 	unsigned int pages, unsigned int expected, loff_t start)
 {
-	struct inode *inode = page[0]->mapping->host;
 	struct squashfs_cache_entry *buffer = squashfs_get_fragment(inode->i_sb,
 		squashfs_i(inode)->fragment_block,
 		squashfs_i(inode)->fragment_size);
@@ -605,8 +604,8 @@ static void squashfs_readahead(struct re
 
 		if (start >> msblk->block_log == file_end &&
 				squashfs_i(inode)->fragment_block != SQUASHFS_INVALID_BLK) {
-			res = squashfs_readahead_fragment(pages, nr_pages,
-							  expected, start);
+			res = squashfs_readahead_fragment(inode, pages,
+					nr_pages, expected, start);
 			if (res)
 				goto skip_pages;
 			continue;
_

Patches currently in -mm which might be from willy@infradead.org are


