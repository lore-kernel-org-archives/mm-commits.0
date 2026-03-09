Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667F33ED12F
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773087873; cv=none; b=rBqkbjrp3vMmldsg9kC4FeOnpkcBNlcbDrFo2otIS/dHe5f4kF3KlBpQQHCu/I8yKEVqK7PHwUPvLIJJ+slGWkAbp0XHEEDF+s8q73VSX+kC4X31Z0JuPlhtFOpmcuHIGmED2KUCyzGI6e7b3NJOf5gEbVuevd8bV1ISXwvGyuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773087873; c=relaxed/simple;
	bh=RHSsmc9nYmI9FyP2Z4aoYEmwjnRG71zaeGl7rvaM7kA=;
	h=Date:To:From:Subject:Message-Id; b=PhShjMjJvwpSjyHOOJS/IuoIxLT6P+ebvRxC1sosn8/JPtNEUHKWtij6eLTg8BuNYleevlwwJ41X9MVDqdDuSUbMIqtFqNqwPxDWsyak2wn8OYWBqeeRzTqI8v/iJUUpA8+2jr4jZw+3i3ZH1UTtaqQ2/2z67r9VjqyiYdlex2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qphfVBqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qphfVBqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED14C4CEF7;
	Mon,  9 Mar 2026 20:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773087873;
	bh=RHSsmc9nYmI9FyP2Z4aoYEmwjnRG71zaeGl7rvaM7kA=;
	h=Date:To:From:Subject:From;
	b=qphfVBqTMkSuErrUmKRNiVREzEtvldq38QTKtbhDfhQtRm+B0jN/QnzHNQFMCwVVv
	 XNPgEISnZlMDC/jH056HMDXhIu2HqRiYdRVG5VSCJatwSv+X7Gf5U4od0M5Gu/mmHv
	 M/UOQ+MG2eH4cOR/OhiO/MlJ0GBY7jlutzaIZdBs=
Date: Mon, 09 Mar 2026 13:24:32 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch added to mm-nonmm-unstable branch
Message-Id: <20260309202433.1ED14C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/ts_kmp: fix integer overflow in pattern length calculation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch

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
Subject: lib/ts_kmp: fix integer overflow in pattern length calculation
Date: Sun, 8 Mar 2026 20:20:28 +0000

The ts_kmp algorithm stores its prefix_tbl[] table and pattern in a single
allocation sized from the pattern length.  If the prefix_tbl[] size
calculation wraps, the resulting allocation can be too small and
subsequent pattern copies can overflow it.

Fix this by rejecting zero-length patterns and by using overflow helpers
before calculating the combined allocation size.

Link: https://lkml.kernel.org/r/20260308202028.2889285-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ts_kmp.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/lib/ts_kmp.c~lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation
+++ a/lib/ts_kmp.c
@@ -94,8 +94,22 @@ static struct ts_config *kmp_init(const
 	struct ts_config *conf;
 	struct ts_kmp *kmp;
 	int i;
-	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
-	size_t priv_size = sizeof(*kmp) + len + prefix_tbl_len;
+	unsigned int prefix_tbl_len;
+	size_t priv_size;
+
+	/* Zero-length patterns would make kmp_find() read beyond kmp->pattern. */
+	if (unlikely(!len))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * kmp->pattern is stored immediately after the prefix_tbl[] table.
+	 * Reject lengths that would wrap while sizing either region.
+	 */
+	if (unlikely(check_mul_overflow(len, sizeof(*kmp->prefix_tbl),
+					&prefix_tbl_len) ||
+		     check_add_overflow(sizeof(*kmp), (size_t)len, &priv_size) ||
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

