Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7164356A38;
	Wed,  7 Oct 2026 02:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338708; cv=none; b=LJciA6G7mrDhboflPEcefXJVizM03/4IyG13VtATkEF3Gqz9Dnt9z4QRIt75sPwjsFyzs8hI9gKEwbyZmjFFe16D4PtA41V/LzLSLrlbB6731vRh7v40qc4Je66TQuuTsXnrSrVICqcCqwY/FUobAlQVON+TiaxG2QOtf3zGDWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338708; c=relaxed/simple;
	bh=EFt3zlY6v1Gmy32QHRSxHi1wDP8ovnI1oW3EdF5zRDQ=;
	h=Date:To:From:Subject:Message-Id; b=USlMbLU85emMYrwbWwEL2pkGOblmbjvDi2/dbL4wMCItiQyLNcnlsf59F5ppf+3kJLvE0YM99B8chBFTt/e1XOaoa3H5ph6Wa8QhZZ6VO7DRhvL70BoIndL6FX1ybJY8z3HBCWbkUwFfwHejsWFukKcP2qO5bn3I4XuN8NxoRmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HpKorAoj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HpKorAoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8031F0089C;
	Wed,  7 Oct 2026 02:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338706;
	bh=Zh7WkOAFIxpteijsSCYXy8ynTWihg20T2z23l23DXrA=;
	h=Date:To:From:Subject;
	b=HpKorAojC9lU4Tm1mVa0jifula92x0HKEGNXCFkS7BqPpmNeO3Gf7JUOS/Se+Ry1v
	 O+iXUn1CYto8HnG1wXMV2n8d5Lt/VGf19/ZalPOl5d4xxeyKW5NWMm7t8DeNh+T9Ec
	 7g0TQYlQORFlHOOtVHsfW9tOymgw2/JXtnYoJaF4=
Date: Tue, 06 Oct 2026 19:05:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hpa@zytor.com,alain@knaff.lu,mattst88@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-decompress_bunzip2-fix-off-by-one-in-run-length-bounds-check.patch removed from -mm tree
Message-Id: <20261007020506.AB8031F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/decompress_bunzip2: fix off-by-one in run-length bounds check
has been removed from the -mm tree.  Its filename was
     lib-decompress_bunzip2-fix-off-by-one-in-run-length-bounds-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matt Turner <mattst88@gmail.com>
Subject: lib/decompress_bunzip2: fix off-by-one in run-length bounds check
Date: Sat, 12 Sep 2026 14:17:35 -0400

The run-length path rejects a block when dbufCount+t equals dbufSize, but
the loop that follows writes exactly t bytes starting at dbufCount, so a
block that fills the buffer exactly is legal.  bzip2 allows it too: its
decompressor bounds a block at 100000 * blockSize100k and checks that
limit per byte appended.  Use > instead of >=.

bzip2's encoder stops filling a block 19 bytes early, so nothing it
produces ever reaches the limit and the bug stays hidden.  Compressors
that use the full block size do reach it: an lbzip2 -9 image whose block
ends on a run fails to decode, and a self-extracting kernel built that way
does not boot.

This code came from busybox, which fixed the same line in 2013 in commit
932e233a491b ("bunzip2: fix off-by-one check").

I ran into this because my system uses lbzip2 as /bin/bzip2 -- a common
thing on Gentoo I believe.  As far as I can tell, anyone using lbzip2
as their system bzip2 would run into this and it's only because it's
very uncommon these days to compress a kernel with bzip2 that no one
has noticed.  I only noticed because I was adding support for various
compression formats on alpha.

Link: https://lore.kernel.org/20260912-b4-bunzip2-blocksize-fix-v1-1-c7384bbfc954@gmail.com
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
---

 lib/decompress_bunzip2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_bunzip2.c~lib-decompress_bunzip2-fix-off-by-one-in-run-length-bounds-check
+++ a/lib/decompress_bunzip2.c
@@ -439,7 +439,7 @@ got_huff_bits:
 		   array.) */
 		if (runPos) {
 			runPos = 0;
-			if (dbufCount+t >= dbufSize)
+			if (dbufCount+t > dbufSize)
 				return RETVAL_DATA_ERROR;
 
 			uc = symToByte[mtfSymbol[0]];
_

Patches currently in -mm which might be from mattst88@gmail.com are


