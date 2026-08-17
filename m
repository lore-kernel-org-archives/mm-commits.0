Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A388275AFD
	for <mm-commits@vger.kernel.org>; Mon, 17 Aug 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786988683; cv=none; b=KKeEM85G0cvBi3jJlpLbOhV/t7H6qsz3V177RBypwHl+WV2cuHHCmgv0J5260SA4uOFbifzNuWgbsnPtEhKUE5wdZk0OkPyTsDOOpgBZtX0lVE1+h2YicSuP61OyUK4yw7XBozH4koGbeWx0fQy5QKrlKXXgxNKZVwgQ/s311k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786988683; c=relaxed/simple;
	bh=zjP1zykZDsXa+y031f3aGNIKCoHiC2/KXppa7p+jwlw=;
	h=Date:To:From:Subject:Message-Id; b=UxFX0KZTxm2lYanvJ2NYy9yEk+KHUNcgQ8aY8CEMNk9n/hwWf6tLeZyJMbwUWh3veHHXyVsQ2MPml5QX+2shCtr8C5Q/RHyIs4pVEOKq0AWCVyT3TbN6qC1pkDd4nR+ygF7J+7eztr60hiRWJRNbH9Y4fDM4A1Kjc0BEFl5Jd20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iUWsFr5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iUWsFr5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7921F000E9;
	Mon, 17 Aug 2026 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786988682;
	bh=EuAwpy+IzLDBKXH2o7qCbgD5iroZuLqaq05c9mHWI5A=;
	h=Date:To:From:Subject;
	b=iUWsFr5oD8i5VtzMwayW+jy08rG4Kfc94ETu2piBpU92s7feUnOuWiBHsRxyRlNFQ
	 vACQbiYKwR+UdkK5sHBIOlK4xqIGT8yfYQ1DfFK9+jpS0MITNMHW13Mo5O4E6F5K3k
	 IJB1EB47VhbjFFX+9KoHgTpdNmi4jAYQgimZg2GM=
Date: Mon, 17 Aug 2026 10:44:41 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-avoid-false-sharing-between-vmstats-and-events.patch added to mm-unstable branch
Message-Id: <20260817174442.5C7921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: avoid false sharing between vmstats and events
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-avoid-false-sharing-between-vmstats-and-events.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-avoid-false-sharing-between-vmstats-and-events.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/memcontrol: avoid false sharing between vmstats and events
Date: Mon, 17 Aug 2026 03:38:35 -0700

Moving v1 userspace eventfd handling into memcontrol-v1.c shrank struct
vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.  This
moved memory_events_local[MEMCG_SWAP_FAIL] and the hot vmstats_percpu
pointer onto the same cacheline.

The stress-ng mremap stressor exercises MADV_PAGEOUT with swap disabled,
generating about 20 million MEMCG_SWAP_FAIL updates per 60-second run on a
176-CPU test system.  Those writes bounce the line while memcg statistics
paths load vmstats_percpu.

Move cgwb_list into the existing alignment gap and cacheline-align
vmstats_percpu.  This separates the pointer from the event counters
without increasing the size of struct mem_cgroup in the tested
configuration.

The blamed commit reduced median mremap throughput by 4.38% on the test
system with one socket.  The patched kernel brings the performance to
within 0.5% of the parent which is within the observed boot-to-boot spread
(up to 1.2%).

Link: https://lore.kernel.org/20260817103835.2937733-1-usama.arif@linux.dev
Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-avoid-false-sharing-between-vmstats-and-events
+++ a/include/linux/memcontrol.h
@@ -268,10 +268,15 @@ struct mem_cgroup {
 #endif
 	int kmemcg_id;
 
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
+#endif
+
+	/* Keep the hot per-CPU stats pointer away from memory event counters. */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu
+		____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch
mm-memcontrol-avoid-false-sharing-between-vmstats-and-events.patch
squashfs-avoid-thundering-herd-cache-wakeups.patch

