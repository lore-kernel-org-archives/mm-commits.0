Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FA1325706
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346759; cv=none; b=Lppx9HVlN8PKRQ/3kxQhnJCQ0nuaJDW/clZr1fqpQfEKi0R1iw4cHW7fMoqTQAJMZWyhUAW2WJN3jxl/fIsmpZrjJe+y6hAXK1pNEazF3t7E/rqygec6a/3R1PGJqbIDcCtbCeddWiO7P9DFskQRi2suGXMWSoQU+7FVWqRa1qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346759; c=relaxed/simple;
	bh=J7HIQuak/7k3fuVW+VcTwxjy3+rhdDtxp9J/qhgHmak=;
	h=Date:To:From:Subject:Message-Id; b=ZY8Ktua7UBci27SSkrlCeRyb8vDX/umhjlhvFEQhgSSu9a7TkhSq9C2UMsEFaWUDEUbJ8SpOae4iPaXdjYTXx8Uu89GBpOgpRnBBlNKuMjq0JMAUjreHghkqdkn/dpGXyi5hQpoINnadwY7sKBj1gc1QuW0RixAlaFesDs853gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=11ueMCGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="11ueMCGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95880C4CEF7;
	Thu, 12 Mar 2026 20:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773346759;
	bh=J7HIQuak/7k3fuVW+VcTwxjy3+rhdDtxp9J/qhgHmak=;
	h=Date:To:From:Subject:From;
	b=11ueMCGsaublUto+yOCgft+749l5gxmMAxYlCntWOhX16I0dnrjLlDjSiDCrVxw5O
	 gvcO0eZt9x1Qqh8zps08KIeqPV2G+NaQGuvQPdaXi7OW7Ba0toUUGTQ7qU8/MeYWGG
	 3xlBL+yOmVlwPBDoNkGc+0ZgDTNmUXRL6t0KI3/s=
Date: Thu, 12 Mar 2026 13:19:18 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch added to mm-nonmm-unstable branch
Message-Id: <20260312201919.95880C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bootconfig: check bounds before writing in __xbc_open_brace()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch

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
Subject: lib/bootconfig: check bounds before writing in __xbc_open_brace()
Date: Thu, 12 Mar 2026 19:11:42 +0000

The bounds check for brace_index happens after the array write.  While the
current call pattern prevents an actual out-of-bounds access (the previous
call would have returned an error), the write-before-check pattern is
fragile and would become a real out-of-bounds write if the error return
were ever not propagated.

Move the bounds check before the array write so the function is
self-contained and safe regardless of caller behavior.

Link: https://lkml.kernel.org/r/20260312191143.28719-3-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c~lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace
+++ a/lib/bootconfig.c
@@ -532,9 +532,9 @@ static char *skip_spaces_until_newline(c
 static int __init __xbc_open_brace(char *p)
 {
 	/* Push the last key as open brace */
-	open_brace[brace_index++] = xbc_node_index(last_parent);
 	if (brace_index >= XBC_DEPTH_MAX)
 		return xbc_parse_error("Exceed max depth of braces", p);
+	open_brace[brace_index++] = xbc_node_index(last_parent);
 
 	return 0;
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
maintainers-add-josh-law-as-reviewer-for-library-code.patch
lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.patch
lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch
lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch

