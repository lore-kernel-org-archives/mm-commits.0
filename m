Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793335964;
	b=Kz27fF10z5lykihBBbpboP3k0rdib4SZwD5CJQt1aXFGZ/UoWOAI5+hS9S7/Gbl5shvH
	 +rv+MtJmT7kiPwvP0hN8IRWZyxLHXAvAcZWMDh93QL4R9uQJWUPb8rqJyKJXVHJLTfBA5
	 V5GY3juM0en1o+4ThASOjqVKF/IE4S8hMPb63v7Vc2hGZheJEWV01pDNqKWGwU+xGRJkb
	 4LDwBSP1fDg27GRviJ9WfszEmCgmoOCpNlhv+v8z1mo2xVvzfE1y01h51N7KF46cb8wL9
	 aDZKRI2LN9dQUgMxwqzzl0FBt0O+xdUJiU9WinJy/UaE64zsBU4CY/1aKKhCcOub1zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793335964;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=H8y0e8cOE76drk6O7TL8+hK6KegwXNg0BtyHtvfa9JQ=;
	b=pWejHFQl3L4KxcXDY5TwRw8dPo0HV28WfCaJUkDTEqUd/QfBE9CxuDsGBAEnpOR+NA/D
	 33awVc/NPj8eFmTWLjJzfLFoJcaDjeFbBroV5QcdE8u1rnGt6hpknGPBdh8IXnnM++tvZ
	 zJzrbcfvyhToHZacdVezoe0tdpS24fzwrXs3iolIxazF8PNIgue3gYcLy1fX7eHO0eoAC
	 lFAnzqtEKV01D3NvClXNxVQi9537Nfa3pyQvH0w3dfL51ENxJPnnJ9El7HInxDe7twXTU
	 EBLD42CR1CApnIK7eZ1IAjb4k8eNq/Am+8/NSGmDUNtFX/JRybOU3WG3Zh3ULNGtHUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iewjj6Jf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE2606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 04:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iewjj6Jf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DEB1F000C1;
	Fri, 30 Oct 2026 04:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793335963;
	bh=H8y0e8cOE76drk6O7TL8+hK6KegwXNg0BtyHtvfa9JQ=;
	h=Date:To:From:Subject;
	b=iewjj6Jfbw+0dQqlUOP1zC2Ej/nOHgR7NdGLVp8HSEfIcNcQd4wx9a3YjZNRWAz7i
	 5jDLjXz/73LEQlEWOrN3xpzozXe8HUxdmLeALp1rk3uBb+nPs3PwO7ILIYlQiuUz1b
	 SnpRDJX/r3ub8btJx6qGAHK9h6hXZd7ot47b1Tm8=
Date: Thu, 29 Oct 2026 21:52:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	weixugc@google.com,rakie.kim@sk.com,joshua.hahnjy@gmail.com,david@kernel.org,
	aneesh.kumar@linux.ibm.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch added to mm-new branch
Message-Id: <20261030045243.23DEB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memory-tiers: reset demotion targets of nodes without memory
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch

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
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: mm/memory-tiers: reset demotion targets of nodes without memory
Date: Tue, 20 Oct 2026 22:44:38 -0400

When a node loses its last memory, offline_pages() clears N_MEMORY before
the memory-tier callback rebuilds the demotion targets. 
disable_all_demotion_targets() resets only N_MEMORY nodes, so the node
keeps its old node_demotion[] entry while it has no memory.  Before
6c542ab75714, the reset covered every online node.

A reclaimer reads the stale entry only between the node regaining memory
and its targets being rebuilt, and it filters the entry against the
current allowed targets, so there is no user-visible effect.  To see it,
online and then offline a node's only DIMM: a debugger still finds the
lower-tier node in node_demotion[nid].preferred.

Reset the targets of every node.

Link: https://lore.kernel.org/20261021024438.1942502-1-gourry@gourry.net
Fixes: 6c542ab75714 ("mm/demotion: build demotion targets based on explicit memory tiers")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---

 mm/memory-tiers.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memory-tiers.c~mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory
+++ a/mm/memory-tiers.c
@@ -378,7 +378,11 @@ static void disable_all_demotion_targets
 	struct memory_tier *memtier;
 	int node;
 
-	for_each_node_state(node, N_MEMORY) {
+	/*
+	 * When the NODE_REMOVED_LAST_MEMORY event fires, N_MEMORY has already
+	 * been dropped from the node, so we must walk every node instead.
+	 */
+	for_each_node(node) {
 		node_demotion[node].preferred = NODE_MASK_NONE;
 		/*
 		 * We are holding memory_tier_lock, it is safe
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch
mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch

