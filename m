Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FA2314D06;
	Sat, 21 Mar 2026 18:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774117698; cv=none; b=Qs0egLuoHl1TrwucD+I97/rkCioS9MSIdJ9yzWcoyy5uBbmPyI6mjV5/lnAzGUIIwCpPnqdNGjF1a30cc1Vycp7eApSGMSGsWbwqkK+X0nHzwKc+dGadSf0YXZ+Ddsu544hVLO5R/D2T4Sce0K1tA5RGhJFQvTvqYgOK+7TumGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774117698; c=relaxed/simple;
	bh=GlzUQdMvXgW8TtwECHJ/GP8LNSr/3M0onypWr225FLo=;
	h=Date:To:From:Subject:Message-Id; b=e78BQdOExNCbF2RAQ64Yh/8E+BtxSYQLcGMxUNhQjLqpCBza5/r+lXozZ6BcJl+gMDYIIBxjhpZWdMvTaH/p4l26AwN4HT1f3q8hRdG5a9zyjHiB0vYwORG4VFAvq6g84kazoTOHK42q88nZ8HcgFsX31YGJQvjlTAcVRP86Sy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NHDwTZEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NHDwTZEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53136C19421;
	Sat, 21 Mar 2026 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774117697;
	bh=GlzUQdMvXgW8TtwECHJ/GP8LNSr/3M0onypWr225FLo=;
	h=Date:To:From:Subject:From;
	b=NHDwTZEvXMgyQXYUQ9/TGYnpQ71gYPTzjxI9wxLw2IIQNio3nD/fchYeRrT4mymbT
	 xOCz7u2N5HhyopYBKrJf8j0Z/V2D7/JepE9wevLOUCL/GYb475yg+yEEn0eNB4O46i
	 grZ1o9yT7NSWmimzLOt/OKwrb9U5cImXu2nUcWz0=
Date: Sat, 21 Mar 2026 11:28:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-fix-param_ctx-leak-on-damon_sysfs_new_test_ctx-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20260321182817.53136C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-fix-param_ctx-leak-on-damon_sysfs_new_test_ctx-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-fix-param_ctx-leak-on-damon_sysfs_new_test_ctx-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Sat, 21 Mar 2026 10:54:24 -0700

Patch series "mm/damon/sysfs: fix memory leak and NULL dereference
issues", v4.

DAMON_SYSFS can leak memory under allocation failure, and do NULL pointer
dereference when a privileged user make wrong sequences of control.  Fix
those.


This patch (of 3):

When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
param_ctx is leaked because the early return skips the cleanup at the out
label.  Destroy param_ctx before returning.

Link: https://lkml.kernel.org/r/20260321175427.86000-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260321175427.86000-2-sj@kernel.org
Fixes: f0c5118ebb0e ("mm/damon/sysfs: catch commit test ctx alloc failure")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-fix-param_ctx-leak-on-damon_sysfs_new_test_ctx-failure
+++ a/mm/damon/sysfs.c
@@ -1524,8 +1524,10 @@ static int damon_sysfs_commit_input(void
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx)
+	if (!test_ctx) {
+		damon_destroy_ctx(param_ctx);
 		return -ENOMEM;
+	}
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err)
 		goto out;
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-sysfs-fix-param_ctx-leak-on-damon_sysfs_new_test_ctx-failure.patch
mm-damon-sysfs-check-contexts-nr-before-accessing-contexts_arr.patch
mm-damon-sysfs-check-contexts-nr-in-repeat_call_fn.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
mm-damon-core-document-damos_commit_dests-failure-semantics.patch
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
lib-bch-fix-signed-left-shift-undefined-behavior.patch
lib-bch-fix-signed-shift-overflow-in-build_mod8_tables.patch

