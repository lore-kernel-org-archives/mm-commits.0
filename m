Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA935C96
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 20:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758312586; cv=none; b=CK5ookKpTKSbs1ckFbpwMsO5x8D9CESZImZngrglhSUwwc0M4KnCl3IV3YgDaALo4jhSdm5poZa0qxYEulmq28XGKDva5Zx5ol5DUcKnsvz7z5RrelWV0CAWjAgbjsxKDl/++Hi4WC0ap0SsKkyURyfhM96tcESMNAth2xyPeSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758312586; c=relaxed/simple;
	bh=xUIKzRavlyuMuEmTZBFohZhoJmRmMsvztqfSPOL+DiI=;
	h=Date:To:From:Subject:Message-Id; b=R0S6RJ23a0UMNOBROLpwzONU5LXAVcXFT44saF26v8bLG4km/7aWkJUnipzQhkrPCybUiJ5ls4cOukk7d8NyE8znQBbw9i/6w6TWROE34PafK7XejxTqpn1Qbob18gBxmfbtFsu8nodtljHTNq4K89HCje0+Ei07T74b3hxHbzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pqMtb01+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pqMtb01+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF71DC4CEF0;
	Fri, 19 Sep 2025 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758312585;
	bh=xUIKzRavlyuMuEmTZBFohZhoJmRmMsvztqfSPOL+DiI=;
	h=Date:To:From:Subject:From;
	b=pqMtb01+dbzmoSMj1ZUQn8JExlEUThnd/zKfrG1b/qh/myFrZW26YFLh1AJ4tshEA
	 zh9NL/Q0UXzwcpBt2g7HfyXJu9SrJ32jgMYy9K5+xqyoSGIZopm6+ZG148DaCSl6LZ
	 9cGOESXf4OKIlt5udqhwVNlO0d49M9X6yi0y5lb8=
Date: Fri, 19 Sep 2025 13:09:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,joshua.hahnjy@gmail.com,jackmanb@google.com,gourry@gourry.net,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions.patch added to mm-unstable branch
Message-Id: <20250919200945.CF71DC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions.patch

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

mm-zswap-interact-directly-with-zsmalloc.patch
mm-zswap-interact-directly-with-zsmalloc-fix.patch
mm-remove-unused-zpool-layer.patch
mm-zpdesc-minor-naming-and-comment-corrections.patch
mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions.patch

