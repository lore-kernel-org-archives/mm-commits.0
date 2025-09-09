Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A9A70830
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 02:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757386117; cv=none; b=Tu+0J7MwDeYF15xckF8NnRVvTj+pNnKqGGsaJIFFd5NQSIg+q0/+xysFm8UKdEqSyH9L2xVDaEIAqOI2wfT/xp2A8do9EPuB9seADh9pDkG8Cecs2KmZ80WBSO+u71kxhU6RBYs5renlCTmRpaB0R5dfJzqwpeAcFrwHW2SeTlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757386117; c=relaxed/simple;
	bh=Cf9cc8tV8BPB2LDfLPq5iIKTU42zE8bWm8jRbfM9Azs=;
	h=Date:To:From:Subject:Message-Id; b=HF5VushZbpHSs7ZDV4/PxZJxKamr6CBWq+mJwhYZ/opiVQvh3610kAfZ00rvxzs1KkGOHaPv/MWvjJ6WcBGkPVvnfyO4ZiwkC8d/uT/eWSX7+ZP7YyokFcpq/GnTyydH5zt5hBoWDvrQ/DEjrP0nt753gX/FWIW1xe2n9vXV58s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mri48Sl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mri48Sl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F2BC4CEF1;
	Tue,  9 Sep 2025 02:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757386116;
	bh=Cf9cc8tV8BPB2LDfLPq5iIKTU42zE8bWm8jRbfM9Azs=;
	h=Date:To:From:Subject:From;
	b=mri48Sl3q/oXKOkzy7Rxk0lCUQnUIkZfyXTUJ3XGVmM9tgkR/+POM/Fx22f2r/N66
	 KpUiHRRiLNHTT+sbGL+Pb24xn2sNX+iyyYh7MVuIXr4lJpd99pN07P2AifWfFzBp35
	 zUXnJ4Ks3ZM/G1TWO01uNaxvtPavIe7SEtF0ATT8=
Date: Mon, 08 Sep 2025 19:48:35 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,axelrasmussen@google.com,cuishw@inspur.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + disable-demotion-during-memory-reclamation.patch added to mm-new branch
Message-Id: <20250909024836.51F2BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: disable demotion during memory reclamation
has been added to the -mm mm-new branch.  Its filename is
     disable-demotion-during-memory-reclamation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/disable-demotion-during-memory-reclamation.patch

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
@@ -6717,6 +6717,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.no_demotion = 1,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
_

Patches currently in -mm which might be from cuishw@inspur.com are

disable-demotion-during-memory-reclamation.patch

