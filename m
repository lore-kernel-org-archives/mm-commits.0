Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF35B267720
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 21:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749589354; cv=none; b=UICG1TT1lZc4/TUCc0aD+LjDg7HIbi8PmblbtlIU6nxfQNnGPHmD341zBdV02n5EtGdcNJnnwrLk6bknqjr7zhTK/2nhTUkHOLXJh8LsljDdIcCz6Toq5VtceQDe7HTUS/T+x/VyddBQBpc9cYj11eEEpJd+rUYSRll9qRKCRiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749589354; c=relaxed/simple;
	bh=hcfAY2GHsjeDrYCkgY5bC7IjQSzKQl4y/7VpU89k98Q=;
	h=Date:To:From:Subject:Message-Id; b=Q4UCAnWClbBHuFtuZwNWYf4av5sgP91LBVOmf0pM4gQydJvBmXv8wEIolqPuYwbPMtFjRQLTEjGGu7Vqose1yqPTEwF/K17fddlVIdUoHPhR9fmYAaUGVJ0vPiPLFZolPovrTA6lhSU2SLX+d458mCa4kmOApNTWho+8AAqHpOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GrdzegjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GrdzegjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD30C4CEED;
	Tue, 10 Jun 2025 21:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749589353;
	bh=hcfAY2GHsjeDrYCkgY5bC7IjQSzKQl4y/7VpU89k98Q=;
	h=Date:To:From:Subject:From;
	b=GrdzegjYqF3rT7kKZkw66k2S9wAOqFdCNONYgPts2lxMzRmLX5z0nJRHRZlIrvyoE
	 XPKa91KNr7QDiFNcO5IR+wYyZ1F5CrVv0kb7vrA5T3NEzFXAckRU6Gr+rBnkScwKKy
	 HzhBD9OWQ0FLNPMvg5f9sFrxywymbVL24+qbUp1g=
Date: Tue, 10 Jun 2025 14:02:32 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,osalvador@suse.de,donettom@linux.ibm.com,balbirs@nvidia.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-tier-fix-abstract-distance-calculation-overflow.patch added to mm-new branch
Message-Id: <20250610210233.6AD30C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-tier: fix abstract distance calculation overflow
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-tier-fix-abstract-distance-calculation-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-tier-fix-abstract-distance-calculation-overflow.patch

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
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/memory-tier: fix abstract distance calculation overflow
Date: Tue, 10 Jun 2025 14:27:51 +0800

In mt_perf_to_adistance(), the calculation of abstract distance (adist)
involves multiplying several int values including MEMTIER_ADISTANCE_DRAM.


*adist = MEMTIER_ADISTANCE_DRAM *
		(perf->read_latency + perf->write_latency) /
		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
		(perf->read_bandwidth + perf->write_bandwidth);

Since these values can be large, the multiplication may exceed the maximum
value of an int (INT_MAX) and overflow (Our platform did), leading to an
incorrect adist.

Change MEMTIER_ADISTANCE_DRAM to be a long constant by writing it with the
'L' suffix.  This prevents the overflow because the multiplication will
then be done in the long type which has a larger range.

Link: https://lkml.kernel.org/r/20250610062751.2365436-1-lizhijian@fujitsu.com
Fixes: 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory-tiers.h~mm-memory-tier-fix-abstract-distance-calculation-overflow
+++ a/include/linux/memory-tiers.h
@@ -18,7 +18,7 @@
  * adistance value (slightly faster) than default DRAM adistance to be part of
  * the same memory tier.
  */
-#define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
+#define MEMTIER_ADISTANCE_DRAM	((4L * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
 
 struct memory_tier;
 struct memory_dev_type {
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-memory-tier-fix-abstract-distance-calculation-overflow.patch

