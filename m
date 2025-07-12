Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C2F2236FB
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358839; cv=none; b=ftOqKPUgFOuchntT2tv0Zp3ORb7B7r8cCeZDSWUrlctTbowXp5cmaVWIdhl4q/ncMgD2AvVkT2gxo5zLqTjGyi2OQhQAcf2iDpJZ9rTzhJm90SM90IAfNhvEmoNLn8HU9MSE+Hs3msIHu8s0uYwnpw4Ui1tE/oCI2LYMxLCS4MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358839; c=relaxed/simple;
	bh=E2l5uq6TT+1Bt7BZKrDYh0sWvn/v/ihbNUW8YWRxUsg=;
	h=Date:To:From:Subject:Message-Id; b=eji+0RXb9G0oCKmcxk0UkMtEm4ooOkfYm/IeIAoDmBcU/eCnHhUBwGVdKl3Gu6079DPEm5q2EX9Mecco1MGvgWdKgYmM8r8jJBRh0W0xbs+YED4+/mTMPkkc2D4ioPwiwshEb9KVLmlTGTVRNywg+9kCVBKZ3otOWdJfXN6Ux98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TavNxQWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TavNxQWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F752C4CEEF;
	Sat, 12 Jul 2025 22:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358835;
	bh=E2l5uq6TT+1Bt7BZKrDYh0sWvn/v/ihbNUW8YWRxUsg=;
	h=Date:To:From:Subject:From;
	b=TavNxQWx4qHtKW/ckwhoL6kkE24erIibrf/RMob9d3qwn14UoFDmvcXkpAw0TKkJw
	 6uIIo0syZKHTxgHp2emajVs24ZAszbtz3ZgQw7j2lf0kneDxGaM+Iw7h3hmCa3O0w5
	 b5W6cn7msiCv8iLvTzF6oPIJOs2QxrgvMm0J0iZo=
Date: Sat, 12 Jul 2025 15:20:34 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch added to mm-new branch
Message-Id: <20250712222035.1F752C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: use folio_expected_ref_count() to calculate ref_count.
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: use folio_expected_ref_count() to calculate ref_count.
Date: Fri, 11 Jul 2025 14:23:55 -0400

Instead of open coding the ref_count calculation, use
folio_expected_ref_count().

Link: https://lkml.kernel.org/r/20250711182355.3592618-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count
+++ a/mm/huge_memory.c
@@ -3728,6 +3728,7 @@ static int __folio_split(struct folio *f
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
 		struct address_space *swap_cache = NULL;
 		struct lruvec *lruvec;
+		int expected_refs;
 
 		if (folio_order(folio) > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
@@ -3798,11 +3799,8 @@ static int __folio_split(struct folio *f
 		     new_folio = next) {
 			next = folio_next(new_folio);
 
-			folio_ref_unfreeze(
-				new_folio,
-				1 + ((mapping || swap_cache) ?
-					     folio_nr_pages(new_folio) :
-					     0));
+			expected_refs = folio_expected_ref_count(new_folio) + 1;
+			folio_ref_unfreeze(new_folio, expected_refs);
 
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -3832,8 +3830,8 @@ static int __folio_split(struct folio *f
 		 * Otherwise, a parallel folio_try_get() can grab origin_folio
 		 * and its caller can see stale page cache entries.
 		 */
-		folio_ref_unfreeze(folio, 1 +
-			((mapping || swap_cache) ? folio_nr_pages(folio) : 0));
+		expected_refs = folio_expected_ref_count(folio) + 1;
+		folio_ref_unfreeze(folio, expected_refs);
 
 		unlock_page_lruvec(lruvec);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-split_huge_page_test-for-folio_split-tests.patch
mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch
mm-huge_memory-move-unrelated-code-out-of-__split_unmapped_folio.patch
mm-huge_memory-use-folio_expected_ref_count-to-calculate-ref_count.patch

