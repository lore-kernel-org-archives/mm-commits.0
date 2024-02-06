Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FB21798A
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 20:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707251115; cv=none; b=SW9o0kV//x6XTAxuIzGxrc9w62/Tr7LNuGAp+WK3npuZima5kD7Z9gq89WXUceIJIwYoT+fGI+8C3R0//gV1kq8/+PaejJInnHXEjBUCFrIM6YpbKcfOoYcryCgZISvuSXPFzLnJAq4pugaIPS2UqfdpLEZSmoWd8KWYEh1MrVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707251115; c=relaxed/simple;
	bh=w1g98L1u+RlVw0AOM5HtZfKIZJq8I7Ejt2Jonr593rk=;
	h=Date:To:From:Subject:Message-Id; b=pSH4M6q72nq9ZWOWD2jQ6cRNSleR8WfuewdFJ7kiYJCV9vpWYEonQv8v+wvC4pXrEc5Lker/dzga+gr1Js46tMzN9J1U0tF0CzGRAS5cYUo5OKOrSGrL8sME+phfo174A3PIdOXzQFofEVGhXtBPrq3Z8d9fxwfF8ftHb2g9j+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=htZ0Dt5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="htZ0Dt5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D6AC433F1;
	Tue,  6 Feb 2024 20:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707251115;
	bh=w1g98L1u+RlVw0AOM5HtZfKIZJq8I7Ejt2Jonr593rk=;
	h=Date:To:From:Subject:From;
	b=htZ0Dt5SHsKgqzFaKhBrfFx1uA/6gljkELts1bKwVE39LJmCMOEytGFP/EeqGHvHK
	 Jigs6o87NqaOafmQaraKj0WRtGU1bEPlPWr8RxUWjhTX0wQ86JFuW5CKFEDKXTenDD
	 4kBzq6OPPkcuBe1sinXP5AJiDlvTgDDrktUu52to=
Date: Tue, 06 Feb 2024 12:25:14 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,aneesh.kumar@linux.ibm.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-print-demotion-targets.patch added to mm-unstable branch
Message-Id: <20240206202514.F1D6AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/demotion: print demotion targets
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-print-demotion-targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-print-demotion-targets.patch

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
Cc: "Huang, Ying" <ying.huang@intel.com>
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

mm-demotion-print-demotion-targets.patch

