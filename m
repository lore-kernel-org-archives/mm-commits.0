Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C167D7FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441699; cv=none; b=h7CAkgtLsXCRiPjexlOaB+vGto5wu0BByGpXAjVo//iT719Sin0y1g7dnDOHon8mhc2n3aNzHwwje/ibQipzSCDIsLjfYTpk8MX/eseNIfDsW5qpJ0+SPoe9XgOiewQT1uD3L4M8LREOqVcrPPFRpvxs3Wj8PAgFlW4nNiilTTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441699; c=relaxed/simple;
	bh=FoEiT9wDKFerJU+PlPaNywFrSSgwY9cIlHld1K+AzxI=;
	h=Date:To:From:Subject:Message-Id; b=VSe0a2bg/avb9E1U9hCBsf8qI0kz/HUPGqnJoSFvq4h2Xu2lt0+FTHvlERY1BF7/GaAEKXvc8zXTTw0knHlNCNpxPDupEdUFNBpKsygwSS2/nOFxU1y/EPwG1NkSl4U3A2XIvaHCX6WJStXe7AbuygXtK/tv3mxH9IvH3N95l2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KyIG3m+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KyIG3m+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FB9C4CEF7;
	Sat, 29 Nov 2025 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441699;
	bh=FoEiT9wDKFerJU+PlPaNywFrSSgwY9cIlHld1K+AzxI=;
	h=Date:To:From:Subject:From;
	b=KyIG3m+C70oY4YCTZOeGbptgSXnB52OwVbxeJCR3Yaj4+aQIM4vlVKjJOVjkohK7V
	 OJgfkfXDrlGU9UyPofL0z0Hg5hQ9yb2UFMSkUWTPZK6s0EKdq5JvAg+uPbw8TmDyO7
	 8471WzA9zvEF50xOqfjAQIUDH81X4v6pS/FpHPg4=
Date: Sat, 29 Nov 2025 10:41:38 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,axelrasmussen@google.com,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch removed from -mm tree
Message-Id: <20251129184139.26FB9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: skip increasing kswapd_failures when reclaim was boosted
has been removed from the -mm tree.  Its filename was
     mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm/vmscan: skip increasing kswapd_failures when reclaim was boosted
Date: Fri, 24 Oct 2025 10:27:11 +0800

We have a colocation cluster used for deploying both offline and online
services simultaneously.  In this environment, we encountered a
scenario where direct memory reclamation was triggered due to kswapd
not running.

1. When applications start up, rapidly consume memory, or experience
   network traffic bursts, the kernel reaches steal_suitable_fallback(),
   which sets watermark_boost and subsequently wakes kswapd.

2. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
   triggered by watermark_boost, the maximum priority is 10. Higher
   priority values mean less aggressive LRU scanning, which can result in
   no pages being reclaimed during a single scan cycle:

   if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
       raise_priority = false;

3. Additionally, many of our pods are configured with memory.low, which
   prevents memory reclamation in certain cgroups, further increasing the
   chance of failing to reclaim memory.

4. This eventually causes pgdat->kswapd_failures to continuously
   accumulate, exceeding MAX_RECLAIM_RETRIES, and consequently kswapd
   stops working.  At this point, the system's available memory is still
   significantly above the high watermark -- it's inappropriate for kswapd
   to stop under these conditions.

The final observable issue is that a brief period of rapid memory
allocation causes kswapd to stop running, ultimately triggering direct
reclaim and making the applications unresponsive.

This problem leading to direct memory reclamation has been a
long-standing issue in our production environment.  We initially held
the simple assumption that it was caused by applications allocating
memory too rapidly for kswapd to keep up with reclamation.  However,
after we began monitoring kswapd's runtime behavior, we discovered a
different pattern:

kswapd initially exhibits very aggressive activity even when there is
still considerable free memory, but it subsequently stops running
entirely, even as memory levels approach the low watermark.

In summary, both boosted watermarks and memory.low increase the
probability of kswapd operation failures.

This patch specifically addresses the scenario involving boosted
watermarks by not incrementing kswapd_failures when reclamation fails. 
A more general solution, potentially addressing memory.low or other
cases, requires further discussion.

Link: https://lkml.kernel.org/r/53de0b3ee0b822418e909db29bfa6513faff9d36@linux.dev
Link: https://lkml.kernel.org/r/20251024022711.382238-1-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted
+++ a/mm/vmscan.c
@@ -7127,7 +7127,12 @@ restart:
 		goto restart;
 	}
 
-	if (!sc.nr_reclaimed)
+	/*
+	 * If the reclaim was boosted, we might still be far from the
+	 * watermark_high at this point. We need to avoid increasing the
+	 * failure count to prevent the kswapd thread from stopping.
+	 */
+	if (!sc.nr_reclaimed && !boosted)
 		atomic_inc(&pgdat->kswapd_failures);
 
 out:
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are

mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch

