Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA6F12D758
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 21:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749589725; cv=none; b=SkZWf0rc9K2c9SdISzKNwgrpw9fQsvubvJwPAEBuDoWwIeM1zvpMJnJKB5v7XPpx/PnqG8jHtauwrjAvt2iG7M2xUBKVlMUP7aJFc7ePKNytcZbFHBWfENRKdsTuAjSbrGDV7wnTHIW1BeI0EmLE1XcTSP0/J5USmvsW8yptmDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749589725; c=relaxed/simple;
	bh=9+EahQBSYaTHKqfVlTpc4TpSLbiXjh4nYp/bRAIZ81M=;
	h=Date:To:From:Subject:Message-Id; b=knzzwPXaSOup3AgnrSQTLkfufvXEnlVe/bKBS4v/D5OG6/WBTTELyeJemfN6Pce1kdzIj0kacWLB8NdyC/Paz3HUrFV1vygcOoWvHjj8FvLm087/DpOo+2bUwOhfZsRJwzNmiciIEpXxYA15ljkq2cNnotKcoOHd4jrJKUmXjXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K60TbFVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K60TbFVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3ECC4CEED;
	Tue, 10 Jun 2025 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749589724;
	bh=9+EahQBSYaTHKqfVlTpc4TpSLbiXjh4nYp/bRAIZ81M=;
	h=Date:To:From:Subject:From;
	b=K60TbFVPDuUPkIBY5uMaDvsh4OmJgdXgcWgqK3d7TNkjzKTw3Bk/JrKrWyOgP9M6D
	 Kn+pJsFqm6GcztVJABPETNpZa6LnBAQkpXaVZz9+vchs7HLoZLQWCi5a8XUOHV0KN+
	 ib31DrUIheMapoQiCJcDaj3tyFC3h6zELXVScQ9g=
Date: Tue, 10 Jun 2025 14:08:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-out-a-writeout-helper-from-pageout.patch added to mm-unstable branch
Message-Id: <20250610210844.3C3ECC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: split out a writeout helper from pageout
has been added to the -mm mm-unstable branch.  Its filename is
     mm-split-out-a-writeout-helper-from-pageout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-out-a-writeout-helper-from-pageout.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

mm-split-out-a-writeout-helper-from-pageout.patch
mm-stop-passing-a-writeback_control-structure-to-shmem_writeout.patch
mm-tidy-up-swap_writeout.patch
mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch
mm-stop-passing-a-writeback_control-structure-to-swap_writeout.patch
mm-remove-the-for_reclaim-field-from-struct-writeback_control.patch

