Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFEE47796
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421775; cv=none; b=doZbGdA2uTL8jYfFRxUUPh51TKySOnrus/VHXRMXVZN0vHcjYJgcsMbKKdoZP/WDPSb1x/WeDDCYMKpKPZAKnzwHxuyNcZy2o0pBLOu3NABpTBG1NlJvQJ344mMXwblPkDuybh3Roc30HPAz94smf6VaCy4e7o14lDSu151tJsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421775; c=relaxed/simple;
	bh=fBFRTpKD/MGvcMzbHon+nCNta8Hyg58lSzCM5BZS890=;
	h=Date:To:From:Subject:Message-Id; b=mA2Y+M92SEDcdVkVSv5GWEjPThZBHF/h1ExLgsAqHq8qcxbaA7rEEI5tC6lblZ9sJD6ToHRFqMGj113uly3IYPyPp6m+3qxG2ZJ0Zg7l/mWcxabxfc+n39uL7A0rcnI+z66G5kSDISVJYd5jGCNtVl74X1zek6NM2P6QSiJ+y2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kKBe9uml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kKBe9uml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7140DC4CEC2;
	Wed,  4 Sep 2024 03:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421774;
	bh=fBFRTpKD/MGvcMzbHon+nCNta8Hyg58lSzCM5BZS890=;
	h=Date:To:From:Subject:From;
	b=kKBe9umlVuo/pbnwSe2OaHUcgh4iuyLP8fwTcwVQI1MB0RSF2s5qXoLtbp6ZysIoa
	 jv2nDGu7dXHpfOTvkABCn6to4i1HNrIMpICI6vqdUp75kLiAsh26499TBHrxUsTRve
	 //2tT870NpVJHhT8C6lNf/mnxW1HSi4CDkXh/+M0=
Date: Tue, 03 Sep 2024 20:49:33 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3.patch removed from -mm tree
Message-Id: <20240904034934.7140DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3
has been removed from the -mm tree.  Its filename was
     mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-3.patch

This patch was dropped because it was folded into mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch

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

mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch

