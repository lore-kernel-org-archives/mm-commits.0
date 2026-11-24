Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795550453;
	b=4LEBmNHxBlnsMvrw++RQnkpLjH9CQDTOSxGJf49AxsRS3oGOGssvorpigWOmQKIeT2Em
	 be7lx8NFeJL/rlw0Yu6mzy3cbLPt/pbGkBm3C6YopwMugChS3RNnKX+vJvr3BetbP8Ha9
	 qTQaaC5UT70DrZXuc+FzIBjs2lXQWNv7JSLkLynDBN/1bWE61PRRxRB+cARfu/7f+fkPh
	 hqPjQ2uWrzVnfk2UPeylKTiIePS8MNnJ/w4WmbGVR6RhmCjcXM9brOa8ayJ/wCxGO1vvL
	 abxE0sdLviRc2FshasRNo9QASNNXF1NeyBZxS0k/GPWdVYwVE3KWaod2FT6Qwhk9vxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795550453;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Obzt7eYiFlPA1fqyC4bKsThd9NdppUH264CL6XsP+LE=;
	b=tr3Aj0z/xIMj73v0VXpqgFSvCcqKpgjbdm6CIBL7uXTTWnDC2YImALkRxEfbdX+HypVH
	 uoI00OfhWGs7Aa4wOpXz2/TvjoFI0pQofljoImxPvrbtclM8dNE8hstj4iuT2HX/PDEQM
	 L1M0Z5ImzI4dZ3qMVfsdEiCDxBUto/TTC7GdfjzIbrXYoVKaqfZzBb59AYspgIHRKfzjk
	 lFwpfqjgymj5tHI2Lc3vsHYAc6YzonQW7SnBJ/ugmKdXXWU+TMd80fCb/Pr2Gt+O/u+HB
	 yR6ndJ7h61O4SmeXs1Nk4fyR8sk8j1laT76z6/pjzv/K/sBoA8zOXwwhSKKsMtSBTIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YJxmcDdq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6F0606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 20:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YJxmcDdq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14E71F000C6;
	Tue, 24 Nov 2026 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795550452;
	bh=Obzt7eYiFlPA1fqyC4bKsThd9NdppUH264CL6XsP+LE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=YJxmcDdqjjR1dvEzSj9qCzzwGomLUwVusP5NquCbLPfStZoxjZynaZVUaaWWYCz3r
	 KcTKtsyqFL2/LlccKZhC2ik1fSck4y/wjVGQEtKKUvCzvC8w89TMEpFUuXOeho2BLa
	 ZK7b+gHM+xef6yEyTCoW4ELvd3Yzx/vgvIU47Yyg=
Date: Tue, 24 Nov 2026 12:00:52 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	weixugc@google.com,rakie.kim@sk.com,joshua.hahnjy@gmail.com,david@kernel.org,
	aneesh.kumar@linux.ibm.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261021024438.1942502-1-gourry@gourry.net>
References: <20261021024438.1942502-1-gourry@gourry.net>
Subject: [merged mm/core.git: for-next] mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch removed from -mm tree
Message-Id: <20261124200052.B14E71F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memory-tiers: reset demotion targets of nodes without memory
has been removed from the -mm tree.  Its filename was
     mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch

This patch was dropped because it was merged into mm/core.git: for-next

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

Link: https://patch.msgid.link/20261021024438.1942502-1-gourry@gourry.net
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

mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch
selftests-mm-add-madv_cold-and-madv_pageout-contract-tests.patch
selftests-mm-check-madv_cold-and-madv_pageout-range-handling.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch
selftests-mm-check-madv_pageout-file-permissions.patch
selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch
mm-hmm-reject-shadow-stack-mappings.patch

