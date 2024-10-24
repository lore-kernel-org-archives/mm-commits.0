Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42807157A59
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739432; cv=none; b=Df4PE+NENQXdfwFdaqrbstVkBAgRFjd+BTAl/eZQ84PcUvS4drI2KreQeDk8/yn1or6IWfGzAWlHd0Ia9o2xYf8MPGNjMdlQ6hzE0pnY9s9Wkx0q8BXJ/O6FKO8vcV6a9i38VgosbBMGIJFSG9SavTc7MRKuw7NViEVkyBHCT14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739432; c=relaxed/simple;
	bh=BK2k/Lm+X6mQImEEg6AoU0y91a/aYKKPpJVyITgVkB0=;
	h=Date:To:From:Subject:Message-Id; b=nQ7P+/zwPKeH+EZyy7MJ5gjZrsz+RRhyet/mZF/TduXHoHjz4W7hr2TIyZG2fIx/D/TIbTnfhsRF69gU+hhKnDwYprrAZr/wRdLeeuv6RbM6ads2wGA/Or/TN2/iQMYFrIJvDnV6xOd65fvD+BfZKAC/Q2hTLJtKKqC2mgsCTwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XP7oU+Jh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XP7oU+Jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5675C4CEC6;
	Thu, 24 Oct 2024 03:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739431;
	bh=BK2k/Lm+X6mQImEEg6AoU0y91a/aYKKPpJVyITgVkB0=;
	h=Date:To:From:Subject:From;
	b=XP7oU+JhClUbQCPdWaxvlMDBkw90BAuqeZxYAw5QalK6EgtFgnyA2KITryNWMcAtk
	 F5EgT9x569JsK24JqfwUhh6FphfINuYTubhCic47vqJYzl+Fyj3kBN9H6XJgKlIQa3
	 aiwuiRaS2mpzU7KxExdJBV3JfUBngsKCTELfMvxg=
Date: Wed, 23 Oct 2024 20:10:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch added to mm-nonmm-unstable branch
Message-Id: <20241024031031.D5675C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_min_heap: update min_heap_callbacks to use default builtin swap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch

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
Subject: lib/test_min_heap: update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:54 +0800

Replace the swp function pointer in the min_heap_callbacks of
test_min_heap with NULL, allowing direct usage of the default builtin swap
implementation.  This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Link: https://lkml.kernel.org/r/20241020040200.939973-5-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Coly Li <colyli@suse.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Sakai <msakai@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_min_heap.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/lib/test_min_heap.c~lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap
+++ a/lib/test_min_heap.c
@@ -23,14 +23,6 @@ static __init bool greater_than(const vo
 	return *(int *)lhs > *(int *)rhs;
 }
 
-static __init void swap_ints(void *lhs, void *rhs, void __always_unused *args)
-{
-	int temp = *(int *)lhs;
-
-	*(int *)lhs = *(int *)rhs;
-	*(int *)rhs = temp;
-}
-
 static __init int pop_verify_heap(bool min_heap,
 				struct min_heap_test *heap,
 				const struct min_heap_callbacks *funcs)
@@ -72,7 +64,7 @@ static __init int test_heapify_all(bool
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, err;
 
@@ -104,7 +96,7 @@ static __init int test_heap_push(bool mi
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, temp, err;
 
@@ -136,7 +128,7 @@ static __init int test_heap_pop_push(boo
 	};
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, temp, err;
 
@@ -175,7 +167,7 @@ static __init int test_heap_del(bool min
 	heap.nr = ARRAY_SIZE(values);
 	struct min_heap_callbacks funcs = {
 		.less = min_heap ? less_than : greater_than,
-		.swp = swap_ints,
+		.swp = NULL,
 	};
 	int i, err;
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch
lib-list_sort-remove-unnecessary-header-includes.patch
tools-lib-list_sort-remove-unnecessary-header-includes.patch
perf-tools-update-expected-diff-for-lib-list_sortc.patch
lib-min_heap-introduce-non-inline-versions-of-min-heap-api-functions.patch
lib-min_heap-optimize-min-heap-by-prescaling-counters-for-better-performance.patch
lib-min_heap-avoid-indirect-function-call-by-providing-default-swap.patch
lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch
perf-core-update-min_heap_callbacks-to-use-default-builtin-swap.patch
dm-vdo-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcache-update-min_heap_callbacks-to-use-default-builtin-swap.patch
bcachefs-clean-up-duplicate-min_heap_callbacks-declarations.patch
bcachefs-update-min_heap_callbacks-to-use-default-builtin-swap.patch
documentation-core-api-add-min-heap-api-introduction.patch

