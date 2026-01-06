Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C2234844F
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728213; cv=none; b=ei/H2ee0nW6NBOx2Oz7CPedYrBR4f12THvnC9NpnePVL84XOtvgnqRjwv38RRQVzJWbro+ZS8rrGx2m0DlYTiZwoyL2EoZGRRE0Qu9FDq7lbMc2vr86Ujfz/4O2B3Wnbw2qMTcfx0oa7hC38YLEzEqeUUnkHrR3g0yT/ujIqCH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728213; c=relaxed/simple;
	bh=JBdUf+aPwPN8Kpq0TvVDQMHZtIzW/Nc0gWHiCawYZjo=;
	h=Date:To:From:Subject:Message-Id; b=bZZpWRW3uIDy6SVSfXLj94n37xVyp7fi02kF5B+avKdxtBREFJw567Hf0c5tMBB6cqLMdX8dwMOZHp8rgg9npQd58nX2x2ruWqLHmIjJiPkMktXwSAytyF3vsIfJtkmsG2KWREIBXeiHgUdGIpU+IoUOrxBckYGPaLNY9TdOJGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nh8FEw9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nh8FEw9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7474EC116C6;
	Tue,  6 Jan 2026 19:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767728212;
	bh=JBdUf+aPwPN8Kpq0TvVDQMHZtIzW/Nc0gWHiCawYZjo=;
	h=Date:To:From:Subject:From;
	b=nh8FEw9rYI0RArgkiicFZmK1JaQRL2iFAmX7NJJDQL9rvbZwqKErK7o3q+0EyhiiR
	 0JUWQIpiUtUSlTYgT22qVI2kpdhXiHg4Ve7LpNnEr7Lb2ONE4wlIG2eoXnRVcrVuU+
	 JI6AZVeHJkwrSIVpajfFczqC/4vL1ymHEJ0aZ5NM=
Date: Tue, 06 Jan 2026 11:36:51 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@kernel.org,bingjiao@google.com,axelrasmussen@google.com,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch removed from -mm tree
Message-Id: <20260106193652.7474EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
has been removed from the -mm tree.  Its filename was
     mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
Date: Mon, 22 Dec 2025 09:48:34 +0900

On systems with multiple memory-tiers consisting of DRAM and CXL memory,
the OOM killer is not invoked properly.

Here's the command to reproduce:

$ sudo swapoff -a
$ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
    --memrate-rd-mbs 1 --memrate-wr-mbs 1

The memory usage is the number of workers specified with the --memrate
option multiplied by the buffer size specified with the --memrate-bytes
option, so please adjust it so that it exceeds the total size of the
installed DRAM and CXL memory.

If swap is disabled, you can usually expect the OOM killer to terminate
the stress-ng process when memory usage approaches the installed memory
size.

However, if multiple memory-tiers exist (multiple
/sys/devices/virtual/memory_tiering/memory_tier<N> directories exist) and
/sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will not be
invoked and the system will become inoperable, regardless of whether MGLRU
is enabled or not.

This issue can be reproduced using NUMA emulation even on systems with
only DRAM.  You can create two-fake memory-tiers by booting a single-node
system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
parameters.

The reason for this issue is that memory allocations do not directly
trigger the oom-killer, assuming that if the target node has an underlying
memory tier, it can always be reclaimed by demotion.

So this change avoids this issue by not attempting to demote if the
underlying node has less free memory than the minimum watermark, and the
oom-killer will be triggered directly from memory allocations.

Link: https://lkml.kernel.org/r/20251222004834.10539-4-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier
+++ a/mm/vmscan.c
@@ -356,7 +356,18 @@ static bool can_demote(int nid, struct s
 		return false;
 
 	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
+		int z;
+		struct zone *zone;
+		struct pglist_data *pgdat = NODE_DATA(demotion_nid);
+
+		for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
+			if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
+						ZONE_MOVABLE, 0))
+				return true;
+		}
+	}
+	return false;
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are


