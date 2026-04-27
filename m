Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF79328243
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313496; cv=none; b=URTqiCwasYn14+TFR9s6wi6HNvbSMjhDCfkMC6LMVdb+2M6bRsS6jTJjw7VYn+qNZqr4PGyXH+2/NVGmb3CvGjR8KZBhPmFk7148CVFvVLDCV668mhz1033OjtA3ru50PlBSs4x22fj7kFEva/rJWAZChYqpcKAT40myssicSoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313496; c=relaxed/simple;
	bh=+bcyzxMqNFlyFAwmBP4yQNxi1lMWmCaoVjvghYSMuaU=;
	h=Date:To:From:Subject:Message-Id; b=ExnYLRmMyjZGmAgTR2LXIOG1pgA6yhKPMwDNkT79PRr1h4vyR21SDmKukD5lQEP7vSJr/OG2r7NbL0ErDGcYxSCUnLWLA/sAqtFJ1WorXXjBSyH3o6+vy9f4Cxjlh2oBbFODR4JH7jjw6h5Ptylpg2nEVJ2TLxUL+cSp8Lw1/6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRc5dYMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRc5dYMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4A4C2BCB4;
	Mon, 27 Apr 2026 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313496;
	bh=+bcyzxMqNFlyFAwmBP4yQNxi1lMWmCaoVjvghYSMuaU=;
	h=Date:To:From:Subject:From;
	b=WRc5dYMNIg9yVbvK0h+PLSCIGxUWOFWiLtepEwMS8DE/PMf+7Zn2QgKj7mhk7hCVw
	 ipPZlmlIiunYe+t4s2jeDXQM0Mu9qqO8/WUDuFOWUaXh28UQ5aMAVvdbBIWTmZZ7ta
	 5GXKzCQcd1e7CtPA78J06KQZcovzkoE4e5z2XXBU=
Date: Mon, 27 Apr 2026 11:11:35 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch removed from -mm tree
Message-Id: <20260427181136.4F4A4C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: remove redundant swap constrained check upon isolation
has been removed from the -mm tree.  Its filename was
     mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: remove redundant swap constrained check upon isolation
Date: Fri, 24 Apr 2026 01:43:19 +0800

Remove the swap-constrained early reject check upon isolation.  This check
is a micro optimization when swap IO is not allowed, so folios are
rejected early.  But it is redundant and overly broad since
shrink_folio_list() already handles all these cases with proper
granularity.

Notably, this check wrongly rejected lazyfree folios, and it doesn't cover
all rejection cases.  shrink_folio_list() uses may_enter_fs(), which
distinguishes non-SWP_FS_OPS devices from filesystem-backed swap and does
all the checks after folio is locked, so flags like swap cache are stable.

This check also covers dirty file folios, which are not a problem now
since sort_folio() already bumps dirty file folios to the next generation,
but causes trouble for unifying dirty folio writeback handling.

And there should be no performance impact from removing it.  We may have
lost a micro optimization, but unblocked lazyfree reclaim for NOIO
contexts, which is not a common case in the first place.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-8-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/vmscan.c~mm-mglru-remove-redundant-swap-constrained-check-upon-isolation
+++ a/mm/vmscan.c
@@ -4650,12 +4650,6 @@ static bool isolate_folio(struct lruvec
 {
 	bool success;
 
-	/* swap constrained */
-	if (!(sc->gfp_mask & __GFP_IO) &&
-	    (folio_test_dirty(folio) ||
-	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
-		return false;
-
 	/* raced with release_pages() */
 	if (!folio_try_get(folio))
 		return false;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

