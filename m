Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0771979D9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560183; cv=none; b=LWCaA76NBkjsO52tCcHNT/gdplmujYwnVdZggI1m2XCmC2rQpdriPQlfTB4sWRXU78CEPs9Zurk5ZB5Q6jmPjqYA8DMAiBpJ+xGRH0MOhakRXN8rCjlLMFT2miq4nUmKd3ptm327jA7+UARoPsOmt0erSW+afppsfk9tXPr+erg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560183; c=relaxed/simple;
	bh=mhL8rYCYn7Lp9SZDzPv82Cg2NWYC/ZeStL3fYHTMGtQ=;
	h=Date:To:From:Subject:Message-Id; b=rrhh4KWe2HW8I+q3ffefAViNzz9BHIRegQSy84nUNKY7U2c7TxPH3ixetY/NuYp4buM6sVaWOavE14z34pBHKwlMZa0dCkUTQqro1GO4vf0QeIRGDLW4TUmuaI2bLdKF4Z/Wpy+w9e03VEExJMNpXZ//z4VQ1FOG6kj7N3OsBdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IAsk5Llr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IAsk5Llr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C617BC43394;
	Thu, 22 Feb 2024 00:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560182;
	bh=mhL8rYCYn7Lp9SZDzPv82Cg2NWYC/ZeStL3fYHTMGtQ=;
	h=Date:To:From:Subject:From;
	b=IAsk5LlrSjvj3Gjl37JtFkDIgl6a+thKuiyZMGJiLRsCqo6LWowqqvecB9L8mBaYF
	 uVH1lu9iU6JaeAquAQBH8Omv4r6YZui+K8hId8cHEBVTonW0Xew45RgrvCli3Of5aD
	 AuSDKSMqqjbQKVzf5e2pVtDIKMsKYfo8f4KQXk4g=
Date: Wed, 21 Feb 2024 16:03:02 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,yangyifei03@kuaishou.com,songmuchun@bytedance.com,shakeelb@google.com,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,hannes@cmpxchg.org,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-use-larger-batches-for-proactive-reclaim.patch removed from -mm tree
Message-Id: <20240222000302.C617BC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: use larger batches for proactive reclaim
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-larger-batches-for-proactive-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm: memcg: use larger batches for proactive reclaim
Date: Fri, 2 Feb 2024 23:38:54 +0000

Before 388536ac291 ("mm:vmscan: fix inaccurate reclaim during proactive
reclaim") we passed the number of pages for the reclaim request directly
to try_to_free_mem_cgroup_pages, which could lead to significant
overreclaim.  After 0388536ac291 the number of pages was limited to a
maximum 32 (SWAP_CLUSTER_MAX) to reduce the amount of overreclaim. 
However such a small batch size caused a regression in reclaim performance
due to many more reclaim start/stop cycles inside memory_reclaim.  The
restart cost is amortized over more pages with larger batch sizes, and
becomes a significant component of the runtime if the batch size is too
small.

Reclaim tries to balance nr_to_reclaim fidelity with fairness across nodes
and cgroups over which the pages are spread.  As such, the bigger the
request, the bigger the absolute overreclaim error.  Historic in-kernel
users of reclaim have used fixed, small sized requests to approach an
appropriate reclaim rate over time.  When we reclaim a user request of
arbitrary size, use decaying batch sizes to manage error while maintaining
reasonable throughput.

MGLRU enabled - memcg LRU used
root - full reclaim       pages/sec   time (sec)
pre-0388536ac291      :    68047        10.46
post-0388536ac291     :    13742        inf
(reclaim-reclaimed)/4 :    67352        10.51

MGLRU enabled - memcg LRU not used
/uid_0 - 1G reclaim       pages/sec   time (sec)  overreclaim (MiB)
pre-0388536ac291      :    258822       1.12            107.8
post-0388536ac291     :    105174       2.49            3.5
(reclaim-reclaimed)/4 :    233396       1.12            -7.4

MGLRU enabled - memcg LRU not used
/uid_0 - full reclaim     pages/sec   time (sec)
pre-0388536ac291      :    72334        7.09
post-0388536ac291     :    38105        14.45
(reclaim-reclaimed)/4 :    72914        6.96

[tjmercier@google.com: v4]
  Link: https://lkml.kernel.org/r/20240206175251.3364296-1-tjmercier@google.com
Link: https://lkml.kernel.org/r/20240202233855.1236422-1-tjmercier@google.com
Fixes: 0388536ac291 ("mm:vmscan: fix inaccurate reclaim during proactive reclaim")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Koutny <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Efly Young <yangyifei03@kuaishou.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-use-larger-batches-for-proactive-reclaim
+++ a/mm/memcontrol.c
@@ -6981,6 +6981,8 @@ static ssize_t memory_reclaim(struct ker
 
 	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
 	while (nr_reclaimed < nr_to_reclaim) {
+		/* Will converge on zero, but reclaim enforces a minimum */
+		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
 		unsigned long reclaimed;
 
 		if (signal_pending(current))
@@ -6995,8 +6997,7 @@ static ssize_t memory_reclaim(struct ker
 			lru_add_drain_all();
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
-					min(nr_to_reclaim - nr_reclaimed, SWAP_CLUSTER_MAX),
-					GFP_KERNEL, reclaim_options);
+					batch_size, GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
_

Patches currently in -mm which might be from tjmercier@google.com are


