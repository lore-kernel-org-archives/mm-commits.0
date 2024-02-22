Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2296FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645176; cv=none; b=ngoUZZ4ya2qxrxVWh54DXLsqpXwrsYzSONwtxG7G9Rlgr0sHBv4EZz/bUPUwzoFxCD4BhWMclwHua+TZf7nMVQcaRYBgm0MAHXCchkQLoib7gT5bjKTZR8kZASrnSvmYLC/PcHTeN0Re5iBp3E9nnUzI/aTIK1ivHPzY9wUqKmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645176; c=relaxed/simple;
	bh=roG5TYcUti4fkJVt+YGkTzl53BWUUBaDx7uBP1xCLPU=;
	h=Date:To:From:Subject:Message-Id; b=Css1wrBgE+37teySCgTdU3cN4mSEdSV5lW4sXON95oGvqPyPC96NwGy3lqhMSdhYZcYaXuPU97VJwSO80J2bY4FtqNA5OMfv7fwTQLvKD+Ihx5NRU6hq+iQV4734QYGKN7jpoLgrqY7rN8IW28lQTXmoz8CT1DCFWLGbFEJzidk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V7DyRN/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V7DyRN/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313D0C433F1;
	Thu, 22 Feb 2024 23:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645176;
	bh=roG5TYcUti4fkJVt+YGkTzl53BWUUBaDx7uBP1xCLPU=;
	h=Date:To:From:Subject:From;
	b=V7DyRN/W6xwjXzBQdJ05+BUpgzCjMQmetmYRCFiofACjks71eML5aMJ2LnFVzR0UD
	 NpTHjUFIrlspJJk7P5FNcl9xXZ3f/ZL0UNrdpl71CfhUI/s+8qo2pEH3hEO7d18sYK
	 XosTouLZEbEZwoT1+qL87a77S+tQCiv9R+5xrKgE=
Date: Thu, 22 Feb 2024 15:39:35 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-min_heap-optimize-number-of-comparisons-in-min_heapify.patch removed from -mm tree
Message-Id: <20240222233936.313D0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib min_heap: optimize number of comparisons in min_heapify()
has been removed from the -mm tree.  Its filename was
     lib-min_heap-optimize-number-of-comparisons-in-min_heapify.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib min_heap: optimize number of comparisons in min_heapify()
Date: Wed, 10 Jan 2024 16:12:13 +0800

Optimize the min_heapify() function, resulting in a significant reduction
of approximately 50% in the number of comparisons for large random inputs,
while maintaining identical results.

The current implementation performs two comparisons per level to identify
the minimum among three elements.  In contrast, the proposed bottom-up
variation uses only one comparison per level to assess two children until
reaching the leaves.  Then, it sifts up until the correct position is
determined.

Typically, the process of sifting down proceeds to the leaf level,
resulting in O(1) secondary comparisons instead of log2(n).  This
optimization significantly reduces the number of costly indirect function
calls and improves overall performance.

Link: https://lkml.kernel.org/r/20240110081213.2289636-3-visitorckw@gmail.com
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

 include/linux/min_heap.h |   40 +++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

--- a/include/linux/min_heap.h~lib-min_heap-optimize-number-of-comparisons-in-min_heapify
+++ a/include/linux/min_heap.h
@@ -35,31 +35,33 @@ static __always_inline
 void min_heapify(struct min_heap *heap, int pos,
 		const struct min_heap_callbacks *func)
 {
-	void *left, *right, *parent, *smallest;
+	void *left, *right;
 	void *data = heap->data;
+	void *root = data + pos * func->elem_size;
+	int i = pos, j;
 
+	/* Find the sift-down path all the way to the leaves. */
 	for (;;) {
-		if (pos * 2 + 1 >= heap->nr)
+		if (i * 2 + 2 >= heap->nr)
 			break;
+		left = data + (i * 2 + 1) * func->elem_size;
+		right = data + (i * 2 + 2) * func->elem_size;
+		i = func->less(left, right) ? i * 2 + 1 : i * 2 + 2;
+	}
 
-		left = data + ((pos * 2 + 1) * func->elem_size);
-		parent = data + (pos * func->elem_size);
-		smallest = parent;
-		if (func->less(left, smallest))
-			smallest = left;
+	/* Special case for the last leaf with no sibling. */
+	if (i * 2 + 2 == heap->nr)
+		i = i * 2 + 1;
 
-		if (pos * 2 + 2 < heap->nr) {
-			right = data + ((pos * 2 + 2) * func->elem_size);
-			if (func->less(right, smallest))
-				smallest = right;
-		}
-		if (smallest == parent)
-			break;
-		func->swp(smallest, parent);
-		if (smallest == left)
-			pos = (pos * 2) + 1;
-		else
-			pos = (pos * 2) + 2;
+	/* Backtrack to the correct location. */
+	while (i != pos && func->less(root, data + i * func->elem_size))
+		i = (i - 1) / 2;
+
+	/* Shift the element into its correct place. */
+	j = i;
+	while (i != pos) {
+		i = (i - 1) / 2;
+		func->swp(data + i * func->elem_size, data + j * func->elem_size);
 	}
 }
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are


