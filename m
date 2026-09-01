Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0202399369
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 04:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788236432; cv=none; b=JyyvvpFs5fiWz155Q61/Mpsbgp93VTA4DlFv7MBNzdCv2Toaqpo45wpXBgarCFm/LfDeqvSkW1dfDfD54+14YDHXogSqkroPik3k6WavWrmgO9XRrh8u5uFxvAa6mMgZwUetF9IFrvT9YKiLEDB+8XahkUr7CzxmGxepm+C0j3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788236432; c=relaxed/simple;
	bh=zh0GOwYQaecDw498iUU8hMP00jPxSjEYJKg4Je94YxY=;
	h=Date:To:From:Subject:Message-Id; b=PANQolDzRSSN50iPQ97Hyk6tKWG9huws71pzNoSCkf4TvkOIvGD4xg04KyxJFMYsOJA/gnCTzTDlgKgqQ+2QqNmLES3QG+snlU9QqjJ5MMtFSyULzn1/XdJL1VTqQ/9FdsMkM7Wtd6ZjcT4Slye9Gx0KBEUfnfawK61/aZ+OUqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=McwbDFkv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="McwbDFkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5B81F000E9;
	Tue,  1 Sep 2026 04:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788236431;
	bh=oBzuna+O8TZ4zREF6NrnBHkoKtu/bhdI7L5UEGRmsOc=;
	h=Date:To:From:Subject;
	b=McwbDFkvUGubeJQwijuJW3MqjUfFLRLw+cLZgCaGoipRbxLd9gfJKK1lY2RsQPzUA
	 evOoKLfyZbki2TonEuetm26uIcsRSZyUk8Imw7CHetLu5OYv+pzsc+N5qJuxdiVNAT
	 P3c9TVPs+O+t6plMYumD+cFC92B4PHKSFt1kqiig=
Date: Mon, 31 Aug 2026 21:20:30 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,aris@ruivo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-move-pmd_protnone-into-gup_fast_pmd_leaf.patch added to mm-new branch
Message-Id: <20260901042031.3C5B81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-move-pmd_protnone-into-gup_fast_pmd_leaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-move-pmd_protnone-into-gup_fast_pmd_leaf.patch

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
From: Aristeu Rozanski <aris@ruivo.org>
Subject: mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
Date: Thu, 27 Aug 2026 21:55:43 -0400

Patch series "mm: gup: cleanup gup_fast call chain", v3.

These two patches implement the refactor in gup_fast call chain David
Hildenbrand mentioned in [1].


This patch (of 2):	

Make pmd handling match pud handling by calling pmd_protnone() inside
gup_fast_pmd_leaf().

Link: https://lore.kernel.org/20260828015542.125576330@ruivo.org
Link: https://lore.kernel.org/20260828015542.245315718@ruivo.org
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u [1]
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-move-pmd_protnone-into-gup_fast_pmd_leaf
+++ a/mm/gup.c
@@ -2929,6 +2929,10 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 	struct folio *folio;
 	int refs;
 
+	/* See gup_fast_pte_range() */
+	if (pmd_protnone(orig))
+		return 0;
+
 	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
@@ -3024,10 +3028,6 @@ static int gup_fast_pmd_range(pud_t *pud
 			return 0;
 
 		if (unlikely(pmd_leaf(pmd))) {
-			/* See gup_fast_pte_range() */
-			if (pmd_protnone(pmd))
-				return 0;
-
 			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
 				pages, nr))
 				return 0;
_

Patches currently in -mm which might be from aris@ruivo.org are

mm-gup-move-pmd_protnone-into-gup_fast_pmd_leaf.patch
mm-gup-cleanup-the-gup_fast_-call-chain.patch

