Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FBF4AE8C1;
	Wed, 16 Sep 2026 22:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596920; cv=none; b=ar2bWKa2RLrw6LT92fu1IzR2H+OZn/f/ino6oZPVWd9GGRhoBNcsDNbzv4KcI86EqiT/Pj5ru6DmxIVe9UavUjq1OlIj29e34lql0TwhoF8ESvdTPFro6AyosvfBvSDcALQFYMqjuaTF5qZ5e+VqKJx6fWs3uyb2HadN2OtpjlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596920; c=relaxed/simple;
	bh=BcS4qYQwUFjIMTWjKrMHWZrxpyReM/ldP5aMgd1MGoM=;
	h=Date:To:From:Subject:Message-Id; b=pR0BYrb7yDsINwWfVdJoxkXHvksJNnp0fdjVa+tLgx6B5d8eMpcw5wydRUVcCRiCyhftBY7DBdPMhee2ZPFwk1be/r65jBwPcouoI2RzCeaKaxmiEj2nXHuPYxEz4SiVa1i/StKqdjUCVWzaSIqK4RlVrB54z6GthBFIjG99/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tiyz7YV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tiyz7YV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD981F00893;
	Wed, 16 Sep 2026 22:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789596903;
	bh=dspbkvZxNyJ6/W6CRZsCEHNDPPHFZvB4n58u1ZRcltc=;
	h=Date:To:From:Subject;
	b=Tiyz7YV2m6/pwHDZ6jdmh4XVg3ecevI9T44/MIOV4ksGAcLrH3+Q+dXnzk+dw9436
	 vVaIVlKAhVZk2saJVx9SogJxvnE4kUGnRKa+6ZEr9LVq+5aJeQt+aPT35dDJlsnwWt
	 6ML2m5oKVnbHmrdj0MSCwEcrb8Blv/602OzSg178=
Date: Wed, 16 Sep 2026 15:15:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,mgorman@techsingularity.net,henry.willard@oracle.com,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,xiangzao@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-do-not-boost-watermarks-in-kdump-capture-kernels.patch added to mm-new branch
Message-Id: <20260916221503.8CD981F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: do not boost watermarks in kdump capture kernels
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-do-not-boost-watermarks-in-kdump-capture-kernels.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-do-not-boost-watermarks-in-kdump-capture-kernels.patch

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
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
Subject: mm/page_alloc: do not boost watermarks in kdump capture kernels
Date: Wed, 16 Sep 2026 19:25:45 +0800

A watermark boost is not confined to one watermark: wmark_pages() adds it
to min, low and high alike, so every watermark check sees it, including
should_reclaim_retry() and the last ditch ALLOC_WMARK_HIGH attempt in
__alloc_pages_may_oom().  Once the boost exceeds the memory still free the
allocator gives up and invokes the OOM killer, and a capture kernel that
is still booting has nothing to kill: the boot panics and the vmcore is
lost.

Seen on an arm64 machine with 64K pages, CONFIG_PAGE_BLOCK_MAX_ORDER=10
(pageblock = 64M) and crashkernel=512M, running a distribution kernel
based on 7.0.14.  A high order UNMOVABLE allocation fell back to a MOVABLE
pageblock while the capture kernel was still in do_initcalls():

  Node 0 DMA free:68096kB boost:65536kB min:68160kB
  low:68800kB high:69440kB managed:479168kB
  Out of memory and no killable processes...
  Kernel panic - not syncing: System is deadlocked on memory

The zone was not short of memory.  Subtracting the boost gives min:2624kB
low:3264kB high:3904kB, so the 68096kB still free sat 17 times above the
high watermark and the allocator would not even have entered its slow
path.  The boost supplied 65536kB of the 68160kB min and by itself put the
zone 64kB under water.  It is that large because boost_watermark() clamps
it with max(pageblock_nr_pages, max_boost); watermark_boost_factor alone
would have allowed 5824kB.

Commit 14f69140ff9c ("mm: limit boost_watermark on small zones") already
tried to protect capture kernels, but it infers them from the zone size
and skips the boost only below four pageblocks.  arm64 64K pageblocks were
512M then, so the guard reached zones up to 2G;
CONFIG_PAGE_BLOCK_MAX_ORDER can cap them at 64M, which shrinks the guard
to zones under 256M and lets this 468M zone through.

kdump is a property of the kernel, not of the zone, so test for it
directly.  A capture kernel exits within seconds and never uses the
fragmentation avoidance the boost buys.  Normal kernels are unaffected:
the size based check still covers their genuinely tiny zones.

Passing sysctl.vm.watermark_boost_factor=0 to the capture kernel does not
cover this window: sysctl.* parameters are written through procfs by
do_sysctl_args(), which runs after do_initcalls() where the panic above
happened, and watermark_boost_factor has no early_param of its own.

Link: https://lore.kernel.org/20260916112545.3707893-1-xiangzao@linux.alibaba.com
Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org> # v5.0
---

 mm/page_alloc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-do-not-boost-watermarks-in-kdump-capture-kernels
+++ a/mm/page_alloc.c
@@ -37,6 +37,7 @@
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
 #include <linux/compaction.h>
+#include <linux/crash_dump.h>
 #include <trace/events/kmem.h>
 #include <trace/events/oom.h>
 #include <linux/prefetch.h>
@@ -2160,10 +2161,17 @@ static inline bool boost_watermark(struc
 
 	if (!watermark_boost_factor)
 		return false;
+
+	/*
+	 * A kdump capture kernel exits before a boost can pay off, while
+	 * the raised watermark can exceed the memory left for the dump.
+	 */
+	if (is_kdump_kernel())
+		return false;
+
 	/*
 	 * Don't bother in zones that are unlikely to produce results.
-	 * On small machines, including kdump capture kernels running
-	 * in a small area, boosting the watermark can cause an out of
+	 * On small machines, boosting the watermark can cause an out of
 	 * memory situation immediately.
 	 */
 	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
_

Patches currently in -mm which might be from xiangzao@linux.alibaba.com are

mm-page_alloc-do-not-boost-watermarks-in-kdump-capture-kernels.patch

