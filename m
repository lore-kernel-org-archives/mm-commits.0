Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D90A2F50
	for <mm-commits@vger.kernel.org>; Thu, 13 Jun 2024 21:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718312462; cv=none; b=RRb9imgqnu11DW7fRvoNlJH9BdpAThjv4fFp9k0sbnG+Sq+p2sf5Mfzuqo5DzP384LMPYj4DEtxVYoUrZuspHqFkLXXX0a2n1UmIaK1A9s4C9Qddmlus3K0O+sdqumgVs/vNCwcbbO+oZS51WgD4n0VrLt2o3D/7t3UOTV4udKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718312462; c=relaxed/simple;
	bh=T4Oi25g4aJBDdvNJVpiCLbKcdw5ENR/6gB4nP14IPro=;
	h=Date:To:From:Subject:Message-Id; b=Or0vRy7bEd98AActhE4d5tjU9doou0rnSGcPFQvEhZ+GBWpohE87SgKEXm02eRS+dvknI5wi0Gz0qYRISKAZprhsVXLBslvxydDqbjbMCUNGAeunZo8YQR3a5CtasN+uubIV5LGeZ+9g9I+xZaXyuVYYBGeHD6sDmRbXhcSvUh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lHV+wCjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lHV+wCjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665C4C2BBFC;
	Thu, 13 Jun 2024 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718312462;
	bh=T4Oi25g4aJBDdvNJVpiCLbKcdw5ENR/6gB4nP14IPro=;
	h=Date:To:From:Subject:From;
	b=lHV+wCjJbtW/4guWC5h7yuPfGgv0qVDVZwhnia4vRBjakENc8aIIaUu9aViIVHhzI
	 P7smnNRmA5oDV4S0x2ObWKD4o5sRfBxUuq+id1xVPQwqhfu4om+9pHzOGcJ2U6UnIN
	 UeLZbcZkDpKtTaJyknfObygbyne/iiJF2sqOSTy0=
Date: Thu, 13 Jun 2024 14:01:01 -0700
To: mm-commits@vger.kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch added to mm-unstable branch
Message-Id: <20240613210102.665C4C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
Date: Thu, 13 Jun 2024 15:28:58 +0800

fix bug:
https://lore.kernel.org/linux-mm/20240613065521.15960-1-ioworker0@gmail.com/

Link: https://lkml.kernel.org/r/20240613072858.16512-1-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++-------
 mm/rmap.c        |    7 +------
 2 files changed, 4 insertions(+), 13 deletions(-)

--- a/mm/huge_memory.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
+++ a/mm/huge_memory.c
@@ -2707,10 +2707,8 @@ static bool __discard_anon_folio_pmd_loc
 	if (unlikely(page_folio(page) != folio))
 		return false;
 
-	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd)) {
-		folio_set_swapbacked(folio);
+	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
 		return false;
-	}
 
 	orig_pmd = pmdp_huge_clear_flush(vma, addr, pmdp);
 
@@ -2737,10 +2735,8 @@ static bool __discard_anon_folio_pmd_loc
 	 *
 	 * The only folio refs must be one from isolation plus the rmap(s).
 	 */
-	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd))
-		folio_set_swapbacked(folio);
-
-	if (folio_test_swapbacked(folio) || ref_count != map_count + 1) {
+	if (folio_test_dirty(folio) || pmd_dirty(orig_pmd) ||
+	    ref_count != map_count + 1) {
 		set_pmd_at(mm, addr, pmdp, orig_pmd);
 		return false;
 	}
--- a/mm/rmap.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix
+++ a/mm/rmap.c
@@ -1824,12 +1824,7 @@ static bool try_to_unmap_one(struct foli
 			 */
 			if (unlikely(folio_test_swapbacked(folio) !=
 					folio_test_swapcache(folio))) {
-				/*
-				 * unmap_huge_pmd_locked() will unmark a
-				 * PMD-mapped folio as lazyfree if the folio or
-				 * its PMD was redirtied.
-				 */
-				WARN_ON_ONCE(!pmd_mapped);
+				WARN_ON_ONCE(1);
 				goto walk_done_err;
 			}
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch
mm-rmap-add-helper-to-restart-pgtable-walk-on-changes.patch
mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list-fix.patch
mm-mlock-implement-folio_mlock_step-using-folio_pte_batch.patch

