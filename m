Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E3C881E
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031242; cv=none; b=g/llX/I/ZCkLH7RAxrwvCzS3rKT2Jz/6ycCbhzuC0ON6Sf+oqAoXeAoM8gRXKlxeMjwv1rhxAM9PuIUBsk1NA7hBxHKV5oLbBiKtdhiNxnRLAkXW3m8ttkFUnqZjOBhzq/S8b0EOwdjClZ0HGvJbypwfZkWlfHXhhEX5mJERCIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031242; c=relaxed/simple;
	bh=d18BmcrCQi+45ji8bTBBMbkUIIYVl8LEjCfpRjRkkmQ=;
	h=Date:To:From:Subject:Message-Id; b=tVYPYdilQ+ME4p6vN0H7/8CskYMZjeXp1NC/la36VBubDXEoADdoztqtqOayrK5QAAY5r8mHklXsChW8Uv0DIKLzG5+Rqo7EvRg7n9En40CBnpG/qF3x2HTNGTYGo26zr20nle/NMP5hUc5bdJ0EpLgpXKTg8Kpaii9Bal9bdTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RhNsOpUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RhNsOpUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98F0C43390;
	Sun,  4 Feb 2024 07:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031242;
	bh=d18BmcrCQi+45ji8bTBBMbkUIIYVl8LEjCfpRjRkkmQ=;
	h=Date:To:From:Subject:From;
	b=RhNsOpUsA83nvFzGW49A1GVqQtR+GACUZYY9BLlw8yRYS2agNwFY4Di/q9ztH7rPX
	 8xt10opYT3o72vBZrraFb963J5AJ1tPv2jhqsb5fSQYaOFqaJsqES3WNna7rvmIFtj
	 hb6IsFmnKVMWrggZCkjENT5DGQyJQoCO4XUP7DnQ=
Date: Sat, 03 Feb 2024 23:20:41 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,dan.j.williams@intel.com,corbet@lwn.net,gourry.memverge@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch added to mm-unstable branch
Message-Id: <20240204072041.D98F0C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: refactor a read-once mechanism into a function for re-use
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch

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
Subject: mm/mempolicy: refactor a read-once mechanism into a function for re-use
Date: Fri, 2 Feb 2024 12:02:36 -0500

Move the use of barrier() to force policy->nodemask onto the stack into a
function `read_once_policy_nodemask` so that it may be re-used.

Link: https://lkml.kernel.org/r/20240202170238.90004-3-gregory.price@memverge.com
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
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

 mm/mempolicy.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use
+++ a/mm/mempolicy.c
@@ -1905,6 +1905,20 @@ unsigned int mempolicy_slab_node(void)
 	}
 }
 
+static unsigned int read_once_policy_nodemask(struct mempolicy *pol,
+					      nodemask_t *mask)
+{
+	/*
+	 * barrier stabilizes the nodemask locally so that it can be iterated
+	 * over safely without concern for changes. Allocators validate node
+	 * selection does not violate mems_allowed, so this is safe.
+	 */
+	barrier();
+	memcpy(mask, &pol->nodes, sizeof(nodemask_t));
+	barrier();
+	return nodes_weight(*mask);
+}
+
 /*
  * Do static interleaving for interleave index @ilx.  Returns the ilx'th
  * node in pol->nodes (starting from ilx=0), wrapping around if ilx
@@ -1912,20 +1926,12 @@ unsigned int mempolicy_slab_node(void)
  */
 static unsigned int interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 {
-	nodemask_t nodemask = pol->nodes;
+	nodemask_t nodemask;
 	unsigned int target, nnodes;
 	int i;
 	int nid;
-	/*
-	 * The barrier will stabilize the nodemask in a register or on
-	 * the stack so that it will stop changing under the code.
-	 *
-	 * Between first_node() and next_node(), pol->nodes could be changed
-	 * by other threads. So we put pol->nodes in a local stack.
-	 */
-	barrier();
 
-	nnodes = nodes_weight(nodemask);
+	nnodes = read_once_policy_nodemask(pol, &nodemask);
 	if (!nnodes)
 		return numa_node_id();
 	target = ilx % nnodes;
_

Patches currently in -mm which might be from gourry.memverge@gmail.com are

mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch
mm-mempolicy-introduce-mpol_weighted_interleave-for-weighted-interleaving.patch
mm-mempolicy-protect-task-interleave-functions-with-tsk-mems_allowed_seq.patch

