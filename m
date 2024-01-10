Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F022D4C3CD
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="quH8uGlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BD1C433C7;
	Wed, 10 Jan 2024 15:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902256;
	bh=E6B4A6wGjn/KiRuuqz+dyIL2F19iNolGBlQJeyohjCY=;
	h=Date:To:From:Subject:From;
	b=quH8uGlQ66Xu5c5LIcZenJxxA+V3cOBGCV5etJA3uoRqrowQVUwki+PjhzNe8thhu
	 WrtX2IR6Wbj6kmr+M5QEtoGbxyMoXqETHsplmuWCJIUHFHXT6ITERjjhcMGVwZYx/d
	 htEWiFGQBEFefl/wfB+FXeXXZ+qay3X6znelGgJE=
Date: Wed, 10 Jan 2024 07:57:35 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-optimize-number-of-calls-to-min_heapify.patch added to mm-nonmm-unstable branch
Message-Id: <20240110155736.68BD1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: optimize number of calls to min_heapify()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-optimize-number-of-calls-to-min_heapify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-optimize-number-of-calls-to-min_heapify.patch

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
Subject: lib min_heap: optimize number of calls to min_heapify()
Date: Wed, 10 Jan 2024 16:12:12 +0800

Patch series "lib min_heap: Min heap optimizations".

The purpose of this patch series is to enhance the existing min heap
implementation.  The optimization focuses on both the heap construction
process and the number of comparisons made during the heapify operation.


This patch (of 2):

Improve the heap construction process by reducing unnecessary heapify
operations.  Specifically, adjust the starting condition from n / 2 to n /
2 - 1 in the loop that iterates over all non-leaf elements.

Link: https://lkml.kernel.org/r/20240110081213.2289636-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20240110081213.2289636-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/min_heap.h~lib-min_heap-optimize-number-of-calls-to-min_heapify
+++ a/include/linux/min_heap.h
@@ -70,7 +70,7 @@ void min_heapify_all(struct min_heap *he
 {
 	int i;
 
-	for (i = heap->nr / 2; i >= 0; i--)
+	for (i = heap->nr / 2 - 1; i >= 0; i--)
 		min_heapify(heap, i, func);
 }
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-min_heap-optimize-number-of-calls-to-min_heapify.patch
lib-min_heap-optimize-number-of-comparisons-in-min_heapify.patch

