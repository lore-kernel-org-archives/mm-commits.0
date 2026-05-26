Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62E318EE2
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 20:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779826526; cv=none; b=SEv/Aldjf1U6pBAbKcQzMUnNzDRlb6RTQk3IjSGyomFlkUptdOf7677354gTRCMBbNadxnv3RAEjIaF6sinzoYDd3u8hNVd6HysYi1N7JhpY3bHFU/jue9d1BgQY80+xxbyK0m4dyU7/8UHLGzFt3lnWDVy5AzBv5lAsg0YrreM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779826526; c=relaxed/simple;
	bh=Wirds/06H8fgTlPBtOHZ696+v/kaen9z7ZZPHD6Jr7c=;
	h=Date:To:From:Subject:Message-Id; b=PUwB8HzzebZQumpGlzgYAJEkUPrbDjHtyQisQyNsUqyaUBI/Ad76zQOb4oAYDyxUGphY93Y6kYmKkjQUFckuqa0yyAHknjC8Q+597AevTg/oRq+ZCYPW5WwADghKUX6nFveewpKS8T/8Ze5UPPUB1Hy6xu/KugO6MhiFRu6ADc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H5VteAA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H5VteAA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D971F000E9;
	Tue, 26 May 2026 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779826524;
	bh=cllDD94vcr9QBxRiDvbIEgDXei1UlNZ2qoGLsuRj1Yk=;
	h=Date:To:From:Subject;
	b=H5VteAA+ndxpKtX0spbx3IEdCStisyCklIkic5zutSmfBDbjz6TTpHJKcwFMlCNJr
	 oESkowkoCGunm20p8PAxs66dgnzkMZN2cuycetMDSrgHASIKnRf1f4RVck/BEDaxRY
	 CLzV7juxh0p3Sse54XTW3upeN8kcsRcHk2c9wYRc=
Date: Tue, 26 May 2026 13:15:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-mentions-of-pagewriteback.patch added to mm-new branch
Message-Id: <20260526201524.64D971F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove mentions of PageWriteback
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-mentions-of-pagewriteback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-mentions-of-pagewriteback.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-remove-mentions-of-pagewriteback.patch
mm-document-the-folio-refcount-a-little-better.patch

