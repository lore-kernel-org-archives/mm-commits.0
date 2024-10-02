Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0052215F7B
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 20:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727902521; cv=none; b=DVA5YaCHgrDUWYS31tJ/u5RKXpu8314YWVq4qOBk823acBYQbZP7izd+Y43CvhAbIZwyiWUcYu8rBP9EnAMFAkHWPZZLNVkXICg1b8zSCknzc4MITOMLgkyNISBHC9ctvpUovWM//KSdEHdQvIeDawhzL5oD78OpznKsZ4grC00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727902521; c=relaxed/simple;
	bh=shDsyZuB/khyBNaBpr3s/ipleP0iUDKGaBxkljsDAIk=;
	h=Date:To:From:Subject:Message-Id; b=KFV6TQcNPCiD0gBD1q5vha2M8LZGmjML6XaZkDtsi/imKm9i2fCN9VtR5LEUOxybLEcsNIjkzYNfoRLM/VVmBA4HWotkV5h+vRRJuzprxU5ywh+njUqjbbqPBG3jiPpOHZke+6iXOVlMpvPPdO8bjDtusLmzo8fBVcOEg8x9FHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nR644pT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nR644pT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFBDC4CEC2;
	Wed,  2 Oct 2024 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727902520;
	bh=shDsyZuB/khyBNaBpr3s/ipleP0iUDKGaBxkljsDAIk=;
	h=Date:To:From:Subject:From;
	b=nR644pT41KPVu4ABY+z+J+ej49ranwY3kHw4Tx3A7ID8GhG503Ok18TSPy4wES6RL
	 wWZd15PoVZBQ4wnWnL10HyK3Py3n/kTuFEdIQQEilVDvRiIhyGJUWDdz1TAHxB1F6i
	 aK1He6n4YfycfIiypCAjVix1A8I3ulIDSU9x9OGU=
Date: Wed, 02 Oct 2024 13:55:19 -0700
To: mm-commits@vger.kernel.org,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-use-a-folio-in-try_to_merge_one_page.patch added to mm-unstable branch
Message-Id: <20241002205520.8EFBDC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: use a folio in try_to_merge_one_page()
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-use-a-folio-in-try_to_merge_one_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-use-a-folio-in-try_to_merge_one_page.patch

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
Subject: ksm: use a folio in try_to_merge_one_page()
Date: Wed, 2 Oct 2024 16:25:27 +0100

Patch series "Remove PageKsm()".

The KSM flag is almost always tested on the folio rather than on the page.
This series removes the final users of PageKsm() and makes the flag only


This patch (of 5):

It is safe to use a folio here because all callers took a refcount on this
page.  The one wrinkle is that we have to recalculate the value of folio
after splitting the page, since it has probably changed.  Replaces nine
calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20241002152533.1350629-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20241002152533.1350629-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/ksm.c~ksm-use-a-folio-in-try_to_merge_one_page
+++ a/mm/ksm.c
@@ -1442,28 +1442,29 @@ out:
 static int try_to_merge_one_page(struct vm_area_struct *vma,
 				 struct page *page, struct page *kpage)
 {
+	struct folio *folio = page_folio(page);
 	pte_t orig_pte = __pte(0);
 	int err = -EFAULT;
 
 	if (page == kpage)			/* ksm page forked */
 		return 0;
 
-	if (!PageAnon(page))
+	if (!folio_test_anon(folio))
 		goto out;
 
 	/*
 	 * We need the folio lock to read a stable swapcache flag in
-	 * write_protect_page().  We use trylock_page() instead of
-	 * lock_page() because we don't want to wait here - we
-	 * prefer to continue scanning and merging different pages,
-	 * then come back to this page when it is unlocked.
+	 * write_protect_page().  We trylock because we don't want to wait
+	 * here - we prefer to continue scanning and merging different
+	 * pages, then come back to this page when it is unlocked.
 	 */
-	if (!trylock_page(page))
+	if (!folio_trylock(folio))
 		goto out;
 
-	if (PageTransCompound(page)) {
+	if (folio_test_large(folio)) {
 		if (split_huge_page(page))
 			goto out_unlock;
+		folio = page_folio(page);
 	}
 
 	/*
@@ -1472,28 +1473,28 @@ static int try_to_merge_one_page(struct
 	 * ptes are necessarily already write-protected.  But in either
 	 * case, we need to lock and check page_count is not raised.
 	 */
-	if (write_protect_page(vma, page_folio(page), &orig_pte) == 0) {
+	if (write_protect_page(vma, folio, &orig_pte) == 0) {
 		if (!kpage) {
 			/*
-			 * While we hold page lock, upgrade page from
-			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
+			 * While we hold folio lock, upgrade folio from
+			 * anon to a NULL stable_node with the KSM flag set:
 			 * stable_tree_insert() will update stable_node.
 			 */
-			folio_set_stable_node(page_folio(page), NULL);
-			mark_page_accessed(page);
+			folio_set_stable_node(folio, NULL);
+			folio_mark_accessed(folio);
 			/*
-			 * Page reclaim just frees a clean page with no dirty
+			 * Page reclaim just frees a clean folio with no dirty
 			 * ptes: make sure that the ksm page would be swapped.
 			 */
-			if (!PageDirty(page))
-				SetPageDirty(page);
+			if (!folio_test_dirty(folio))
+				folio_mark_dirty(folio);
 			err = 0;
 		} else if (pages_identical(page, kpage))
 			err = replace_page(vma, page, kpage, orig_pte);
 	}
 
 out_unlock:
-	unlock_page(page);
+	folio_unlock(folio);
 out:
 	return err;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-remove-pageksm.patch

