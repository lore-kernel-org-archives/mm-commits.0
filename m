Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8434A15;
	Sat, 24 Feb 2024 01:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738074; cv=none; b=YxJK6Ultn/4ImfZowIoLSk3CYE0/JonC+uTGRzltKCl1pouAbL4x/hb57ICMWzsrIZgZ4bCzHh4+3Kc04s98ikkXpDD9rkUBm4x6E4dFjdc2FyY1mzkK5QsMnCEMnxM29kUrZOOPyqRrXXRWaQZR9ayZxaSPk11DrBSq/rxOtrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738074; c=relaxed/simple;
	bh=oB1CSDYISluEC0of0ux0+itcH/N+XzxwZNV1VXWZSVA=;
	h=Date:To:From:Subject:Message-Id; b=hnbvV3W/cYGYHqW3e/4k36kO/YoKZ8F5PiB7PTfCoiTMFVUrmyfjDm6hZUA6s7cgrkt+4bwC+1u20pQS7lOq/hMYLx29z+tNdfOQL+clHKP4MaZ2O1h7GTRTa/k/qcIBHsLNTE4I6nJr8CXtrmEGP3jTpsbc3qvo9z/uolRj6qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PMsQ9lNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PMsQ9lNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE8EC433C7;
	Sat, 24 Feb 2024 01:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738073;
	bh=oB1CSDYISluEC0of0ux0+itcH/N+XzxwZNV1VXWZSVA=;
	h=Date:To:From:Subject:From;
	b=PMsQ9lNhnngzLRFlIenB6eatYkUp6ij3M7Y4NH0ojU4FUdQg7xqAgxsxhlKOP7Oja
	 zumvYDy4nWVk//occkQsoCc8wqw53y8fjZgu532rwjnY7PiSGTgEf0sdWll/A9+Yr9
	 dvpOLPzwm/jNgGRdm1zl7REdVQ5kSv5m8V+jpKyM=
Date: Fri, 23 Feb 2024 17:27:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,jannh@google.com,hannes@cmpxchg.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch removed from -mm tree
Message-Id: <20240224012753.CFE8EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cachestat: fix folio read-after-free in cache walk
has been removed from the -mm tree.  Its filename was
     mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm: cachestat: fix folio read-after-free in cache walk
Date: Mon, 19 Feb 2024 19:01:21 -0800

In cachestat, we access the folio from the page cache's xarray to compute
its page offset, and check for its dirty and writeback flags.  However, we
do not hold a reference to the folio before performing these actions,
which means the folio can concurrently be released and reused as another
folio/page/slab.

Get around this altogether by just using xarray's existing machinery for
the folio page offsets and dirty/writeback states.

This changes behavior for tmpfs files to now always report zeroes in their
dirty and writeback counters.  This is okay as tmpfs doesn't follow
conventional writeback cache behavior: its pages get "cleaned" during
swapout, after which they're no longer resident etc.

Link: https://lkml.kernel.org/r/20240220153409.GA216065@cmpxchg.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Reported-by: Jann Horn <jannh@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>	[6.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   51 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

--- a/mm/filemap.c~mm-cachestat-fix-folio-read-after-free-in-cache-walk
+++ a/mm/filemap.c
@@ -4111,28 +4111,40 @@ static void filemap_cachestat(struct add
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, last_index) {
+		int order;
 		unsigned long nr_pages;
 		pgoff_t folio_first_index, folio_last_index;
 
+		/*
+		 * Don't deref the folio. It is not pinned, and might
+		 * get freed (and reused) underneath us.
+		 *
+		 * We *could* pin it, but that would be expensive for
+		 * what should be a fast and lightweight syscall.
+		 *
+		 * Instead, derive all information of interest from
+		 * the rcu-protected xarray.
+		 */
+
 		if (xas_retry(&xas, folio))
 			continue;
 
+		order = xa_get_order(xas.xa, xas.xa_index);
+		nr_pages = 1 << order;
+		folio_first_index = round_down(xas.xa_index, 1 << order);
+		folio_last_index = folio_first_index + nr_pages - 1;
+
+		/* Folios might straddle the range boundaries, only count covered pages */
+		if (folio_first_index < first_index)
+			nr_pages -= first_index - folio_first_index;
+
+		if (folio_last_index > last_index)
+			nr_pages -= folio_last_index - last_index;
+
 		if (xa_is_value(folio)) {
 			/* page is evicted */
 			void *shadow = (void *)folio;
 			bool workingset; /* not used */
-			int order = xa_get_order(xas.xa, xas.xa_index);
-
-			nr_pages = 1 << order;
-			folio_first_index = round_down(xas.xa_index, 1 << order);
-			folio_last_index = folio_first_index + nr_pages - 1;
-
-			/* Folios might straddle the range boundaries, only count covered pages */
-			if (folio_first_index < first_index)
-				nr_pages -= first_index - folio_first_index;
-
-			if (folio_last_index > last_index)
-				nr_pages -= folio_last_index - last_index;
 
 			cs->nr_evicted += nr_pages;
 
@@ -4150,24 +4162,13 @@ static void filemap_cachestat(struct add
 			goto resched;
 		}
 
-		nr_pages = folio_nr_pages(folio);
-		folio_first_index = folio_pgoff(folio);
-		folio_last_index = folio_first_index + nr_pages - 1;
-
-		/* Folios might straddle the range boundaries, only count covered pages */
-		if (folio_first_index < first_index)
-			nr_pages -= first_index - folio_first_index;
-
-		if (folio_last_index > last_index)
-			nr_pages -= folio_last_index - last_index;
-
 		/* page is in cache */
 		cs->nr_cache += nr_pages;
 
-		if (folio_test_dirty(folio))
+		if (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY))
 			cs->nr_dirty += nr_pages;
 
-		if (folio_test_writeback(folio))
+		if (xas_get_mark(&xas, PAGECACHE_TAG_WRITEBACK))
 			cs->nr_writeback += nr_pages;
 
 resched:
_

Patches currently in -mm which might be from nphamcs@gmail.com are


