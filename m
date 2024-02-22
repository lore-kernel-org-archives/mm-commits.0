Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FBB24B23
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560087; cv=none; b=Angv+yXRMNJcfq2UxCcnrFcaI8alyVrZellSvfv6ScCqfxD6Tfs48iQe6Mk33IMrMJtY8ZDeecm+Gc4sOdDdaHeOCy9+axjUk+ogtF1I+dSP1YUU2CYlaTBqooyTllujSVa5QS/wQ55Sqk5wbXkSJuGWaZ5oLlFasbnbDdrp9Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560087; c=relaxed/simple;
	bh=cslaQrekDCO3SUXy77rX9m6hCyd9H+S2FZKL8Vg62OQ=;
	h=Date:To:From:Subject:Message-Id; b=rNlN02TUNIZ3+ur7LtdON1FEkWqMEjfgaPQRODxc7lE7BNtnKvDJqByd9fk+/BVLIhae/OgbRE1+RUJPuWnrKu9EhBsW0IbEn8YnVfmEHSOdQVaE0R0o6oAFlq517ny7oVDLZ8twCn3K1fPa/xjERKSA7JVAlJnGsHOyYoltbM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=An95Df+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="An95Df+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AE0C43399;
	Thu, 22 Feb 2024 00:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560087;
	bh=cslaQrekDCO3SUXy77rX9m6hCyd9H+S2FZKL8Vg62OQ=;
	h=Date:To:From:Subject:From;
	b=An95Df+0+1z8Zz+hcAk7/6KIarzY18Td52KOeSX3iiEP/AQbY3JZNdlxpTXxeum8c
	 VOFBrvN8EEP8COqGynaTDNZmxyZzxUIJbu1v69k79nK8Pw78g1fC6j7bn64Za1WMUj
	 /xBMu+AGciO1IB8gcj8bmAypVum/JOj+ktuBXl/4=
Date: Wed, 21 Feb 2024 16:01:26 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,shakeelb@google.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch removed from -mm tree
Message-Id: <20240222000127.68AE0C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: move mem_cgroup_charge() into alloc_anon_folio()
has been removed from the -mm tree.  Its filename was
     mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4173,8 +4173,8 @@ static bool pte_range_none(pte_t *pte, i
 
 static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 {
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	struct vm_area_struct *vma = vmf->vma;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	unsigned long orders;
 	struct folio *folio;
 	unsigned long addr;
@@ -4226,15 +4226,21 @@ static struct folio *alloc_anon_folio(st
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
@@ -4301,10 +4307,6 @@ static vm_fault_t do_anonymous_page(stru
 	nr_pages = folio_nr_pages(folio);
 	addr = ALIGN_DOWN(vmf->address, nr_pages * PAGE_SIZE);
 
-	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
-		goto oom_free_page;
-	folio_throttle_swaprate(folio, GFP_KERNEL);
-
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * preceding stores to the page contents become visible before
@@ -4358,8 +4360,6 @@ unlock:
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

mm-compaction-early-termination-in-compact_nodes.patch

