Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675A65F
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560143; cv=none; b=Jfm6/lnEPO2HNHPHEJs1x1XmZzgd3XZqobwawarWTG9mscA5+dPnmGOhERt4d6wW5t+NxXsA34sO0EYry9v6zqIKzvL0CE7en6sGHX4KhuvqT457Y387LFAtZs02UzfkUAY0YBGzVEn2NOIB1SAzZ6VnLgg1Qp5OiXRVuWikD34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560143; c=relaxed/simple;
	bh=Our2FkvwEFWUwYV1qo3oP+HW3wNbY5O+ggawLxh2Goc=;
	h=Date:To:From:Subject:Message-Id; b=o0mxXZI2mku57SzD8ef57zgb1+R3+TImIiizAITDQFAUjp/DDtaiYnfRsVQfhxxuwli91IdNL0XODEOJAlSdKRSyT0LW6I8NITLOEpoG32FE3nBjOaPoVQjOkG7bpZea3SZN9bE9djMmRbtsIEL+CZoQ9hcqif42Y57U7TpZcfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fzgwPw3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fzgwPw3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59E6C43394;
	Thu, 22 Feb 2024 00:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560142;
	bh=Our2FkvwEFWUwYV1qo3oP+HW3wNbY5O+ggawLxh2Goc=;
	h=Date:To:From:Subject:From;
	b=fzgwPw3QunMmEcIsx3oO5ve0sTMcvgohJBQLTMlbG8aru7h3afvl4jd5l/mEKmIQN
	 ImIviUN/iYbY4urbS6FFJdrxcVrJvNOG0gRlP90DEGVmeHglF8JVq5Lp2QXk7fPG/c
	 DoFjSrxkOnVJ7LQ4KVXYFtMeQ5V1XO9MZ8pEJY9w=
Date: Wed, 21 Feb 2024 16:02:22 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,dan.j.williams@intel.com,corbet@lwn.net,gourry.memverge@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch removed from -mm tree
Message-Id: <20240222000222.D59E6C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: protect task interleave functions with tsk->mems_allowed_seq
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry.memverge@gmail.com>
Subject: mm/mempolicy: protect task interleave functions with tsk->mems_allowed_seq
Date: Fri, 2 Feb 2024 12:02:38 -0500

In the event of rebind, pol->nodemask can change at the same time as an
allocation occurs.  We can detect this with tsk->mems_allowed_seq and
prevent a miscount or an allocation failure from occurring.

The same thing happens in the allocators to detect failure, but this can
prevent spurious failures in a much smaller critical section.

[gourry.memverge@gmail.com: weighted interleave checks wrong parameter]
  Link: https://lkml.kernel.org/r/20240206192853.3589-1-gregory.price@memverge.com
Link: https://lkml.kernel.org/r/20240202170238.90004-5-gregory.price@memverge.com
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hasan Al Maruf <Hasan.Maruf@amd.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq
+++ a/mm/mempolicy.c
@@ -1874,11 +1874,17 @@ bool apply_policy_zone(struct mempolicy
 
 static unsigned int weighted_interleave_nodes(struct mempolicy *policy)
 {
-	unsigned int node = current->il_prev;
+	unsigned int node;
+	unsigned int cpuset_mems_cookie;
 
+retry:
+	/* to prevent miscount use tsk->mems_allowed_seq to detect rebind */
+	cpuset_mems_cookie = read_mems_allowed_begin();
+	node = current->il_prev;
 	if (!current->il_weight || !node_isset(node, policy->nodes)) {
 		node = next_node_in(node, policy->nodes);
-		/* can only happen if nodemask is being rebound */
+		if (read_mems_allowed_retry(cpuset_mems_cookie))
+			goto retry;
 		if (node == MAX_NUMNODES)
 			return node;
 		current->il_prev = node;
@@ -1892,8 +1898,14 @@ static unsigned int weighted_interleave_
 static unsigned int interleave_nodes(struct mempolicy *policy)
 {
 	unsigned int nid;
+	unsigned int cpuset_mems_cookie;
+
+	/* to prevent miscount, use tsk->mems_allowed_seq to detect rebind */
+	do {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		nid = next_node_in(current->il_prev, policy->nodes);
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 
-	nid = next_node_in(current->il_prev, policy->nodes);
 	if (nid < MAX_NUMNODES)
 		current->il_prev = nid;
 	return nid;
@@ -2370,6 +2382,7 @@ static unsigned long alloc_pages_bulk_ar
 		struct page **page_array)
 {
 	struct task_struct *me = current;
+	unsigned int cpuset_mems_cookie;
 	unsigned long total_allocated = 0;
 	unsigned long nr_allocated = 0;
 	unsigned long rounds;
@@ -2387,7 +2400,13 @@ static unsigned long alloc_pages_bulk_ar
 	if (!nr_pages)
 		return 0;
 
-	nnodes = read_once_policy_nodemask(pol, &nodes);
+	/* read the nodes onto the stack, retry if done during rebind */
+	do {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		nnodes = read_once_policy_nodemask(pol, &nodes);
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+	/* if the nodemask has become invalid, we cannot do anything */
 	if (!nnodes)
 		return 0;
 
_

Patches currently in -mm which might be from gourry.memverge@gmail.com are


