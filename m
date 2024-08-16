Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2657DA89;
	Fri, 16 Aug 2024 05:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785420; cv=none; b=cZ6Jx5w++gLxeU+7DG2PsHBSOu2UTBc6hkTa6s04W9mHq2MCJPKXftNetfOckYspzRAVBR8B7UnwtQHG8GIRB0UB9/ftaRtWNriwO7i6lKtDy4y4n9uIlURYrGrPYwuez58IkugvwGiH33R1YDni0/E29/Ezcu5+8q1XJ4DC6V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785420; c=relaxed/simple;
	bh=o6wrP7wy90tCN8CE8gc1Mxm5L1hLG7tkv+oHkWo2rLQ=;
	h=Date:To:From:Subject:Message-Id; b=WAaV9ToxPtXZIgyFcJ3gEs2xU7IjZfJcMc0cq9otv+0W64mTGWgZufv/460kUTL/mXdCH8lyXN+j7cV8w+JeX4tDiJf5uf6CWWx2zvm5kmuVnCl6MNBtOsQIrjETz4suNoECFxIFhlsjMEHvtC/c+M9zfHNWUYR200SH3xbyfBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2T7GuSg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2T7GuSg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658C4C32782;
	Fri, 16 Aug 2024 05:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785420;
	bh=o6wrP7wy90tCN8CE8gc1Mxm5L1hLG7tkv+oHkWo2rLQ=;
	h=Date:To:From:Subject:From;
	b=2T7GuSg/6nJBxFc3rSALm9uEbDRVzru5R+yiiGXLti8gx3lZ806UHGNWgF9MicgUV
	 Me0vlkUDb6q90HNdCcfO/GtbuwK4Evq6pTzigfqoT2QbcEEj3HHQYSWd6W2c4qgaYJ
	 FwSUxo/+ubjojhlQ1CVA/T3fD7PWE03IXRxH0Q0s=
Date: Thu, 15 Aug 2024 22:16:59 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,shy828301@gmail.com,mgorman@suse.de,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-numa-no-task_numa_fault-call-if-pmd-is-changed.patch removed from -mm tree
Message-Id: <20240816051700.658C4C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/numa: no task_numa_fault() call if PMD is changed
has been removed from the -mm tree.  Its filename was
     mm-numa-no-task_numa_fault-call-if-pmd-is-changed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/numa: no task_numa_fault() call if PMD is changed
Date: Fri, 9 Aug 2024 10:59:05 -0400

When handling a numa page fault, task_numa_fault() should be called by a
process that restores the page table of the faulted folio to avoid
duplicated stats counting.  Commit c5b5a3dd2c1f ("mm: thp: refactor NUMA
fault handling") restructured do_huge_pmd_numa_page() and did not avoid
task_numa_fault() call in the second page table check after a numa
migration failure.  Fix it by making all !pmd_same() return immediately.

This issue can cause task_numa_fault() being called more than necessary
and lead to unexpected numa balancing results (It is hard to tell whether
the issue will cause positive or negative performance impact due to
duplicated numa fault counting).

Link: https://lkml.kernel.org/r/20240809145906.1513458-3-ziy@nvidia.com
Fixes: c5b5a3dd2c1f ("mm: thp: refactor NUMA fault handling")
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Closes: https://lore.kernel.org/linux-mm/87zfqfw0yw.fsf@yhuang6-desk2.ccr.corp.intel.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~mm-numa-no-task_numa_fault-call-if-pmd-is-changed
+++ a/mm/huge_memory.c
@@ -1685,7 +1685,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
 		spin_unlock(vmf->ptl);
-		goto out;
+		return 0;
 	}
 
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
@@ -1728,22 +1728,16 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATED;
 		nid = target_nid;
-	} else {
-		flags |= TNF_MIGRATE_FAIL;
-		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-		if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
-			spin_unlock(vmf->ptl);
-			goto out;
-		}
-		goto out_map;
-	}
-
-out:
-	if (nid != NUMA_NO_NODE)
 		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
+		return 0;
+	}
 
-	return 0;
-
+	flags |= TNF_MIGRATE_FAIL;
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
+		spin_unlock(vmf->ptl);
+		return 0;
+	}
 out_map:
 	/* Restore the PMD */
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
@@ -1753,7 +1747,10 @@ out_map:
 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, pmd);
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	spin_unlock(vmf->ptl);
-	goto out;
+
+	if (nid != NUMA_NO_NODE)
+		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from ziy@nvidia.com are

memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch
mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch

