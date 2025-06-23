Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4783F223714
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 21:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715415; cv=none; b=rlLmIT5+0PDPKznr0tjxAqN2a1XI3b5GFRzXeS0+A+DlPKOsJU94x2MgIEDhOnllwQ8XP6aWHTQOR67sitiaAWS8gSMqOtmIliY/WNoJ7A1xupxCK/eZLlN+Bj+dgf0NqfY3k9Sm0SoAxDwG9RajiVz87nMG+rfnVqi+ig64j+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715415; c=relaxed/simple;
	bh=fep2/t4KuEWrSwquDqtoAXK3HqWFYlA0sKpMdpVJN8s=;
	h=Date:To:From:Subject:Message-Id; b=m2XHubijRj2yDyBQBJdz2FP4m/c++J8wZS1mUQ4wGdvDqWCFOVQnkJUXobhXWotqrE8fszFjFAs3iwbQQsUY3gcD3kRmv7xUrIlUoZsT6lREPeJ34CGhmBCYPmkseilwHtXoaMsVyj62mMR+VqM5n6YibE+TpIKr6vIhwQDz4Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ymTZWIyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ymTZWIyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AE7C4CEEA;
	Mon, 23 Jun 2025 21:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750715415;
	bh=fep2/t4KuEWrSwquDqtoAXK3HqWFYlA0sKpMdpVJN8s=;
	h=Date:To:From:Subject:From;
	b=ymTZWIywR73H65sgT8imTp3f3lXsz7evTBEb3CvJIg4do4Zxx7gQnOk0XGuk9JV7M
	 bwQjLHiXwQXtdM2WhV0OYdXWMhDzbxfT60980EWjEOak7au5R/ov5iL3HJDdmlVyLx
	 lOZN2vj2cqSolKHyAvgURZcVZ5XrVG2lbfuJ3nWg=
Date: Mon, 23 Jun 2025 14:50:14 -0700
To: mm-commits@vger.kernel.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch added to mm-new branch
Message-Id: <20250623215015.11AE7C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: respect psi_memstall region in node reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch

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
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/vmscan: respect psi_memstall region in node reclaim
Date: Mon, 23 Jun 2025 11:58:48 -0700

Patch series "mm: per-node proactive reclaim", v2.

This adds support for allowing proactive reclaim in general on a NUMA
system.  A per-node interface extends support for beyond a memcg-specific
interface, respecting the current semantics of memory.reclaim: respecting
aging LRU and not supporting artificially triggering eviction on nodes
belonging to non-bottom tiers.

This patch allows userspace to do:

     echo 512M swappiness=10 > /sys/devices/system/node/nodeX/reclaim

One of the premises for this is to semantically align as best as possible
with memory.reclaim.  During a brief time memcg did support nodemask until
55ab834a86a9 (Revert "mm: add nodes= arg to memory.reclaim"), for which
semantics around reclaim (eviction) vs demotion were not clear, rendering
charging expectations to be broken.

With this approach:

1. Users who do not use memcg can benefit from proactive reclaim.

2. Proactive reclaim on top tiers will trigger demotion, for which
   memory is still byte-addressable.  Reclaiming on the bottom nodes will
   trigger evicting to swap (the traditional sense of reclaim).  This
   follows the semantics of what is today part of the aging process on
   tiered memory, mirroring what every other form of reclaim does
   (reactive and memcg proactive reclaim).  Furthermore per-node proactive
   reclaim is not as susceptible to the memcg charging problem mentioned
   above.

3. Unlike memcg, there should be no surprises of callers expecting
   reclaim but instead got a demotion.  Essentially relying on behavior of
   shrink_folio_list() after 6b426d071419 ("mm: disable top-tier fallback
   to reclaim on proactive reclaim"), without the expectations of
   try_to_free_mem_cgroup_pages().

4. Unlike the nodes= arg, this interface avoids confusing semantics,
   such as what exactly the user wants when mixing top-tier and low-tier
   nodes in the nodemask.  Further per-node interface is less exposed to
   "free up memory in my container" usecases, where eviction is intended.

5. Users that *really* want to free up memory can use proactive
   reclaim on nodes knowingly to be on the bottom tiers to force eviction
   in a natural way - higher access latencies are still better than swap. 
   If compelled, while no guarantees and perhaps not worth the effort,
   users could also also potentially follow a ladder-like approach to
   eventually free up the memory.  Alternatively, perhaps an 'evict'
   option could be added to the parameters for both memory.reclaim and
   per-node interfaces to force this action unconditionally.


This patch (of 4):

... rather benign but keep proper ending order.

Link: https://lkml.kernel.org/r/20250623185851.830632-1-dave@stgolabs.net
Link: https://lkml.kernel.org/r/20250623185851.830632-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-respect-psi_memstall-region-in-node-reclaim
+++ a/mm/vmscan.c
@@ -7651,8 +7651,8 @@ static int __node_reclaim(struct pglist_
 	set_task_reclaim_state(p, NULL);
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc.gfp_mask);
-	psi_memstall_leave(&pflags);
 	delayacct_freepages_end();
+	psi_memstall_leave(&pflags);
 
 	trace_mm_vmscan_node_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch
mm-memcg-make-memoryreclaim-interface-generic.patch
mm-vmscan-make-__node_reclaim-more-generic.patch
mm-introduce-per-node-proactive-reclaim-interface.patch

