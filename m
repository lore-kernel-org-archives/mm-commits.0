Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3A833C1AD
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773087872; cv=none; b=AGhRPugS7/s6lk2NIWN/jkjoVrg/HtKPur6xdiC3QCOix93S8Xvink/y5bzIfz/1qHs1Eu3eSkiAZwOR+Lr6ea2eZboJ+z5tdbfjV2D4Rqm4HRvnfaHpoKKUiXRuYsMzQx9GzuwEd2phy6uYKGwpiTiWcTqVPnuK1DApE17K3yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773087872; c=relaxed/simple;
	bh=5Znw7wafTrBrmHOBNaJtkUBiWZI+NhFbrwl9vwqOiZc=;
	h=Date:To:From:Subject:Message-Id; b=uOPNtcDz2cpGzemsb24opAuj9Om6/NWeyvVMwerzJnzqT3QVO2646OfxbWk8kdh5gGMCtKlVrCVA9rxVa8plzdQzaYoBPAgvHyCaLgbFJlQJrDQ6a9GnNPsb14kq9XPt5x4PP/ari+JWvWDQUOFzOI0p7/S2KjxmYof+wiADEz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L/owXXSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L/owXXSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE90C4CEF7;
	Mon,  9 Mar 2026 20:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773087871;
	bh=5Znw7wafTrBrmHOBNaJtkUBiWZI+NhFbrwl9vwqOiZc=;
	h=Date:To:From:Subject:From;
	b=L/owXXSmQ9RpRYSPjX8v0Y4vl+Rq7SfGKxfQqEFRMUSWMLNmlUalM4gNfX4S2aImU
	 zkGTG/eZx8ZCYLDXU1NIof9WKUZz495f3HDKtdsWLLCtqZm+vh1aqEXXVCaeof6Aid
	 qrLOkVt6bMobKKoY282FIpZtChHYTrGiKxSbY+kE=
Date: Mon, 09 Mar 2026 13:24:31 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch added to mm-nonmm-unstable branch
Message-Id: <20260309202431.DBE90C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/ts_bm: fix integer overflow in pattern length calculation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch

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
Subject: lib/ts_bm: fix integer overflow in pattern length calculation
Date: Sun, 8 Mar 2026 20:20:27 +0000

The ts_bm algorithm stores its good_shift[] table and pattern in a single
allocation sized from the pattern length.  If the good_shift[] size
calculation wraps, the resulting allocation can be too small and
subsequent pattern copies can overflow it.

Fix this by rejecting zero-length patterns and by using overflow helpers
before calculating the combined allocation size.

Link: https://lkml.kernel.org/r/20260308202028.2889285-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ts_bm.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/lib/ts_bm.c~lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation
+++ a/lib/ts_bm.c
@@ -163,8 +163,22 @@ static struct ts_config *bm_init(const v
 	struct ts_config *conf;
 	struct ts_bm *bm;
 	int i;
-	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
-	size_t priv_size = sizeof(*bm) + len + prefix_tbl_len;
+	unsigned int prefix_tbl_len;
+	size_t priv_size;
+
+	/* Zero-length patterns would underflow bm_find()'s initial shift. */
+	if (unlikely(!len))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * bm->pattern is stored immediately after the good_shift[] table.
+	 * Reject lengths that would wrap while sizing either region.
+	 */
+	if (unlikely(check_mul_overflow(len, sizeof(*bm->good_shift),
+					&prefix_tbl_len) ||
+		     check_add_overflow(sizeof(*bm), (size_t)len, &priv_size) ||
+		     check_add_overflow(priv_size, prefix_tbl_len, &priv_size)))
+		return ERR_PTR(-EINVAL);
 
 	conf = alloc_ts_config(priv_size, gfp_mask);
 	if (IS_ERR(conf))
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
maintainers-add-josh-law-as-reviewer-for-library-code.patch
lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch

