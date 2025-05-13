Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148491EDA04
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119234; cv=none; b=jTwGAPBtnkR2HjtKtAGX2ONnLDSTnl0aVN036TUL4NamkwdfWbPQ/LCl24o0Ya2+f7G/w9Mrgpld680LRC5UMOZVvaLFm923D26icD05+JpK+vtC2zehV56nmwVUhueFEa4PrX1efAbnDfygiOsCLIiOSSLMA+R2kiXJZGzExCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119234; c=relaxed/simple;
	bh=yF+E8sO/NiO4vmHc27VVK3x1h9ljZgbE98Ld5w4jSUY=;
	h=Date:To:From:Subject:Message-Id; b=XRja58YjsfQmFpam5aDCf39QwbYhaJcM0prWkd/heZRdqdiOmHtK5bqqBuWlaBwzRDm0nh5lPrruzQJwljNCkk9Khqhg+sbqZ9HrynuhMS+h0R9JzuoYzfviVdiMlv3i2kfW+dzfV9x8PJZwltxeb2Eu65EhZtFoxnkmzlImRcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkjAyyF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkjAyyF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41CEC4CEE4;
	Tue, 13 May 2025 06:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119233;
	bh=yF+E8sO/NiO4vmHc27VVK3x1h9ljZgbE98Ld5w4jSUY=;
	h=Date:To:From:Subject:From;
	b=QkjAyyF3Yf2Lz7LMmAVNiL1vS33969DZScmbPaqGFKXlVxkzdQuMxI5L3IlzFxABc
	 6s08zHPHLJ5HXKYn/BSXVAiwHu5MmtFGOk+MI9qijIrtRBYySgcEEHWdqrO8Jlzih/
	 BD0/x/bfcJJ2fFrH0zUbe+Tkd2Nq7f29Gf/Tek1w=
Date: Mon, 12 May 2025 23:53:53 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-add-more-comments-about-cache_trim_mode.patch removed from -mm tree
Message-Id: <20250513065353.D41CEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: add more comments about cache_trim_mode
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-more-comments-about-cache_trim_mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: vmscan: add more comments about cache_trim_mode
Date: Mon, 21 Apr 2025 17:13:29 +0800

Add more comments for cache_trim_mode, and the annotations provided by
Johannes Weiner in [1].

Link: https://lore.kernel.org/all/20250314141833.GA1316033@cmpxchg.org/
Link: https://lkml.kernel.org/r/4baad87ba637f1e6f666e9b99b3fdcb7ab39171b.1745225696.git.hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-add-more-comments-about-cache_trim_mode
+++ a/mm/vmscan.c
@@ -2536,7 +2536,8 @@ static void get_scan_count(struct lruvec
 
 	/*
 	 * If there is enough inactive page cache, we do not reclaim
-	 * anything from the anonymous working right now.
+	 * anything from the anonymous working right now to make sure
+         * a streaming file access pattern doesn't cause swapping.
 	 */
 	if (sc->cache_trim_mode) {
 		scan_balance = SCAN_FILE;
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-cma-set-early_pfn-and-bitmap-as-a-union-in-cma_memrange.patch

