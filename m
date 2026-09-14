Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BC63115AC;
	Mon, 14 Sep 2026 02:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789351778; cv=none; b=DU9aSqj7vMfc/cTO187X2cX66mwxtPR+YlxWIDpsFqGsOmJqH9KwKG2KDMBVT9+fBNUMTrxdjxNfzGZqcDdl5wzGbJEsqSwSNTk0F5nRZY8KxJjS+25YO0ADt5MM4AalAK5xSsWtjUg+PCRTBYfLSI/wCMtJgk6P/PgdsVejuPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789351778; c=relaxed/simple;
	bh=crp+VG43PYejLaU85bWJ1h04JjIDaqElEaHNw2coUiA=;
	h=Date:To:From:Subject:Message-Id; b=Ww5BMGN979TjhwFP/4vVMQGmfue9yEQg2hDt2J7uphLNvcVALUE+VD2g39H8XZuqEAGDSzL9FqzfpwbA9EJIbzGrTfnH9hXbHLHslfitC188pVUo+J/Nq98dkvW340wtxZj+PgYg8pfvcVgbucTs3emx1R/K8lsLcIjgf9rVb1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AeoBQ9Fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AeoBQ9Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1541F000FF;
	Mon, 14 Sep 2026 02:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789351776;
	bh=Cp54qsSei8JO4Qmt7HDw+bhMbk9LtDOHb0LZMxDgIWU=;
	h=Date:To:From:Subject;
	b=AeoBQ9FmLpz91KUaksZ2/yosvIFKJf7UMzm1GWP6G4MkNlmyyaWbmfw4ozzCsHBsB
	 oNFFP8hOQ0KOmXoNAVS0FLUIbG0ARcXH3IctiI6umUKzwIqvO/iHow7XMTviMLMNmp
	 nppvLCGXiKSWdtIaVCyYV49akuH0HE14iTIZnCPU=
Date: Sun, 13 Sep 2026 19:09:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hpa@zytor.com,alain@knaff.lu,mattst88@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-decompress_bunzip2-fix-off-by-one-in-run-length-bounds-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260914020936.2C1541F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/decompress_bunzip2: fix off-by-one in run-length bounds check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-decompress_bunzip2-fix-off-by-one-in-run-length-bounds-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-decompress_bunzip2-fix-off-by-one-in-run-length-bounds-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

lib-decompress_bunzip2-fix-off-by-one-in-run-length-bounds-check.patch

