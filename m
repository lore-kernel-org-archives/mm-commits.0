Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058669;
	b=cMFO6mwL2d/jqE6UblNXdvfNU/5e/R0qA/JJVKZtNtWwZ0NMKJOTt1YaKSFMVuY92sJf
	 sHALl9g6VPsDDtJFLycZvSQ1GFNC5AOnWUreSE57vY16jt+JrUh1Ev+RI0FoELLhEhAkU
	 ej4NQzwQRMLhFgEJb6hzL6XIJfjEkBBHJ1q03rrF+6+wcrdoul5gsB99RO2Wnh7F2yM2p
	 jumanhMIi8TXdhRvihPvJ4k9fH1u2/KQnUK7IB7ajeTqXXln1eIlKSszxZ/AficL/Y+Ux
	 KRS3AmwIk29xOXn4Q/gVE0VibO1scCi//TBraoItM9l2uxas1WnrQau+ck1BKAa3ZRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058669;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=aU+j9wPTudaMwBX886I+7mGSSI5JW+TPM1PvIU/CdU0=;
	b=YCjFsRtQ45414ANAwBpGkxgBzYrEG2y3jaMJCOWJ9W0uowxDRytc4h1IZi4tzAkRGJuZ
	 jIIljsBxHHYI+geS/88oWYuldMVVrwpbbVe56z2RDtVKPRP2Ni3N5Ivnn/4r3HssedyeC
	 EshpWjh58zDQHs2z+9Map/hVfRkoPXfQzY/WMI261GqhXOfg4DHpxun98UUSgzBoaeZCz
	 1sgrlaQYYYPzZiOU+opGxUfyf0AZILG5UHAvPcM+BahL63kYnEY2nPlUcpVvIIs0y6P+S
	 eQh1uBxsE7Us2+tzrRhL4jjGuNC2cFoH7iCY2H6sCst1fLEPE+pe3/7ybz6RYUEk75Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y04uxY+1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3DB606A32C
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 03:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y04uxY+1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EEE1F000C4;
	Thu, 19 Nov 2026 03:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795058669;
	bh=aU+j9wPTudaMwBX886I+7mGSSI5JW+TPM1PvIU/CdU0=;
	h=Date:To:From:Subject;
	b=Y04uxY+1dg0bIlSO1Q+SUo7EP4pGE9z1Ou/QXjD1gA6DGZMX7jKGTkrHAoAr6gMIB
	 lwf+e5qtd3PM+KBwP9ZOiJBhhsjHxROBwb0+vgWYyNYgwI1hARi1IzRBW23cYFjZnC
	 x1NrhKk5lDKRBxLvmxvF8lLenC12IdIgSRiDAHHM=
Date: Wed, 18 Nov 2026 19:24:28 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,ycshark.kim@samsung.com,
	weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,
	qi.zheng@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,
	ljs@kernel.org,kasong@tencent.com,jason.sim@samsung.com,
	jaewon31.kim@samsung.com,hannes@cmpxchg.org,dskiba@google.com,
	david@kernel.org,david@fromorbit.com,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,
	tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-workingset-compare-shadow-nodes-node-wide-without-kmem-accounting.patch added to mm-new branch
Message-Id: <20261119032429.27EEE1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: workingset: compare shadow nodes node-wide without kmem accounting
has been added to the -mm mm-new branch.  Its filename is
     mm-workingset-compare-shadow-nodes-node-wide-without-kmem-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-workingset-compare-shadow-nodes-node-wide-without-kmem-accounting.patch

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
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm: workingset: compare shadow nodes node-wide without kmem accounting
Date: Fri,  6 Nov 2026 15:59:04 -0800

count_shadow_nodes() limits the number of xarray nodes holding shadow
entries to 1/8th of the pages that could be using them.  For a memcg, it
counts the LRU and slab pages local to that memcg.

With kmem accounting disabled (cgroup.memory=nokmem), shadow nodes are not
charged to any memcg and __list_lru_init() makes the shadow_nodes list_lru
non-memcg-aware, so all shadow nodes of a NUMA node are on a single list. 
shrinker_alloc() falls back to a non-memcg-aware shadow node shrinker,
which shrink_slab() only invokes for the root memcg.  count_shadow_nodes()
therefore compares every shadow node on the NUMA node against the pages
local to the root memcg.

When most tasks run in child memcgs, the root memcg only holds a small
fraction of all pages, so the shadow node limit derived from the root
memcg page count is far below the number of shadow nodes on the NUMA node.
Since the shrinker has seeks == 0, every root shrink_slab() call trims
about half of the "excess" shadow nodes.  Most refault information is
thrown away, so refaults of recently evicted file folios are not detected.
Refaulted folios lose PG_workingset and the workingset_refault and
workingset_restore stats drop.

In testing on devices with kmem accounting disabled, moving tasks from the
root memcg into per-application memcgs dropped workingset_nodes from
~37,000 to ~900 and raised workingset_nodereclaim 4.6x while pgsteal_file
rose by ~12%.

When kmem accounting is disabled, compare the shadow nodes against the
whole NUMA node, as is done without memcg.  Behavior with kmem accounting
enabled is unchanged.

Link: https://lore.kernel.org/20261106235904.1092712-1-tjmercier@google.com
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>

 mm/workingset.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/workingset.c~mm-workingset-compare-shadow-nodes-node-wide-without-kmem-accounting
+++ a/mm/workingset.c
@@ -682,7 +682,16 @@ static unsigned long count_shadow_nodes(
 	 * PAGE_SIZE / xa_nodes / node_entries * 8 / PAGE_SIZE
 	 */
 #ifdef CONFIG_MEMCG
-	if (sc->memcg) {
+	/*
+	 * Without kmem accounting the shadow_nodes list_lru is not
+	 * memcg-aware. So the count above covers the whole NUMA node, and the
+	 * shrinker only runs for the root memcg, whose local pages can be a
+	 * small fraction of the node's when most tasks run in child memcgs.
+	 * Compare the shadow node count against the memcg page count only when
+	 * the shadow_nodes list_lru is memcg-aware. Otherwise use the NUMA node
+	 * page count as is done without memcg.
+	 */
+	if (sc->memcg && shadow_nodes.memcg_aware) {
 		struct lruvec *lruvec;
 		int i;
 
_

Patches currently in -mm which might be from tjmercier@google.com are

mm-vmscan-remove-redundant-mem_cgroup_online-checks.patch
mm-mglru-stop-rotating-offlined-memcgs-to-the-old-generation.patch
mm-workingset-compare-shadow-nodes-node-wide-without-kmem-accounting.patch

