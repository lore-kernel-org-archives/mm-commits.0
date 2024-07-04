Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB11173448;
	Thu,  4 Jul 2024 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720118645; cv=none; b=JCmwO5vmK9gpGILSyEIfjUsezP2IE8k7x8ZSdypkPXCgy7ot7iMRbv7OXpf8l29DlzkNedWc9RwKdukHYyPNG82/9jEfHKttlTWJ0V2PXXVx8639/6Kat1cmjV74jR0uOGXwnV+Pd5lCrDOUYn54gofKb1qFLqlvDWZaBz931uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720118645; c=relaxed/simple;
	bh=r49hmGx633SdpXbLnwpR2+M1sg4c4srNN+hBIO7Ucd4=;
	h=Date:To:From:Subject:Message-Id; b=mCX7WDOmLeZaeX5N3CcZW30EGaB/zdVBdu0WVV+1m3oUR+55CU7SdSkgCrCm3RAlSJHihlTzrjT+C7JSY1LOQ3DFr7zXJ0byTcoBxAsY2U4AEouW32UldVLaNth1RSOuVEjunHdb85ZgVa3EztuiRkuzekPzYmfDeOkdP4WFA0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C4gU441C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C4gU441C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED03C4AF0A;
	Thu,  4 Jul 2024 18:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720118645;
	bh=r49hmGx633SdpXbLnwpR2+M1sg4c4srNN+hBIO7Ucd4=;
	h=Date:To:From:Subject:From;
	b=C4gU441CRVHX6PxMC7r3BJ1jl7y35zBBByOmCQU+VrEdpkPuN5/gHVk0V7mA3mXcq
	 J/disUcETMa95oAvAR7PUt7IhLNdimNGDVkXngBSs2p/HF18WZnz0ElsWg9XZ8ntOE
	 3V7b8C7Vwsp0sVoRovMZc2hYddX0+rrDf0hnQYa8=
Date: Thu, 04 Jul 2024 11:44:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,aneesh.kumar@linux.ibm.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch added to mm-hotfixes-unstable branch
Message-Id: <20240704184405.4ED03C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: clear the LRU flag of a page before adding to LRU batch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch

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
From: yangge <yangge1116@126.com>
Subject: mm/gup: clear the LRU flag of a page before adding to LRU batch
Date: Wed, 3 Jul 2024 20:02:33 +0800

If a large number of CMA memory are configured in system (for example,
the CMA memory accounts for 50% of the system memory), starting a
virtual virtual machine with device passthrough, it will call
pin_user_pages_remote(..., FOLL_LONGTERM, ...) to pin memory.  Normally
if a page is present and in CMA area, pin_user_pages_remote() will
migrate the page from CMA area to non-CMA area because of FOLL_LONGTERM
flag.  But the current code will cause the migration failure due to
unexpected page refcounts, and eventually cause the virtual machine
fail to start.

If a page is added in LRU batch, its refcount increases one, remove the
page from LRU batch decreases one.  Page migration requires the page is
not referenced by others except page mapping.  Before migrating a page,
we should try to drain the page from LRU batch in case the page is in
it, however, folio_test_lru() is not sufficient to tell whether the
page is in LRU batch or not, if the page is in LRU batch, the migration
will fail.

To solve the problem above, we modify the logic of adding to LRU batch.
Before adding a page to LRU batch, we clear the LRU flag of the page
so that we can check whether the page is in LRU batch by
folio_test_lru(page).  It's quite valuable, because likely we don't
want to blindly drain the LRU batch simply because there is some
unexpected reference on a page, as described above.

This change makes the LRU flag of a page invisible for longer, which
may impact some programs.  For example, as long as a page is on a LRU
batch, we cannot isolate it, and we cannot check if it's an LRU page. 
Further, a page can now only be on exactly one LRU batch.  This doesn't
seem to matter much, because a new page is allocated from buddy and
added to the lru batch, or be isolated, it's LRU flag may also be
invisible for a long time.

Link: https://lkml.kernel.org/r/1720075944-27201-1-git-send-email-yangge1116@126.com
Link: https://lkml.kernel.org/r/1720008153-16035-1-git-send-email-yangge1116@126.com
Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
Signed-off-by: yangge <yangge1116@126.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

--- a/mm/swap.c~mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch
+++ a/mm/swap.c
@@ -212,10 +212,6 @@ static void folio_batch_move_lru(struct
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		/* block memcg migration while the folio moves between lru */
-		if (move_fn != lru_add_fn && !folio_test_clear_lru(folio))
-			continue;
-
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
@@ -256,11 +252,16 @@ static void lru_move_tail_fn(struct lruv
 void folio_rotate_reclaimable(struct folio *folio)
 {
 	if (!folio_test_locked(folio) && !folio_test_dirty(folio) &&
-	    !folio_test_unevictable(folio) && folio_test_lru(folio)) {
+	    !folio_test_unevictable(folio)) {
 		struct folio_batch *fbatch;
 		unsigned long flags;
 
 		folio_get(folio);
+		if (!folio_test_clear_lru(folio)) {
+			folio_put(folio);
+			return;
+		}
+
 		local_lock_irqsave(&lru_rotate.lock, flags);
 		fbatch = this_cpu_ptr(&lru_rotate.fbatch);
 		folio_batch_add_and_move(fbatch, folio, lru_move_tail_fn);
@@ -353,11 +354,15 @@ static void folio_activate_drain(int cpu
 
 void folio_activate(struct folio *folio)
 {
-	if (folio_test_lru(folio) && !folio_test_active(folio) &&
-	    !folio_test_unevictable(folio)) {
+	if (!folio_test_active(folio) && !folio_test_unevictable(folio)) {
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
+		if (!folio_test_clear_lru(folio)) {
+			folio_put(folio);
+			return;
+		}
+
 		local_lock(&cpu_fbatches.lock);
 		fbatch = this_cpu_ptr(&cpu_fbatches.activate);
 		folio_batch_add_and_move(fbatch, folio, folio_activate_fn);
@@ -701,6 +706,11 @@ void deactivate_file_folio(struct folio
 		return;
 
 	folio_get(folio);
+	if (!folio_test_clear_lru(folio)) {
+		folio_put(folio);
+		return;
+	}
+
 	local_lock(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate_file);
 	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file_fn);
@@ -717,11 +727,16 @@ void deactivate_file_folio(struct folio
  */
 void folio_deactivate(struct folio *folio)
 {
-	if (folio_test_lru(folio) && !folio_test_unevictable(folio) &&
-	    (folio_test_active(folio) || lru_gen_enabled())) {
+	if (!folio_test_unevictable(folio) && (folio_test_active(folio) ||
+	    lru_gen_enabled())) {
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
+		if (!folio_test_clear_lru(folio)) {
+			folio_put(folio);
+			return;
+		}
+
 		local_lock(&cpu_fbatches.lock);
 		fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate);
 		folio_batch_add_and_move(fbatch, folio, lru_deactivate_fn);
@@ -738,12 +753,16 @@ void folio_deactivate(struct folio *foli
  */
 void folio_mark_lazyfree(struct folio *folio)
 {
-	if (folio_test_lru(folio) && folio_test_anon(folio) &&
-	    folio_test_swapbacked(folio) && !folio_test_swapcache(folio) &&
-	    !folio_test_unevictable(folio)) {
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+	    !folio_test_swapcache(folio) && !folio_test_unevictable(folio)) {
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
+		if (!folio_test_clear_lru(folio)) {
+			folio_put(folio);
+			return;
+		}
+
 		local_lock(&cpu_fbatches.lock);
 		fbatch = this_cpu_ptr(&cpu_fbatches.lru_lazyfree);
 		folio_batch_add_and_move(fbatch, folio, lru_lazyfree_fn);
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch

