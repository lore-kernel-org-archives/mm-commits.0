Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2DD18030
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 04:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724819227; cv=none; b=WHbHqts7ava0PQzj/UA+22PppOqT2tB2naSK7AskaL5RLCvRNCAtjYRtrg1JfQubrZ/maddCcuwfi9FPSQ1iDkEqv9KOwJJrJZyg48OGxHI0NH6Pqndwo+wDep3BO5hYtQEEzlZoldOonnxVGy2rTwgENPW4e9XMWqCsKpznWt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724819227; c=relaxed/simple;
	bh=DfjCw1SjQF+Y8cXRMPSZX1MdUJuDSzSzDrkIt7/eMxE=;
	h=Date:To:From:Subject:Message-Id; b=G8ayRd/kipz6F/Bd3+rfhAZ8rzBubqGHKMHwGpr/OchULKSdgD8lm0zVNhpS0sEttooNjXmZ1qAPWJ6oU9jCfTEJBmen6nTiOxWyWWdRlxAeFXUKQjibzR4NM2vgGIA3FYlH0uJZzTcrTDqaExhZWWIikldR3Gn3yZIZT6QqPSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jua2OAO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jua2OAO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2216C4FF0D;
	Wed, 28 Aug 2024 04:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724819226;
	bh=DfjCw1SjQF+Y8cXRMPSZX1MdUJuDSzSzDrkIt7/eMxE=;
	h=Date:To:From:Subject:From;
	b=jua2OAO5efiszwKC24wvenHzWF/V5vGw7+w7U3/5m/AE+l/mdl8KFV2mW1WQWGOUk
	 0ftt7BynIXPvtXhwZV0bgQm1uvH/S+v0xxqoq67kgIIFRrOQdYBhkv2K6gctd9Eick
	 EGiivToD9LqNsJ7adhSV0eCjd5eY0IYWjp7NFEVw=
Date: Tue, 27 Aug 2024 21:27:06 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3.patch added to mm-unstable branch
Message-Id: <20240828042706.C2216C4FF0D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3.patch

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
From: Barry Song <21cnbao@gmail.com>
Subject: mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3
Date: Wed, 21 Aug 2024 17:49:21 +1200

add missing zswap_invalidate()

Link: https://lkml.kernel.org/r/20240821054921.43468-1-21cnbao@gmail.com
Signed-off-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swapfile.c~mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3
+++ a/mm/swapfile.c
@@ -1514,6 +1514,8 @@ static bool __swap_entries_free(struct s
 	unlock_cluster_or_swap_info(si, ci);
 
 	if (!has_cache) {
+		for (i = 0; i < nr; i++)
+			zswap_invalidate(swp_entry(si->type, offset + i));
 		spin_lock(&si->lock);
 		swap_entry_range_free(si, entry, nr);
 		spin_unlock(&si->lock);
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3.patch

