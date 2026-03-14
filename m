Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED6334F49F
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 22:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773528938; cv=none; b=j/QSJ8WZWB0du43DvrnpTKF1vBwA8nkBV57sgvU+frzQVsv+6DjMSlc3cX6wVjC7AbUAGn7bpeLiFAWzqSNtSG80YSxw5usVt9njCBoUOmFHC5Ebm9fSLnIVcDLT+8MCH6BuISxGo4HfvYN5PisLssDCr/4HAsUM7lHdkoSHOGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773528938; c=relaxed/simple;
	bh=WPibFRqpDCyi4KtkNp3oRjgqkPeeq3hhVFriVm75hEw=;
	h=Date:To:From:Subject:Message-Id; b=qesE5gwWMekCvZnyZAhYnAXJh6+P7feIhkZXYb5mkrFndhkoMXIl/ydrjQCrlpfdN1KVqNPFM92POAWj+W4B1OwcrET7250FEf03P/e+/ITe+RS5BXnjC+N1aTvvDannd5wPqzQkfjNmnoahrd4UOqC5R0CuukSBz496aYH/oHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XVK2cfXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XVK2cfXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2920FC116C6;
	Sat, 14 Mar 2026 22:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773528938;
	bh=WPibFRqpDCyi4KtkNp3oRjgqkPeeq3hhVFriVm75hEw=;
	h=Date:To:From:Subject:From;
	b=XVK2cfXjLvgHfKUIQqV3EatwujGgiU/E+a4NZMZ6lGRw8T03tTuDROaow71KfvYxO
	 qNoq/YN8MBu4RF0txkHCSLjq0F2PhFvQb5HZVxIE6oY2RWPmP6x0tlosMj9CkIUwvy
	 SUDdk+AQc+UTzB+hJ6tLC7as5olQls09f6a0w4uQ=
Date: Sat, 14 Mar 2026 15:55:37 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.patch removed from -mm tree
Message-Id: <20260314225538.2920FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error
has been removed from the -mm tree.  Its filename was
     lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Tested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
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
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch

