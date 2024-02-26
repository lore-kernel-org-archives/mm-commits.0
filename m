Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A2713249E
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 22:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708986326; cv=none; b=ReRGtVZ26D7MNqgHMW09iE7Q8cRLNxby5YwZIs1JfwQ6cQqRIss/F7M5y+IBP3eCXNdf/skaI05lfzEK967xJCVf/b97NHdVd434wfVdm0/d3lj3NtC5A5Ooka7lQ4snPOKI4XDQDemdXA3eHGMuvXrRT1y/9Qa/0XnZvWir3kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708986326; c=relaxed/simple;
	bh=GKbZGjSYYVpzX7PsRODxmmN+izc8X2grdbnmRCL90lU=;
	h=Date:To:From:Subject:Message-Id; b=V+8JMXnHLobD/UrFeqg46l0mVeawATyWWZNjTTdA1iIoHPnGIFHOieeEspATXCDVz6YzOoMjnoa9jWNruGy/qCgDc9zlYbzeM3FMd+a8a0Yb7WzEUj7cqana4WmWFjS7b99/iJl5qKgmF5VNk/8Dm+c8bgdPLrJcNqcMjPvs8uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uSDAytO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uSDAytO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C580C43601;
	Mon, 26 Feb 2024 22:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708986326;
	bh=GKbZGjSYYVpzX7PsRODxmmN+izc8X2grdbnmRCL90lU=;
	h=Date:To:From:Subject:From;
	b=uSDAytO49CQBqa5snolyAiNUsebN7gPxKDSCwqnAT8RjWJgQagtI/JhBmIfOCCznx
	 YHpSTyZDO1rVXODU6eTOi95J0NFDtTchQLfuJ9vWKHB5CiYWl5W4uDKpI1jzuBqMfB
	 kNomGuUbAuw+7P3yRIVe/s/dErN/pUPvnnzLo3Dw=
Date: Mon, 26 Feb 2024 14:25:25 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yuzhao@google.com,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-order-1-folios-in-the-page-cache.patch added to mm-unstable branch
Message-Id: <20240226222526.1C580C43601@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support order-1 folios in the page cache
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-order-1-folios-in-the-page-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-order-1-folios-in-the-page-cache.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: support order-1 folios in the page cache
Date: Mon, 26 Feb 2024 15:55:28 -0500

Folios of order 1 have no space to store the deferred list.  This is not a
problem for the page cache as file-backed folios are never placed on the
deferred list.  All we need to do is prevent the core MM from touching the
deferred list for order 1 folios and remove the code which prevented us
from allocating order 1 folios.

Link: https://lore.kernel.org/linux-mm/90344ea7-4eec-47ee-5996-0c22f42d6a6a@google.com/
Link: https://lkml.kernel.org/r/20240226205534.1603748-3-zi.yan@sent.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c     |    2 --
 mm/huge_memory.c |   19 +++++++++++++++----
 mm/internal.h    |    3 +--
 mm/readahead.c   |    3 ---
 4 files changed, 16 insertions(+), 11 deletions(-)

--- a/mm/filemap.c~mm-support-order-1-folios-in-the-page-cache
+++ a/mm/filemap.c
@@ -1912,8 +1912,6 @@ no_page:
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order == 1)
-				order = 0;
 			if (order > 0)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
 			folio = filemap_alloc_folio(alloc_gfp, order);
--- a/mm/huge_memory.c~mm-support-order-1-folios-in-the-page-cache
+++ a/mm/huge_memory.c
@@ -790,8 +790,10 @@ struct deferred_split *get_deferred_spli
 
 void folio_prep_large_rmappable(struct folio *folio)
 {
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
-	INIT_LIST_HEAD(&folio->_deferred_list);
+	if (!folio || !folio_test_large(folio))
+		return;
+	if (folio_order(folio) > 1)
+		INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_large_rmappable(folio);
 }
 
@@ -3114,7 +3116,8 @@ int split_huge_page_to_list(struct page
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
-		if (!list_empty(&folio->_deferred_list)) {
+		if (folio_order(folio) > 1 &&
+		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			list_del(&folio->_deferred_list);
 		}
@@ -3165,6 +3168,9 @@ void folio_undo_large_rmappable(struct f
 	struct deferred_split *ds_queue;
 	unsigned long flags;
 
+	if (folio_order(folio) <= 1)
+		return;
+
 	/*
 	 * At this point, there is no one trying to add the folio to
 	 * deferred_list. If folio is not in deferred_list, it's safe
@@ -3190,7 +3196,12 @@ void deferred_split_folio(struct folio *
 #endif
 	unsigned long flags;
 
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
+	/*
+	 * Order 1 folios have no space for a deferred list, but we also
+	 * won't waste much memory by not adding them to the deferred list.
+	 */
+	if (folio_order(folio) <= 1)
+		return;
 
 	/*
 	 * The try_to_unmap() in page reclaim path might reach here too,
--- a/mm/internal.h~mm-support-order-1-folios-in-the-page-cache
+++ a/mm/internal.h
@@ -420,8 +420,7 @@ static inline struct folio *page_rmappab
 {
 	struct folio *folio = (struct folio *)page;
 
-	if (folio && folio_order(folio) > 1)
-		folio_prep_large_rmappable(folio);
+	folio_prep_large_rmappable(folio);
 	return folio;
 }
 
--- a/mm/readahead.c~mm-support-order-1-folios-in-the-page-cache
+++ a/mm/readahead.c
@@ -514,9 +514,6 @@ void page_cache_ra_order(struct readahea
 		/* Don't allocate pages past EOF */
 		while (index + (1UL << order) - 1 > limit)
 			order--;
-		/* THP machinery does not support order-1 */
-		if (order == 1)
-			order = 0;
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch

