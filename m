Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0886733936D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465787; cv=none; b=mHOGsT8fBJe+EQ2KmP9yJ+edYBAJiJqFUV5Xha/C4zcZ9lvXUWYmT8qRjWsGIwKVkfZ6+ooVpq4TOd8NZmtolaYrgwFQNSAI+PUgIKF/rKcReYu0MIhxCJ8n+uOf666q3zgNTrG2+emrt8fuwXL8M3iYJ1nYjO0K2b5iiY/U9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465787; c=relaxed/simple;
	bh=KRuTodiui4k10S9zSacNM2rcRoRjyd28kgfhutEkN00=;
	h=Date:To:From:Subject:Message-Id; b=D4pzWmAGpb/ASomEBytm1NqbMk8EO1+fygMi66Ir2OE+5D83UXSFk0p2BvJynxrmJrfGF/J3jswFol0C2+F4dkoMybreaDKM1iHHNYC+2bOOi6sj1Vv35anfks2hX2gFxc/YqwKCIbBivjWxvBYrd0De0srdkxbT1ZGhztzIxao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FM+6UT63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FM+6UT63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877EC1F00A3A;
	Fri, 31 Jul 2026 02:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465785;
	bh=2KEIlFIIsxqBOHC9Xx6wBbCge4HbVKA2htAQ9lHHxMU=;
	h=Date:To:From:Subject;
	b=FM+6UT63DuD1RTFV9Cy/1Zj3gIvtPo9PWtdG8r3JHFqo8rOCwuTsKb0gb5rXO+nVw
	 DYc6JQfmWjUSjOjU6qHaKYox1LAndrSlvu1sk3ulw4vMpJ3cIesXCz9EOAKFwvgUL+
	 UQNVjTaqOhI0jZsbfxm/NY5HBhD0ZWHGMGsfOGbY=
Date: Thu, 30 Jul 2026 19:43:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,yan.y.zhao@intel.com,vannapurve@google.com,shivankg@amd.com,shakeel.butt@linux.dev,seanjc@google.com,roman.gushchin@linux.dev,rientjes@google.com,rick.p.edgecombe@intel.com,rakie.kim@sk.com,qi.zheng@linux.dev,pratyush@kernel.org,peterx@redhat.com,pbonzini@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,michael.roth@amd.com,mhocko@kernel.org,matthew.brost@intel.com,jthoughton@google.com,joshua.hahnjy@gmail.com,jiaqiyan@google.com,jgg@ziepe.ca,gourry@gourry.net,fvdl@google.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch removed from -mm tree
Message-Id: <20260731024305.877EC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: use error variable in alloc_hugetlb_folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


