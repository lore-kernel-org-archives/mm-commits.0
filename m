Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2ED2A1BA
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740455260; cv=none; b=m8TovNjsXgfUBl5ykarxqsgIk8bUDUPL4j6zR8nLQPxo2OzCmWxP/V55Z6pWWA6LRq2pI51gd4ZXrt3HKvkeNSpon7Q99Xkzvs9hN7umiwBuKILQvtzoY+L6Hifw8XIPFE/kCol2uZ5AKNh5IMGn6yklI2WoXtXbkSynryvbAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740455260; c=relaxed/simple;
	bh=kfz0giEvKxNBEwF9/o89fj8UuzZHamrfpiXTZcBkaPo=;
	h=Date:To:From:Subject:Message-Id; b=aA+Tsi1iUGeep9aglBs4gcwjpPxrA+TozR3dSU97v6v194hS17gIJoivJd/YBW7MNS9M5WvnlZEWgvBTHoFDfuoR74eAWVG8UwkQC+vithRu9GqUnnh6PbM7DoYa5pzGA1O6F9/dS/bKz76SwCcNugcKrMVRPJ4MJBugCsN93v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=loHmAuo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="loHmAuo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA19C4CEE2;
	Tue, 25 Feb 2025 03:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740455259;
	bh=kfz0giEvKxNBEwF9/o89fj8UuzZHamrfpiXTZcBkaPo=;
	h=Date:To:From:Subject:From;
	b=loHmAuo8Jr4a587vw5vRI+GutjkgRSrKwBRxdWryU7f8z/06EeKGstBM1rLFp6T6+
	 RzKg+XhWngMnrPn6Lv/g2ZY26HcSmW6uxB0IYOyM/kRbhEtPlMCnsGxvmeNPx4qTda
	 L8yIVHoLlD9zFIM/AQjWbeHrLH/b4sDaZWXQHOwk=
Date: Mon, 24 Feb 2025 19:47:39 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-back-full-cluster-when-no-entry-is-reclaimed.patch added to mm-hotfixes-unstable branch
Message-Id: <20250225034739.DCA19C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: add back full cluster when no entry is reclaimed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-add-back-full-cluster-when-no-entry-is-reclaimed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-back-full-cluster-when-no-entry-is-reclaimed.patch

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
Subject: mm: swap: add back full cluster when no entry is reclaimed
Date: Mon, 24 Feb 2025 19:39:10 +0800

If no swap cache is reclaimed, cluster taken off from full_clusters list
will not be put in any list and we can't reclaime HAS_CACHE slots
efficiently.  Do relocate_cluster for such cluster to avoid inefficiency.

Link: https://lkml.kernel.org/r/20250224113910.522439-1-shikemeng@huaweicloud.com
Fixes: 3b644773eefda ("mm, swap: reduce contention on device lock")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/swapfile.c~mm-swap-add-back-full-cluster-when-no-entry-is-reclaimed
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

mm-swap-add-back-full-cluster-when-no-entry-is-reclaimed.patch
mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch
mm-swap-avoid-bug_on-in-relocate_cluster.patch
mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

