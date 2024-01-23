Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D043738DCC
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970628; cv=none; b=uQRxBgnXKcyc+y0gZSYj/WTgIluz8Jo0zPr8Ru/4B5Vz+Uxbc2SVXWp9lNO57/CdqOF4es7nhv4axYBqD2/7WedL/VX0CVjIC5Wy2Ry6OI2eqiToYtpAWi4WQ/sdTb53jJ5Q97zkYs8yDJDD4VM+IG/uHIa4TkxVE2zU9D92/eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970628; c=relaxed/simple;
	bh=iHUREvR9U+zQEqIKpyU+In5j2DN95piMUj5+NjF+F6I=;
	h=Date:To:From:Subject:Message-Id; b=bXX+psFFpFN0SLD39tqGFZsdg7KTEMgoq5tPTkMannCUaS6QmzDc12EWf8w4816Td/iiMPYZz4q3BG2okTzq9LEbyRJ4/hnYJYvtHAj+QD/m5fch2hlAFIW/A1ih5/hx6vROYbYbSDUsRExl9nsRWxgXEVFkvLq7eEUqCi9PRcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L2cJPczV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L2cJPczV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B07C433F1;
	Tue, 23 Jan 2024 00:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970628;
	bh=iHUREvR9U+zQEqIKpyU+In5j2DN95piMUj5+NjF+F6I=;
	h=Date:To:From:Subject:From;
	b=L2cJPczVgxqTjbLdFCqRTAiyiGxyMLGx2f95xZah4x3lCd7NUIrD6nAsahZlRimRH
	 YhyxKPQSf+QmWxQnpyo6ZcNE5j8CTpW8kFwU5FUeQFk2Kxmm4yEpA2SRHWns2L7yRb
	 kNQbrfWIsqg2ivVXn9nbaUco6EN3PnRitgOiIfhc=
Date: Mon, 22 Jan 2024 16:43:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,shakeelb@google.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch added to mm-unstable branch
Message-Id: <20240123004347.D6B07C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory: move mem_cgroup_charge() into alloc_anon_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: move mem_cgroup_charge() into alloc_anon_folio()
Date: Wed, 17 Jan 2024 18:39:54 +0800

The GFP flags from vma_thp_gfp_mask() according to user configuration only
used for large folio allocation but not for memory cgroup charge, and
GFP_KERNEL is used for both order-0 and large order folio when memory
cgroup charge at present.  However, mem_cgroup_charge() uses the GFP flags
in a fairly sophisticated way.  In addition to checking
gfpflags_allow_blocking(), it pays attention to __GFP_NORETRY and
__GFP_RETRY_MAYFAIL to ensure that processes within this memcg do not
exceed their quotas.

So we'd better to move mem_cgroup_charge() into alloc_anon_folio(),

1) it will make us to allocate as much as possible large order folio,
   because we could try the next order if mem_cgroup_charge() fails,
   although the memcg's memory usage is close to its limits.

2) using same GFP flags for allocation and charge is to be consistent
   with PMD THP firstly, in addition, according to GFP flag returned from
   vma_thp_gfp_mask(), GFP_TRANSHUGE_LIGHT could make us skip direct
   reclaim, _GFP_NORETRY will make us skip mem_cgroup_oom() and won't
   trigger memory cgroup oom from large order(order <= COSTLY_ORDER) folio
   charging.

Link: https://lkml.kernel.org/r/20240122011612.501029-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240117103954.2756050-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio
+++ a/mm/memory.c
@@ -4153,8 +4153,8 @@ static bool pte_range_none(pte_t *pte, i
 
 static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 {
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	struct vm_area_struct *vma = vmf->vma;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	unsigned long orders;
 	struct folio *folio;
 	unsigned long addr;
@@ -4206,15 +4206,21 @@ static struct folio *alloc_anon_folio(st
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr, true);
 		if (folio) {
+			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+				folio_put(folio);
+				goto next;
+			}
+			folio_throttle_swaprate(folio, gfp);
 			clear_huge_page(&folio->page, vmf->address, 1 << order);
 			return folio;
 		}
+next:
 		order = next_order(&orders, order);
 	}
 
 fallback:
 #endif
-	return vma_alloc_zeroed_movable_folio(vmf->vma, vmf->address);
+	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
 }
 
 /*
@@ -4281,10 +4287,6 @@ static vm_fault_t do_anonymous_page(stru
 	nr_pages = folio_nr_pages(folio);
 	addr = ALIGN_DOWN(vmf->address, nr_pages * PAGE_SIZE);
 
-	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
-		goto oom_free_page;
-	folio_throttle_swaprate(folio, GFP_KERNEL);
-
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * preceding stores to the page contents become visible before
@@ -4338,8 +4340,6 @@ unlock:
 release:
 	folio_put(folio);
 	goto unlock;
-oom_free_page:
-	folio_put(folio);
 oom:
 	return VM_FAULT_OOM;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch
mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch

