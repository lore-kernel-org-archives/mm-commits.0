Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59A03B5851
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 22:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783030362; cv=none; b=qyb9oSo0SbkxB6rneE9USnbBeU5gWyyjlJzcpqpc1w4hKJvVMyAmPfGAT8DeFFntZ836at9B49hy//0m4miEuSnhOwmriJ+sPHDzvPt9q0aBYaEsG4T79iFLbIzPAI4Bg2rvWgS1nXjGn+CQBOGVl4XGshfdzAF1QwHtOqEDzTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783030362; c=relaxed/simple;
	bh=ce3IQpbUXYn4c+v6Mg+W5VhOi7iWXrdtu2N9jpdOXTY=;
	h=Date:To:From:Subject:Message-Id; b=nhvZZlm4RodsHKuqXgodoOovzeukS/xVRSDOaTQeJT75g8o6RHaM4X+r1vNzFWspBQWvL9UdXv9udgtOw410bVUtDvqDLKsDjOmoVIIPMBEAjC+jz7b5XpKog4hIusECOPKjo0EUFZo+fJF951w7XqX7IusKrG1JbtRazUKhoHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RHhLYq3q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RHhLYq3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529051F000E9;
	Thu,  2 Jul 2026 22:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783030360;
	bh=TzE17KTNulkU5tHnyEC6ZhpzPS6Y6EOgizwbR6qkxiA=;
	h=Date:To:From:Subject;
	b=RHhLYq3qoH7Zqmp/atjYpVEajV+vcE1szKX5azyBEzdO+DGunvhqn0mqGwFTRCZ0N
	 YQJdjNch+i61zbbUl8C5B1hzIVXCzXKJHxqEYwr00a1sKAwSlvi+pd57fitoYGEaeU
	 p+OG5SBEKQBriU6frlLJDR9avwrjSGCbN8RZXgjM=
Date: Thu, 02 Jul 2026 15:12:39 -0700
To: mm-commits@vger.kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch added to mm-new branch
Message-Id: <20260702221240.529051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: use error variable in alloc_hugetlb_folio
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch

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
From: Ackerley Tng <ackerleytng@google.com>
Subject: mm: hugetlb: use error variable in alloc_hugetlb_folio
Date: Thu, 02 Jul 2026 09:21:48 -0700

Refactor alloc_hugetlb_folio to use a local variable for returning error
codes.  Instead of returning ERR_PTR(-ENOSPC) at the end of the error
path, assign -ENOSPC to a return variable at each failure point and return
that variable at the end.

This allows the cleanup goto targets to be used with other errors in a
later patch.

No functional change intended.

Link: https://lore.kernel.org/20260702-hugetlb-open-up-v4-4-d53cefcccf34@google.com
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -2886,8 +2886,10 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	if (map_chg) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0)
+		if (gbl_chg < 0) {
+			ret = -ENOSPC;
 			goto out_end_reservation;
+		}
 	} else {
 		/*
 		 * If we have the vma reservation ready, no need for extra
@@ -2903,13 +2905,17 @@ struct folio *alloc_hugetlb_folio(struct
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg_rsvd);
-		if (ret)
+		if (ret) {
+			ret = -ENOSPC;
 			goto out_subpool_put;
+		}
 	}
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret)
+	if (ret) {
+		ret = -ENOSPC;
 		goto out_uncharge_cgroup_reservation;
+	}
 
 	/* Takes reference on mpol. */
 	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
@@ -2940,6 +2946,7 @@ struct folio *alloc_hugetlb_folio(struct
 		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
 		if (!folio) {
 			mpol_cond_put(mpol);
+			ret = -ENOSPC;
 			goto out_uncharge_cgroup;
 		}
 		spin_lock_irq(&hugetlb_lock);
@@ -3032,7 +3039,7 @@ out_subpool_put:
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-	return ERR_PTR(-ENOSPC);
+	return ERR_PTR(ret);
 }
 
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
_

Patches currently in -mm which might be from ackerleytng@google.com are

mm-hugetlb-consolidate-interpretation-of-gbl_chg-within-alloc_hugetlb_folio.patch
mm-hugetlb-move-mpol-interpretation-out-of-alloc_buddy_hugetlb_folio_with_mpol.patch
mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch
mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch
mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch
mm-hugetlb-refactor-out-hugetlb_alloc_folio.patch

