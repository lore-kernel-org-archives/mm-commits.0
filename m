Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671CC13D897
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 23:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741303841; cv=none; b=tmzaD8RqzfnafxcLZga4cR3aBatRtIHu0kXtQOYFW3DIDc7KmnKlNzmOsdRzbtBlFua7mCnyc6wONwOFR4HqxJggDyXO4hF0qUqIi7EA8UCuiDfD8pNPyVDotl1uLfJF+dVUXNuhBBZimIKJ8uQeyp1lVNRWLA1Atjrid0uSB6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741303841; c=relaxed/simple;
	bh=UWJ+40M6k5rgECMay+GN9QbV2NG26d52cnsC7TT1o1Q=;
	h=Date:To:From:Subject:Message-Id; b=m08fNfllC2SpC94agzVQ8lgJAqDk5nZC7Q1N7fSRCET4xmBdCgTP4zPkABAmYGqpaOHo8jJVtA4MdUClJF04cr/gXlCeO2LQ7Vpb91lGvAhW6HjuzCWlvXe/NX3kwKRMye8swxTGH8/Z8mnudcaxf69hvkSxncPfqE/X0UVqAyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aXdYkORV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aXdYkORV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEFCC4CEE0;
	Thu,  6 Mar 2025 23:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741303840;
	bh=UWJ+40M6k5rgECMay+GN9QbV2NG26d52cnsC7TT1o1Q=;
	h=Date:To:From:Subject:From;
	b=aXdYkORVZ40xv18GLPbBg+UJqYTPLG6Tkp+qTdUSWbgP6k+7cbVmTW64VHD3+/hMp
	 nyGHqXD61Xz7P6xxM/UL/QrA2aqp9h7dTDamGSzXnbRI5FLCunh6ZRsvv3ORHvlKyT
	 ++nkcm/5xpgvTIMfcck9vAxHhvcncD+JRA4KCe7M=
Date: Thu, 06 Mar 2025 15:30:39 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,kasong@tencent.com,chrisl@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_cgroup-remove-double-initialization-of-locals.patch added to mm-unstable branch
Message-Id: <20250306233040.ABEFCC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap_cgroup: remove double initialization of locals
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_cgroup-remove-double-initialization-of-locals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_cgroup-remove-double-initialization-of-locals.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: swap_cgroup: remove double initialization of locals
Date: Thu, 6 Mar 2025 09:31:42 -0500

Fixes: 6769183166b3 ("mm/swap_cgroup: decouple swap cgroup recording and clearing")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-remove-double-initialization-of-locals
+++ a/mm/swap_cgroup.c
@@ -92,8 +92,7 @@ void swap_cgroup_record(struct folio *fo
  */
 unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
 {
-	pgoff_t offset = swp_offset(ent);
-	pgoff_t end = offset + nr_ents;
+	pgoff_t offset, end;
 	struct swap_cgroup *map;
 	unsigned short old, iter = 0;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch
mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch
mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch
mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch
mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch
mm-page_alloc-group-fallback-functions-together.patch
mm-swap_cgroup-remove-double-initialization-of-locals.patch

