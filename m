Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD411E8825;
	Wed, 23 Oct 2024 20:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729716086; cv=none; b=gMv70BFNPR7ZBCC5J/08oav4YqhxbJZNPk1Oncne9fXSL7EI+TiQFrAX1MxGSgqBsTQA6OxslOAnEKA8ixuVAgMmqHEGM5hvUxla3DdfJAnRlwLlMIf9TKtzOBaMAGcGptoKFczBs+ZgkPNqZu5wDLsaiuuGL8X1nwhBDUcCOw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729716086; c=relaxed/simple;
	bh=3frh9VCSXfHd7V5fIBUt9BWZ3Cp5ohqTA6u/4IchxJ0=;
	h=Date:To:From:Subject:Message-Id; b=dHyxSinAA+fVuiIbiSm4ii/VPmyDVIK35vJ6/ZW0jkbHk4KFBiXACPHbMr14kuN4BfG1DYhz9K+fFQQ9202mH9Fijx2B/+sYw4nu3DdwXp7pGOJBA1H1mQBx6DAmpHjihGPsN8Ds7gE6+1y1IwrhphIUJRw+su3+fZfTgL9urAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lW1u0Fbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lW1u0Fbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DFBC4CECC;
	Wed, 23 Oct 2024 20:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729716085;
	bh=3frh9VCSXfHd7V5fIBUt9BWZ3Cp5ohqTA6u/4IchxJ0=;
	h=Date:To:From:Subject:From;
	b=lW1u0FbicPYIe/QqbCMCcml+Rby0pm9uG3aEZpEHulUubiIXovYYZDnWki6oRYiFy
	 y6r2aXIgdpbcoAL1rCyJ+1Vs/FhPc9XpIG//WaC6cr9RM7iUYXtTTJnJvVP1WvrrlG
	 Qe/6gqJ+j9Xl+U8Eoo/6LOgZe5KZapQDgGUlbLbM=
Date: Wed, 23 Oct 2024 13:41:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nifan@outlook.com,mhocko@suse.com,dave@stgolabs.net,dan.j.williams@intel.com,a.manzanares@samsung.com,dongjoo.linux.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023204125.C4DFBC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix NUMA stats update for cpu-less nodes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Dongjoo Seo <dongjoo.linux.dev@gmail.com>
Subject: mm/page_alloc: fix NUMA stats update for cpu-less nodes
Date: Wed, 23 Oct 2024 10:50:37 -0700

In the case of memoryless node, when a process prefers a node with no
memory(e.g., because it is running on a CPU local to that node), the
kernel treats a nearby node with memory as the preferred node.  As a
result, such allocations do not increment the numa_foreign counter on the
memoryless node, leading to skewed NUMA_HIT, NUMA_MISS, and NUMA_FOREIGN
stats for the nearest node.

This patch corrects this issue by:
1. Checking if the zone or preferred zone is CPU-less before updating
   the NUMA stats.
2. Ensuring NUMA_HIT is only updated if the zone is not CPU-less.
3. Ensuring NUMA_FOREIGN is only updated if the preferred zone is not
   CPU-less.

Example Before and After Patch:
- Before Patch:
 node0                   node1           node2
 numa_hit                86333181       114338269            5108
 numa_miss                5199455               0        56844591
 numa_foreign            32281033        29763013               0
 interleave_hit                91              91               0
 local_node              86326417       114288458               0
 other_node               5206219           49768        56849702

- After Patch:
                            node0           node1           node2
 numa_hit                 2523058         9225528               0
 numa_miss                 150213           10226        21495942
 numa_foreign            17144215         4501270               0
 interleave_hit                91              94               0
 local_node               2493918         9208226               0
 other_node                179351           27528        21495942

Similarly, in the context of cpuless nodes, this patch ensures that NUMA
statistics are accurately updated by adding checks to prevent the
miscounting of memory allocations when the involved nodes have no CPUs. 
This ensures more precise tracking of memory access patterns accross all
nodes, regardless of whether they have CPUs or not, improving the overall
reliability of NUMA stat.  The reason is that page allocation from
dev_dax, cpuset, memcg ..  comes with preferred allocating zone in cpuless
node and its hard to track the zone info for miss information.

Link: https://lkml.kernel.org/r/20241023175037.9125-1-dongjoo.linux.dev@gmail.com
Signed-off-by: Dongjoo Seo <dongjoo.linux.dev@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Fan Ni <nifan@outlook.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes
+++ a/mm/page_alloc.c
@@ -2858,19 +2858,21 @@ static inline void zone_statistics(struc
 {
 #ifdef CONFIG_NUMA
 	enum numa_stat_item local_stat = NUMA_LOCAL;
+	bool z_is_cpuless = !node_state(zone_to_nid(z), N_CPU);
+	bool pref_is_cpuless = !node_state(zone_to_nid(preferred_zone), N_CPU);
 
-	/* skip numa counters update if numa stats is disabled */
 	if (!static_branch_likely(&vm_numa_stat_key))
 		return;
 
-	if (zone_to_nid(z) != numa_node_id())
+	if (zone_to_nid(z) != numa_node_id() || z_is_cpuless)
 		local_stat = NUMA_OTHER;
 
-	if (zone_to_nid(z) == zone_to_nid(preferred_zone))
+	if (zone_to_nid(z) == zone_to_nid(preferred_zone) && !z_is_cpuless)
 		__count_numa_events(z, NUMA_HIT, nr_account);
 	else {
 		__count_numa_events(z, NUMA_MISS, nr_account);
-		__count_numa_events(preferred_zone, NUMA_FOREIGN, nr_account);
+		if (!pref_is_cpuless)
+			__count_numa_events(preferred_zone, NUMA_FOREIGN, nr_account);
 	}
 	__count_numa_events(z, local_stat, nr_account);
 #endif
_

Patches currently in -mm which might be from dongjoo.linux.dev@gmail.com are

mm-page_alloc-fix-numa-stats-update-for-cpu-less-nodes.patch

