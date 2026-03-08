Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC7018050
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772999960; cv=none; b=jQ8SMVgbaUSx0oP4wmC1OJ8fDttUgfyWn7EDXXJWm2zldmNE7kM6ebOLNNs0Fa9ruut26SkI6IRRwcbrlSvGHww7V8C/zWZxw8EYlh2amtFUud4uR7b/UwMstftFgEPmnR7Qt0E7qXvVHAxQ6YQexJLrUFcmdB6P/juRGUDC/4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772999960; c=relaxed/simple;
	bh=qHJ9LzBDOhotbsZsQqH2VewXh6Z1UXEGzKCSQaadBgw=;
	h=Date:To:From:Subject:Message-Id; b=V3BipXMqsU4ovOlcFywoDMwR3MpUCwfSrD9e79FYui8hHFbl3zWCRLkX4Be+kImk5+9IvNz0WsWhtEfbBwwgC7t1WWGSKwvgv297hoeL73UL2h40zIdXiUuDaee6W/Xzx07o+EEbgaedc19eIVBalUNQ9lFlcNkwqCyttvf1dd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RqXoUOR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RqXoUOR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1B7C116C6;
	Sun,  8 Mar 2026 19:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772999960;
	bh=qHJ9LzBDOhotbsZsQqH2VewXh6Z1UXEGzKCSQaadBgw=;
	h=Date:To:From:Subject:From;
	b=RqXoUOR5TWJwN6Ho60DZYgshKVeWdFbOdacektPTedfSl/tVBNgV8aHtW9XNwTT0Z
	 s9jtS1nMrMidfsJaHPZ067FCoj04z6wbneac91iRPlhTeiGbgyCBMeqZc+TL02akRR
	 mslNfkHEt3E6cUwjATI+hF2lrvHMAPp9uAz4ILPc=
Date: Sun, 08 Mar 2026 12:59:19 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch added to mm-nonmm-unstable branch
Message-Id: <20260308195920.1C1B7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: decompress_bunzip2: fix 32-bit shift undefined behavior
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch

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
From: Josh Law <objecting@objecting.org>
Subject: lib: decompress_bunzip2: fix 32-bit shift undefined behavior
Date: Sun, 8 Mar 2026 16:50:12 +0000

Fix undefined behavior caused by shifting a 32-bit integer by 32 bits
during decompression.  This prevents potential kernel decompression
failures or corruption when parsing malicious or malformed bzip2 archives.

Link: https://lkml.kernel.org/r/20260308165012.2872633-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/decompress_bunzip2.c~lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior
+++ a/lib/decompress_bunzip2.c
@@ -135,7 +135,7 @@ static unsigned int INIT get_bits(struct
 		}
 		/* Avoid 32-bit overflow (dump bit buffer to top of output) */
 		if (bd->inbufBitCount >= 24) {
-			bits = bd->inbufBits&((1 << bd->inbufBitCount)-1);
+			bits = bd->inbufBits & ((1ULL << bd->inbufBitCount) - 1);
 			bits_wanted -= bd->inbufBitCount;
 			bits <<= bits_wanted;
 			bd->inbufBitCount = 0;
@@ -146,7 +146,7 @@ static unsigned int INIT get_bits(struct
 	}
 	/* Calculate result */
 	bd->inbufBitCount -= bits_wanted;
-	bits |= (bd->inbufBits >> bd->inbufBitCount)&((1 << bits_wanted)-1);
+	bits |= (bd->inbufBits >> bd->inbufBitCount) & ((1ULL << bits_wanted) - 1);
 
 	return bits;
 }
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch
lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
lib-bug-remove-unnecessary-variable-initializations.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch
lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch

