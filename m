Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A11818040
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 22:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQ+zdaMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA554C433C7;
	Fri, 12 Jan 2024 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705098813;
	bh=7Kbz6Xa/k/wW8xr1JxbaXIqAfEery0s/b5s8v6ErlFU=;
	h=Date:To:From:Subject:From;
	b=qQ+zdaMbDYYTm04ztKq7GQPNeSwqwgf0g8rOl44iGNJOWr9iBCg1DLlK9hmujED3u
	 kDIMhbXISFIuuxOvhuzYWxUhPDYvCYU5CsUgUFaWEsI3kc98FjhHG7wOfZ1bcHwGww
	 AveQXqafu4MRDaovsVrU6Im9IQwCx9HwNcZO04mQ=
Date: Fri, 12 Jan 2024 14:33:33 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,sthanneeru.opensrc@micron.com,ravis.opensrc@micron.com,rakie.kim@sk.com,mhocko@suse.com,Jonathan.Cameron@huawei.com,hyeongtak.ji@sk.com,honggyu.kim@sk.com,Hasan.Maruf@amd.com,hannes@cmpxchg.org,gregory.price@memverge.com,fvdl@google.com,dan.j.williams@intel.com,corbet@lwn.net,ak@linux.intel.com,gourry.memverge@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use.patch added to mm-unstable branch
Message-Id: <20240112223333.CA554C433C7@smtp.kernel.org>
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
Date: Fri, 12 Jan 2024 16:08:33 -0500

Move the use of barrier() to force policy->nodemask onto the stack into a
function `read_once_policy_nodemask` so that it may be re-used.

Link: https://lkml.kernel.org/r/20240112210834.8035-3-gregory.price@memverge.com
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Suggested-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Hasan Al Maruf <Hasan.Maruf@amd.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-refactor-a-read-once-mechanism-into-a-function-for-re-use
+++ a/mm/mempolicy.c
@@ -1907,6 +1907,20 @@ unsigned int mempolicy_slab_node(void)
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
+	__builtin_memcpy(mask, &pol->nodes, sizeof(nodemask_t));
+	barrier();
+	return nodes_weight(*mask);
+}
+
 /*
  * Do static interleaving for interleave index @ilx.  Returns the ilx'th
  * node in pol->nodes (starting from ilx=0), wrapping around if ilx
@@ -1914,20 +1928,12 @@ unsigned int mempolicy_slab_node(void)
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

