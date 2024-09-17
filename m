Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE70E1537DB
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560561; cv=none; b=a43/qk9gnm3Nng9WixKFd0Y8WrDI+ktMejYuRrEDHYERI4MHTg1zYiX8XK8cD3xCNlJqGFV7/+4ZXxEFPqMlTAv57nHRCrugo2Ji76DRXzl595w3bHbAa86dp7/ZjLTky97SzH+ly+ddzOMiEzH6iQuwpvORoHEVkVAf7rcFvC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560561; c=relaxed/simple;
	bh=5CaohOtHXLkrzpGzjdFZwsboDKGeRe9IyCUjlc6BQcw=;
	h=Date:To:From:Subject:Message-Id; b=Q4u8xbUbpxBvKk+6GuKdZDwHwz6BWGXf6ZS7yDL9KiAYj0h2QZBAmhqE2k63Gcc20Dol0g1NElCXd3yNxa+UhyKFIrgzsAwo/3NAtJxuS5YR/Xk8DLbm/m5CjrAvggGthaJT26DWf6Lc+xub7UOeKfpy5ImTb+3pSx6znuw6ZUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RXqMAaJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RXqMAaJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1801C4CEC6;
	Tue, 17 Sep 2024 08:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560561;
	bh=5CaohOtHXLkrzpGzjdFZwsboDKGeRe9IyCUjlc6BQcw=;
	h=Date:To:From:Subject:From;
	b=RXqMAaJUslHbKEx5YcpLf1MZ3VjZ7NGvdG3JQHMcF8DY6s7gwSG0PM8TkJXqMeIRq
	 Pdz74XzlP1xSTPJOVXaIlRwWykeV6TYcWf9cYMnhP6OQQyCx1dqMdDqtYMYMODLtLX
	 7GDw+a1KT4EOBQLr+F1vhkvnXaRaNztxtCwSrPhs=
Date: Tue, 17 Sep 2024 01:09:18 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,usamaarif642@gmail.com,surenb@google.com,shy828301@gmail.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,ryncsn@gmail.com,ryan.roberts@arm.com,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,kaleshsingh@google.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-swap_read_folio_zeromap-for-large-folios-with-partial-zeromap.patch removed from -mm tree
Message-Id: <20240917080920.D1801C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix swap_read_folio_zeromap() for large folios with partial zeromap
has been removed from the -mm tree.  Its filename was
     mm-fix-swap_read_folio_zeromap-for-large-folios-with-partial-zeromap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: fix swap_read_folio_zeromap() for large folios with partial zeromap
Date: Mon, 9 Sep 2024 11:21:17 +1200

Patch series "mm: enable large folios swap-in support", v9.

Currently, we support mTHP swapout but not swapin.  This means that once
mTHP is swapped out, it will come back as small folios when swapped in. 
This is particularly detrimental for devices like Android, where more than
half of the memory is in swap.

The lack of mTHP swapin functionality makes mTHP a showstopper in
scenarios that heavily rely on swap.  This patchset introduces mTHP
swap-in support.  It starts with synchronous devices similar to zRAM,
aiming to benefit as many users as possible with minimal changes.


This patch (of 3):

There could be a corner case where the first entry is non-zeromap, but a
subsequent entry is zeromap.  In this case, we should not let
swap_read_folio_zeromap() return false since we will still read corrupted
data.

Additionally, the iteration of test_bit() is unnecessary and can be
replaced with bitmap operations, which are more efficient.

We can adopt the style of swap_pte_batch() and folio_pte_batch() to
introduce swap_zeromap_batch() which seems to provide the greatest
flexibility for the caller.  This approach allows the caller to either
check if the zeromap status of all entries is consistent or determine the
number of contiguous entries with the same status.

Since swap_read_folio() can't handle reading a large folio that's
partially zeromap and partially non-zeromap, we've moved the code to
mm/swap.h so that others, like those working on swap-in, can access it.

Link: https://lkml.kernel.org/r/20240908232119.2157-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240908232119.2157-2-21cnbao@gmail.com
Fixes: 0ca0c24e3211 ("mm: store zero pages to be swapped out in a bitmap")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Usama Arif <usamaarif642@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   32 +++++++-------------------------
 mm/swap.h    |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 25 deletions(-)

--- a/mm/page_io.c~mm-fix-swap_read_folio_zeromap-for-large-folios-with-partial-zeromap
+++ a/mm/page_io.c
@@ -227,26 +227,6 @@ static void swap_zeromap_folio_clear(str
 }
 
 /*
- * Return the index of the first subpage which is not zero-filled
- * according to swap_info_struct->zeromap.
- * If all pages are zero-filled according to zeromap, it will return
- * folio_nr_pages(folio).
- */
-static unsigned int swap_zeromap_folio_test(struct folio *folio)
-{
-	struct swap_info_struct *sis = swp_swap_info(folio->swap);
-	swp_entry_t entry;
-	unsigned int i;
-
-	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
-		if (!test_bit(swp_offset(entry), sis->zeromap))
-			return i;
-	}
-	return i;
-}
-
-/*
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
  */
@@ -522,19 +502,21 @@ static void sio_read_complete(struct kio
 
 static bool swap_read_folio_zeromap(struct folio *folio)
 {
-	unsigned int idx = swap_zeromap_folio_test(folio);
-
-	if (idx == 0)
-		return false;
+	int nr_pages = folio_nr_pages(folio);
+	bool is_zeromap;
 
 	/*
 	 * Swapping in a large folio that is partially in the zeromap is not
 	 * currently handled. Return true without marking the folio uptodate so
 	 * that an IO error is emitted (e.g. do_swap_page() will sigbus).
 	 */
-	if (WARN_ON_ONCE(idx < folio_nr_pages(folio)))
+	if (WARN_ON_ONCE(swap_zeromap_batch(folio->swap, nr_pages,
+			&is_zeromap) != nr_pages))
 		return true;
 
+	if (!is_zeromap)
+		return false;
+
 	folio_zero_range(folio, 0, folio_size(folio));
 	folio_mark_uptodate(folio);
 	return true;
--- a/mm/swap.h~mm-fix-swap_read_folio_zeromap-for-large-folios-with-partial-zeromap
+++ a/mm/swap.h
@@ -80,6 +80,32 @@ static inline unsigned int folio_swap_fl
 {
 	return swp_swap_info(folio->swap)->flags;
 }
+
+/*
+ * Return the count of contiguous swap entries that share the same
+ * zeromap status as the starting entry. If is_zeromap is not NULL,
+ * it will return the zeromap status of the starting entry.
+ */
+static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
+		bool *is_zeromap)
+{
+	struct swap_info_struct *sis = swp_swap_info(entry);
+	unsigned long start = swp_offset(entry);
+	unsigned long end = start + max_nr;
+	bool first_bit;
+
+	first_bit = test_bit(start, sis->zeromap);
+	if (is_zeromap)
+		*is_zeromap = first_bit;
+
+	if (max_nr <= 1)
+		return max_nr;
+	if (first_bit)
+		return find_next_zero_bit(sis->zeromap, end, start) - start;
+	else
+		return find_next_bit(sis->zeromap, end, start) - start;
+}
+
 #else /* CONFIG_SWAP */
 struct swap_iocb;
 static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
@@ -171,6 +197,13 @@ static inline unsigned int folio_swap_fl
 {
 	return 0;
 }
+
+static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
+		bool *has_zeromap)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SWAP */
 
 #endif /* _MM_SWAP_H */
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


