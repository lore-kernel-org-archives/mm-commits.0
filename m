Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518461990A7
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761453628; cv=none; b=ZkRcF7z4FMmMNiot2CysgGQGcyZTc3p/Ad+kbmVLXM6o7Ab0pwlHrz8qs/xdui+rVN/YmZyh1ClPRIk+ZTAdZ0pSNJdOqVTiCv9BNFwkU9Lg8sAZfB0+hw5vfyTXd46sBOsl2LNEN6w8LdjRpIeRfyfLPH04cKux6r5GDY11VHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761453628; c=relaxed/simple;
	bh=NS6CPbEbcC14IRgKsjpvaPc+ygNOHMsNbP42365uRP8=;
	h=Date:To:From:Subject:Message-Id; b=Gi/9//v+QHL91lxyMA5FYi/fpjX1nRnGKa4FFiHkUzDAYCt+yN2903nw44x/7RYyTkuBIVFPOHkadEBlpFwp4mkX/Jsy6jop/hnK6Jr8vXflLO+cof0cY5JLGNn96/Bsq4HKsJ/mS3eC+YPwPrIotJecFXIU9M04u5GkKEAnglk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iHR94iYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iHR94iYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EFBC4CEE7;
	Sun, 26 Oct 2025 04:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761453627;
	bh=NS6CPbEbcC14IRgKsjpvaPc+ygNOHMsNbP42365uRP8=;
	h=Date:To:From:Subject:From;
	b=iHR94iYJklRGP28mwiD/IXmRFpdP+/qLUStZ6ew4gwRV645iawIi86Lwq1cL/m4Yp
	 6GQBvQ5ijNhJ/gEcCSn51dnNuGsg8b8F2GnDWWW5MwMsokrhahT6Y6kZ0hyUSlqZ3X
	 FGGVAbsbGW7ZIYlx+UDNuuwKwNWEVr4/y5JcqeeA=
Date: Sat, 25 Oct 2025 21:40:27 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,axelrasmussen@google.com,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch added to mm-new branch
Message-Id: <20251026044027.B3EFBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: skip increasing kswapd_failures when reclaim was boosted
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm/vmscan: skip increasing kswapd_failures when reclaim was boosted
Date: Fri, 24 Oct 2025 10:27:11 +0800

We encountered a scenario where direct memory reclaim was triggered,
leading to increased system latency:

1. The memory.low values set on host pods are actually quite large, some
   pods are set to 10GB, others to 20GB, etc.
2. Since most pods have memory protection configured, each time kswapd is
   woken up, if a pod's memory usage hasn't exceeded its own memory.low,
   its memory won't be reclaimed.
3. When applications start up, rapidly consume memory, or experience
   network traffic bursts, the kernel reaches steal_suitable_fallback(),
   which sets watermark_boost and subsequently wakes kswapd.
4. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
   triggered by watermark_boost, the maximum priority is 10. Higher
   priority values mean less aggressive LRU scanning, which can result in
   no pages being reclaimed during a single scan cycle:

if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
    raise_priority = false;

5. This eventually causes pgdat->kswapd_failures to continuously
   accumulate, exceeding MAX_RECLAIM_RETRIES, and consequently kswapd stops
   working. At this point, the system's available memory is still
   significantly above the high watermark — it's inappropriate for kswapd
   to stop under these conditions.

The final observable issue is that a brief period of rapid memory
allocation causes kswapd to stop running, ultimately triggering direct
reclaim and making the applications unresponsive.

Link: https://lkml.kernel.org/r/20251024022711.382238-1-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted
+++ a/mm/vmscan.c
@@ -7128,7 +7128,12 @@ restart:
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

mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch

