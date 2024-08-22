Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE9A41C63
	for <mm-commits@vger.kernel.org>; Thu, 22 Aug 2024 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724351432; cv=none; b=bus6Qfkkch1ONdpFkNQiaH/40X0MASA4229r6VTnSniJmkSXJwsfFRyu1vavK/RAPp56z/GUMGaVWnnrIpjte5p+rUMp/eODffyxneGBOwb03dXbxySt1Qv3ZM8a7ow0iarULHdtarG9YQH/yB7SenhpSGEuIPzKUjYiTxiI1g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724351432; c=relaxed/simple;
	bh=v5qvaZoW+gUt+ffy+mP3iC/ARYn3kV4HMtyKYlH3K8o=;
	h=Date:To:From:Subject:Message-Id; b=tpaHcDwGvdGv0Jup8eJL7nWOiBtbCsRXQKYMf7ritNg+IsZcRqvyTbXjo/zAQUEo0J4linlqhmrTCs/uE5Vp0OtXOXXYZDuZEGI2YNRyWDUBhn9+MpOca3U84qjhqyBNmnxrr12ekdRXd6IP8AxBr0MdPVpIcjY0iBLffVAONxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pGsQYBv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pGsQYBv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A359FC32782;
	Thu, 22 Aug 2024 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724351431;
	bh=v5qvaZoW+gUt+ffy+mP3iC/ARYn3kV4HMtyKYlH3K8o=;
	h=Date:To:From:Subject:From;
	b=pGsQYBv9AVBrvMFoaBuWTRWTFXXoxRU6YaYNQELezA6aGtGV+5DxGiwHceEAiU7i1
	 5cSNF4N1+FfMaKbneH4kS5o5zhrZhLhFkY32FOVMwlDgbhL8f+EEwX2O1CwhjjdZ6e
	 6yGrKd/Sg1Lp0+anAhtJ0xlpDvABXMTQQdWVEbKM=
Date: Thu, 22 Aug 2024 11:30:31 -0700
To: mm-commits@vger.kernel.org,mhocko@suse.com,mgorman@techsingularity.net,lizefan.x@bytedance.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-the-null-ac-nodemask-in-__alloc_pages_slowpath.patch added to mm-unstable branch
Message-Id: <20240822183031.A359FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm:page_alloc: fix the NULL ac->nodemask in __alloc_pages_slowpath()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-the-null-ac-nodemask-in-__alloc_pages_slowpath.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-the-null-ac-nodemask-in-__alloc_pages_slowpath.patch

This patch will later appear in the mm-unstable branch at
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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm:page_alloc: fix the NULL ac->nodemask in __alloc_pages_slowpath()
Date: Thu, 22 Aug 2024 17:26:12 +0800

should_reclaim_retry() is not ALLOC_CPUSET aware and that means that it
considers reclaimability of NUMA nodes which are outside of the cpuset. 
If other nodes have a lot of reclaimable memory then should_reclaim_retry
would instruct page allocator to retry even though there is no memory
reclaimable on the cpuset nodemask.  This is not really a huge problem
because the number of retries without any reclaim progress is bound but it
could be certainly improved.  This is a cold path so this shouldn't really
have a measurable impact on performance on most workloads.

1.Test step and the machines.
------------
root@vm:/sys/fs/cgroup/test# numactl -H | grep size
node 0 size: 9477 MB
node 1 size: 10079 MB
node 2 size: 10079 MB
node 3 size: 10078 MB

root@vm:/sys/fs/cgroup/test# cat cpuset.mems
    2

root@vm:/sys/fs/cgroup/test# stress --vm 1 --vm-bytes 12g  --vm-keep
stress: info: [33430] dispatching hogs: 0 cpu, 0 io, 1 vm, 0 hdd
stress: FAIL: [33430] (425) <-- worker 33431 got signal 9
stress: WARN: [33430] (427) now reaping child worker processes
stress: FAIL: [33430] (461) failed run completed in 2s

2. reclaim_retry_zone info:

We can only alloc pages from node=2, but the reclaim_retry_zone is
node=0 and return true.

root@vm:/sys/kernel/debug/tracing# cat trace
stress-33431   [001] ..... 13223.617311: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=1 wmark_check=1
stress-33431   [001] ..... 13223.617682: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=2 wmark_check=1
stress-33431   [001] ..... 13223.618103: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=3 wmark_check=1
stress-33431   [001] ..... 13223.618454: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=4 wmark_check=1
stress-33431   [001] ..... 13223.618770: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=5 wmark_check=1
stress-33431   [001] ..... 13223.619150: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=6 wmark_check=1
stress-33431   [001] ..... 13223.619510: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=7 wmark_check=1
stress-33431   [001] ..... 13223.619850: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=8 wmark_check=1
stress-33431   [001] ..... 13223.620171: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=9 wmark_check=1
stress-33431   [001] ..... 13223.620533: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=10 wmark_check=1
stress-33431   [001] ..... 13223.620894: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=11 wmark_check=1
stress-33431   [001] ..... 13223.621224: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=12 wmark_check=1
stress-33431   [001] ..... 13223.621551: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=13 wmark_check=1
stress-33431   [001] ..... 13223.621847: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=14 wmark_check=1
stress-33431   [001] ..... 13223.622200: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=15 wmark_check=1
stress-33431   [001] ..... 13223.622580: reclaim_retry_zone: node=0 zone=Normal   order=0 reclaimable=4260 available=1772019 min_wmark=5962 no_progress_loops=16 wmark_check=1

With this patch, we can check the right node and get less retry in
__alloc_pages_slowpath() because there is nothing to do.

Link: https://lkml.kernel.org/r/20240822092612.3209286-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++++++
 mm/page_alloc.c |    5 +++++
 2 files changed, 11 insertions(+)

--- a/mm/compaction.c~mm-page_alloc-fix-the-null-ac-nodemask-in-__alloc_pages_slowpath
+++ a/mm/compaction.c
@@ -23,6 +23,7 @@
 #include <linux/freezer.h>
 #include <linux/page_owner.h>
 #include <linux/psi.h>
+#include <linux/cpuset.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -2822,6 +2823,11 @@ enum compact_result try_to_compact_pages
 					ac->highest_zoneidx, ac->nodemask) {
 		enum compact_result status;
 
+		if (cpusets_enabled() &&
+			(alloc_flags & ALLOC_CPUSET) &&
+			!__cpuset_zone_allowed(zone, gfp_mask))
+				continue;
+
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
--- a/mm/page_alloc.c~mm-page_alloc-fix-the-null-ac-nodemask-in-__alloc_pages_slowpath
+++ a/mm/page_alloc.c
@@ -4092,6 +4092,11 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		unsigned long min_wmark = min_wmark_pages(zone);
 		bool wmark;
 
+		if (cpusets_enabled() &&
+			(alloc_flags & ALLOC_CPUSET) &&
+			!__cpuset_zone_allowed(zone, gfp_mask))
+				continue;
+
 		available = reclaimable = zone_reclaimable_pages(zone);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-page_alloc-fix-the-null-ac-nodemask-in-__alloc_pages_slowpath.patch

