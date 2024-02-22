Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8D6631
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560141; cv=none; b=u8Y4Uc0S6u+7T5E9ovrKtRjJYhw0Ejuf/Gag9065362X01jThJSoKVQ/bqvtQO06IWh+kmGbmD93FcasdWcxGUuYqYdiYR442iqh5TwkAyxCe6qoPqVx8g7IYT18JnEmIT0vNF/dbuRrEoTcTdUwJK+tZt1sWkOqUjE/EHj+2FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560141; c=relaxed/simple;
	bh=fufKjXA92pQ+gedOXlb3NiBYEQGbIB0dO7geEittgYI=;
	h=Date:To:From:Subject:Message-Id; b=qMnkdlrvt0hQZzz65qjW9WOiG2E3yzbDjcrMdvtAZIkaCiLwGH9LRPZ/sA9kZciql+cKBkIyXV/46pD+Rnfg3ZBPqpHITiqahfOk6gZWv4Tftd43FoWqdis2LJdhf+ZumozoLqQ4gUX4HGjvtw5FjMSp1Lbvt0z/ZO77dUDnEaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UylXGhTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UylXGhTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA19C43394;
	Thu, 22 Feb 2024 00:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560140;
	bh=fufKjXA92pQ+gedOXlb3NiBYEQGbIB0dO7geEittgYI=;
	h=Date:To:From:Subject:From;
	b=UylXGhTudHErahRuXc1ifmdTP5Hi9TaG5M+JiSLfX+6SkyQlCFqgHBy4Rl4qFfGRk
	 ydEvPUaRkE4vvS1lcNxjRAsYjzwCZjO+CHdq69Fjm8ZRw+5e4ra+ipMHPWTfuZmCEo
	 kArZmOC95Mp6+3kkmISeg4/gploZOY/CbEd/xrGU=
Date: Wed, 21 Feb 2024 16:02:20 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@kernel.org,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,dan.j.williams@intel.com,corbet@lwn.net,gourry.memverge@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch removed from -mm tree
Message-Id: <20240222000220.BDA19C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: refactor a read-once mechanism into a function for re-use
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


