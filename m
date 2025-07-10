Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBF428467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126218; cv=none; b=Zb7ShWZ6xSScUwQdg0yYiCRgcuhKm53meH16Kh4Hs0s1zr3ehO3rRsmc5ZXjQT31eNhkFYmuVv0uXWMjNyuTfkSnXFNZBGCrPFzxKFhsMW3IVnZUHg9Hm4OgNrV1FmWHw6WBeCNz9uy8oh0j8lTFj1nqU2hdgwX1k+au908zJ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126218; c=relaxed/simple;
	bh=62mDAsou3SyneQiv3VdeZ8ZuVO58c+WRP+3gNrYdlJU=;
	h=Date:To:From:Subject:Message-Id; b=H6/Z0+27AUDOjtuqJfzG9/eGuoWKx19PocNiFYbu8PC9O9QxaOztiY+ALNFpsDVfNZa5e01U+VK3Bz9dSIL+2yErJdn19wLBqBosCn5g+uHkjuWLCZJAcwGoEIMM1nZUFK9SCqmLIsrVosFauq4YJoLE8ugxCQ3xZEn6q0y+Khk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lt8V7/cQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lt8V7/cQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A335DC4CEE3;
	Thu, 10 Jul 2025 05:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126217;
	bh=62mDAsou3SyneQiv3VdeZ8ZuVO58c+WRP+3gNrYdlJU=;
	h=Date:To:From:Subject:From;
	b=Lt8V7/cQ3Nwl8tRV9Uj9jZ7/uxd22Jg/Cs4q2Py1B+TcUqx1hV0uXA9bgubKVDjV4
	 VSaZ8l+bthSnLU/F69zIC8oGqPjowJ9UAVfOiPeM9lwPvfmeXoAGTnUrYD2/WMK85o
	 nYQFOuij6sApp59gqdvcT+FuRzpobrCgUPZBK5s0=
Date: Wed, 09 Jul 2025 22:43:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.aibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-out-a-writeout-helper-from-pageout.patch removed from -mm tree
Message-Id: <20250710054337.A335DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: split out a writeout helper from pageout
has been removed from the -mm tree.  Its filename was
     mm-split-out-a-writeout-helper-from-pageout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: split out a writeout helper from pageout
Date: Tue, 10 Jun 2025 07:49:37 +0200

Patch series "stop passing a writeback_control to swap/shmem writeout",
v3.

This series was intended to remove the last remaining users of
AOP_WRITEPAGE_ACTIVATE after my other pending patches removed the rest,
but spectacularly failed at that.

But instead it nicely improves the code, and removes two pointers from
struct writeback_control.


This patch (of 6):

Move the code to write back swap / shmem folios into a self-contained
helper to keep prepare for refactoring it.

Link: https://lkml.kernel.org/r/20250610054959.2057526-1-hch@lst.de
Link: https://lkml.kernel.org/r/20250610054959.2057526-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baolin Wang <baolin.wang@linux.aibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   94 +++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

--- a/mm/vmscan.c~mm-split-out-a-writeout-helper-from-pageout
+++ a/mm/vmscan.c
@@ -652,14 +652,55 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
+static pageout_t writeout(struct folio *folio, struct address_space *mapping,
+		struct swap_iocb **plug, struct list_head *folio_list)
+{
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.nr_to_write = SWAP_CLUSTER_MAX,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.for_reclaim = 1,
+		.swap_plug = plug,
+	};
+	int res;
+
+	folio_set_reclaim(folio);
+
+	/*
+	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
+	 * or we failed to allocate contiguous swap entries.
+	 */
+	if (shmem_mapping(mapping)) {
+		if (folio_test_large(folio))
+			wbc.list = folio_list;
+		res = shmem_writeout(folio, &wbc);
+	} else {
+		res = swap_writeout(folio, &wbc);
+	}
+
+	if (res < 0)
+		handle_write_error(mapping, folio, res);
+	if (res == AOP_WRITEPAGE_ACTIVATE) {
+		folio_clear_reclaim(folio);
+		return PAGE_ACTIVATE;
+	}
+
+	/* synchronous write? */
+	if (!folio_test_writeback(folio))
+		folio_clear_reclaim(folio);
+
+	trace_mm_vmscan_write_folio(folio);
+	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
+	return PAGE_SUCCESS;
+}
+
 /*
  * pageout is called by shrink_folio_list() for each dirty folio.
  */
 static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 			 struct swap_iocb **plug, struct list_head *folio_list)
 {
-	int (*writeout)(struct folio *, struct writeback_control *);
-
 	/*
 	 * We no longer attempt to writeback filesystem folios here, other
 	 * than tmpfs/shmem.  That's taken care of in page-writeback.
@@ -690,51 +731,12 @@ static pageout_t pageout(struct folio *f
 		}
 		return PAGE_KEEP;
 	}
-	if (shmem_mapping(mapping))
-		writeout = shmem_writeout;
-	else if (folio_test_anon(folio))
-		writeout = swap_writeout;
-	else
-		return PAGE_ACTIVATE;
-
-	if (folio_clear_dirty_for_io(folio)) {
-		int res;
-		struct writeback_control wbc = {
-			.sync_mode = WB_SYNC_NONE,
-			.nr_to_write = SWAP_CLUSTER_MAX,
-			.range_start = 0,
-			.range_end = LLONG_MAX,
-			.for_reclaim = 1,
-			.swap_plug = plug,
-		};
-
-		/*
-		 * The large shmem folio can be split if CONFIG_THP_SWAP is
-		 * not enabled or contiguous swap entries are failed to
-		 * allocate.
-		 */
-		if (shmem_mapping(mapping) && folio_test_large(folio))
-			wbc.list = folio_list;
 
-		folio_set_reclaim(folio);
-		res = writeout(folio, &wbc);
-		if (res < 0)
-			handle_write_error(mapping, folio, res);
-		if (res == AOP_WRITEPAGE_ACTIVATE) {
-			folio_clear_reclaim(folio);
-			return PAGE_ACTIVATE;
-		}
-
-		if (!folio_test_writeback(folio)) {
-			/* synchronous write? */
-			folio_clear_reclaim(folio);
-		}
-		trace_mm_vmscan_write_folio(folio);
-		node_stat_add_folio(folio, NR_VMSCAN_WRITE);
-		return PAGE_SUCCESS;
-	}
-
-	return PAGE_CLEAN;
+	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
+		return PAGE_ACTIVATE;
+	if (!folio_clear_dirty_for_io(folio))
+		return PAGE_CLEAN;
+	return writeout(folio, mapping, plug, folio_list);
 }
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are


