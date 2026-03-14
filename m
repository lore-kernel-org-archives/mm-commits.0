Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB50B1F7569
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773528935; cv=none; b=cRJh2uu8NvWbS+aI3PfuN2t93WIZb+drgcnGSAXKnXxPjzwR6EbNBmmiwR6Y8ZPLswCn1U2fLAui9BXMakcREYBTCJKpR39XsyY/qHd89duSTpEQ0O2XBHZw68fWU9XLl+cKn0D7P7RdogPFnIIlEkC/FctyIkDzzn9/9IV2hik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773528935; c=relaxed/simple;
	bh=hkHmupJ/8R/19DhNP3ChT4PgwFkg9EARvzIZJBRmr9g=;
	h=Date:To:From:Subject:Message-Id; b=Y0M8BSlRbm9GeGJlFi9CmG/QU6NWLRi/mw+awLMwHNBJ10wgx5N3xjTDp1CgdfzsC3TAsFysC8n7qAhR7WSBAelb9YbXX1pNnEslPvaBTH9in5JGeQhMLdBayNzh6N7jgCc5fZNX1QlFnpOiI1LHhKISmenXUQakMsmUzqDaUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ObG1yB72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ObG1yB72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50467C116C6;
	Sat, 14 Mar 2026 22:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773528935;
	bh=hkHmupJ/8R/19DhNP3ChT4PgwFkg9EARvzIZJBRmr9g=;
	h=Date:To:From:Subject:From;
	b=ObG1yB72gdUsMjQ6ZOfOGK9jUspjFFJNs/z7GT7dIHBJpaPOQSGYip1vIAr/V0jyu
	 tXOzfQCvq/rzpdSscdTbh+LzoeoODzGoT2SrnxIUtCl013IMX2x74mF1XTt+9/RsFg
	 oJ6gH8m1mPXDsf6RmZJTT8d2Fl/F4+joJa+kfv4s=
Date: Sat, 14 Mar 2026 15:55:34 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch removed from -mm tree
Message-Id: <20260314225535.50467C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bootconfig: fix typo "budy" in _xbc_exit() comment
has been removed from the -mm tree.  Its filename was
     lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/bootconfig: fix typo "budy" in _xbc_exit() comment
Date: Sat, 7 Mar 2026 12:26:46 +0000

Fix a spelling error in the _xbc_exit() kernel-doc comment where "budy
system" was written instead of "buddy system".

Link: https://lkml.kernel.org/r/20260307122646.2838540-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c~lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment
+++ a/lib/bootconfig.c
@@ -911,7 +911,7 @@ static int __init xbc_parse_tree(void)
 
 /**
  * _xbc_exit() - Clean up all parsed bootconfig
- * @early: Set true if this is called before budy system is initialized.
+ * @early: Set true if this is called before buddy system is initialized.
  *
  * This clears all data structures of parsed bootconfig on memory.
  * If you need to reuse xbc_init() with new boot config, you can
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
lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.patch
lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch

