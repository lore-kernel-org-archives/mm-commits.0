Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C453F104C;
	Fri,  9 Oct 2026 05:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525387; cv=none; b=X1hQqaXq2ikamApYebT1emFZp8t4ga5+i/fmQBpKmplBv4KtV6PqWG8uInA2+b/XO8ffvewZpHyTdADxwAu/5D8WEEt9XktcFUf/rwKgyX33k7qI8GpGhpqqxUdbUymg/4MTB9OOppz1Ok8SDcHiYhtaDtOnwM7hInM0EhbireY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525387; c=relaxed/simple;
	bh=8wTihtLXtkuw7JQFjgQ/j/P/zAedA3kUDAmF/JUXAIE=;
	h=Date:To:From:Subject:Message-Id; b=oUvPZg0SwRxgrLkN2sfYT53IYlCOIogHz1wQHW+up0PsHsVpUiTzuEOaLiZ/JRQQ4yCYJM1PUrjPv9nHDwtea35Iy9nhV0UKYVe9/zFJ6a+YAHWg3EwuVttGIXryAtBy0OJR0byJH98N/lHkbo4nMsz5SCnoHqLCV1sVzXJx920=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wgU32E++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wgU32E++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B451F000FF;
	Fri,  9 Oct 2026 05:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525385;
	bh=Yndk6fmivoBv1gAtFeZwrqYJPhqbMOGgeFUTx0s6zu4=;
	h=Date:To:From:Subject;
	b=wgU32E++j9B6zv9whDdskf3LNM54K1yVhKZ2BpXsdxap2Qf0xGeEqKZ8d1JXrk8PT
	 v6HI3HBS6W2S+HQQbB6MaCu+1u2MEAMIa62/RnSnqjAzXcJE3DpQHPRdm7ap121JYV
	 FUd8Xc5A3Rl0ZdoelEHhPq1ttf8uh1yIrPIt8n9I=
Date: Thu, 08 Oct 2026 22:56:24 -0700
To: mm-commits@vger.kernel.org,zhoujinmeng@bytedance.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lihongfu@kylinos.cn,hannes@cmpxchg.org,david@kernel.org,jinmengzhou22@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-charge-folios-to-the-target-mms-memcg.patch removed from -mm tree
Message-Id: <20261009055625.57B451F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: charge folios to the target mm's memcg
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-charge-folios-to-the-target-mms-memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Hongfu Li <lihongfu@kylinos.cn>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
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
@@ -647,7 +647,8 @@ static inline int mem_cgroup_charge(stru
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
@@ -1146,9 +1147,10 @@ static inline int mem_cgroup_charge(stru
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
@@ -3051,7 +3054,7 @@ struct folio *alloc_hugetlb_folio(struct
 		.nodemask = nodemask,
 	};
 
-	folio = hugetlb_alloc_folio(h, &mpoli, alloc_flags);
+	folio = hugetlb_alloc_folio(h, &mpoli, vma->vm_mm, alloc_flags);
 
 	mpol_cond_put(mpol);
 
--- a/mm/memcontrol.c~mm-hugetlb-charge-folios-to-the-target-mms-memcg
+++ a/mm/memcontrol.c
@@ -5265,6 +5265,7 @@ int __mem_cgroup_charge(struct folio *fo
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
+ * @mm: mm context of the allocation target
  * @gfp: reclaim mode
  *
  * This function is called when allocating a huge page folio, after the page has
@@ -5274,9 +5275,10 @@ int __mem_cgroup_charge(struct folio *fo
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


