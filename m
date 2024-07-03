Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3411836D0;
	Wed,  3 Jul 2024 20:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720037334; cv=none; b=BXEOHaiP5dqe+B/lBj8PxrDovIZtUqjoX8sOn7dp8/ZOVfXTCuNQ3+VvBWecWvK/ajTGzeUS2uAcDIHl6kQm6uq/AHdNAQ8cAzew9Ymc4DljZgjMTU01e8HoJIR0jBC41nHXj47f2Bg+bvO2gEUR+O6HYQyfhLioEeLTmcpGgMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720037334; c=relaxed/simple;
	bh=DVox1BhYmlVSGINFvKZZZongePGMtgf0FVx0De/8DsA=;
	h=Date:To:From:Subject:Message-Id; b=sa2t+iJ/uhKwoaFOnoSnUCByJobw2gv1x4NOyluvf2ATfmm5SYs3SN57v8MFFCDLWbji1tHNGBqCB+629n9TToX6KIilQ3WBmRYnHVD26/YmnZkgO1BqH7XU14Qtdlz16haEOdjpNYYAvztpA7aJMYpR2tCfncYko0VmqAybtm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aPnTg+dS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aPnTg+dS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C015AC2BD10;
	Wed,  3 Jul 2024 20:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720037333;
	bh=DVox1BhYmlVSGINFvKZZZongePGMtgf0FVx0De/8DsA=;
	h=Date:To:From:Subject:From;
	b=aPnTg+dSCrzxfRtuNW3ZwuhTWQnZrn+db6w2fLc6s+eOp8yyQUqPhooAkg19L75ep
	 9xgytRvdm0BzTeu2Z7LfUrZpsgajrd5aeOYi/IgrhZHtwcfhzqpJ8U8s2E25RviSMy
	 dVMPHHhbdX2YKW44mpQgChPeDYJfMHDUpT5USDUw=
Date: Wed, 03 Jul 2024 13:08:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,aneesh.kumar@linux.ibm.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch added to mm-hotfixes-unstable branch
Message-Id: <20240703200853.C015AC2BD10@smtp.kernel.org>
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

If a large number of CMA memory are configured in system (for example, the
CMA memory accounts for 50% of the system memory), starting a virtual
virtual machine with device passthrough, it will call
pin_user_pages_remote(..., FOLL_LONGTERM, ...) to pin memory.  Normally if
a page is present and in CMA area, pin_user_pages_remote() will migrate
the page from CMA area to non-CMA area because of FOLL_LONGTERM flag.  But
the current code will cause the migration failure due to unexpected page
refcounts, and will eventually cause the virtual machine to fail to start.

If a page is added in LRU batch, its refcount increases one, remove the
page from LRU batch decreases one.  Page migration requires the page is
not referenced by others except page mapping.  Before migrating a page, we
should try to drain the page from LRU batch in case the page is in it,
however, folio_test_lru() is not sufficient to tell whether the page is in
LRU batch or not, if the page is in LRU batch, the migration will fail.

To solve the problem above, we modify the logic of adding to LRU batch. 
Before adding a page to LRU batch, we clear the LRU flag of the page so
that we can check whether the page is in LRU batch with
folio_test_lru(page).  Seems making the LRU flag of the page invisible a
long time is no problem, because a new page is allocated from buddy and
added to the lru batch, its LRU flag is also not visible for a long time.

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

