Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385DB43CE44
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 22:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786056192; cv=none; b=pOErLdX1bhnAaDprv3Pq1VlwgPH6yQwoG+juow+zdXqQweFUWcDJGpaZlzbm/8nVcAYDO/yIEL5AmHUa2kXRWIvOEJT/a7Ggl6fH8Jf4t8bKK9CYZrvnH/yKlC4L9YC2GtHTscj2snTzDUZer4t6qVP2Pw6I8YAkSrIzZ972XXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786056192; c=relaxed/simple;
	bh=c/0Ljl9tSYuttrRnfqI3633OlcJz0rzG/bRHoZBwonY=;
	h=Date:To:From:Subject:Message-Id; b=fcOWQre3rbMrSKowB43WhLQMCghHFxl0Ps0+Dj9GOLh6ujqP8BFKPkgUBywFFB4k7kW9Dc4Y9RVSXuajhVPM/H71trVVXbA2uwO3edURXbUBgo4281sSy517H7BLCW2p36zKLQ36uf9H95mxIq/16JFEnG6Pm3WsHM3GCKASBdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ckkRvsgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ckkRvsgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C401F00A3A;
	Thu,  6 Aug 2026 22:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786056190;
	bh=UOBbVzQ4riaPNeKh9zPdfzppRz29zYirpw4jYe6wfho=;
	h=Date:To:From:Subject;
	b=ckkRvsgn8+gN0OrkkhivY9mfmgAAvpLC2XYLFLUBvSMN49HaZI2XYXa5dBeIFNB/c
	 0676IjjthyI6Yt4QACXj4NaHEzI/UYui5YMQo8k0YYGsppUwUXmiAbLyke4CV1wRD3
	 2t/K8GIs5HBj88LMT4MtKQbX9maURKiLGJIb9890=
Date: Thu, 06 Aug 2026 15:43:10 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-support-batch-writeback-in-shrink_memcg.patch added to mm-new branch
Message-Id: <20260806224310.C7C401F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: support batch writeback in shrink_memcg()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-support-batch-writeback-in-shrink_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-support-batch-writeback-in-shrink_memcg.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hao Jia <jiahao1@lixiang.com>
Subject: mm/zswap: support batch writeback in shrink_memcg()
Date: Thu, 6 Aug 2026 15:09:43 +0800

Currently, shrink_memcg() writes back at most one entry per-node during
its traversal.  This makes shrink_worker() inefficient, as it must
repeatedly re-enter shrink_memcg() to make any substantial progress. 
Under high memory pressure, this can cause the writeback speed to be too
slow to keep up with refaults, leading to zswap store failures and forcing
pages to skip zswap and go directly to disk, which results in an LRU
inversion.

To address this, extend the per-node scan budget in shrink_memcg() from a
single entry to up to SWAP_CLUSTER_MAX pages, enabling batch writeback for
both the shrink_worker() and zswap_store() paths.

Test Setup:
- Total memory: 32 GB, 1 NUMA node.
- zswap settings: accept_threshold_percent=50, shrinker_enabled=N.

Test Case 1:
Set max_pool_percent=1, allocate 512MB of anonymous pages, and fill them
with random data (to avoid compression). Then, use cgroup memory.reclaim
to force a large amount of anonymous pages into zswap. At an interval of
2ms, allocate a 4K anonymous page where the first 4 bytes are random numbers
and the rest are zeros, and then trigger reclamation of this 4K page through
cgroup memory.reclaim. When the pool threshold is reached, shrink_memcg()
will be triggered.
The test data after running for 120s is as follows:
                                Baseline      Patched
shrink_worker wakeups              5,363          169
shrink_memcg calls            11,373,201      350,703
written_back pages                40,212       40,241
zswap_store calls                161,190      163,753
   store succeeded (ret=1)       102,743      117,183
   store rejected (ret=0)         58,447       46,570
   store reject rate                ~36%        ~28%
pool_limit_hit delta              55,826       33,760
pswpout                           98,659       86,811
pswpin                                 2            0

Test Case 2:
We evaluated the following two sub-configurations using stress-ng inside
a cgroup capped at memory.max=1G for 120 seconds:
  Test Case 2a (max_pool_percent=1): Continuously triggers the global
  zswap pool limit, thereby waking up shrink_worker() to perform asynchronous
  shrinking.
  Test Case 2b (zswap.max=320M, max_pool_percent=50): Continuously triggers
  the cgroup's zswap.max limit, thereby invoking synchronous shrinking.
Command executed for both setups:
   bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
   exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t \
120s -q'

Test Case 2a (max_pool_percent=1):
                                Baseline       Patched
shrink_worker wakeups              5,640         1,308
shrink_memcg calls             8,481,500     3,140,972
written_back pages                   260       468,216
zswap_store calls              2,742,756     2,011,269
   store succeeded (ret=1)       934,640       947,988
   store rejected (ret=0)      1,808,116     1,063,281
   store reject rate                ~66%          ~52%
pool_limit_hit delta           1,181,310       196,882
pswpout                        1,808,376     1,531,497
pswpin                         4,288,497     3,635,365
Test Case 2b (zswap.max=320M, max_pool_percent=50):
                                Baseline       Patched
shrink_worker wakeups                 0              0
shrink_memcg calls              687,608         54,002
written_back pages              639,176        846,663
zswap_store calls             1,224,222      1,228,548
   store succeeded (ret=1)      992,816      1,208,123
   store rejected (ret=0)       231,431         20,425
   store reject rate               ~19%            ~2%
pool_limit_hit delta                  0              0
pswpout                         870,745        867,360
pswpin                        1,707,823      1,216,814

Under identical workloads and runtimes, batched zswap shrinking exhibits a
significant reduction in both shrink_worker() wakeups and shrink_memcg()
calls.  Furthermore, the sharp drop in both pswpin and zswap_store()
rejections demonstrates that batching zswap shrink operations effectively
mitigates zswap_store() failures caused by hitting the pool limit.  This
significantly prevents pages from bypassing zswap and falling back
directly to disk, thereby reducing LRU inversion.

Link: https://lore.kernel.org/20260806070943.95542-3-jiahao.kernel@gmail.com
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-support-batch-writeback-in-shrink_memcg
+++ a/mm/zswap.c
@@ -1277,6 +1277,14 @@ static struct shrinker *zswap_alloc_shri
 	return shrinker;
 }
 
+/*
+ * Scan up to SWAP_CLUSTER_MAX pages on each per-node zswap LRU of @memcg
+ * and write back the reclaimable ones.
+ *
+ * Return: 0 if at least one entry was written back, -EAGAIN if entries
+ * were scanned but none could be written back, or -ENOENT if @memcg has
+ * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
+ */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
 	int nid, shrunk = 0, scanned = 0;
@@ -1292,13 +1300,14 @@ static int shrink_memcg(struct mem_cgrou
 		return -ENOENT;
 
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
-		unsigned long nr_to_walk = 1;
+		unsigned long nr_to_walk = SWAP_CLUSTER_MAX;
 
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
 					    &shrink_memcg_cb, NULL, &nr_to_walk);
-		scanned += 1 - nr_to_walk;
+		scanned += SWAP_CLUSTER_MAX - nr_to_walk;
 	}
 
+	/* Nothing was scanned: every LRU under @memcg was empty. */
 	if (!scanned)
 		return -ENOENT;
 
_

Patches currently in -mm which might be from jiahao1@lixiang.com are

mm-zswap-fix-global-shrinker-when-memory-cgroup-is-disabled.patch
mm-zswap-support-batch-writeback-in-shrink_memcg.patch

