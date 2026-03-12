Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0903923EABA
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 21:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773352195; cv=none; b=kyxjYJ4eonZ5oQNpJscVLLOb/iZa8B5ZkKhteONv4I1M4MV5zgrIPpUz0atPuFvasv+b2rNIA+jfNc9XH1/7gEquvArN7UQPOkByyLXsEHRvmhpjiDEAnNcqXtRr9FYla2e0Pclnr6cM9KIasqkzC8FYrggDUDJxovOyNkMFabs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773352195; c=relaxed/simple;
	bh=e4iUYk8K65+6EIu4rxaOH5BTF6GlKHLG9YlwFS/eEcY=;
	h=Date:To:From:Subject:Message-Id; b=NHQdxEW2JTf5ztKYmdw4NPt0tecmEVd2WUgUg1Vt65N68NRJQBGHtnPDmgTS3GyYcDJ0S6v0E9bEp2yKGfPyQvj6FjxtL6OTgZo0j7tZ9pAQ/pla14ywmljQs6pBQy9Kb1g4RRXIGRg6icVfc+p0J4OnBstIyaHA1uZgryDzV74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cRoNr4R1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cRoNr4R1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD64C4CEF7;
	Thu, 12 Mar 2026 21:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773352194;
	bh=e4iUYk8K65+6EIu4rxaOH5BTF6GlKHLG9YlwFS/eEcY=;
	h=Date:To:From:Subject:From;
	b=cRoNr4R1xiE5gKA+9M1juH6eNEOJva8VKfpppFVt7hq88gLBu5AsYsdlLaa9gNyxW
	 ZtM3Ih2xFeagGipzNXF1WYxNMRhpzvq3/82RbzBEtPmMhFMAKxMZ/nLACQOLetjP+F
	 HVnf1ze7BKlBtkcJ8UmTfK8X83u5mPFrWLvPZhfE=
Date: Thu, 12 Mar 2026 14:49:53 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch removed from -mm tree
Message-Id: <20260312214954.7CD64C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bootconfig: check bounds before writing in __xbc_open_brace()
has been removed from the -mm tree.  Its filename was
     lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch

This patch was dropped because it is obsolete

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
lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch

