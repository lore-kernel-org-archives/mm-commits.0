Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE0A28467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126223; cv=none; b=EvJNfyUVrmEEc8Suh2x5dUT63o97KgR5BgXE2MHnpjQxnXA1UfYuehw+bEdcUNOa+wSiYX4pZ0j3/cFvTzXeJSE4TR5cRom/RFTzOIgKTEGn2sD1udKV8HkLZOfBwmzRnufKJzsVMyZn/FOLQTFYHyaa/jLZHHNgiwy770kMmU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126223; c=relaxed/simple;
	bh=mGIL/A8DGN0evspJeZkV+wDvIwC4ZtbGPkbyWkUdoVU=;
	h=Date:To:From:Subject:Message-Id; b=HE/tcA/iTO9RgUHhCukdXhlYIKXbzcax5hQkCX1MfNEiOuBB21+B9e9rgGxpBSvjsnHr1w9wFbUqP261cC3SLWlrqPldrHYZfttv88aIGF1v/SGovCTloYIwegNDcqExFMpNDLYAPN8gqajOYNm9UW48FX0+b3FsyK9hMOMrLXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfzAdm43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfzAdm43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CACC4CEE3;
	Thu, 10 Jul 2025 05:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126223;
	bh=mGIL/A8DGN0evspJeZkV+wDvIwC4ZtbGPkbyWkUdoVU=;
	h=Date:To:From:Subject:From;
	b=bfzAdm43zfBH4CUB4zPAxyKUP4fHAI98JwIC848YO3JU15/uV8qJU+u0Z9w3tJiHT
	 IIT2JnyRaTApcpkZrpLin9X9UhTCQzoGwFXPn9JLkH2TsJytmI29LtKG5LNWAWNHCH
	 q31Jw/69ChAzTRZRSRRTq/Bw3M4hoboLEjvBuJf0=
Date: Wed, 09 Jul 2025 22:43:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-stop-passing-a-writeback_control-structure-to-swap_writeout.patch removed from -mm tree
Message-Id: <20250710054343.61CACC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: stop passing a writeback_control structure to swap_writeout
has been removed from the -mm tree.  Its filename was
     mm-stop-passing-a-writeback_control-structure-to-swap_writeout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: stop passing a writeback_control structure to swap_writeout
Date: Tue, 10 Jun 2025 07:49:41 +0200

swap_writeout only needs the swap_iocb cookie from the writeback_control
structure, so pass it explicitly.

Link: https://lkml.kernel.org/r/20250610054959.2057526-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    7 -------
 mm/page_io.c              |    4 ++--
 mm/shmem.c                |   10 +---------
 mm/swap.h                 |    7 +++++--
 mm/vmscan.c               |   10 +---------
 5 files changed, 9 insertions(+), 29 deletions(-)

--- a/include/linux/writeback.h~mm-stop-passing-a-writeback_control-structure-to-swap_writeout
+++ a/include/linux/writeback.h
@@ -72,13 +72,6 @@ struct writeback_control {
 	 */
 	unsigned no_cgroup_owner:1;
 
-	/* To enable batching of swap writes to non-block-device backends,
-	 * "plug" can be set point to a 'struct swap_iocb *'.  When all swap
-	 * writes have been submitted, if with swap_iocb is not NULL,
-	 * swap_write_unplug() should be called.
-	 */
-	struct swap_iocb **swap_plug;
-
 	/* internal fields used by the ->writepages implementation: */
 	struct folio_batch fbatch;
 	pgoff_t index;
--- a/mm/page_io.c~mm-stop-passing-a-writeback_control-structure-to-swap_writeout
+++ a/mm/page_io.c
@@ -237,7 +237,7 @@ static void swap_zeromap_folio_clear(str
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
  */
-int swap_writeout(struct folio *folio, struct writeback_control *wbc)
+int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	int ret = 0;
 
@@ -281,7 +281,7 @@ int swap_writeout(struct folio *folio, s
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(folio, wbc->swap_plug);
+	__swap_writepage(folio, swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
--- a/mm/shmem.c~mm-stop-passing-a-writeback_control-structure-to-swap_writeout
+++ a/mm/shmem.c
@@ -1635,21 +1635,13 @@ try_split:
 		list_add(&info->swaplist, &shmem_swaplist);
 
 	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
-		struct writeback_control wbc = {
-			.sync_mode	= WB_SYNC_NONE,
-			.nr_to_write	= SWAP_CLUSTER_MAX,
-			.range_start	= 0,
-			.range_end	= LLONG_MAX,
-			.for_reclaim	= 1,
-			.swap_plug	= plug,
-		};
 		shmem_recalc_inode(inode, 0, nr_pages);
 		swap_shmem_alloc(folio->swap, nr_pages);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(folio_mapped(folio));
-		return swap_writeout(folio, &wbc);
+		return swap_writeout(folio, plug);
 	}
 	if (!info->swapped)
 		list_del_init(&info->swaplist);
--- a/mm/swap.h~mm-stop-passing-a-writeback_control-structure-to-swap_writeout
+++ a/mm/swap.h
@@ -3,6 +3,8 @@
 #define _MM_SWAP_H
 
 struct mempolicy;
+struct swap_iocb;
+
 extern int page_cluster;
 
 #ifdef CONFIG_SWAP
@@ -20,7 +22,7 @@ static inline void swap_read_unplug(stru
 		__swap_read_unplug(plug);
 }
 void swap_write_unplug(struct swap_iocb *sio);
-int swap_writeout(struct folio *folio, struct writeback_control *wbc);
+int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
@@ -160,7 +162,8 @@ static inline struct folio *swapin_reada
 	return NULL;
 }
 
-static inline int swap_writeout(struct folio *f, struct writeback_control *wbc)
+static inline int swap_writeout(struct folio *folio,
+		struct swap_iocb **swap_plug)
 {
 	return 0;
 }
--- a/mm/vmscan.c~mm-stop-passing-a-writeback_control-structure-to-swap_writeout
+++ a/mm/vmscan.c
@@ -655,14 +655,6 @@ typedef enum {
 static pageout_t writeout(struct folio *folio, struct address_space *mapping,
 		struct swap_iocb **plug, struct list_head *folio_list)
 {
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = SWAP_CLUSTER_MAX,
-		.range_start = 0,
-		.range_end = LLONG_MAX,
-		.for_reclaim = 1,
-		.swap_plug = plug,
-	};
 	int res;
 
 	folio_set_reclaim(folio);
@@ -675,7 +667,7 @@ static pageout_t writeout(struct folio *
 	if (shmem_mapping(mapping))
 		res = shmem_writeout(folio, plug, folio_list);
 	else
-		res = swap_writeout(folio, &wbc);
+		res = swap_writeout(folio, plug);
 
 	if (res < 0)
 		handle_write_error(mapping, folio, res);
_

Patches currently in -mm which might be from hch@lst.de are


