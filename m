Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3209931E83B
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334325; cv=none; b=FuAYLySSePiDUlUqHKbrlrfbw0GuHil52lUuR1zCcpjcyQTjMKkpzyTAlPOteNUBYCQUFQvonQujNTC/hSRTt+E7QLl6CZL2rID7E2VZCW27mcsKIzXCPDM5uxJw6fQ6PI58i0HaEhyjsWpSRCW4fVPx1vIwsZowSdL/wgei15M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334325; c=relaxed/simple;
	bh=YGGq2/THsg7B3FJ8IhRqFRz57aUMwbi/cR+VM/NPejU=;
	h=Date:To:From:Subject:Message-Id; b=ab305H1zWVeSTw8UF0wF+n6w1/dc2qKERqFFyyTBa5ByWjCM0cR9gINex+V+IAxfxft1CvhNfuLZhDr5d0JfXrIFSACQ+akCFov+DFOn60C4BBtDk+MAaMUgmSMDggExj3QUAUHMN+MQsmQ46sFNRG6dEUeuOn9YV+Zr5hnpFMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fjb/UJvz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fjb/UJvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101921F0089B;
	Wed,  7 Oct 2026 00:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334323;
	bh=h4lD48GZaG4miD80zt5NjW4frfqGHxuNYZZf4soJULs=;
	h=Date:To:From:Subject;
	b=Fjb/UJvzb/fxeSye6s7JuFMouXqaMBxlaVSXN+0TwnTrCPWtV8zcl4e710PIL16Da
	 My9ka3EFoSEF6rwbZRPkd11ZrfaACyQ1xsLHgS/v9Wu5UCQvnbglKyzFJLz1va0FTP
	 kfbuHbqrRrP8HYCaTe2XVlRRIY3gHvMTu5IFUTrU=
Date: Tue, 06 Oct 2026 17:52:02 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,aris@ruivo.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-move-pmd_protnone-into-gup_fast_pmd_leaf.patch removed from -mm tree
Message-Id: <20261007005203.101921F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
has been removed from the -mm tree.  Its filename was
     mm-gup-move-pmd_protnone-into-gup_fast_pmd_leaf.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
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


