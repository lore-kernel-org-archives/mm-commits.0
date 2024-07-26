Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EEF148FFA;
	Fri, 26 Jul 2024 20:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026293; cv=none; b=DQrTOM0g8iQ0oLrW9Wv/VgpT2cQ/E2XMjlT247ShpkgFg75YZpK3PDjsvp+F9Y6O7kZhy/ABcdLhSpfgbhQdDMMmfnTuU24mf4MNBzXtewdjQt0Nl3JApqavfnAOfUva521WZxcaIlKlDE1YGv6SoqeDZIT/g8O7djiSoFDY6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026293; c=relaxed/simple;
	bh=OSizIzcs7Bx51EpI/sCeDOuv1/CqNy6RzLmsPProrQY=;
	h=Date:To:From:Subject:Message-Id; b=N4Gqhbm61tvlIIszceZ7zFvCOmSCS5guodr8PC/71mcYLRoYmOZTAjCwEyGJIjHegadfNaTPVoId1Im37Ig9A8VbUuUBvqojjShYRAzr6JKXu1aKONh+WB4QgF84ke+PJ5ogBYmDD7CUaZhgzJ+eeLwM+C1tzBvtKzPs/DRj0NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hO3To0zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hO3To0zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FD3C4AF0B;
	Fri, 26 Jul 2024 20:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026293;
	bh=OSizIzcs7Bx51EpI/sCeDOuv1/CqNy6RzLmsPProrQY=;
	h=Date:To:From:Subject:From;
	b=hO3To0zt8jObC4RlCA4GMCbcwPhgtMhyX2LXlUh1ZIztvs17fKAvnBn/6TsqJynkr
	 nQ7B/zmWhwcHWReyrirs6q1mvIBV8p7Lh1EghEiSD2jhR/UDsu3csHjWKXgDUUgB+q
	 XgQwwNjJzV2aHcVD1f5YIgka7r1sk+YxN+D9WP/k=
Date: Fri, 26 Jul 2024 13:38:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hpa@zytor.com,alain@knaff.lu,ross.lagerwall@citrix.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] decompress_bunzip2-fix-rare-decompression-failure.patch removed from -mm tree
Message-Id: <20240726203813.07FD3C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: decompress_bunzip2: fix rare decompression failure
has been removed from the -mm tree.  Its filename was
     decompress_bunzip2-fix-rare-decompression-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: decompress_bunzip2: fix rare decompression failure
Date: Wed, 17 Jul 2024 17:20:16 +0100

The decompression code parses a huffman tree and counts the number of
symbols for a given bit length.  In rare cases, there may be >= 256
symbols with a given bit length, causing the unsigned char to overflow. 
This causes a decompression failure later when the code tries and fails to
find the bit length for a given symbol.

Since the maximum number of symbols is 258, use unsigned short instead.

Link: https://lkml.kernel.org/r/20240717162016.1514077-1-ross.lagerwall@citrix.com
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/decompress_bunzip2.c~decompress_bunzip2-fix-rare-decompression-failure
+++ a/lib/decompress_bunzip2.c
@@ -232,7 +232,8 @@ static int INIT get_next_block(struct bu
 	   RUNB) */
 	symCount = symTotal+2;
 	for (j = 0; j < groupCount; j++) {
-		unsigned char length[MAX_SYMBOLS], temp[MAX_HUFCODE_BITS+1];
+		unsigned char length[MAX_SYMBOLS];
+		unsigned short temp[MAX_HUFCODE_BITS+1];
 		int	minLen,	maxLen, pp;
 		/* Read Huffman code lengths for each symbol.  They're
 		   stored in a way similar to mtf; record a starting
_

Patches currently in -mm which might be from ross.lagerwall@citrix.com are


