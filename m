Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D91C6A3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 02:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732935410; cv=none; b=R98uIgZ6YeZusgubGo2QpBl9jRdSXNCVZlpNxQbxGfrA2dL4gDU7TVObXV3qj2bc4+na/G3adzEzQxFgfAvEnBnWRhhsS+PM0SUufQFh6zJBjqL4C3zyxQ+CDNBcX9vnEPwRnutsqHvC19vvfKz6Luzf7UYtz/xExN95C9Zx40Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732935410; c=relaxed/simple;
	bh=X4NdBiJShuzpdY8Nsg10pXTgO4VCuGyDV7vqT3IHkxM=;
	h=Date:To:From:Subject:Message-Id; b=IDJ6XCeq2ezQFushh0+m61v2CfD6RxcTQ8llfB2exGcsb0cS4S77BLnLyknBfoUKmFGgQLVGSWh0f9UDNHB12S7FCSK51kEvTQYkMbThYfyPRmWXf9XVm+UOJOqtja6Tgd40WOyK0/gpH038Re9n5MiKms4nwir8gh4YiSKZilw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xGdfGKcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xGdfGKcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E25C4CECF;
	Sat, 30 Nov 2024 02:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732935410;
	bh=X4NdBiJShuzpdY8Nsg10pXTgO4VCuGyDV7vqT3IHkxM=;
	h=Date:To:From:Subject:From;
	b=xGdfGKcGzMrWBp/jB216LNlfYskXvMsdFbqGPWN/3UxlmFKJe+Rbq/G8gjBmr8Ptd
	 EHa2K51DMjWrzvBq+6Xp50yY3GHOZ9Vi1N+wW/1a4+wgH8URERfvJBbFa9O9t+dD75
	 82SM/P7BMeGh8aTDfcSZCwu/azSv6paxGv6NNanw=
Date: Fri, 29 Nov 2024 18:56:49 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,geert@linux-m68k.org,corbet@lwn.net,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-min_heap-add-brief-introduction-to-min-heap-api.patch added to mm-nonmm-unstable branch
Message-Id: <20241130025650.59E25C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib min_heap: add brief introduction to Min Heap API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-min_heap-add-brief-introduction-to-min-heap-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-min_heap-add-brief-introduction-to-min-heap-api.patch

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
Subject: lib min_heap: add brief introduction to Min Heap API
Date: Sat, 30 Nov 2024 02:12:21 +0800

A short description of the Min Heap API is added to the min_heap.h,
explaining its purpose for managing min-heaps and emphasizing the use of
macro wrappers instead of direct function calls.  For more details, users
are directed to the documentation at Documentation/core-api/min_heap.rst.

Link: https://lkml.kernel.org/r/20241129181222.646855-4-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/min_heap.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/min_heap.h~lib-min_heap-add-brief-introduction-to-min-heap-api
+++ a/include/linux/min_heap.h
@@ -6,6 +6,17 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+/*
+ * The Min Heap API provides utilities for managing min-heaps, a binary tree
+ * structure where each node's value is less than or equal to its children's
+ * values, ensuring the smallest element is at the root.
+ *
+ * Users should avoid directly calling functions prefixed with __min_heap_*().
+ * Instead, use the provided macro wrappers.
+ *
+ * For further details and examples, refer to Documentation/core-api/min_heap.rst.
+ */
+
 /**
  * Data structure to hold a min-heap.
  * @nr: Number of elements currently in the heap.
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch
lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch
lib-min_heap-add-brief-introduction-to-min-heap-api.patch
documentation-core-api-min_heap-add-author-information.patch

