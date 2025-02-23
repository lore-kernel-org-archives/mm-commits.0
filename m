Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE05A1C683
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 01:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740275094; cv=none; b=fcEeTJj2EcUpJJvtH2JAI80pUPUS3XkTf8pnRnYKLAXWdxkc8iLBwebg0XrVIUdNRKo8hN2x0Mm/KdncHTjoYUqqAt0KH1a1hSxJtpwwNakPY5GxkNmthx/XnR9M+1DCBwdgDfetctyLk+O1YZl5P9c0d2YAbCQ6AcrbNCMITD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740275094; c=relaxed/simple;
	bh=2L/h2Uy1njdWHlMJtcb/AXu1dCLfT9PG0hCpFrCX/xc=;
	h=Date:To:From:Subject:Message-Id; b=l8wMah9t8bBeNruv243a8PnOBsXk16BJx82CpZDd0stFBjwnZFBJP4adQ2SGo7xR6/O6loHrdVW3VdYutFTqqWbiCV5T9U2lIY+LNcIU6ooliUj22XmEvi/OZ4lC2U0UHE87QnG/V+u4jYH4C+dnn7zva2jKFyztmdfyr6NFvrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0PF4RsnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PF4RsnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA88C4CED1;
	Sun, 23 Feb 2025 01:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740275093;
	bh=2L/h2Uy1njdWHlMJtcb/AXu1dCLfT9PG0hCpFrCX/xc=;
	h=Date:To:From:Subject:From;
	b=0PF4RsnGgoj1awZzvdwSolaxBDp11PyUg3RnGROGU4vV+X+KtKgAHvvzG/zFOvn1m
	 tKpazBosYLNqIrne2Rlp9RyIJy3fuJmqEwh5MxBwYDDoQ0Rcjrt7OPSjuuYsPQROpI
	 q12Re8DG53OzM4KUlED37HNWxk29i2cXuoYP62zc=
Date: Sat, 22 Feb 2025 17:44:52 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch added to mm-hotfixes-unstable branch
Message-Id: <20250223014453.4FA88C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: avoid losing cluster in swap_reclaim_full_clusters()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: avoid losing cluster in swap_reclaim_full_clusters()
Date: Sun, 23 Feb 2025 00:08:45 +0800

If no swap cache is reclaimed, cluster taken off from full_clusters list
will not be put in any list and may not be reused.  Do relocate_cluster
for such cluster to fix the issue.

Link: https://lkml.kernel.org/r/20250222160850.505274-2-shikemeng@huaweicloud.com
Fixes: 3b644773eefda ("mm, swap: reduce contention on device lock")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/swapfile.c~mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters
+++ a/mm/swapfile.c
@@ -858,6 +858,10 @@ static void swap_reclaim_full_clusters(s
 			offset++;
 		}
 
+		/* in case no swap cache is reclaimed */
+		if (ci->flags == CLUSTER_FLAG_NONE)
+			relocate_cluster(si, ci);
+
 		unlock_cluster(ci);
 		if (to_scan <= 0)
 			break;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch
mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch
mm-swap-avoid-bug_on-in-relocate_cluster.patch
mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

