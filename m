Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48521296BCF
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 20:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346761; cv=none; b=ibBZfm5M/3CfSaJwho53EtoN6WXaUd7lNF1IPnKRMwTZtis7Hz2Y1p5h7FcsuxGF6GxEioRE9VligLSETdNvu2zwUUzgz3zY6j6kpoR1bPxvSWS1w9xzZEtOlO1wmv/rrgF0b6EkwBuw1/JYOzeED8rr9ZNC3xN9SITxxSQBTII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346761; c=relaxed/simple;
	bh=BC34SUk065tGDI3mC/tOgQMyoc6F93abGbFxRovkngg=;
	h=Date:To:From:Subject:Message-Id; b=G1HyCELFIBn44yo6N1gmHzAO6LNhzVajmroJ+1JBUsIoZyaKYyK21N6Zln4oIWlgJ8xghW1gZfKZ+N+N3l/5JwKoKZODYTqHzwwVz55KgFlOvwJxUzGA1HLE2zjxa+c4mCc8r3mEYHvUjdek20qY11QJLBpgndmR9lA3LEXJMh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BY6roybd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BY6roybd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA190C4CEF7;
	Thu, 12 Mar 2026 20:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773346760;
	bh=BC34SUk065tGDI3mC/tOgQMyoc6F93abGbFxRovkngg=;
	h=Date:To:From:Subject:From;
	b=BY6roybdHhi8iviQkqKCJXIwBHaVocO7Dn+wvDx8wzTzLfA31MbXgx7LMQ2AfF4w0
	 wbgdn6fTJnMUPO3DgA3+mW03erkZidPX1eBm0hyJ9kbBrJfBvgH5F3coWYa03/XHZA
	 JjhMivNsVSTQQIY0BE0dbLnrAAZA4qXpz+CSVvqQ=
Date: Thu, 12 Mar 2026 13:19:20 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch added to mm-nonmm-unstable branch
Message-Id: <20260312201920.DA190C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch

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
Subject: lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
Date: Thu, 12 Mar 2026 19:11:43 +0000

snprintf() returns the number of characters that would have been written
excluding the NUL terminator.  Output is truncated when the return value
is >= the buffer size, not just > the buffer size.

When ret == size, the current code takes the non-truncated path, advancing
buf by ret and reducing size to 0.  This is wrong because the output was
actually truncated (the last character was replaced by NUL).  Fix by using
>= so the truncation path is taken correctly.

Link: https://lkml.kernel.org/r/20260312191143.28719-4-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c~lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after
+++ a/lib/bootconfig.c
@@ -316,7 +316,7 @@ int __init xbc_node_compose_key_after(st
 			       depth ? "." : "");
 		if (ret < 0)
 			return ret;
-		if (ret > size) {
+		if (ret >= size) {
 			size = 0;
 		} else {
 			size -= ret;
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

