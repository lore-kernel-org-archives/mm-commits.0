Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CFBB658
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031244; cv=none; b=Acv29HZdLktLFpiUMmnAhivTLX1vt9u6Z3MvXzeh2tkT9PDAS658A8tySeg5s6dpAQl6azTRt2UevdI+mGbbaIOtk0uv4lBjPKPoM+zk/hKYlrRQFr31sh2WAjQMOMYmuGaptw8nvRUgHXBTnWdQM9Bf+CAoPMoWIN/PEQCsnkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031244; c=relaxed/simple;
	bh=T94gGtP8O9NeW4mJ90Iz4iRA/2hWb9cAESAKSjd4B/s=;
	h=Date:To:From:Subject:Message-Id; b=Zwz4pFMOs1iMp/DMo/0eMJ1Sw5ecOeWs6Ec1w5FYvKD0fd6+QdMP9c/ESKUBUf7SQrxH/nYpasOOVruNfsSVy+Fs4AMar422vOl6jPRJgbVg7jrY3XtHPovXV5CCmcrQKmE0vtfJJi28uExQhE5TPK4ThivjQUZdKG4EHp/bco0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SusMCa6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SusMCa6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C05C43399;
	Sun,  4 Feb 2024 07:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031243;
	bh=T94gGtP8O9NeW4mJ90Iz4iRA/2hWb9cAESAKSjd4B/s=;
	h=Date:To:From:Subject:From;
	b=SusMCa6QI8LSHW5cG7ibogPmsB1bIhADMOAlCLs91JQe2I4t58+Q97fI9u+2XJD6h
	 WBSpZn/+CGCfHTkcm5atBYpu6qi4gX2LkCCz0Bgc4bfYqJUP/g48WDTjSbPUHFRcTC
	 dx3T8eFpKER6FSVuQmizL762IdAND1ZE7EbSxyZg=
Date: Sat, 03 Feb 2024 23:20:42 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,dan.j.williams@intel.com,corbet@lwn.net,gourry.memverge@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch added to mm-unstable branch
Message-Id: <20240204072043.74C05C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: protect task interleave functions with tsk->mems_allowed_seq
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch

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
From: Gregory Price <gourry.memverge@gmail.com>
Subject: mm/mempolicy: protect task interleave functions with tsk->mems_allowed_seq
Date: Fri, 2 Feb 2024 12:02:38 -0500

In the event of rebind, pol->nodemask can change at the same time as an
allocation occurs.  We can detect this with tsk->mems_allowed_seq and
prevent a miscount or an allocation failure from occurring.

The same thing happens in the allocators to detect failure, but this can
prevent spurious failures in a much smaller critical section.

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

 mm/mempolicy.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq
+++ a/mm/mempolicy.c
@@ -1874,11 +1874,17 @@ bool apply_policy_zone(struct mempolicy
 
 static unsigned int weighted_interleave_nodes(struct mempolicy *policy)
 {
-	unsigned int node = current->il_prev;
+	unsigned int node;
+	unsigned int cpuset_mems_cookie;
 
-	if (!current->il_weight || !node_isset(node, policy->nodes)) {
+retry:
+	/* to prevent miscount use tsk->mems_allowed_seq to detect rebind */
+	cpuset_mems_cookie = read_mems_allowed_begin();
+	node = current->il_prev;
+	if (!node || !node_isset(node, policy->nodes)) {
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

mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch
mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving.patch
mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch

