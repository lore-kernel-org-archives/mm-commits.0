Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E232370ADC
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067213; cv=none; b=YKJQxXlbOz73lN6/Q5OvByEYMBnbMFihJtN14yAcd1E1mWq05VFIUQE+Hyp6Mau0Ku1hFza8RscDKF1HyQNY6/OG72A05eksWsF4QQcYX81Qf62B1V5cFldDfrNpHm2PRWgRT+8/IVYmNweW0YNP/7O/kNErKAG5K7o6EobbyJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067213; c=relaxed/simple;
	bh=G6vfZLvYG4sfcxArol6ouMZo/4pLZakt3/OOPzV7iYI=;
	h=Date:To:From:Subject:Message-Id; b=UYBm4+tFp7l5msr+sHLIhadq0viNsEE6SVpJoX52xITvSxxVLRF+6c1MJpJL4pWdJjwd0uV1IgBianKeXVUgCyndWljnot7TKR+VaSCorycGURkB3V0irmKuErhI99Wa0lZJUEdDm9qrIguLui1Uh4ke6g3bxeYds2vtfQQKD30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NIFrZpr2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NIFrZpr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F281F000E9;
	Sun, 21 Jun 2026 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067212;
	bh=rCFJsoGlQBwODfQTb0FG6UKo63AhNem8OCAsUsjLbGU=;
	h=Date:To:From:Subject;
	b=NIFrZpr2MMlCEWH1eXT3IHMR6DdqIdHaxaOEFN7El5m/W2XHkMCddxerBY/PtGol6
	 Ev3wBCcZqpNNcn5KDrH75zlauHAUmSUfonq8w1qrpepdTSbH4M25pFr+7gbtqqHv5c
	 dq2H+eS0P9U6cYfr1HsaaHcf17PV6kQZp24tfzB4=
Date: Sun, 21 Jun 2026 11:40:11 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-merge-writeout-into-pageout.patch removed from -mm tree
Message-Id: <20260621184012.12F281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: merge writeout into pageout
has been removed from the -mm tree.  Its filename was
     mm-merge-writeout-into-pageout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: merge writeout into pageout
Date: Mon, 1 Jun 2026 13:34:28 +0200

writeout is only called from pageout, and a straight flow at the end, so
merge the two functions.

Link: https://lore.kernel.org/20260601113449.3464734-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   63 +++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

--- a/mm/vmscan.c~mm-merge-writeout-into-pageout
+++ a/mm/vmscan.c
@@ -612,45 +612,14 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
-static pageout_t writeout(struct folio *folio, struct address_space *mapping,
-		struct swap_iocb **plug, struct list_head *folio_list)
-{
-	int res;
-
-	folio_set_reclaim(folio);
-
-	/*
-	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
-	 * or we failed to allocate contiguous swap entries, in which case
-	 * the split out folios get added back to folio_list.
-	 */
-	if (shmem_mapping(mapping))
-		res = shmem_writeout(folio, plug, folio_list);
-	else
-		res = swap_writeout(folio, plug);
-
-	if (res < 0)
-		handle_write_error(mapping, folio, res);
-	if (res == AOP_WRITEPAGE_ACTIVATE) {
-		folio_clear_reclaim(folio);
-		return PAGE_ACTIVATE;
-	}
-
-	/* synchronous write? */
-	if (!folio_test_writeback(folio))
-		folio_clear_reclaim(folio);
-
-	trace_mm_vmscan_write_folio(folio);
-	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
-	return PAGE_SUCCESS;
-}
-
 /*
  * pageout is called by shrink_folio_list() for each dirty folio.
  */
 static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 			 struct swap_iocb **plug, struct list_head *folio_list)
 {
+	int res;
+
 	/*
 	 * We no longer attempt to writeback filesystem folios here, other
 	 * than tmpfs/shmem.  That's taken care of in page-writeback.
@@ -674,7 +643,33 @@ static pageout_t pageout(struct folio *f
 		return PAGE_ACTIVATE;
 	if (!folio_clear_dirty_for_io(folio))
 		return PAGE_CLEAN;
-	return writeout(folio, mapping, plug, folio_list);
+
+	folio_set_reclaim(folio);
+
+	/*
+	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
+	 * or we failed to allocate contiguous swap entries, in which case
+	 * the split out folios get added back to folio_list.
+	 */
+	if (shmem_mapping(mapping))
+		res = shmem_writeout(folio, plug, folio_list);
+	else
+		res = swap_writeout(folio, plug);
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
 }
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are


