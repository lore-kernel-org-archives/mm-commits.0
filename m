Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3170C3E5EFF
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 19:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773860898; cv=none; b=bQ9ZQmrOJ4puikTbr39shLcSLaINX87RYUJZ/yau2AwQe0/oZFQRMKOCDfpwormMUSoEAvhBPiCVN9iKgyoPck63t1tmepy4fqY9gTFzHZDiMghRJXIdXQakC2i0iMVo0NwP2Y75SeBstZaFlB35skA0QPpGmFDeg6pO42mYa4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773860898; c=relaxed/simple;
	bh=D7gYURAJU5+7QTSoIs6F0HbiMgUTwl4Wm3nOesNUXOc=;
	h=Date:To:From:Subject:Message-Id; b=V0p84goY7sIkMZo8kvkUfy0MGAU2uuwGeK0iVX6XbAPGkIRS1HCDmZKDxJ/A2iuDK3BLHpyM7cuXrKSZbSLf95ClG38fmHIbkO7CHWymXP4XDZEi9bGSHaBAGlouY8IleEvbOtOUBIMFH5JzWNffmQCacAyAO2TK3IrIxeKmHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SxBzuntE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SxBzuntE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57B3C19421;
	Wed, 18 Mar 2026 19:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773860897;
	bh=D7gYURAJU5+7QTSoIs6F0HbiMgUTwl4Wm3nOesNUXOc=;
	h=Date:To:From:Subject:From;
	b=SxBzuntEyOSa7TRtHubsz4RrS0NnHD0wwXuEAr0s88pUdJ8YNha/QnEJkGlScVX02
	 AFQOehbFGuVyxE5dwS9zDrn7tHi5wYLiJJOokgd6vMwNw+qEX8Dyo+6jd5Kqn083Ty
	 /DIsYyzQDHw9ewEORlC74p13cL7RVQXrz8zyZ9lQ=
Date: Wed, 18 Mar 2026 12:08:17 -0700
To: mm-commits@vger.kernel.org,ivan.djelic@parrot.com,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bch-fix-signed-left-shift-undefined-behavior.patch added to mm-nonmm-unstable branch
Message-Id: <20260318190817.C57B3C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bch: fix signed left-shift undefined behavior
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bch-fix-signed-left-shift-undefined-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bch-fix-signed-left-shift-undefined-behavior.patch

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
Subject: lib/bch: fix signed left-shift undefined behavior
Date: Wed, 18 Mar 2026 07:48:05 +0000

Patch series "lib/bch: fix undefined behavior from signed left-shifts".

Fix two instances of undefined behavior in lib/bch.c caused by
left-shifting signed integers into or past the sign bit.

While the kernel's -fno-strict-overflow flag prevents miscompilation
today, these are formally UB per C11 6.5.7p4 and trivial to fix.


This patch (of 2):

Use 1u instead of 1 to avoid undefined behavior when left-shifting into
the sign bit of a signed int.  deg() can return up to 31, and 1 << 31 is
UB per C11.

Link: https://lkml.kernel.org/r/20260318074806.16527-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ivan Djelic <ivan.djelic@parrot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/bch.c~lib-bch-fix-signed-left-shift-undefined-behavior
+++ a/lib/bch.c
@@ -392,7 +392,7 @@ static void compute_syndromes(struct bch
 			for (j = 0; j < 2*t; j += 2)
 				syn[j] ^= a_pow(bch, (j+1)*(i+s));
 
-			poly ^= (1 << i);
+			poly ^= (1u << i);
 		}
 	} while (s > 0);
 
@@ -612,7 +612,7 @@ static int find_poly_deg2_roots(struct b
 		while (v) {
 			i = deg(v);
 			r ^= bch->xi_tab[i];
-			v ^= (1 << i);
+			v ^= (1u << i);
 		}
 		/* verify root */
 		if ((gf_sqr(bch, r)^r) == u) {
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
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch
lib-bch-fix-signed-left-shift-undefined-behavior.patch
lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch

