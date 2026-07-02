Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128D13AB466
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783030364; cv=none; b=FduVeXIhqRPGzu3F12KrR/U3dhcLAbDKBFa59j36jGO1Qle1599ubfyhR+Acx0/yw61xr7HcAiw1nxJYSZBN/6gkFg/4b1nm30DdYqclRsBDXxlZMjN2yk0o/7wFG0xJ0BK+mLSGul/GoZTOKOkWZ049RAS3LULYiFQdbNv1rN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783030364; c=relaxed/simple;
	bh=Cb8R2s3u+uCWQURR7mDB1AINMQw0tmWzYC3RrDTR1rU=;
	h=Date:To:From:Subject:Message-Id; b=YjoiSspnv93/0C/tQdLzXVNzmYbzHOmcNKR4UbDobpaJfmAe+y1yjmdRmWy2iqeuR1dXjc7fRqe5TAGwmClXbEqWCDKtuDu5p9XDhEY4XXtR9Z+hVmoPUig5anDiBD1/S4ORZxi3seW23EeFk+otFJmQOHLC8rRrXurIxySuzSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIge5KPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIge5KPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14111F000E9;
	Thu,  2 Jul 2026 22:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783030362;
	bh=EJcWAniHZhV7Vx4HoYPnxiTSQZsn7QmJJpjnI+GJoXw=;
	h=Date:To:From:Subject;
	b=cIge5KPcuWr0Zny7Pu2dzuwLp7dQ3IFzDiot1ukY1jxf/6VwIzrR2LpJE8E3rMXtH
	 yODjIxoisStsMV0ldLaJ+LFuhHRv+jHQkM+e5lYZTZlKF5zvV6ZUZZabb8Pnab6mGw
	 EHZa2mr/ujgib9K+MMLdETIbQqcY4psJIYrbb1mQ=
Date: Thu, 02 Jul 2026 15:12:42 -0700
To: mm-commits@vger.kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch added to mm-new branch
Message-Id: <20260702221242.A14111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: move mem_cgroup_charge_hugetlb() earlier in allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch

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

mm-hugetlb-consolidate-interpretation-of-gbl_chg-within-alloc_hugetlb_folio.patch
mm-hugetlb-move-mpol-interpretation-out-of-alloc_buddy_hugetlb_folio_with_mpol.patch
mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch
mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch
mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch
mm-hugetlb-refactor-out-hugetlb_alloc_folio.patch

