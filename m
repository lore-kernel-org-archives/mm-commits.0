Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D563C554B
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439220; cv=none; b=q5SU8SpbeRBGAII+5nl+LnoolNE1y08rlbh/58sB9SHdJsjS63toPHCVGW3CTry3MLBURe21xlmAM82CWXZvgyWYIZwaJGAU9kBjz5EGhlGfSvrC4cseHRyfEK+tIoKqP80q/vSPtzodIKh10aBQMp5dHP2Q3v7B+hp/1gZhbD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439220; c=relaxed/simple;
	bh=6FhIailZYCJR4OGOqUJ7viLe0xZby0FYz975pf1U5bU=;
	h=Date:To:From:Subject:Message-Id; b=Yf6jIKM2z3e7gC1HWW3DZQd4r+OtpEp1SY+NtGuo0hwum6WcUlfaV2ume6MzPjWzxaPw7oSWN/b+WIGBHqCOPCxvCFZ4dJitCBHPAfHttGkSnUKqwOejAc1NM95Agh3fD8ChNFtTm6wziyshSvLXbs3+r126MBfpt/WJMyiBy8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2oiBQD1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2oiBQD1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01EA1F00893;
	Tue,  2 Jun 2026 22:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439219;
	bh=rhe++skW+JZ46kitiEVu9dtjjyPfd9eDhZc4XyPdEls=;
	h=Date:To:From:Subject;
	b=2oiBQD1po8PZ8OC09gtqiy0s6Y0UGKbT579T+8ImcVQcgltMV9dcYw2ng09XLgjuR
	 iARUInvXLh4KSNeL//MqAXHoqa9Woa4l2jnf4XcOCJ5lH3cHQSsjKhpJEpHT6M3AYG
	 tmNHt7w9vB5aHhvHaSLF71jH77HoDQHn3+cnULZk=
Date: Tue, 02 Jun 2026 15:26:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-mentions-of-pagewriteback.patch removed from -mm tree
Message-Id: <20260602222658.F01EA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove mentions of PageWriteback
has been removed from the -mm tree.  Its filename was
     mm-remove-mentions-of-pagewriteback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove mentions of PageWriteback
Date: Tue, 26 May 2026 20:56:48 +0100

Update two comments to refer to writeback in general instead of the
specific flag.  Convert the large comment in memory.c to be entirely
folio-based.

Link: https://lore.kernel.org/20260526195650.353196-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 mm/memory.c     |   20 ++++++++++----------
 mm/migrate.c    |    2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

--- a/mm/compaction.c~mm-remove-mentions-of-pagewriteback
+++ a/mm/compaction.c
@@ -1123,7 +1123,7 @@ isolate_migratepages_block(struct compac
 		 * To minimise LRU disruption, the caller can indicate with
 		 * ISOLATE_ASYNC_MIGRATE that it only wants to isolate pages
 		 * it will be able to migrate without blocking - clean pages
-		 * for the most part.  PageWriteback would require blocking.
+		 * for the most part.  Writeback would require blocking.
 		 */
 		if ((mode & ISOLATE_ASYNC_MIGRATE) && folio_test_writeback(folio))
 			goto isolate_fail_put;
--- a/mm/memory.c~mm-remove-mentions-of-pagewriteback
+++ a/mm/memory.c
@@ -5398,18 +5398,18 @@ static vm_fault_t __do_fault(struct vm_f
 	vm_fault_t ret;
 
 	/*
-	 * Preallocate pte before we take page_lock because this might lead to
-	 * deadlocks for memcg reclaim which waits for pages under writeback:
-	 *				lock_page(A)
-	 *				SetPageWriteback(A)
-	 *				unlock_page(A)
-	 * lock_page(B)
-	 *				lock_page(B)
+	 * Preallocate pte before we take folio lock because this might lead to
+	 * deadlocks for memcg reclaim which waits for folios under writeback:
+	 *				folio_lock(A)
+	 *				folio_set_writeback(A)
+	 *				folio_unlock(A)
+	 * folio_lock(B)
+	 *				folio_lock(B)
 	 * pte_alloc_one
 	 *   shrink_folio_list
-	 *     wait_on_page_writeback(A)
-	 *				SetPageWriteback(B)
-	 *				unlock_page(B)
+	 *     folio_wait_writeback(A)
+	 *				folio_set_writeback(B)
+	 *				folio_unlock(B)
 	 *				# flush A, B to clear the writeback
 	 */
 	if (pmd_none(*vmf->pmd) && !vmf->prealloc_pte) {
--- a/mm/migrate.c~mm-remove-mentions-of-pagewriteback
+++ a/mm/migrate.c
@@ -1256,7 +1256,7 @@ static int migrate_folio_unmap(new_folio
 	if (folio_test_writeback(src)) {
 		/*
 		 * Only in the case of a full synchronous migration is it
-		 * necessary to wait for PageWriteback. In the async case,
+		 * necessary to wait for writeback. In the async case,
 		 * the retry loop is too short and in the sync-light case,
 		 * the overhead of stalling is too much
 		 */
_

Patches currently in -mm which might be from willy@infradead.org are


