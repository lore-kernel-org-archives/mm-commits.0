Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9750422B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671939; cv=none; b=VTK4yGgny9A/kyhjLNs1pEwJrPXqWRy5mMNkt6sq8AbcdjFMNDBFsOSWcLLmXt8/PMWYyoxmTePL6ylbwR+9mPZZ5X0fek/AlYlk85rwVBMq1aa2vd6bx0OTrihFc2/tT2LD0d2dvgiwZRXJhRWl7Oc7wVhAaacZNjsweJw328A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671939; c=relaxed/simple;
	bh=QTeM/JvYS432OGCMuO+LjyucBbDIH2/2Wrf+3wccLPY=;
	h=Date:To:From:Subject:Message-Id; b=jKG/qB5G2JM7E06enwanzMlwf6s3Qm9SwSoY/sA2BbmM255fnVsnNq07sqWiXAF3sLf5aX9YdDCixD2LNkssgbDNAKnC+M+dYWbVwIgW2xP9emtoKeMrENL4uJwQ3zGDXNjMjWGfiqkdbbYpOHDT6k2dklIfqUemBxPhZPG0QSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wNqIYqcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wNqIYqcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E39EC4CEF7;
	Sat, 28 Mar 2026 04:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671939;
	bh=QTeM/JvYS432OGCMuO+LjyucBbDIH2/2Wrf+3wccLPY=;
	h=Date:To:From:Subject:From;
	b=wNqIYqcJDYzOXGlYb5ge1RD0qwzOnXj65D1m2qXOpHTYP9P18n/ZFigOhkLPK/rxz
	 o2QUb0a2D/NTSdEvLFWzKnl3Sf1XrZ5j5TbB6Xu3VNhwL2M7jdkbPqVInePGtkSe5K
	 7DAgWE6TkWiAKijkKMMA3SMohivoHIC5Ho6epe3E=
Date: Fri, 27 Mar 2026 21:25:38 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch removed from -mm tree
Message-Id: <20260328042539.6E39EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: decompress_bunzip2: fix 32-bit shift undefined behavior
has been removed from the -mm tree.  Its filename was
     lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

