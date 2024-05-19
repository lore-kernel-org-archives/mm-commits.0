Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A46335C7
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 23:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716162016; cv=none; b=ntJSKETacZUHTolakJVz9g87Chzm5PX7lOx0ezFFn1B3ntlc3Ppi2MD2D7HA7aS+NJai0stZTbTSJ74ae7Yo12bujTM3OZRd2gx5CQT0+ZEaYoeMGAjqZUvsRTSMHwfAPPv1DMknLI4yzYYyQINM2EkOIyB3BrZKVPPbkZmg9vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716162016; c=relaxed/simple;
	bh=Enj4x818OJQOU+shpc1/kGfHDmHLEplAI3yRBoCLAxQ=;
	h=Date:To:From:Subject:Message-Id; b=niaHA9acUN8J6GC4yb11Uo+ZbaGbRWI5YFjdPI+6JFx26rn4qNhSh9gGozWQwRjnl35Rnam8I3nxyY0DMEgrWDWUYvaOpZXHNJRL7FQgi+ueKHIjvtChedSh8LTwYkTbQhzt48TwmD8hncSwzBP9iRpsV7swK9/3uGmdlEAbhjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wXk359JT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wXk359JT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF93C32781;
	Sun, 19 May 2024 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716162015;
	bh=Enj4x818OJQOU+shpc1/kGfHDmHLEplAI3yRBoCLAxQ=;
	h=Date:To:From:Subject:From;
	b=wXk359JTtmS6rVrW3pN/Idx2+z6CBlaJHHD4aBc8W6y8H3ppJg1NdUwaiqlW4xWZe
	 sdMER/LJ5wnLuWxYdofz283l72mcXtP9geeS4IdzJnJtGG22UEitvvQ48Fcn5o8s/Y
	 KcMxQ334f5z8mKOH/9EFo2/7j041Rtj1J1XGZZ/s=
Date: Sun, 19 May 2024 16:40:15 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,peterx@redhat.com,muchun.song@linux.dev,anshuman.khandual@arm.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch added to mm-unstable branch
Message-Id: <20240519234015.BFF93C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: drop node_alloc_noretry from alloc_fresh_hugetlb_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm/hugetlb: drop node_alloc_noretry from alloc_fresh_hugetlb_folio
Date: Thu, 16 May 2024 10:10:35 +0200

Since commit d67e32f26713 ("hugetlb: restructure pool allocations"), the
parameter node_alloc_noretry from alloc_fresh_hugetlb_folio() is not used,
so drop it.

Link: https://lkml.kernel.org/r/20240516081035.5651-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -2289,13 +2289,11 @@ static struct folio *only_alloc_fresh_hu
  * pages is zero.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+		gfp_t gfp_mask, int nid, nodemask_t *nmask)
 {
 	struct folio *folio;
 
-	folio = __alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask,
-						node_alloc_noretry);
+	folio = __alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
 	if (!folio)
 		return NULL;
 
@@ -2513,7 +2511,7 @@ static struct folio *alloc_surplus_huget
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
 	if (!folio)
 		return NULL;
 
@@ -2549,7 +2547,7 @@ static struct folio *alloc_migrate_huget
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
 	if (!folio)
 		return NULL;
 
@@ -3474,7 +3472,7 @@ static void __init hugetlb_hstate_alloc_
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 			folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-					&node_states[N_MEMORY], NULL);
+					&node_states[N_MEMORY]);
 			if (!folio)
 				break;
 			free_huge_folio(folio); /* free it into the hugepage allocator */
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-hugetlb-drop-node_alloc_noretry-from-alloc_fresh_hugetlb_folio.patch

