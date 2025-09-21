Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A441D6AA
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758487543; cv=none; b=kG5ADTOwENU0uyTp4lvl35h8QdZBk/5oc/tXS4rZH5wOWhi00AQw4frgEEbFYe1S0fT9E588cMsGHYxos25yVqQphEraC4M96dn+FmYBGyaxw+hpK37H4gtVQSs9c7DgO9VDwrygHTwpcikRI/5L6Av2+v6TK4uKQPU9aMCvbKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758487543; c=relaxed/simple;
	bh=PK7mBrC25cyx9ZJYW0GW1xRzrr9TW8tmufwFIWo0eos=;
	h=Date:To:From:Subject:Message-Id; b=eREhesWcYCSFNSp47GXLCaso6DcgTRegIdJ1Arz7lOXSnlWuVPRj7WHZEANVN83UxYFVh4/EooMv6bCJQBmPg7Ui+/b5tCbyxwwzeX58LOBqtw/NE32EkEqOVECegnNt5cbon8uWLzv8L1DAPxp8rZ5husiUSr9G6usfCnMAfw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=INYIzotb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="INYIzotb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9C7C4CEE7;
	Sun, 21 Sep 2025 20:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758487543;
	bh=PK7mBrC25cyx9ZJYW0GW1xRzrr9TW8tmufwFIWo0eos=;
	h=Date:To:From:Subject:From;
	b=INYIzotb1VS9VxTA01A+Fl8TTiQqaQWiAFcEy2bAm2lNlUxgw3nYTY3TVEJFk4OSu
	 fnzSRo1jAugSBqCNcnJd0iAFCGBfzoTjcefH7+8o9AwNbjQZk66HiE+Q/y8H6ZMoKY
	 klFY4eMJWkVfjwQnHEjv4m/Ui0RW9Qz5myX5hWoo=
Date: Sun, 21 Sep 2025 13:45:42 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,axelrasmussen@google.com,cuishw@inspur.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] disable-demotion-during-memory-reclamation.patch removed from -mm tree
Message-Id: <20250921204543.3C9C7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: disable demotion during memory reclamation
has been removed from the -mm tree.  Its filename was
     disable-demotion-during-memory-reclamation.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: cuishiwei <cuishw@inspur.com>
Subject: mm: disable demotion during memory reclamation
Date: Tue, 9 Sep 2025 09:21:41 +0800

I've found an issue while using CXL memory.  My machine has one DRAM NUMA
node and one CXL NUMA node:

node 1 cpus: 96 97 98 99...	- dram Numa node
node 1 size: 772048 MB
node 1 free: 759737 MB
node 3 cpus:			- CXL memory Numa node
node 3 size: 524288 MB
node 3 free: 524287 MB
1.enable demotion
echo 1 > /sys/kernel/mm/numa/demotion_enabled
2.Execute a memory allocation program in a memcg
cgexec -g memory:test numactl -N 1 ./allocate_memory 20	- allocate 20G memory
numastat allocate_memory：
                           Node 0          Node 1          Node 3
                  --------------- --------------- ---------------
Huge                         0.00            0.00            0.00
Heap                         0.00            0.00            0.00
Stack                        0.00            0.01            0.00
Private                      0.05        20481.56            0.01
3.Setting the memory cgroup memory limit to be exceeded
echo 15G > /sys/fs/cgroup/test/memory.max
numastat allocate_memory：
                           Node 0          Node 1          Node 3
                  --------------- --------------- ---------------
Huge                         0.00            0.00            0.00
Heap                         0.00            0.00            0.00
Stack                        0.00            0.01            0.00
Private                      0.00         4011.54            10560.00

This happens because demotion was enabled, when the memcg's memory limit
was exceeded, memory from the DRAM NUMA node was first migrated to the CXL
NUMA node.  After that, a memory reclaim was performed, which was
unnecessary.

When a memory cgroup exceeds its memory limit, the system reclaims its
cold memory.However, if /sys/kernel/mm/numa/demotion_enabled is set to 1,
memory on fast memory nodes will also be demoted to slow memory nodes.

This demotion contradicts the goal of reclaiming cold memory within the
memcg.At this point, demoting cold memory from fast to slow nodes is
pointless;it doesn't reduce the memcg's memory usage.  Therefore, we
should set no_demotion when reclaiming memory in a memcg.

Link: https://lkml.kernel.org/r/20250909012141.1467-1-cuishw@inspur.com
Signed-off-by: cuishiwei <cuishw@inspur.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmscan.c~disable-demotion-during-memory-reclamation
+++ a/mm/vmscan.c
@@ -6714,6 +6714,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.no_demotion = 1,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
_

Patches currently in -mm which might be from cuishw@inspur.com are


