Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191AD1F7569
	for <mm-commits@vger.kernel.org>; Sat, 14 Mar 2026 22:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773528941; cv=none; b=TvR9UsakjCZ+HJFxzPkbS964KAX4EzWi74TnwF0Tfu6Nay+1NQYWZ9AIC0G3kW6AQsTr5Tek7aws/0qa0Ptw6hpO3cEeOQbldSnMdW+DWVHUOslqQqcYyqX+IzmIAkRoIrbVhOt6fsTXEAViA1owAlLi5KC2Hlx7QYDOCDUzQuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773528941; c=relaxed/simple;
	bh=281Y2X6C/Ei0Qm+8CVeh7d2vOikxbgyoyFCIfxRNA30=;
	h=Date:To:From:Subject:Message-Id; b=TxEk9P7N73MgKHE/XqCC4PwKQfrGfe7775J4tumoCBQCVQeo1Cq4FbxATIwc1ChLuBhGxBztktP9QRKExVRs1l55mA7THt2U2s59z+8Tqtfn/m7uZd8fz0O6jPazGYQSW9/c9psR+f/VzxsD9KwapBt6h3dhdnXC/+Jggpam8Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aHn3o4cI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aHn3o4cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A9DC116C6;
	Sat, 14 Mar 2026 22:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773528941;
	bh=281Y2X6C/Ei0Qm+8CVeh7d2vOikxbgyoyFCIfxRNA30=;
	h=Date:To:From:Subject:From;
	b=aHn3o4cITDVaRW9hiYWvRqsoKWEc/VyFLVjxWggqTniR2SQE7U9yPsBzlmu/zTkKW
	 1rEJOUayZ4T9RTATWC3UpJ+DaFDkPmdABJRRDhfJQNxzny4i8QzoJ7Gp3yJLZn/zfQ
	 DSTp9ryu6SbezxFUttghJBZg3K7SzzwJF1S1Wg6w=
Date: Sat, 14 Mar 2026 15:55:40 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch removed from -mm tree
Message-Id: <20260314225540.E5A9DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
has been removed from the -mm tree.  Its filename was
     lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_after.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
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
lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
lib-glob-initialize-back_str-to-silence-uninitialized-variable-warning.patch

