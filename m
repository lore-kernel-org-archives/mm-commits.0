Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2EA13541F
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 21:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716931969; cv=none; b=L0BOv7soUJbdrFieF9y69CZWfXVgzwRfO8zJf6xTklUmSvlg52D7dVpql0MtAXAEgyr9Jq4ZCHDZLMv622pOd2IVkni3x3AXDgWWjFwtflNNP2drqcCBM69IfB8qjBbkS+j+coFqqLFTWvvcEwm3p4gXrMtauE/4W/6Sqr3B9hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716931969; c=relaxed/simple;
	bh=LKwrfr7YOkrht7p5ByqEAr1ygk9tRtgPAXulMXhSoKE=;
	h=Date:To:From:Subject:Message-Id; b=RMPd5LTJrEXFYz2t+cICNvgjNSVBv2v/opG3h9qGMslfu4glaxt0aU5WDsoBEEP/3W9j7zqeL4oI3ejVcDaSxGV5fu/JV+uHyERfDjiuggZI6XjWpb3gfbMII3oTpAM4vtdnJ+y6KT5MO60xKlnG9jI729+Sp3uFMt344Dlh9BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GPCWS1Jn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GPCWS1Jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD70C3277B;
	Tue, 28 May 2024 21:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716931968;
	bh=LKwrfr7YOkrht7p5ByqEAr1ygk9tRtgPAXulMXhSoKE=;
	h=Date:To:From:Subject:From;
	b=GPCWS1JnSJip1xAo/gqtAeMc/4LMcvyj1edRqIP+4AMRMYuyNrIMkABbuSUjI+XyN
	 gBv59KRCAt4gVrO1Klop0DwH/4iMxfFLWspHe/C+tTF/krNoiMAl/wDH3wh8VFH9gt
	 1QMuWSzrMxkY2kRA/n5GPHoIufQMj2Fxyv8ug8zI=
Date: Tue, 28 May 2024 14:32:47 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling.patch added to mm-nonmm-unstable branch
Message-Id: <20240528213248.8BD70C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/lib/list_sort: remove redundant code for cond_resched handling
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling.patch

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
Subject: tools/lib/list_sort: remove redundant code for cond_resched handling
Date: Sun, 26 May 2024 07:02:06 +0800

Since cond_resched() is not called in userspace, remove the redundant code
in userspace's list_sort() implementation.  This change eliminates the
unused 'count' variable and the associated logic for invoking cmp()
periodically, which was intended to trigger cond_resched() in kernel
space.

The removed code includes:
- Declaration and increment of the 'count' variable.
- Conditional invocation of cmp() based on 'count'.

This cleanup simplifies merge_final(), avoids unnecessary overhead, and
has no impact on the functionality of list_sort() in userspace.

Link: https://lkml.kernel.org/r/20240525230206.1077536-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/lib/list_sort.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/tools/lib/list_sort.c~tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling
+++ a/tools/lib/list_sort.c
@@ -52,7 +52,6 @@ static void merge_final(void *priv, list
 			struct list_head *a, struct list_head *b)
 {
 	struct list_head *tail = head;
-	u8 count = 0;
 
 	for (;;) {
 		/* if equal, take 'a' -- important for sort stability */
@@ -78,15 +77,6 @@ static void merge_final(void *priv, list
 	/* Finish linking remainder of list b on to tail */
 	tail->next = b;
 	do {
-		/*
-		 * If the merge is highly unbalanced (e.g. the input is
-		 * already sorted), this loop may run many iterations.
-		 * Continue callbacks to the client even though no
-		 * element comparison is needed, so the client's cmp()
-		 * routine can invoke cond_resched() periodically.
-		 */
-		if (unlikely(!++count))
-			cmp(priv, b, b);
 		b->prev = tail;
 		tail = b;
 		b = b->next;
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
tools-lib-list_sort-remove-redundant-code-for-cond_resched-handling.patch

