Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B732352921
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388566; cv=none; b=CzyA5BzEJ/rNwO9iVqyMah9sIerNbM6J1HDgACISSga0ZPV6A0/AiHumq1U71e0LfDg7NobqxFX8GCjpl/qvPXJ8GYFpuMbhIl3Owu/FBalFQL7hUUIPv/SJORpEgjy5b0vMwFqTtsGIuRTGCQJgs1Rd/WeJ1zgUkFUsa34c8lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388566; c=relaxed/simple;
	bh=lxDooC50FNphRCrxj/ouVdfAHsG44yqafHfW01SZxcY=;
	h=Date:To:From:Subject:Message-Id; b=D5CYEELeQAaHx0beca9m01v6f8i0dDDw4lqFDa2UgI+SahSi37rl+bZTtWX10yYwbwdRb4EXkeJA4De5WCfOiYgJWzoH8Ule0r0waMGnSP9PtPRq09SfcBpd4EmYKx3NPu9I+A/N4oX/vl8PuFRjJq2ekokK+S1UfgMwG95JrhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T3n95uWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T3n95uWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437CEC19424;
	Tue, 24 Mar 2026 21:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388566;
	bh=lxDooC50FNphRCrxj/ouVdfAHsG44yqafHfW01SZxcY=;
	h=Date:To:From:Subject:From;
	b=T3n95uWcGqFuchZV5SRoXyxlFH4D8NuVxvJWP3gSRJJQTOI5QhjZyidgHMgelXoEU
	 xPOjzdohpFls3C6AEAcXvCUmvMRUi8dRqFXOOuOhtn+Cd2G2kc2Zn0Yoh3/+mHhWI8
	 /NiR8ict1v+We3O2uZOGrJw6/Xqgz9kGgpVugalE=
Date: Tue, 24 Mar 2026 14:42:45 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags.patch removed from -mm tree
Message-Id: <20260324214246.437CEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: remove unnecessary restrain unmask of swap gfp flags
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem: remove unnecessary restrain unmask of swap gfp flags
Date: Wed, 11 Feb 2026 22:33:23 +0800

The comment makes it look like copy-paste leftovers from
shmem_replace_folio.  The first try of the swap doesn't always have a
limited zone.

So don't drop the restraint, which should make the GFP more accurate.

Link: https://lkml.kernel.org/r/20260211-shmem-swap-gfp-v1-1-e9781099a861@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags
+++ a/mm/shmem.c
@@ -2044,14 +2044,8 @@ static struct folio *shmem_swap_alloc_fo
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct folio *new, *swapcache;
 	int nr_pages = 1 << order;
-	gfp_t alloc_gfp;
+	gfp_t alloc_gfp = gfp;
 
-	/*
-	 * We have arrived here because our zones are constrained, so don't
-	 * limit chance of success with further cpuset and node constraints.
-	 */
-	gfp &= ~GFP_CONSTRAINT_MASK;
-	alloc_gfp = gfp;
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (WARN_ON_ONCE(order))
 			return ERR_PTR(-EINVAL);
_

Patches currently in -mm which might be from kasong@tencent.com are


