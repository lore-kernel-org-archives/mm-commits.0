Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EE0286D70
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782878130; cv=none; b=kykFeu8wdrzQBncq8yOrJc6pyWDTAa+K6cjbZrnx0tRR8qtJG3G2YBeUhaW8KQsf1BnwNnGKON+Pz70X8WZiNtTvOioo0JhQNn4vXsK+POhZvq78GtHf81lXSOVFSssLa7cD7vY1pFPGQgK2XGXVLCSzlhOruxajrGaw+rGPa4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782878130; c=relaxed/simple;
	bh=GrCoibP+PhvGd8F84wOU5u8NCWgkFY5FFyRKZ/W4LLM=;
	h=Date:To:From:Subject:Message-Id; b=SpjjlXWMjII3kp8+b+YDXLjhkTjfc59yrH/kCTlnErSPFNO6APEYbCY+wYhGiEjcMZG/Su77C6L2480JWMH1ktuFw5xSiFcNATvOolMWiuDiCnlMfWHz30HwGKjboxArdIFBo7UR3UPFq1Jx/WoTI1hxg1sCxd9YlVFKshCkyu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DDTe5lG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DDTe5lG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D61A1F000E9;
	Wed,  1 Jul 2026 03:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782878128;
	bh=yi/uE+0R206s6ZXGP8/h8zK3o5nhtJg6AZv5RuuEZvA=;
	h=Date:To:From:Subject;
	b=DDTe5lG+ld32f8xO62LGNGPx+F07V0xqe/KqIl/1D5GvGVIn2u2aLHdUtn1wHHTYX
	 3Rom5Ob1+8a1fpXGSLHKdEMmgHykfJpJxrj+AULmYVsaYVlgqDrDGEvIZkqLGwfb1L
	 AH83/s8VrRLi02VIDBGfxjfr228DZCVxkVwKJohQ=
Date: Tue, 30 Jun 2026 20:55:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch added to mm-new branch
Message-Id: <20260701035528.1D61A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmpressure: skip tree=true accounting on cgroup v2
has been added to the -mm mm-new branch.  Its filename is
     mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/vmpressure: skip tree=true accounting on cgroup v2
Date: Tue, 30 Jun 2026 04:23:32 -0700

Patch series "mm/vmpressure: reduce CPU, memory and code overhead on
cgroup v2", v3.

The vmpressure subsystem has two distinct consumers, gated by the @tree
argument:

  tree=false : in-kernel socket pressure, consumed by TCP/SCTP. This
               is cgroup v2 only; v1 sockets read memcg->tcpmem_pressure
               instead.
  tree=true  : cgroup v1 userspace eventfd notifications via the
               memory.pressure_level / cgroup.event_control interface.
               v2 has no equivalent (userspace gets reclaim signals
               through memory.pressure / PSI, which doesn't touch
               vmpressure).

So of the four (hierarchy, tree) combinations, only two carry data that
anyone reads.  The existing early return in vmpressure() covered v1 +
tree=false; the symmetric v2 + tree=true case was falling through and
doing the full lock / accumulate / schedule_work / parent-walk dance, even
though the events list it eventually iterates is empty on cgroup v2
(vmpressure_register_event() is wired up only through the v1 cftype
"memory.pressure_level" and can't be reached from a v2 memcg).

Patch 1 extends the existing early return to also skip v2 + tree=true.  On
a v2-only host this eliminates a contended path where reclaimers can
serialize on a single global sr_lock.  bpftrace on a 176-core production
host (cgroup v2, 285 memcgs, sustained reclaim) showed ~16,200 such calls
per minute with tree = true.

Patch 2 follows up with a cleanup: it splits the v1 userspace eventfd
interface (struct vmpressure_event, the events list and its mutex, the
work_struct and its handler, the parent walk, vmpressure_register_event /
unregister_event, and vmpressure_prio) into a new mm/memcontrol-v1.c built
only when CONFIG_MEMCG_V1=y, behind small no-op stubs in the header. 
mm/vmpressure.c keeps the shared bits and the tree=false socket-pressure
path.  The size of vmpressure.c goes down to half and the code is much
more simpler.  The only #ifdef CONFIG_MEMCG_V1 remaining in source is
around the v1-only fields inside struct vmpressure itself.  Memory savings
on CONFIG_MEMCG_V1=n:
struct vmpressure : 112B -> 24B
struct mem_cgroup : 1664B -> 1536B

This split is the first step toward eventually making vmpressure
CONFIG_MEMCG_V1 only.  The v2 in-kernel socket pressure path (tree=false)
cannot be removed today immediately: PSI is not an exact replacement for
vmpressure, and switching networking socket-buffer back-off to PSI may
regress networking performance or increase memory pressure in workloads
that today rely on vmpressure's hysteresis.  The medium-term plan is to
introduce a PSI-based socket-pressure path, keep vmpressure available for
v2 behind a defconfig as an opt-out for several releases, and only then
drop the tree=false path entirely, at which point everything that remains
in mm/memcontrol-v1.c is the whole subsystem.


This patch (of 2):

vmpressure() has two outputs gated by the @tree argument:

  @tree=false drives in-kernel socket pressure (mem_cgroup_set_
              socket_pressure), consumed by TCP/SCTP. This only
              applies on cgroup v2; on v1 socket memory is charged
              separately via tcpmem and the consumer reads
              memcg->tcpmem_pressure instead.

  @tree=true  drives userspace eventfd notifications via the v1
              memory.pressure_level / cgroup.event_control interface.
              v2 has no equivalent: userspace gets reclaim signals
              through memory.pressure (PSI), which does not touch
              vmpressure.

The existing early return covered v1 + @tree=false.  The symmetric v2 +
@tree=true case was falling through and doing the full lock / accumulate /
schedule_work / parent-walk dance for an events list that can never be
populated.  bpftrace on a 176-core production host (cgroup v2,
CONFIG_MEMCG_V1=n, 285 memcgs, sustained reclaim) showed ~16,200
@tree=true vmpressure() calls per minute.  Add an early return that skips
cgroup v2 + tree = true which avoids us doing all this work.  On a v2-only
host this also eliminates a lock contention path that can serialise
reclaimers on a single global sr_lock.

Link: https://lore.kernel.org/20260630112617.1198623-1-usama.arif@linux.dev
Link: https://lore.kernel.org/20260630112617.1198623-2-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/vmpressure.c~mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2
+++ a/mm/vmpressure.c
@@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, st
 		return;
 
 	/*
-	 * The in-kernel users only care about the reclaim efficiency
-	 * for this @memcg rather than the whole subtree, and there
-	 * isn't and won't be any in-kernel user in a legacy cgroup.
+	 * Only two combinations have a consumer:
+	 *   cgroup v2 + tree=false -> in-kernel socket pressure
+	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
+	 * Skip the other two: nothing consumes the result.
 	 */
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree)
+	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
+	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
 		return;
 
 	vmpr = memcg_to_vmpressure(memcg);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch

