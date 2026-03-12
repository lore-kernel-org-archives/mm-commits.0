Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CE7318B85
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 20:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346758; cv=none; b=RUAQnK9t1QIHbIR0x/j25XiMB0hpBlGD2rr50KH/ntlQFi3E4bEhvtXTISB+yctEjPLf0/ouIrHC4ty+kq1hPOE/tZrVyOhJUs9A7fivXDVbJMZ/fMfbLbrGTbCm9QYTT48j4e8eRA/TsMkMVRkMJLSsIrbDDi5OpsTGsn0bIKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346758; c=relaxed/simple;
	bh=ZfpMeEvwGkz56CRLW1lKzspyXrSj/MOl8262xaXDF7w=;
	h=Date:To:From:Subject:Message-Id; b=YfWo0/sE4vMY7C6V/6by+RXnxmdDuGeuE1dVbkBjYOh0V8s5ZD1w20hKkTkSVm4Zv4ZdpXCI2K71/woN0kxjS8k3cbD8bIkOse87Nfmkh26k0/1qTxPxuYIyoz2YIMHQh60yoCX2HILlKRsdXfK5LQ4TUgHIeBJTc5B1bzlpny8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p1KhQs/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p1KhQs/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1DCC19425;
	Thu, 12 Mar 2026 20:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773346758;
	bh=ZfpMeEvwGkz56CRLW1lKzspyXrSj/MOl8262xaXDF7w=;
	h=Date:To:From:Subject:From;
	b=p1KhQs/69324MjcS3qohmk5sl3m8XqFhSeNhh2+Nee29GzdjSKFgGFpUb2LHMEHlz
	 Mhj9WzhGhYsUUA1rd3E/bcTZjt6VAP+/3mN0yjjqgFa8oCmjRkoRVIK+6/3fIg8SQv
	 FbPNxcawDxHfZXYdYDkLBZnnmeodwISgp5riYQmM=
Date: Thu, 12 Mar 2026 13:19:17 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.patch added to mm-nonmm-unstable branch
Message-Id: <20260312201918.2A1DCC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.patch

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
Subject: lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error
Date: Thu, 12 Mar 2026 19:11:41 +0000

Patch series "lib/bootconfig: three bug fixes", v2.

Three fixes for lib/bootconfig.c:

1. Fix off-by-one in xbc_verify_tree() unclosed brace error reporting.

2. Check bounds before writing in __xbc_open_brace() to prevent
   potential out-of-bounds writes.

3. Fix snprintf truncation check in xbc_node_compose_key_after().


This patch (of 3):

__xbc_open_brace() pushes entries with post-increment
(open_brace[brace_index++]), so brace_index always points one past the
last valid entry.  xbc_verify_tree() reads open_brace[brace_index] to
report which brace is unclosed, but this is one past the last pushed entry
and contains stale/zero data, causing the error message to reference the
wrong node.

Use open_brace[brace_index - 1] to correctly identify the unclosed brace. 
brace_index is known to be > 0 here since we are inside the if
(brace_index) guard.

Link: https://lkml.kernel.org/r/20260312191143.28719-1-objecting@objecting.org
Link: https://lkml.kernel.org/r/20260312191143.28719-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c~lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error
+++ a/lib/bootconfig.c
@@ -802,7 +802,7 @@ static int __init xbc_verify_tree(void)
 
 	/* Brace closing */
 	if (brace_index) {
-		n = &xbc_nodes[open_brace[brace_index]];
+		n = &xbc_nodes[open_brace[brace_index - 1]];
 		return xbc_parse_error("Brace is not closed",
 					xbc_node_get_data(n));
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

