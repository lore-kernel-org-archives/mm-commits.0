Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EFE21E3C3
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 23:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033554; cv=none; b=fZHpFtY2FqBogkN49EBZGGR6tDaNa5raPk4dZ2jaxOj0xh4ub6hCi44A0yO4mnBibXX6AwU73w5R9qtXq1SaO5wXHBf/iTMOKV7I1oSUbn0835BfL6psKrAPm45IGqNkn2dJTPWk4jmvamFinqmnl39hMPKPkDIYg3IXpfJsud8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033554; c=relaxed/simple;
	bh=/zJGvDii0ECqcIi5wNd3LLXIdIJlcrPLo3Y9jPdCZU8=;
	h=Date:To:From:Subject:Message-Id; b=lJNJ7LMDZm3UT78YJIWKj/YNYNETku7TdMZUDrpmjPqLY/lF6lq6jVaJiX6NFXh65XnbcwZfwm8Jlnyy7909pFVMWOc5G0JSb9/O3gf5sbgP2UNFI+osL3iFkMBkvsVEsoNFB80ETucsx/hikBCoRsyZuqYx0fSOBvC9rU7bL1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PI06t7Nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PI06t7Nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05119C4CECE;
	Tue, 15 Oct 2024 23:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729033554;
	bh=/zJGvDii0ECqcIi5wNd3LLXIdIJlcrPLo3Y9jPdCZU8=;
	h=Date:To:From:Subject:From;
	b=PI06t7Nm/eAJXbDJbPWgZ9vHsdt/fpmvWXtpkBNN8Fj/VenPTyWFZl5C+yfylENEE
	 IprU3jx6WqdmKnKAVoPQ8gau1HTW3YuiWMD0ABZmTS//YFR7JYsxn2H+X1nYVBXpi2
	 QL0Zi/j8iD6Nh3d9vBFBMdsjBKJazZzv0t3gf4Ao=
Date: Tue, 15 Oct 2024 16:05:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@kernel.org,mgorman@techsingularity.net,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20241015230554.05119C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: Let GFP_ATOMIC order-0 allocs access highatomic reserves
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2.patch

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
From: Matt Fleming <mfleming@cloudflare.com>
Subject: mm/page_alloc: Let GFP_ATOMIC order-0 allocs access highatomic reserves
Date: Tue, 15 Oct 2024 13:51:58 +0100

update comment

Link: https://lkml.kernel.org/r/20241015125158.3597702-1-matt@readmodwrite.com
Link: https://lore.kernel.org/all/CAGis_TWzSu=P7QJmjD58WWiu3zjMTVKSzdOwWE8ORaGytzWJwQ@mail.gmail.com/
Fixes: 1d91df85f399 ("mm/page_alloc: handle a missing case for memalloc_nocma_{save/restore} APIs")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2
+++ a/mm/page_alloc.c
@@ -2893,10 +2893,10 @@ struct page *rmqueue_buddy(struct zone *
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
 
 			/*
-			 * If the allocation fails, allow OOM handling access
-			 * to HIGHATOMIC reserves as failing now is worse than
-			 * failing a high-order atomic allocation in the
-			 * future.
+			 * If the allocation fails, allow OOM handling and
+			 * order-0 (atomic) allocs access to HIGHATOMIC
+			 * reserves as failing now is worse than failing a
+			 * high-order atomic allocation in the future.
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
_

Patches currently in -mm which might be from mfleming@cloudflare.com are

mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves.patch
mm-page_alloc-let-gfp_atomic-order-0-allocs-access-highatomic-reserves-v2.patch

