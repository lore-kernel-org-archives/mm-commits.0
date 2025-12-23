Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD9724DD15
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 01:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766454173; cv=none; b=IPuh6tMMZwkpM3vvbCo+EDpqQrpff+bOeRvmBmEHylmO/vW0MqR1GpBP2/GKfWQrg+GxDYQX9nlz6RbyvOvR3E3p6OC/v1qaBxoyWyMgFHPbT7RH08t/rMwNTNRi8hN4CkmqULpj0KCDbeGgdwrlNe7PhrzLxiI2a0WM+soVP8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766454173; c=relaxed/simple;
	bh=5VyAjrhDuzxGvzxf/3kOqXMUo14JxgeWLTtTYdMeUr4=;
	h=Date:To:From:Subject:Message-Id; b=d7awT3N6pr2mYk5R1Q+uf1zJmB5IWsmeoQUgM45cJHZuaXzgKrRau9WVv9QILP3UllKBDMYUyQYGi2yAsG86caX87BAWSWw0aYgr5cwQZ18KlSbqOA3UCaNw/PTf+93HYf9OKWx2XETK6Zf16ZGKBMBSNqRyn3wlC3FAPtQoLz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uJXt2sov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uJXt2sov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6784EC4CEF1;
	Tue, 23 Dec 2025 01:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766454172;
	bh=5VyAjrhDuzxGvzxf/3kOqXMUo14JxgeWLTtTYdMeUr4=;
	h=Date:To:From:Subject:From;
	b=uJXt2sovTH85RNhmd9hWL0CnNeRARl9zjhSSzFlrfoHBsOxmS1GZx9u9cVwBYc/DM
	 5MlJhFymfEHFxxls2CmeYBn0ntXIrvIHLqzF/orzfDhfNjeIA0gqCynleJ6sgUYHBa
	 ibmNC2oF2sC2aT8100Siet0ZBokgH34cGKZ1q4G8=
Date: Mon, 22 Dec 2025 17:42:51 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch added to mm-new branch
Message-Id: <20251223014252.6784EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry.patch
mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes.patch
mm-numa_emu-add-document-for-numa-emulation.patch
mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch

