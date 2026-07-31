Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F109328635
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465788; cv=none; b=qwkQsh2w1t+S94lkQhbMpX8DaBL6Z66tXBY1sgZWRmQG0lFmwsLR4m/HmTLRGlWSDl1I5URuEJGyK9Q/gATe2ayeWyJbcUp6EZW+NmErpDY1+AosMTPN/yWbId9tFPTcecQcfx9kDT5Ep6xIVXeK7Py9sUm+rXXWB2zH4hZTYCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465788; c=relaxed/simple;
	bh=ykm3DJ7DlqftdCHDcuH8owKgRm0JIShkMfMSf/GYoRo=;
	h=Date:To:From:Subject:Message-Id; b=ak3CG/T8j7NCvx7G++cxUBM63fUfkJETRj3nJ1H35x5q7gzTvC46MmKegx5ImsyMWH25PzfLvZWE0EoUga/pE7QcesSp7/25CEW3KvoH6KUuB6J+qs0IUDi42Vyttcyr/6latMEC4HlfUQ4/nfKHibGealfA/6PJT/Vaathc4qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0PRJm+jR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PRJm+jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AEB1F000E9;
	Fri, 31 Jul 2026 02:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465787;
	bh=1T1C4wCxaTX1wMZVByIhuKStLlMZgv82UU00zWuwbvQ=;
	h=Date:To:From:Subject;
	b=0PRJm+jRhRkeqUAimQxIk46zM9OUvWIJrk0fgAbqgfYWgb2WansKUDEXJ4/5MzoP+
	 JZvcHXe8unKvOvKS2wHcgWhUaoBMW1fSHsvaTNvcv8TvL2xPn9CI85hFiM68ZU/MoY
	 VDiC+TdTxjRM0QUBJYu4VJuiJ/FWm+PoUJLDyNL0=
Date: Thu, 30 Jul 2026 19:43:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,yan.y.zhao@intel.com,vannapurve@google.com,shivankg@amd.com,shakeel.butt@linux.dev,seanjc@google.com,roman.gushchin@linux.dev,rientjes@google.com,rick.p.edgecombe@intel.com,rakie.kim@sk.com,qi.zheng@linux.dev,pratyush@kernel.org,peterx@redhat.com,pbonzini@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,michael.roth@amd.com,mhocko@kernel.org,matthew.brost@intel.com,jthoughton@google.com,joshua.hahnjy@gmail.com,jiaqiyan@google.com,jgg@ziepe.ca,gourry@gourry.net,fvdl@google.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch removed from -mm tree
Message-Id: <20260731024306.E4AEB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: move mem_cgroup_charge_hugetlb() earlier in allocation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ackerley Tng <ackerleytng@google.com>
Subject: mm: hugetlb: move mem_cgroup_charge_hugetlb() earlier in allocation
Date: Thu, 02 Jul 2026 09:21:49 -0700

Move mem_cgroup_charge_hugetlb() earlier in the folio allocation process. 
This change draws a cleaner line between memcg charging and the subsequent
hugetlb-specific reservation logic for VMAs and subpools.

While it would be ideal to make all accounting and reservations perfectly
symmetric, mem_cgroup_charge_hugetlb() is a complex operation that cannot
be performed under the hugetlb_lock.  Moving the charge to this earlier
point ensures that memcg charging is handled before the code begins
manipulating subpool and VMA-specific state.  These two types of
accounting will be separated in a future patch.

If mem_cgroup_charge_hugetlb() fails, the code now branches to
out_subpool_put to ensure the folio is freed and the subpool references
are handled correctly.

Link: https://lore.kernel.org/20260702-hugetlb-open-up-v4-5-d53cefcccf34@google.com
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

 mm/hugetlb.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation
+++ a/mm/hugetlb.c
@@ -2977,6 +2977,24 @@ struct folio *alloc_hugetlb_folio(struct
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	/*
+	 * Unconditionally increment NR_HUGETLB here. If it turns out that
+	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+
+	if (ret == -ENOMEM) {
+		free_huge_folio(folio);
+		/*
+		 * Skip uncharging hugetlb_cgroup since the charges
+		 * were committed to the folio and freeing the folio
+		 * would have cleared those up.
+		 */
+		goto out_subpool_put;
+	}
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -3004,19 +3022,6 @@ struct folio *alloc_hugetlb_folio(struct
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here. If it turns out that
-	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	return folio;
 
 out_uncharge_cgroup:
_

Patches currently in -mm which might be from ackerleytng@google.com are


