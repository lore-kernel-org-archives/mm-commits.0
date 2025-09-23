Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2982512DE
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597505; cv=none; b=L3htDxxhI3M+ZjNMXFPfx8jIo3Y74xES22w7/PAhxIX8CZxO7uog0H+6vQC/qxZN1za2+5/+a0sZGAFTw+EMIPpBSoE5KoOKLeYwgTA9rkeoXx1ISJn72VhTKpncEJpLQhKcNzEEi8Y7ptuRkNTdsT5Cj6BZBPzdz2lt0OBFMWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597505; c=relaxed/simple;
	bh=zZgAwp7XhL/VgXstqGZFKE41mDRnLNfsq8YnurBc4tg=;
	h=Date:To:From:Subject:Message-Id; b=ZhqHq/Jb82tBLUr5MXVSeTpzpwVpShb3IY9evTVnMjDd2Yx60Z3d741gNWgKDK6ye0n38A7JzS/8d/VegDYokU3eQ9uaq40LCXTStmpWkMOsBl7zMF6kUNjKxskOggu9e46e+YRsDM0SvgmnSR0LVqPwR5bnmlxIY119fXc91bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2JQRYQDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2JQRYQDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF10C4CEF0;
	Tue, 23 Sep 2025 03:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597505;
	bh=zZgAwp7XhL/VgXstqGZFKE41mDRnLNfsq8YnurBc4tg=;
	h=Date:To:From:Subject:From;
	b=2JQRYQDiNFx6wLg/ALeODQOBpSftAPgHWjK/X4EW5drvj3bzSBKEYdi0M2NtkIIEE
	 gxobYdCLWkVxqdlzZ1QuXwcjNbPqPRhlodwPtlCgl5dCzYI6Mut/+a8bOTsV3OD2w+
	 uYknRw9Z7bktNwa7Eytnba0htgMvmvUW0FYaPfkY=
Date: Mon, 22 Sep 2025 20:18:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,joshua.hahnjy@gmail.com,jackmanb@google.com,gourry@gourry.net,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions.patch removed from -mm tree
Message-Id: <20250923031825.8FF10C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions
Date: Fri, 19 Sep 2025 12:21:34 -0400

On NUMA systems without bindings, allocations check all nodes for free
space, then wake up the kswapds on all nodes and retry. This ensures
all available space is evenly used before reclaim begins. However,
when one process or certain allocations have node restrictions, they
can cause kswapds on only a subset of nodes to be woken up.

Since kswapd hysteresis targets watermarks that are *higher* than
needed for allocation, even *unrestricted* allocations can now get
suckered onto such nodes that are already pressured. This ends up
concentrating all allocations on them, even when there are idle nodes
available for the unrestricted requests.

This was observed with two numa nodes, where node0 is normal and node1
is ZONE_MOVABLE to facilitate hotplugging: a kernel allocation wakes
kswapd on node0 only (since node1 is not eligible); once kswapd0 is
active, the watermarks hover between low and high, and then even the
movable allocations end up on node0, only to be kicked out again;
meanwhile node1 is empty and idle.

Similar behavior is possible when a process with NUMA bindings is
causing selective kswapd wakeups.

To fix this, on NUMA systems augment the (misleading) watermark test
with a check for whether kswapd is already active during the first
iteration through the zonelist. If this fails to place the request,
kswapd must be running everywhere already, and the watermark test is
good enough to decide placement.

With this patch, unrestricted requests successfully make use of node1,
even while kswapd is reclaiming node0 for restricted allocations.

[gourry@gourry.net: don't retry if no kswapds were active]
Link: https://lkml.kernel.org/r/20250919162134.1098208-1-hannes@cmpxchg.org
Signed-off-by: Gregory Price <gourry@gourry.net>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions
+++ a/mm/page_alloc.c
@@ -3735,6 +3735,8 @@ get_page_from_freelist(gfp_t gfp_mask, u
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool skip_kswapd_nodes = nr_online_nodes > 1;
+	bool skipped_kswapd_nodes = false;
 
 retry:
 	/*
@@ -3797,6 +3799,19 @@ retry:
 			}
 		}
 
+		/*
+		 * If kswapd is already active on a node, keep looking
+		 * for other nodes that might be idle. This can happen
+		 * if another process has NUMA bindings and is causing
+		 * kswapd wakeups on only some nodes. Avoid accidental
+		 * "node_reclaim_mode"-like behavior in this case.
+		 */
+		if (skip_kswapd_nodes &&
+		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
+			skipped_kswapd_nodes = true;
+			continue;
+		}
+
 		cond_accept_memory(zone, order, alloc_flags);
 
 		/*
@@ -3889,6 +3904,15 @@ try_this_zone:
 	}
 
 	/*
+	 * If we skipped over nodes with active kswapds and found no
+	 * idle nodes, retry and place anywhere the watermarks permit.
+	 */
+	if (skip_kswapd_nodes && skipped_kswapd_nodes) {
+		skip_kswapd_nodes = false;
+		goto retry;
+	}
+
+	/*
 	 * It's possible on a UMA machine to get through all zones that are
 	 * fragmented. If avoiding fragmentation, reset and try again.
 	 */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


