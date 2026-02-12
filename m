Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E1E25B2F4;
	Thu, 12 Feb 2026 20:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929994; cv=none; b=lUvqVDbLuWTxgrAHja99+bC/5SfdIjIgyUKvCfdhR8HANBqOym3Cd2zZdqF6svFXCo1vskmUHNwdfzAj3FeBdM1aFGVYLesCIadnvdyCKel68S87EfEQvJ6RzCmPJj69YEljutawkUlRhZGA/MzcPfmo8HLl/nuoIzdFnXFZx/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929994; c=relaxed/simple;
	bh=wgJKQfmxOzsKstGBY6rLl+Aq49bQ/slkNHMgqOHPRxQ=;
	h=Date:To:From:Subject:Message-Id; b=Hexa/sIMGDEH+Db0/NkXXgT4hnpD2cDeY4ptvkUVHm8t3MI2fxJDnp+97wA3W5Y7Up/yvgjlef9lJHsVp77L57I684nAArwAxtz0syNcipfgZ9E02Sq9j3tLl+nU1EryJ0PphGPaCBE2pfFul85x1+umRSPXQXREZPyH0hki7n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z6mm+czl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z6mm+czl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A9AC4CEF7;
	Thu, 12 Feb 2026 20:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770929993;
	bh=wgJKQfmxOzsKstGBY6rLl+Aq49bQ/slkNHMgqOHPRxQ=;
	h=Date:To:From:Subject:From;
	b=Z6mm+czlaIiffWRu2xFuftV/5TC7BBkWNd8ty7wpJwYAJT1gfAVKWe3qgYvNylUBG
	 yE7c0cG25/K/Xwy9ZhhZZFpIaWe1alrSk//PjNCRd5dDMdYVKhC9UObLIlF8daYXXE
	 NXNrSe0t7EGQok7vqmpoO5nhKbGJ6R9ETdOxJG8Q=
Date: Thu, 12 Feb 2026 12:59:52 -0800
To: mm-commits@vger.kernel.org,wangyinfeng@phytium.com.cn,stable@vger.kernel.org,rppt@kernel.org,jonathan.cameron@huawei.com,gourry@gourry.net,david@kernel.org,dan.j.williams@intel.com,cuichao1753@phytium.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch added to mm-new branch
Message-Id: <20260212205953.87A9AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: numa_memblks: identify the accurate NUMA ID of CFMW
has been added to the -mm mm-new branch.  Its filename is
     mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch

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
From: Cui Chao <cuichao1753@phytium.com.cn>
Subject: mm: numa_memblks: identify the accurate NUMA ID of CFMW
Date: Wed, 11 Feb 2026 18:33:20 +0800

In some physical memory layout designs, the address space of CFMW (CXL
Fixed Memory Window) resides between multiple segments of system memory
belonging to the same NUMA node.  In numa_cleanup_meminfo, these multiple
segments of system memory are merged into a larger numa_memblk.  When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory.

When a CXL RAM region is created in userspace, the memory capacity of the
newly created region is not added to the CFMW-dedicated NUMA node. 
Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
containing RAM).  This makes it impossible to clearly distinguish between
the two types of memory, which may affect memory-tiering applications.

Example memory layout:

Physical address space:
    0x00000000 - 0x1FFFFFFF  System RAM (node0)
    0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
    0x40000000 - 0x5FFFFFFF  System RAM (node0)
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

After numa_cleanup_meminfo, the two node0 segments are merged into one:
    0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.

To address this scenario, accurately identifying the correct NUMA node can
be achieved by checking whether the region belongs to both numa_meminfo
and numa_reserved_meminfo.

While this issue is only observed in a QEMU configuration, and no known
end users are impacted by this problem, it is likely that some firmware
implementation is leaving memory map holes in a CXL Fixed Memory Window. 
CXL hotplug depends on mapping free window capacity, and it seems to be
only a coincidence to have not hit this problem yet.

1. Issue Impact and Backport Recommendation:

This patch fixes an issue observed in QEMU emulation where, during the
dynamic creation of a CXL RAM region, the memory capacity is not assigned
to the correct CFMW-dedicated NUMA node.  While hardware platforms could
potentially have such memory configurations, we are not currently aware of
any such hardware.  This issue leads to:

    Failure of the memory tiering mechanism: The system is designed to
    treat System RAM as fast memory and CXL memory as slow memory. For
    performance optimization, hot pages may be migrated to fast memory
    while cold pages are migrated to slow memory. The system uses NUMA
    IDs as an index to identify different tiers of memory. If the NUMA
    ID for CXL memory is calculated incorrectly and its capacity is
    aggregated into the NUMA node containing System RAM (i.e., the node
    for fast memory), the CXL memory cannot be correctly identified. It
    may be misjudged as fast memory, thereby affecting performance
    optimization strategies.

    Inability to distinguish between System RAM and CXL memory even for
    simple manual binding: Tools like |numactl|and other NUMA policy
    utilities cannot differentiate between System RAM and CXL memory,
    making it impossible to perform reasonable memory binding.

    Inaccurate system reporting: Tools like |numactl -H|would display
    memory capacities that do not match the actual physical hardware
    layout, impacting operations and monitoring.

This issue affects all users utilizing the CXL RAM functionality who rely
on memory tiering or NUMA-aware scheduling.

Therefore, I recommend backporting this patch to all stable kernel series
that support dynamic CXL region creation.

2. Why a Kernel Update is Recommended Over a Firmware Update:

In the scenario of dynamic CXL region creation, the association between
the memory's HPA range and its corresponding NUMA node is established when
the kernel driver performs the commit operation.  This is a runtime,
OS-managed operation where the platform firmware cannot intervene to
provide a fix.

Considering factors like hardware platform architecture, memory resources,
and others, such a physical address layout can indeed occur.  This patch
does not introduce risk; it simply correctly handles the NUMA node
assignment for CXL RAM regions within such a physical address layout.

Thus, I believe a kernel fix is necessary.

Link: https://lkml.kernel.org/r/20260211103320.2064211-2-cuichao1753@phytium.com.cn
Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa_memblks.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/numa_memblks.c~mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw
+++ a/mm/numa_memblks.c
@@ -570,15 +570,16 @@ static int meminfo_to_nid(struct numa_me
 int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
+	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
 
 	/*
-	 * Prefer online nodes, but if reserved memory might be
-	 * hot-added continue the search with reserved ranges.
+	 * Prefer online nodes unless the address is also described
+	 * by reserved ranges, in which case use the reserved nid.
 	 */
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
 		return nid;
 
-	return meminfo_to_nid(&numa_reserved_meminfo, start);
+	return reserved_nid;
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 
_

Patches currently in -mm which might be from cuichao1753@phytium.com.cn are

mm-numa_memblks-identify-the-accurate-numa-id-of-cfmw.patch

