Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723BFFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645175; cv=none; b=SMhd67Gllxxiud3/EFNtAAllkPPC929WqXNyNPtpnWeFIOJz6RdRwKNfUTHUbEIwd+ds98HY9C8XpuGMs+Ain2TmU/5GZdX7vzXZ+B+U4qKCmJFrH4C35xA4xD8ujc/eXYuiCfKW8mReDiKTyi41K7NZsZD+XL3zYOpejie7RYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645175; c=relaxed/simple;
	bh=LNiY9HaAbmswJlAcNUvk4XuEnLZj8t92Zzp7Z/iZI+4=;
	h=Date:To:From:Subject:Message-Id; b=q13+bmv5D7mR11PlItUX7AFRP9i7FHZd49JU7uTd97qvhipNcDdToBZajB2RURRXLNWYBOVFFyO5jaN7WLggkNKddyf5DQYHGRjlzWyL/OjtRCzkey+mZC9pniiH4NEaU9ux9XGhqQOY+OzbGxsDupLzsrJCF3QNw48e5EK1F+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=clbY+35v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="clbY+35v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45090C433F1;
	Thu, 22 Feb 2024 23:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645175;
	bh=LNiY9HaAbmswJlAcNUvk4XuEnLZj8t92Zzp7Z/iZI+4=;
	h=Date:To:From:Subject:From;
	b=clbY+35v3b56Mp7XmFrkW3ko6JpOlU7gK21yPXFtLj+uSK/3pu8sa0N5zt2umD1Cg
	 gbWxkjjHqPIlHic2KBexMcM7DZNKz5UYv34Utk5bZVIccDlM25WV86iusk8LCTXyyX
	 hkicTWUFAxdkCvPYdbkb3EhK6f3X9qWaAPJTMjF8=
Date: Thu, 22 Feb 2024 15:39:34 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-min_heap-optimize-number-of-calls-to-min_heapify.patch removed from -mm tree
Message-Id: <20240222233935.45090C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: optimize number of calls to min_heapify()
has been removed from the -mm tree.  Its filename was
     lib-min_heap-optimize-number-of-calls-to-min_heapify.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
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


