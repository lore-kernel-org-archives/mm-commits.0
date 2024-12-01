Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAFF2E40B;
	Sun,  1 Dec 2024 08:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733041852; cv=none; b=Yd1QMiTom3YjzSH1OQtnxO9zp3uj1d7+bPPV5NpwLAAbjhAxZ8vxACaSpRss4J/bj9Y6m96jyoigulNehOKAX//6Uw3vXvJwbjHVv0l+wxS12Y/4uwcc4kSv0/JnzLyRrjinZ4xTXkjc0cNGEHnB1lbrVRh6Y08DluHPttlxdRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733041852; c=relaxed/simple;
	bh=6chgIAvmaHO2y5o6qDt4BSlNVjyjL4RA0uj4x3KjJkM=;
	h=Date:To:From:Subject:Message-Id; b=oHoPdx89GIGatMXQtEdw5kk2jsgSNDEKncp5DzIhBONZ+MrdvsXMHe6HVlTtxhm871j3E5GQpZ71KqkU5c3H6CtP2sOscJ17hb1sn4Tym/5OCcdKulePY/qALhVn/u51/xgYCmuTnnOvHiJX3TeKWfV50Ni8vcmFDMRlaEmYcqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jazW1jqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jazW1jqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F95DC4CECF;
	Sun,  1 Dec 2024 08:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733041851;
	bh=6chgIAvmaHO2y5o6qDt4BSlNVjyjL4RA0uj4x3KjJkM=;
	h=Date:To:From:Subject:From;
	b=jazW1jqE3SoBeWfFNGPtHTdgTHR82uZKYInNiZvNvVd4qtck9coAPCwz6zW1sYRJR
	 KMowmbquy4SMQGXVRRu2UeC076Pklh/269WwIpf/R07I0yljxygi5S8S4mBJ7npMUM
	 PYYUpyrdTSxp83uAOc/SeBtv5OpTOxRsHgGAdoeU=
Date: Sun, 01 Dec 2024 00:30:51 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mgorman@techsingularity.net,snishika@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active.patch removed from -mm tree
Message-Id: <20241201083051.8F95DC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: ensure kswapd is woken up if the wait queue is active
has been removed from the -mm tree.  Its filename was
     mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Seiji Nishikawa <snishika@redhat.com>
Subject: mm: vmscan: ensure kswapd is woken up if the wait queue is active
Date: Wed, 27 Nov 2024 00:06:12 +0900

Even after commit 501b26510ae3 ("vmstat: allow_direct_reclaim should use
zone_page_state_snapshot"), a task may remain indefinitely stuck in
throttle_direct_reclaim() while holding mm->rwsem.

__alloc_pages_nodemask
 try_to_free_pages
  throttle_direct_reclaim

This can cause numerous other tasks to wait on the same rwsem, leading
to severe system hangups:

[1088963.358712] INFO: task python3:1670971 blocked for more than 120 seconds.
[1088963.365653]       Tainted: G           OE     -------- -  - 4.18.0-553.el8_10.aarch64 #1
[1088963.373887] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[1088963.381862] task:python3         state:D stack:0     pid:1670971 ppid:1667117 flags:0x00800080
[1088963.381869] Call trace:
[1088963.381872]  __switch_to+0xd0/0x120
[1088963.381877]  __schedule+0x340/0xac8
[1088963.381881]  schedule+0x68/0x118
[1088963.381886]  rwsem_down_read_slowpath+0x2d4/0x4b8

The issue arises when allow_direct_reclaim(pgdat) returns false,
preventing progress even when the pgdat->pfmemalloc_wait wait queue is
empty. Despite the wait queue being empty, the condition,
allow_direct_reclaim(pgdat), may still be returning false, causing it to
continue looping.

In some cases, reclaimable pages exist (zone_reclaimable_pages() returns
 > 0), but calculations of pfmemalloc_reserve and free_pages result in
wmark_ok being false.

And then, despite the pgdat->kswapd_wait queue being non-empty, kswapd
is not woken up, further exacerbating the problem:

crash> px ((struct pglist_data *) 0xffff00817fffe540)->kswapd_highest_zoneidx
$775 = __MAX_NR_ZONES

The issue likely occurs under specific conditions: high memory pressure
with frequent direct reclaim, contention on mmap_sem from concurrent
memory allocations, reclaimable pages exist, but zone states cause
wmark_ok to return false.

Modern workloads (e.g., Python multiprocessing) and changes in kernel
reclaim logic may have surfaced such edge cases more prominently than
before.

The workload involves concurrent Python processes under high memory
pressure, leading to contention on mmap_sem.  While not unusual, this
workload may trigger a rare combination of conditions that expose the
issue.

This patch modifies allow_direct_reclaim() to wake kswapd if the
pgdat->kswapd_wait queue is active, regardless of whether wmark_ok is true
or false.  This change ensures kswapd does not miss wake-ups under high
memory pressure, reducing the risk of task stalls in the throttled reclaim
path.

Link: https://lkml.kernel.org/r/20241126150612.114561-1-snishika@redhat.com
Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-ensure-kswapd-is-woken-up-if-the-wait-queue-is-active
+++ a/mm/vmscan.c
@@ -6389,8 +6389,8 @@ static bool allow_direct_reclaim(pg_data
 
 	wmark_ok = free_pages > pfmemalloc_reserve / 2;
 
-	/* kswapd must be awake if processes are being throttled */
-	if (!wmark_ok && waitqueue_active(&pgdat->kswapd_wait)) {
+	/* Always wake up kswapd if the wait queue is not empty */
+	if (waitqueue_active(&pgdat->kswapd_wait)) {
 		if (READ_ONCE(pgdat->kswapd_highest_zoneidx) > ZONE_NORMAL)
 			WRITE_ONCE(pgdat->kswapd_highest_zoneidx, ZONE_NORMAL);
 
_

Patches currently in -mm which might be from snishika@redhat.com are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim.patch

