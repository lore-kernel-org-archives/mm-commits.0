Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C822250F7
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 20:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705524927; cv=none; b=ewhAkuCbsZw4sgO50kNe99TOFq3u3X1ztZ1Lxdtu4d/fJoYNW49nRp5cdt+18I8Z8IEg9g8BB0MSm2HeqKyfrvmZzoTPVSVS4f6JTrCVKulPhP3XFpBRD8K1I4k7BOzrBrVJuVHgA/8jWTIpGvi1RvG9rcOLUrM5UfwAQqRbwzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705524927; c=relaxed/simple;
	bh=pmbqzhaWD4If72V8DkzIK0i2W7tlgE22xd6iEtd7nKo=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=mIEF/DW8TQVdheNZMfrzx0drZwnjLmVGtyDmlHwyQfBeG9g3rhdDH0+p4PUB4/CB8s4EE85MLPrxYL5cmDRZs0X2IirKmt75cjcGVSOr3k8T2j1ircW1zLUapG6rMJkii+vmyesWV00SDT0G7/OYMQKS6osh05oIOVvNRg0Df/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EpuUeZwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EpuUeZwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9D3C433C7;
	Wed, 17 Jan 2024 20:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705524927;
	bh=pmbqzhaWD4If72V8DkzIK0i2W7tlgE22xd6iEtd7nKo=;
	h=Date:To:From:Subject:From;
	b=EpuUeZwYLpMhKkxZLQO0k1vxT6Plk29VNO2NUrxsTzAN2gCBNqVQ7zq9iRxFH9Tih
	 3s/ZoBq+IDlJ5q2LsXuPQjJrwl4afyJ12KE9X8oD19f1IIY9sBkGMv8uV3t3DfX64N
	 et05hgySwiqYzh2khxOfcY2TxbfhB3CcUIog/rAk=
Date: Wed, 17 Jan 2024 12:55:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,shakeelb@google.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch added to mm-unstable branch
Message-Id: <20240117205526.9E9D3C433C7@smtp.kernel.org>
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

mem_cgroup_charge() uses the GFP flags in a fairly sophisticated way.
In addition to checking gfpflags_allow_blocking(), it pays attention
to __GFP_NORETRY and __GFP_RETRY_MAYFAIL to ensure that processes within
this memcg do not exceed their quotas. Using the same GFP flags ensures
that we handle large anonymous folios correctly, including falling back
to smaller orders when there is plenty of memory available in the system
but this memcg is close to its limits.

Link: https://lkml.kernel.org/r/20240117103954.2756050-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
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

