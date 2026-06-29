Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758FB314D37;
	Mon, 29 Jun 2026 23:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782774667; cv=none; b=Hr1/ksH/iCe/JdG4EC+6WOcT15beEjdCDpVeauKCW5L1SpEgpITA7YkHDq69ZKTdjy+aMEgj1jlzSmwZcDp5PgsaYc86JFfnjpExbqPGgIEbk8AN+C/JrXsPp+X/4CcKvrOKD4LPhyALK+KNdspjdL5QkiGy/6pZpWWgsJ7rlt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782774667; c=relaxed/simple;
	bh=q9NkZ492aB1EfwWDCRs5iUarWXOTV9qwLaHWrkdLZFo=;
	h=Date:To:From:Subject:Message-Id; b=miji09/5O2CQKuB01dDdmXEoPOKapIv13wfYcrzkq0oXHsoQG1g5mBexRG8YZGPUs2XShRKcPetpXPAJaqX9Drd07ilPs4GCgEIKNCJmT5Bqvk22wuxYRkzg2WYhXQ7BMyxPWMcUimeyeKzs0kzI1H9Xrp4TDa4GiTOXWnbFudU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oPU363xd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oPU363xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F941F000E9;
	Mon, 29 Jun 2026 23:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782774666;
	bh=HsS4jFT58CO08bn2w46NjfQSbm90g92nvw5Ob+rCTTc=;
	h=Date:To:From:Subject;
	b=oPU363xd1xiVm/srT95Sz70e+pE9+dHqwKHIYnlfJx+6qZ02Fx9pz0kXzIfRveyQV
	 B5IG3roZC1GgZk5/CIk1zShuIc4SQcFlsi4kYIvrVlhoOFaliJF7GfWwLDgl4Dzox/
	 ci+hg2/9nYjDWe8Qmvc31w1VooLPs23V80zsc18A=
Date: Mon, 29 Jun 2026 16:11:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,nehagholkar@gmail.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch added to mm-new branch
Message-Id: <20260629231105.D7F941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mempolicy: fix automatic numa balancing for shmem
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: mempolicy: fix automatic numa balancing for shmem
Date: Mon, 29 Jun 2026 12:33:37 -0400

Neha reports that mapped shmem aren't considered for NUMA balancing,
noting convergence problems and bandwidth bottlenecking for cachelib based
workloads on tiered memory systems.

Looking at the code and going through the git history, this doesn't
actually seem intentional:

Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
policy lacks MPOL_F_MOF are skipped from NUMA balancing scans.  The
motivation was a real usecase: Oracle was pinning shared segments with
mbind(MPOL_BIND) so trapping faults was both expensive and pointless.

The handling of NULL from vm_ops->get_policy, however, treated "user
explicitly opted out" the same as "user never specified anything." For
VMAs whose shared policy is absent - the common case for shmem - the scan
was disabled too.

This issue is old.  It probably hurts less in conventional NUMA.  But it's
very noticable on tiered systems, where entire tmpfs workingsets can get
stuck on lower-bandwidth memory.

Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
thereby handle the fallback to task policy (-> preferred_node_policy() has
MPOL_F_MOF per default).  Every other consumer of vm_ops->get_policy
already handles it this way, the scan-eligibility check was the outlier.

This preserves Mel's intended fix: don't scan stuff the user explicitly
pinned.  But allow default policy vmas to participate in balancing.

Link: https://lore.kernel.org/20260629163337.1264881-1-hannes@cmpxchg.org
Fixes: fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault VMAs")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Neha Gholkar <nehagholkar@gmail.com>
Tested-by: Neha Gholkar <nehagholkar@gmail.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-automatic-numa-balancing-for-shmem
+++ a/mm/mempolicy.c
@@ -2057,24 +2057,15 @@ struct mempolicy *get_vma_policy(struct
 bool vma_policy_mof(struct vm_area_struct *vma)
 {
 	struct mempolicy *pol;
+	pgoff_t ilx;
+	bool mof;
 
-	if (vma->vm_ops && vma->vm_ops->get_policy) {
-		bool ret = false;
-		pgoff_t ilx;		/* ignored here */
-
-		pol = vma->vm_ops->get_policy(vma, vma->vm_start, &ilx);
-		if (pol && (pol->flags & MPOL_F_MOF))
-			ret = true;
-		mpol_cond_put(pol);
-
-		return ret;
-	}
-
-	pol = vma->vm_policy;
+	pol = __get_vma_policy(vma, vma->vm_start, &ilx);
 	if (!pol)
 		pol = get_task_policy(current);
-
-	return pol->flags & MPOL_F_MOF;
+	mof = pol->flags & MPOL_F_MOF;
+	mpol_cond_put(pol);
+	return mof;
 }
 
 bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch

