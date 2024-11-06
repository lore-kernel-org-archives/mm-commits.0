Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DA1187352
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855644; cv=none; b=KkuB414oab2DyIFk9GiCzOaaVRk/cvu9dvoIu9WbaXXE00aa9lyed9V9W8Uyt2g7VKZpDUr7mDzkEo7/h1VkuhKrjW9ofmDnVYjTbPANskFcOM79wN3ZEA6sd8k8Rbri38DXQ4Tp7IHzrWfgAz5VHG61vhZsXWxa2RuiyHJzAEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855644; c=relaxed/simple;
	bh=qjszasWaDUvQRuHENdO9zoueEO6JkzUWOBoR2+FmsPk=;
	h=Date:To:From:Subject:Message-Id; b=MT8FobqB/7+xYg0Kx3F+wSDXnkjRf4l97AglPfDWAaHC+EQsWOQmsA/IXVfFKYtSJYXf0lS1V9sjkmaJnxJ+ICom4qrkplaUMQpGkk/BSOknGaHcAx8mLvuDTeCzuvHn4glC9rFsTqyo68Hyl07gajaaSC0nHmmsYIVuosL6KIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBSMdsHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBSMdsHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED52C4CECF;
	Wed,  6 Nov 2024 01:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855644;
	bh=qjszasWaDUvQRuHENdO9zoueEO6JkzUWOBoR2+FmsPk=;
	h=Date:To:From:Subject:From;
	b=IBSMdsHDOStaNDVD3gkOje+jxxNgy7Pr+ZllUnqRZpsmhT6I44ObYjMzVpTxlJlDp
	 bpFRm3VNwp5L8uPxswPMEs6EoJOadYoyNhPfD12SoIgZqG0rhlEYN+9PG5Ms9maY0s
	 k0rpOuslulsDTUlne0zSOTmO6TS67v7qyIkWEFO8=
Date: Tue, 05 Nov 2024 17:14:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,peterz@infradead.org,namhyung@kernel.org,msakai@redhat.com,mingo@redhat.com,mark.rutland@arm.com,kent.overstreet@linux.dev,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,corbet@lwn.net,colyli@suse.de,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch removed from -mm tree
Message-Id: <20241106011404.3ED52C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_min_heap: update min_heap_callbacks to use default builtin swap
has been removed from the -mm tree.  Its filename was
     lib-test_min_heap-update-min_heap_callbacks-to-use-default-builtin-swap.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


