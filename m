Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64A61991B8
	for <mm-commits@vger.kernel.org>; Thu, 10 Oct 2024 20:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728593332; cv=none; b=WsdmV3W9LFnV/Tv96bKw+2wqwRHDH/iiAUD86CRr1qlhf+hkX3tX9I8VNsOYvKrLrdOqmwWO2KpqbTY9wAYtdchZ4XxSE0QdKZEnmYzoybVQuMGh8IwnrlNgWxI/+lJc/CMlhfHnFz2JdweE6mTaAoc+3TUCYw9HWEV9Pzl/p4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728593332; c=relaxed/simple;
	bh=6XXslyUtg1WBD5IAgvAj+KDnN9tLOzuzf9R618Ur4oc=;
	h=Date:To:From:Subject:Message-Id; b=KBEY1GBQgLmKuMMSuH+3Lwj1Oxu11VZC0pI1i2O8QEErNessp9icWnsmYSer+YaDnRip2IDVfmgyITlNiVw5Vxl4gqKi61B8VQxpaH0BkemoZUI4mqAynV1MfkXX+zEXwrzXj4iijh4CZL1OvHxfLSfzy7rpwVLlkiOILqVCiYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mTCYUVb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mTCYUVb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CCDC4CEC5;
	Thu, 10 Oct 2024 20:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728593332;
	bh=6XXslyUtg1WBD5IAgvAj+KDnN9tLOzuzf9R618Ur4oc=;
	h=Date:To:From:Subject:From;
	b=mTCYUVb0tDaNmK5z5g2EsGFQ8PZUgMIxNvEcy/qZ1jBkRPuRH84LAMGnfS8+77XYi
	 ftDkJUUEJFDzJ96UVn+KFbJhL7DvORA7P3znjNPj6EpmHUvIv/8d8pU5dmEvAR0pvP
	 oEa7zXcfRCdQMgV/qreikbCMVJaCBLpUQ4dBrMjQ=
Date: Thu, 10 Oct 2024 13:48:51 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-throttle-and-inc-min_seq-when-both-page-types-reach-min_nr_gens.patch removed from -mm tree
Message-Id: <20241010204852.32CCDC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: throttle and inc min_seq when both page types reach MIN_NR_GENS
has been removed from the -mm tree.  Its filename was
     mm-throttle-and-inc-min_seq-when-both-page-types-reach-min_nr_gens.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: throttle and inc min_seq when both page types reach MIN_NR_GENS
Date: Wed, 9 Oct 2024 15:49:53 +0800

The test case of [1] leads to system hang which caused by a local watchdog
thread starved over 20s on a 5.5GB RAM ANDROID15(v6.6) system.  This
commit solve the issue by have the reclaimer be throttled and increase
min_seq if both page types reach MIN_NR_GENS, which may introduce a
livelock of switching type with holding lruvec->lru_lock.

[1]
launch below script 8 times simutanously which allocates 1GB virtual
memory and access it from user space by each thread.
$ costmem -c1024000 -b12800 -o0 &

Link: https://lkml.kernel.org/r/20241009074953.608591-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-throttle-and-inc-min_seq-when-both-page-types-reach-min_nr_gens
+++ a/mm/vmscan.c
@@ -4387,11 +4387,23 @@ static int scan_folios(struct lruvec *lr
 	int remaining = MAX_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	VM_WARN_ON_ONCE(!list_empty(list));
 
-	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
-		return 0;
+	if (get_nr_gens(lruvec, type) == MIN_NR_GENS) {
+		/*
+		 * throttle for a while and then increase the min_seq since
+		 * both page types reach the limit.
+		 */
+		if (get_nr_gens(lruvec, !type) == MIN_NR_GENS) {
+			spin_unlock_irq(&lruvec->lru_lock);
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
+			spin_lock_irq(&lruvec->lru_lock);
+			try_to_inc_min_seq(lruvec, get_swappiness(lruvec, sc));
+		} else
+			return 0;
+	}
 
 	gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-migrate-lru_refs_mask-bits-in-folio_migrate_flags.patch
mm-optimization-on-page-allocation-when-cma-enabled.patch

