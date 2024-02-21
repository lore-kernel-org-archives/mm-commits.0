Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9434612C549
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 22:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708554627; cv=none; b=bvkNMILzAt+wXz+ZsxSdY7A1Gz2dBssPBW19ZyZna6tkmAsKcLolGIyLOJYLp+zH1CwU4zkB7x1kFc7VUaAXS5c40KDTn1bvuAs071ypmBbpNu1wlS1PPTrTe0I6VukebKKPZJMIkTgHaCYnJtKFJ1KVq7qAIZldLQ9hQSsMYmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708554627; c=relaxed/simple;
	bh=RZoRa8MrpnTtPOPDko3706MnNCeqN4NnJJIfvVJpvbE=;
	h=Date:To:From:Subject:Message-Id; b=lrnN9u6YKEH+zFxEADTY1XTmQ/OSPbQ7YtNryw3yS7bPYw/i+q16fALyg4nM/x96xFqGwnPQmn17RKjVVEbzI7/VJqLKH0NMM+Ksj/FaBn6GYAxRQLiDMejFO/0aiLRaFe9gfsjA9A4lu60r7dH2rddCZglRkRAwFBLQO1t7ar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gK2kUUiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gK2kUUiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B434C433C7;
	Wed, 21 Feb 2024 22:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708554625;
	bh=RZoRa8MrpnTtPOPDko3706MnNCeqN4NnJJIfvVJpvbE=;
	h=Date:To:From:Subject:From;
	b=gK2kUUiJdZSvCQZ7LZmiEzw+tVhsHxb78078/aZJv/D0hHknJuyBtbTC6PDoiiCjY
	 QddIKKUfg3rnpbIcu63dZWK0EmTI1T4gN6AFYQ5V1fx2oORpSWsvE4Ox0zNzNRyNwU
	 CZIl4F0Eq5/r3DJzT15MbLomMPtupMxRw19ItRjw=
Date: Wed, 21 Feb 2024 14:30:24 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority.patch removed from -mm tree
Message-Id: <20240221223025.7B434C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, vmscan: don't turn on cache_trim_mode at the highest scan priority
has been removed from the -mm tree.  Its filename was
     mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Byungchul Park <byungchul@sk.com>
Subject: mm, vmscan: don't turn on cache_trim_mode at the highest scan priority
Date: Thu, 8 Feb 2024 15:18:25 +0900

With cache_trim_mode on, reclaim logic doesn't bother reclaiming anon
pages.  However, it should be more careful to turn on the mode because
it's going to prevent anon pages from being reclaimed even if there are a
huge number of anon pages that are very cold and which should be
reclaimed.  Even worse, that can lead kswapd_failures to reach
MAX_RECLAIM_RETRIES and stopping kswapd until direct reclaim eventually
works to resume kswapd.

Link: https://lkml.kernel.org/r/20240208061825.36640-1-byungchul@sk.com
Signed-off-by: Byungchul Park <byungchul@sk.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority
+++ a/mm/vmscan.c
@@ -2269,7 +2269,8 @@ static void prepare_scan_control(pg_data
 	 * anonymous pages.
 	 */
 	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
-	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE))
+	if (sc->priority != 1 && file >> sc->priority &&
+	    !(sc->may_deactivate & DEACTIVATE_FILE))
 		sc->cache_trim_mode = 1;
 	else
 		sc->cache_trim_mode = 0;
_

Patches currently in -mm which might be from byungchul@sk.com are

mm-vmscan-fix-a-bug-calling-wakeup_kswapd-with-a-wrong-zone-index.patch
sched-numa-mm-do-not-try-to-migrate-memory-to-memoryless-nodes.patch

