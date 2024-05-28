Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E2F1791EB
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928922; cv=none; b=cCC00QJR5pT+7hcLA8WCcEuJguci+MEsPC8CUmUfn1E4PcosI8biAt+5oqykMNUTOY5GVJwuk2xnZSjpeo4n2bImYSi6/a5aG2abzdMvdt+0dkD62YuIzypivd248pxCGVEWVLi2Ey/UHJaohh0gmnyWDz2G+pp2BdT4OM71wjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928922; c=relaxed/simple;
	bh=rZRAtaXyQLAGveaqdldzRVsqehpPsYjpDyinOWa9bMk=;
	h=Date:To:From:Subject:Message-Id; b=k5MWKvdJLgM6ivx/TlXQ0PvO62eqb/1K2/L3GvcktFpIZbB5M5Tom7NoR+yD0bAn/YAXtKmpzynp+Z60JCxk0ExM8Am+iQg7SmUKCzZI9RY+sK0SNdwG8/gnEk/flSrFpHpN+kjQVCMuESXM3pVhXhRwx+YwMfFiOHCMEyGouaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q4G9iJwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q4G9iJwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2EEC3277B;
	Tue, 28 May 2024 20:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928921;
	bh=rZRAtaXyQLAGveaqdldzRVsqehpPsYjpDyinOWa9bMk=;
	h=Date:To:From:Subject:From;
	b=Q4G9iJwek3I1kbskEcSWGGN5i72JBLDiGtXleZlJV+GqGruUdxhDnqz17iY0AEym6
	 rAQO3YgjRPFtxsEto/6SaDgmTFkOsU3eABpX1JC11+0DF2dNllOz0f9p2lTntGSNHF
	 tiidEB5yHPEgATU68oZPSl/ruHLvMH35VgYRzZZA=
Date: Tue, 28 May 2024 13:42:01 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch added to mm-nonmm-unstable branch
Message-Id: <20240528204201.9E2EEC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sort: fix outdated comment regarding glibc qsort()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: fix outdated comment regarding glibc qsort()
Date: Tue, 28 May 2024 04:30:09 +0800

The existing comment in lib/sort refers to glibc qsort() using quicksort. 
However, glibc qsort() no longer uses quicksort; it now uses mergesort and
falls back to heapsort if memory allocation for mergesort fails.  This
makes the comment outdated and incorrect.

Update the comment to refer to quicksort in general rather than glibc's
implementation to provide accurate information about the comparisons and
trade-offs without implying an outdated implementation.

Link: https://lkml.kernel.org/r/20240527203011.1644280-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/sort.c~lib-sort-fix-outdated-comment-regarding-glibc-qsort
+++ a/lib/sort.c
@@ -5,7 +5,7 @@
  * This performs n*log2(n) + 0.37*n + o(n) comparisons on average,
  * and 1.5*n*log2(n) + O(n) in the (very contrived) worst case.
  *
- * Glibc qsort() manages n*log2(n) - 1.26*n for random inputs (1.63*n
+ * Quicksort manages n*log2(n) - 1.26*n for random inputs (1.63*n
  * better) at the expense of stack usage and much larger code to avoid
  * quicksort's O(n^2) worst case.
  */
_

Patches currently in -mm which might be from visitorckw@gmail.com are

perf-core-fix-several-typos.patch
bcache-fix-typo.patch
bcachefs-fix-typo.patch
lib-min_heap-add-type-safe-interface.patch
lib-min_heap-add-min_heap_init.patch
lib-min_heap-add-min_heap_peek.patch
lib-min_heap-add-min_heap_full.patch
lib-min_heap-add-args-for-min_heap_callbacks.patch
lib-min_heap-add-min_heap_sift_up.patch
lib-min_heap-add-min_heap_del.patch
lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch
lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch
lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up.patch
lib-test_min_heap-add-test-for-heap_del.patch
bcache-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
lib-sort-remove-unused-pr_fmt-macro.patch
lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch
lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch
lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch

