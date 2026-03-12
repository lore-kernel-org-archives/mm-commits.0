Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7F13DC4AB
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 22:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773355549; cv=none; b=PW5C+VI3IOKqtDDEsusbzulWIPDoD6pcbbIxNpc+wTg8GTkpRogMRGyufpWAH+7Y5EALb4Io0uiRByv70K1IHL4t++VVQBaegkfIB4PEUpzRUhVZJyW0lekMKVi8oF7NHfz+5dQ8YUyyWRZ8K4opzbV4XUSDz1OdLLBBmRn7gOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773355549; c=relaxed/simple;
	bh=IgQ7NXp34erkG1IJ93NJHsTYpVIBAJI/1WFgwCk1ETc=;
	h=Date:To:From:Subject:Message-Id; b=hTcj1epYg8eSX6TIP1VIWzag/krcqYWw2X+y/w7yDIuPO/tE10E13jq1c468qQg1BttU7vuYmLZGdhibi9VEbyyB7uoP0sotstpkVmGiv7zpGDv7YSL+k8h1MgiSXY+JYRfcrg0laCq8cvIwnS3VBV9+dUQVQqnuJVHf72JQPTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jIDzhIVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jIDzhIVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48D9C4CEF7;
	Thu, 12 Mar 2026 22:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773355548;
	bh=IgQ7NXp34erkG1IJ93NJHsTYpVIBAJI/1WFgwCk1ETc=;
	h=Date:To:From:Subject:From;
	b=jIDzhIVMU7ADkQKDtvk2ZA67prTBv3COBeGE3HtC1/T5miIs6fU5+tZVXhCqCZiJr
	 QCMt2GVlDETFDEQPM1ggUa/2ODaS+xvcH7Gas4/nsvybkpFmHI6kC6a0w6zLO6Htrl
	 a5nK6LanFPCNHTc60/KIVm+hok3d6x4Sxj6KpTWU=
Date: Thu, 12 Mar 2026 15:45:48 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20260312224548.C48D9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/glob: initialize back_str to silence uninitialized variable warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch

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
Subject: lib/glob: initialize back_str to silence uninitialized variable warning
Date: Thu, 12 Mar 2026 21:52:49 +0000

back_str is only used when back_pat is non-NULL, and both are always set
together, so it is safe in practice.  Initialize back_str to NULL to make
this safety invariant explicit and silence compiler/static analysis
warnings.

Link: https://lkml.kernel.org/r/20260312215249.50165-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/glob.c~lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning
+++ a/lib/glob.c
@@ -47,7 +47,7 @@ bool __pure glob_match(char const *pat,
 	 * (no exception for /), it can be easily proved that there's
 	 * never a need to backtrack multiple levels.
 	 */
-	char const *back_pat = NULL, *back_str;
+	char const *back_pat = NULL, *back_str = NULL;
 
 	/*
 	 * Loop over each token (character or class) in pat, matching
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
lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.patch
lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch

