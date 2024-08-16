Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB04F77F1B;
	Fri, 16 Aug 2024 05:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785422; cv=none; b=o+0ugVuF/duyf9o25HrfuyWfG9u32ejufdiZjvjV6hcxVqCrIV9VDbPc0BYvT92p2F8XXX9HkBr08DiDc15ITo1CS+G4XI1vG0Xen3Rbd7y80YCw7QKKGDbM+fzxR6gLUyVhs5ADNM7RXFm41WW0ywUNxFVaEi4Yh5oNGzMY9Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785422; c=relaxed/simple;
	bh=pG+xQB9ub2oq4xqXqgbE3/Go4jb9zIS/GZwOEiqQ84s=;
	h=Date:To:From:Subject:Message-Id; b=BKP1fECXx6fvp03CFtIAWtTo6qb/rYQBVMm9fwOvs22u4CaLWpXHCkw2Afbj+v/9K2+PBTpI9lVWgv51TiZRD7E9EBMimuc48DI9009WqhHHOETjLkH8LCmMpQUYizDW07FZG/7ZGnb5YzztOnBT6eoIpStTrADu3LroCuYcmgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gXTo6tlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gXTo6tlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0EEC4AF0B;
	Fri, 16 Aug 2024 05:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785419;
	bh=pG+xQB9ub2oq4xqXqgbE3/Go4jb9zIS/GZwOEiqQ84s=;
	h=Date:To:From:Subject:From;
	b=gXTo6tlBi8ntOfZaMcmXVWmmaxyb6m2QRUl+nIsVEWKS167vxBi3DzjbX1dLccqX8
	 WkL7S6ElN2MyQ9XsPBFFUVoVGniUhhI05FLPbQNO/sUZEc1UIJKEcRc8RZjq+us6y4
	 B8pHkBC9u9y0syv1xzYbgnlkRSSVGbf9mWs9PjlA=
Date: Thu, 15 Aug 2024 22:16:58 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,shy828301@gmail.com,mgorman@suse.de,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-numa-no-task_numa_fault-call-if-pte-is-changed.patch removed from -mm tree
Message-Id: <20240816051659.3E0EEC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/numa: no task_numa_fault() call if PTE is changed
has been removed from the -mm tree.  Its filename was
     mm-numa-no-task_numa_fault-call-if-pte-is-changed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/numa: no task_numa_fault() call if PTE is changed
Date: Fri, 9 Aug 2024 10:59:04 -0400

When handling a numa page fault, task_numa_fault() should be called by a
process that restores the page table of the faulted folio to avoid
duplicated stats counting.  Commit b99a342d4f11 ("NUMA balancing: reduce
TLB flush via delaying mapping on hint page fault") restructured
do_numa_page() and did not avoid task_numa_fault() call in the second page
table check after a numa migration failure.  Fix it by making all
!pte_same() return immediately.

This issue can cause task_numa_fault() being called more than necessary
and lead to unexpected numa balancing results (It is hard to tell whether
the issue will cause positive or negative performance impact due to
duplicated numa fault counting).

Link: https://lkml.kernel.org/r/20240809145906.1513458-2-ziy@nvidia.com
Fixes: b99a342d4f11 ("NUMA balancing: reduce TLB flush via delaying mapping on hint page fault")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Closes: https://lore.kernel.org/linux-mm/87zfqfw0yw.fsf@yhuang6-desk2.ccr.corp.intel.com/
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/mm/memory.c~mm-numa-no-task_numa_fault-call-if-pte-is-changed
+++ a/mm/memory.c
@@ -5295,7 +5295,7 @@ static vm_fault_t do_numa_page(struct vm
 
 	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		goto out;
+		return 0;
 	}
 
 	pte = pte_modify(old_pte, vma->vm_page_prot);
@@ -5358,23 +5358,19 @@ static vm_fault_t do_numa_page(struct vm
 	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		nid = target_nid;
 		flags |= TNF_MIGRATED;
-	} else {
-		flags |= TNF_MIGRATE_FAIL;
-		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-					       vmf->address, &vmf->ptl);
-		if (unlikely(!vmf->pte))
-			goto out;
-		if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
-			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			goto out;
-		}
-		goto out_map;
+		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+		return 0;
 	}
 
-out:
-	if (nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, nid, nr_pages, flags);
-	return 0;
+	flags |= TNF_MIGRATE_FAIL;
+	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+				       vmf->address, &vmf->ptl);
+	if (unlikely(!vmf->pte))
+		return 0;
+	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
 out_map:
 	/*
 	 * Make it present again, depending on how arch implements
@@ -5387,7 +5383,10 @@ out_map:
 		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
 					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	goto out;
+
+	if (nid != NUMA_NO_NODE)
+		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+	return 0;
 }
 
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
_

Patches currently in -mm which might be from ziy@nvidia.com are

memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch
mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch

