Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FD750C2B0;
	Thu,  3 Sep 2026 19:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788464324; cv=none; b=CsSOXav0c6m8rLWBG4hAVrQ8YgQ6gTeLSE/89n3piRuCuiy3OY3vlac2KOLkOs4KjGnvyrRqwCC2bjlNHzoDDl3/oVkp1Mtx2kxXX9wrFWgVoPoseL43yG8JG/BIw8Ii664WYqyfSekZyO1Ong9jBdHMrJL3xBGzS/QTh/+Z9Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788464324; c=relaxed/simple;
	bh=gew2yDtkf5z8s1FZ8dufcMkQRPtNVQ3jS42FmfkUNVA=;
	h=Date:To:From:Subject:Message-Id; b=WiCSXazoIqxikqS+2RiVGnWOXgWPA0iTwPvt34q/a/XQCXyAtj+3EGXwAAO3lstF7N7p6eJ9eGi9ihZxf1vCCn5z+xz4gntnFqzfhCu6WAvB2NBaik1DVSy5/ZtGrESaEflHC15o+uLZLPiIoEd/8VlqLKbzSXStOyXCwCjHd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gUB/z4N4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gUB/z4N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCC61F000E9;
	Thu,  3 Sep 2026 19:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788464306;
	bh=TWbiTkDy+Qn5ANIu2XO2cI5+nEoeiUEgBCkEk3x1uSA=;
	h=Date:To:From:Subject;
	b=gUB/z4N4TNczXYlVMzb9hO1Ex6uib/S23XLcHNC8Fs44nwQ8/12Mxns5+QRF/uVHj
	 zQahyDtpFwyZIVx9NispycGrMr4UDXfWTIc+kjMunodGO6hCbfazBr7WArflYbQVMJ
	 Z8MaT1eiWUyia81h1BXn5KxNSKunVYCu2+boCYGA=
Date: Thu, 03 Sep 2026 12:38:26 -0700
To: mm-commits@vger.kernel.org,zhoujinmeng@bytedance.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@kernel.org,jinmengzhou22@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-charge-folios-to-the-target-mms-memcg.patch added to mm-new branch
Message-Id: <20260903193826.ADCC61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: charge folios to the target mm's memcg
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-charge-folios-to-the-target-mms-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-charge-folios-to-the-target-mms-memcg.patch

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
From: Jinmeng Zhou <jinmengzhou22@gmail.com>
Subject: mm/hugetlb: charge folios to the target mm's memcg
Date: Thu, 3 Sep 2026 15:50:48 +0800

HugeTLB folios are currently charged to the memcg of the allocating task. 
This gives the wrong result when a userfaultfd handler populates a HugeTLB
VMA that belongs to another process.  The UFFDIO_COPY ioctl operates on
the userfaultfd context's mm, but get_mem_cgroup_from_current() charges
the folio to the handler's memcg instead.

This can be reproduced by placing the faulting process and its userfaultfd
handler in different memory cgroups.  Have the target process register a
HugeTLB mapping with userfaultfd, trigger a missing fault, and let the
handler resolve it with UFFDIO_COPY.  The hugepage usage is then reported
in the handler's memory.current instead of the target's.

The generic userfaultfd population path avoids this problem by charging
folios to dst_vma->vm_mm.

Pass the target mm through hugetlb_alloc_folio() and charge the folio by
using get_mem_cgroup_from_mm().  This preserves the existing charge timing
and error handling while making HugeTLB userfaultfd population consistent
with the generic path.

Link: https://lore.kernel.org/20260903075048.3316-1-zhoujinmeng@bytedance.com
Fixes: 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory in memory controller")
Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    3 ++-
 include/linux/memcontrol.h |    8 +++++---
 mm/hugetlb.c               |    9 ++++++---
 mm/memcontrol.c            |    6 ++++--
 4 files changed, 17 insertions(+), 9 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-charge-folios-to-the-target-mms-memcg
+++ a/include/linux/hugetlb.h
@@ -694,7 +694,8 @@ enum hugetlb_alloc_flag {
 #define HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS BIT(HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS_BIT)
 
 struct folio *hugetlb_alloc_folio(struct hstate *h,
-		struct mempolicy_interpreted *mpoli, u8 alloc_flags);
+		struct mempolicy_interpreted *mpoli, struct mm_struct *mm,
+		u8 alloc_flags);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
--- a/include/linux/memcontrol.h~mm-hugetlb-charge-folios-to-the-target-mms-memcg
+++ a/include/linux/memcontrol.h
@@ -648,7 +648,8 @@ static inline int mem_cgroup_charge(stru
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
@@ -1147,9 +1148,10 @@ static inline int mem_cgroup_charge(stru
 	return 0;
 }
 
-static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
+static inline int mem_cgroup_charge_hugetlb(struct folio *folio,
+					    struct mm_struct *mm, gfp_t gfp)
 {
-        return 0;
+	return 0;
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
--- a/mm/hugetlb.c~mm-hugetlb-charge-folios-to-the-target-mms-memcg
+++ a/mm/hugetlb.c
@@ -2844,6 +2844,7 @@ void wait_for_freed_hugetlb_folios(void)
  * hugetlb_alloc_folio - Allocate a hugetlb folio.
  * @h: Hugetlb state control block.
  * @mpoli: Interpreted memory policy to use for allocation.
+ * @mm: Memory descriptor of the allocation target.
  * @alloc_flags: Flags controlling the allocation behavior.
  *
  * Allocates a hugetlb folio and handles cgroup charging and global hstate
@@ -2853,7 +2854,8 @@ void wait_for_freed_hugetlb_folios(void)
  *         -ENOSPC if cgroup charging fails or no folio is available.
  */
 struct folio *hugetlb_alloc_folio(struct hstate *h,
-		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
+		struct mempolicy_interpreted *mpoli, struct mm_struct *mm,
+		u8 alloc_flags)
 {
 	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
 					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
@@ -2908,7 +2910,8 @@ struct folio *hugetlb_alloc_folio(struct
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	ret = mem_cgroup_charge_hugetlb(folio, mm,
+					gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here because if
 	 * mem_cgroup_charge_hugetlb failed, freeing the page will
@@ -3058,7 +3061,7 @@ struct folio *alloc_hugetlb_folio(struct
 		.nodemask = nodemask,
 	};
 
-	folio = hugetlb_alloc_folio(h, &mpoli, alloc_flags);
+	folio = hugetlb_alloc_folio(h, &mpoli, vma->vm_mm, alloc_flags);
 
 	mpol_cond_put(mpol);
 
--- a/mm/memcontrol.c~mm-hugetlb-charge-folios-to-the-target-mms-memcg
+++ a/mm/memcontrol.c
@@ -5275,6 +5275,7 @@ int __mem_cgroup_charge(struct folio *fo
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
+ * @mm: mm context of the allocation target
  * @gfp: reclaim mode
  *
  * This function is called when allocating a huge page folio, after the page has
@@ -5284,9 +5285,10 @@ int __mem_cgroup_charge(struct folio *fo
  * Returns ENOMEM if the memcg is already full.
  * Returns 0 if either the charge was successful, or if we skip the charging.
  */
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp)
 {
-	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 	int ret = 0;
 
 	/*
_

Patches currently in -mm which might be from jinmengzhou22@gmail.com are

mm-hugetlb-charge-folios-to-the-target-mms-memcg.patch

