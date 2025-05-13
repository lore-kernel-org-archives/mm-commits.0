Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12D11EF36C
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119322; cv=none; b=oYk1OJuzWljIuBxXYkzpuNN0W01VC0Q9Fjm2+5hwSHvt4QtVFl7jsuPQ8UZjrWNUYdDwO2pGt7swWnDE1P+c8/7ZRFR9irL2vxHIo7TQTzZ5FP+GN+04MHk0V/wXtKZ7c6hjhsmamtXy58s8K6IE7jeypeWoDtIhUQV0JC+qKM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119322; c=relaxed/simple;
	bh=6YbJxrHHb3emGs3UTk7pQ9uNBFpO9OKb+a7l0doNpmU=;
	h=Date:To:From:Subject:Message-Id; b=ftirYetCdtyq1G1idF2kcn8JeJxEMkQby23VTop/t7Ahqs7+MiaqJGDG4UGA5C01ixx/BGMjD4TtuPq9IUoLX4SQvYl7IAtW2wk2lM9c1nPIiJiS88VKeo7uAV3wTYPy1Y1CQ1M6N5q6l0M3NYpJb7uip7cAvznOxpXg7unV4no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YhKemjg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YhKemjg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62ABBC4CEE4;
	Tue, 13 May 2025 06:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119319;
	bh=6YbJxrHHb3emGs3UTk7pQ9uNBFpO9OKb+a7l0doNpmU=;
	h=Date:To:From:Subject:From;
	b=YhKemjg/bR3lUEXuk8zAYuLIjMBA3LJUg16aIoG006XIe2NznkABwXrpDyR9r34GC
	 rihUh+NevK8TrCHMF6Z2H1lo1fBSo2wI7jJ85SL7Ks6FaOyrwKcgIo8ixVvTgpKmGX
	 m7X4blBT65QAjXvmjih/nS62/017GHwuIAq4iDHE=
Date: Mon, 12 May 2025 23:55:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xarray-fix-kerneldoc-for-__xa_cmpxchg.patch removed from -mm tree
Message-Id: <20250513065519.62ABBC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: fix kerneldoc for __xa_cmpxchg
has been removed from the -mm tree.  Its filename was
     xarray-fix-kerneldoc-for-__xa_cmpxchg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: xarray: fix kerneldoc for __xa_cmpxchg
Date: Wed, 7 May 2025 07:16:20 +0200

Fix the documentation for __xa_cmpxchg to actually describe the
cmpxch-like semantics correctly, based on the version for xa_cmpxchg.

Link: https://lkml.kernel.org/r/20250507051656.3900864-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/lib/xarray.c~xarray-fix-kerneldoc-for-__xa_cmpxchg
+++ a/lib/xarray.c
@@ -1742,20 +1742,23 @@ static inline void *__xa_cmpxchg_raw(str
 			void *old, void *entry, gfp_t gfp);
 
 /**
- * __xa_cmpxchg() - Store this entry in the XArray.
+ * __xa_cmpxchg() - Conditionally replace an entry in the XArray.
  * @xa: XArray.
  * @index: Index into array.
  * @old: Old value to test against.
- * @entry: New entry.
+ * @entry: New value to place in array.
  * @gfp: Memory allocation flags.
  *
  * You must already be holding the xa_lock when calling this function.
  * It will drop the lock if needed to allocate memory, and then reacquire
  * it afterwards.
  *
+ * If the entry at @index is the same as @old, replace it with @entry.
+ * If the return value is equal to @old, then the exchange was successful.
+ *
  * Context: Any context.  Expects xa_lock to be held on entry.  May
  * release and reacquire xa_lock if @gfp flags permit.
- * Return: The old entry at this index or xa_err() if an error happened.
+ * Return: The old value at this index or xa_err() if an error happened.
  */
 void *__xa_cmpxchg(struct xarray *xa, unsigned long index,
 			void *old, void *entry, gfp_t gfp)
_

Patches currently in -mm which might be from hch@lst.de are


