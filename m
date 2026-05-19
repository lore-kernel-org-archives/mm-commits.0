Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04500320CD1;
	Tue, 19 May 2026 20:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779222360; cv=none; b=X8riY+1CGSIayLjTSF654kWVQHGsNUPpscrYc50MZykfFMD1BEv6xgV4uAM3UjKnmHueh8596IjWAHmJOmbulDd9/RDMPosla66bO7pnC0+fReb3YG8GAayx/wfI8CmUPUNfPLvi/1Tb4Fm1Pw3sq7RAtEsrAXUgyGMFVm4txa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779222360; c=relaxed/simple;
	bh=dZgB580wV5B3eYlBodT39eUPujogWfrWstymW3sdKBM=;
	h=Date:To:From:Subject:Message-Id; b=q1rVh+UqteL6lWEOGGJUEE21Mk4S0uj8rvghpuCBiXmnde3I//q/qlKAHRW9enrMt5SZsZSEAB5suMajs99dnZu4pba5ogyUA5Sxr7jE7RVLAyWy97FFtDkp4NCXDkUEL1ysHS4YntbuGz0GG+BTOHdAxgJHIyTF2tqIZJc58nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XJkTfs07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XJkTfs07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DD81F000E9;
	Tue, 19 May 2026 20:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779222358;
	bh=TPNmf42vxRoK8xZFLzKh6LF3SyiQbTxiXq12ogleSAU=;
	h=Date:To:From:Subject;
	b=XJkTfs07Iz5M3FQgRcN4w6rDwbX+yJRnJbkPeI3j2dEO5xjAnQJxxti6WaGgTdlxw
	 uSWLcVjp0sBAOLdIJTbmRxhxBjI2upHMOr8sBJuYVRNbGvHsqFxjGarkbChz4O47yr
	 q5fwqNSL5geKm+5kmqgcOllFscGXi3kSrKUedujw=
Date: Tue, 19 May 2026 13:25:57 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rppt@kernel.org,rafael@kernel.org,osalvador@kernel.org,icheng@nvidia.com,gregkh@linuxfoundation.org,djakov@kernel.org,david@kernel.org,georgi.djakov@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-set-mem-altmap-after-successful-device-registration.patch added to mm-new branch
Message-Id: <20260519202558.52DD81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/memory: set mem->altmap after successful device registration
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-memory-set-mem-altmap-after-successful-device-registration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-memory-set-mem-altmap-after-successful-device-registration.patch

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
From: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Subject: drivers/base/memory: set mem->altmap after successful device registration
Date: Thu, 14 May 2026 02:26:57 -0700

If __add_memory_block() fails at xa_store() (under memory pressure for
example), device_unregister() is called, which eventually triggers
memory_block_release() with mem->altmap still set, causing a
WARN_ON(mem->altmap).  This was triggered by modifying virtio-mem driver.

Fix this by delaying the assignment of mem->altmap until after
__add_memory_block() has succeeded.

Link: https://lore.kernel.org/20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com
Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
Signed-off-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Richard Cheng <icheng@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/memory.c~drivers-base-memory-set-mem-altmap-after-successful-device-registration
+++ a/drivers/base/memory.c
@@ -797,7 +797,6 @@ static int add_memory_block(unsigned lon
 	mem->start_section_nr = block_id * sections_per_block;
 	mem->state = state;
 	mem->nid = nid;
-	mem->altmap = altmap;
 	INIT_LIST_HEAD(&mem->group_next);
 
 #ifndef CONFIG_NUMA
@@ -815,6 +814,8 @@ static int add_memory_block(unsigned lon
 	if (ret)
 		return ret;
 
+	mem->altmap = altmap;
+
 	if (group) {
 		mem->group = group;
 		list_add(&mem->group_next, &group->memory_blocks);
_

Patches currently in -mm which might be from georgi.djakov@oss.qualcomm.com are

drivers-base-memory-set-mem-altmap-after-successful-device-registration.patch

