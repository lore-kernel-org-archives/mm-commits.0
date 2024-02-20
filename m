Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3127077655;
	Tue, 20 Feb 2024 18:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708455371; cv=none; b=sG9a5w8tqpN9YqIKr9KV8cBPgvjX2yyUmyzDv+9MWdRggOisiVwHocxAoLOarxCMHfPn/dn4tRbv85bpr0WB7BUtKz6aNtVcJ8iE5gdWVOt98YlnLiNeQ6T96atz5Un6A04DdGjOJD8lLaml4RRI2A/AAwzM6+DgA8vcX71B4M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708455371; c=relaxed/simple;
	bh=GlIocFEa55qaVCAm7ma/ReE9uSymdv4pYeKMiyz6tSE=;
	h=Date:To:From:Subject:Message-Id; b=InQZKwc1yL4neOBEnbJfKMWRQWnj/olXgzHtQ3ihui8Z2rmp4Nlkh3jgeAq2ubb2JE947Gr86NqTU+ziLPT3hOY1Y02oCZ4HG0IoxbMYBHKA8F6uPGlNyQCYGe3rsf8hjsVLoYKlJcVfBPx+ZCqa1/ex312RonSGm0/brvv0mRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wppylAFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wppylAFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77351C43330;
	Tue, 20 Feb 2024 18:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708455369;
	bh=GlIocFEa55qaVCAm7ma/ReE9uSymdv4pYeKMiyz6tSE=;
	h=Date:To:From:Subject:From;
	b=wppylAFoS7bWXLi/Y/AZIv8AzAhTtIsY/Xl7b56yEZYbpALk4Xkud3yTFJxmIZ/D1
	 UIzipSGSEGxCxJ1kLibpR4OizYx1yr+fNYk5WxHoslCIWTjL6hCsuNaYGppVCtCC74
	 A4KNF2np3uSUFNJ88u78bMKNGNTgjP/4fpQXW3Vo=
Date: Tue, 20 Feb 2024 10:56:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,jannh@google.com,hannes@cmpxchg.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch added to mm-hotfixes-unstable branch
Message-Id: <20240220185609.77351C43330@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cachestat: fix folio read-after-free in cache walk
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch
mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-v2.patch
mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked-fix.patch
mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch
selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch

