Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6232D8BFD
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560202; cv=none; b=C9Pe+yVXlypKEbfCOBYBO7ZQeH7nx9TpsLZyecFtIqleyde8ncvzVx4vn3UnEb6hjsz5RIALCazCrSoFXVPgUPFCSONtDqR9TgQl2Te3pwnU0URWZTxqigyovH34VCMdP3l9Huy/N9oJdd2yNFsM2ArK8BatErmnkTaasa0pnEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560202; c=relaxed/simple;
	bh=I1wqNjImsdlFpPtZtfFeXaNTd58My0WFjJV4B+sax4E=;
	h=Date:To:From:Subject:Message-Id; b=BeVO8/+UUex01zq5SP2r+IRHc1YwuJGUelBAbUATyyPELI4ozugr36xsv1YxrVKrmLRFtXUr82R2KFc4wsXs9J4R64ellc9rSrQjCF58TISC7Nmas2e6f1RpVo8QluAf2xRD4meXudE9QwTfghtKR4cN48feeLLDUgiKS/Qr7ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OLZ5lyUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OLZ5lyUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3966AC43390;
	Thu, 22 Feb 2024 00:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560202;
	bh=I1wqNjImsdlFpPtZtfFeXaNTd58My0WFjJV4B+sax4E=;
	h=Date:To:From:Subject:From;
	b=OLZ5lyUxKY7iwWnjQ8D9+65s+NEWA7GoDTFZcmw1S5rotJpV/UXfPxL4BjFEWnm+2
	 diVohI764nRGqcFWX006/1g2R5ae+LwvId1cbfmhqEoTKTiY+hcTKrKo1lXbzx1XVn
	 dwlkjVB87uCR6vAa7FRZ6KnGY4e9whsU61gHpw9c=
Date: Wed, 21 Feb 2024 16:03:21 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,aneesh.kumar@linux.ibm.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-demotion-print-demotion-targets.patch removed from -mm tree
Message-Id: <20240222000322.3966AC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/demotion: print demotion targets
has been removed from the -mm tree.  Its filename was
     mm-demotion-print-demotion-targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/demotion: print demotion targets
Date: Tue, 6 Feb 2024 10:01:51 +0800

Currently, when a demotion occurs, it will prioritize selecting a node
from the preferred targets as the destination node for the demotion.  If
the preferred node does not meet the requirements, it will try from all
the lower memory tier nodes until it finds a suitable demotion destination
node or ultimately fails.

However, the demotion target information isn't exposed to the users,
especially the preferred target information, which relies on more factors.
This makes it hard for users to understand the exact demotion behavior.

Rather than having a new sysfs interface to expose this information,
printing directly to kernel messages, just like the current page
allocation fallback order does.

A dmesg example with this patch is as follows:
[    0.704860] Demotion targets for Node 0: null
[    0.705456] Demotion targets for Node 1: null
// node 2 is onlined
[   32.259775] Demotion targets for Node 0: perferred: 2, fallback: 2
[   32.261290] Demotion targets for Node 1: perferred: 2, fallback: 2
[   32.262726] Demotion targets for Node 2: null
// node 3 is onlined
[   42.448809] Demotion targets for Node 0: perferred: 2, fallback: 2-3
[   42.450704] Demotion targets for Node 1: perferred: 2, fallback: 2-3
[   42.452556] Demotion targets for Node 2: perferred: 3, fallback: 3
[   42.454136] Demotion targets for Node 3: null
// node 4 is onlined
[   52.676833] Demotion targets for Node 0: perferred: 2, fallback: 2-4
[   52.678735] Demotion targets for Node 1: perferred: 2, fallback: 2-4
[   52.680493] Demotion targets for Node 2: perferred: 4, fallback: 3-4
[   52.682154] Demotion targets for Node 3: null
[   52.683405] Demotion targets for Node 4: null
// node 5 is onlined
[   62.931902] Demotion targets for Node 0: perferred: 2, fallback: 2-5
[   62.938266] Demotion targets for Node 1: perferred: 5, fallback: 2-5
[   62.943515] Demotion targets for Node 2: perferred: 4, fallback: 3-4
[   62.947471] Demotion targets for Node 3: null
[   62.949908] Demotion targets for Node 4: null
[   62.952137] Demotion targets for Node 5: perferred: 3, fallback: 3-4

Regarding this requirement, we have previously discussed [1].  The initial
proposal involved introducing a new sysfs interface.  However, due to
concerns about potential changes and compatibility issues with the
interface in the future, a consensus was not reached with the community. 
Therefore, this time, we are directly printing out the information.

[1] https://lore.kernel.org/all/d1d5add8-8f4a-4578-8bf0-2cbe79b09989@fujitsu.com/

Link: https://lkml.kernel.org/r/20240206020151.605516-1-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/mm/memory-tiers.c~mm-demotion-print-demotion-targets
+++ a/mm/memory-tiers.c
@@ -359,6 +359,26 @@ static void disable_all_demotion_targets
 	synchronize_rcu();
 }
 
+static void dump_demotion_targets(void)
+{
+	int node;
+
+	for_each_node_state(node, N_MEMORY) {
+		struct memory_tier *memtier = __node_get_memory_tier(node);
+		nodemask_t preferred = node_demotion[node].preferred;
+
+		if (!memtier)
+			continue;
+
+		if (nodes_empty(preferred))
+			pr_info("Demotion targets for Node %d: null\n", node);
+		else
+			pr_info("Demotion targets for Node %d: preferred: %*pbl, fallback: %*pbl\n",
+				node, nodemask_pr_args(&preferred),
+				nodemask_pr_args(&memtier->lower_tier_mask));
+	}
+}
+
 /*
  * Find an automatic demotion target for all memory
  * nodes. Failing here is OK.  It might just indicate
@@ -443,7 +463,7 @@ static void establish_demotion_targets(v
 	 * Now build the lower_tier mask for each node collecting node mask from
 	 * all memory tier below it. This allows us to fallback demotion page
 	 * allocation to a set of nodes that is closer the above selected
-	 * perferred node.
+	 * preferred node.
 	 */
 	lower_tier = node_states[N_MEMORY];
 	list_for_each_entry(memtier, &memory_tiers, list) {
@@ -456,6 +476,8 @@ static void establish_demotion_targets(v
 		nodes_andnot(lower_tier, lower_tier, tier_nodes);
 		memtier->lower_tier_mask = lower_tier;
 	}
+
+	dump_demotion_targets();
 }
 
 #else
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are


