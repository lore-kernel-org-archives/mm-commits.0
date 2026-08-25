Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666C43264D5;
	Tue, 25 Aug 2026 01:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622257; cv=none; b=gWr158IalzNcvi0iHbEv3jSFfaH+3x32ayuVtWtuVswyBOwef04BiEih/nqJdW0A/WF7rkRJjeNN7eXR1DukwioSEGBk78xX3V4P2SUoWQgE+tfk2dCKClbyd09Ob81FkoZS0gywrRk8YC1U0aSd216/L5jC4AMJO1pA6XSki/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622257; c=relaxed/simple;
	bh=xA9ehdxfRDTnNC0/viA2vSOXFplOsA4uYpk9a2bKYZY=;
	h=Date:To:From:Subject:Message-Id; b=uVo6ZUjYPKrDFwuBkKsOfEARPE+Y5rZ5QdTXsWCPJLUXK6EOWIk7CbNDrpD6M9xYOo94+Z9MwzZ95o3XmNEAzFZUBlJR8pLWtZo4F9JO+3+a7EB3Waohz9GRwewAxJRGC9I4tWyMhQMj+svf+GZt7d0K2IoW3YmWwGZZRgp0sAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AwDYMZjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AwDYMZjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCFA1F000E9;
	Tue, 25 Aug 2026 01:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622255;
	bh=RgSO62oKk2CvhoD27VuFwLRcErr807FZQ8yJ8NIYRls=;
	h=Date:To:From:Subject;
	b=AwDYMZjMng2i0knACXUzWMP6AUI/7YWXdPA8BfOZYN1h4juByoJm/Ua0vps2oUNWq
	 zId8EPOAnPpo6qz3UQgEMkakZDkOjYsLXHiM26Ha9YKgiddpkIOihwhGmFVGAXzjIu
	 iAEfPsV1Iolwc/NNaO0xKvkdXLqpFynYjw3BF00A=
Date: Mon, 24 Aug 2026 18:44:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,rakie.kim@sk.com,nehagholkar@gmail.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch removed from -mm tree
Message-Id: <20260825014415.CFCFA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mempolicy: fix automatic numa balancing for shmem
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-automatic-numa-balancing-for-shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
very noticeable on tiered systems, where entire tmpfs workingsets can get
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
Acked-by: Balbir Singh <balbirs@nvidia.com>
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
@@ -2060,24 +2060,15 @@ struct mempolicy *get_vma_policy(struct
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


