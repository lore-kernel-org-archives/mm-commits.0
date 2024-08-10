Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6F3B1A4;
	Sat, 10 Aug 2024 01:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723252511; cv=none; b=oUjbtbYcteLZVxH1WPyaUgO9U6ckDitUESrtLq484YEnFDn+JcDlzQYyxxAEtr+d/3+IuXRDh8MIyDM7iT0GlckMzwdAD0ZtrEkHumkoC+F0B50yPgp2Bz77I8xA0VGpAyc6goRjXYSzGCJbsD9HJlOOQLVFYFrGMcGU6MlHl5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723252511; c=relaxed/simple;
	bh=mHb4+1V+84eZKzLYFJi0rOdh0tfcOJghlBiTyFtGOBM=;
	h=Date:To:From:Subject:Message-Id; b=JsMdssApFG9rxMa3PD5xSgVlo1uRHnhNnsnbEUmjGtz+vqXNtY9GWKAdfHVXrNKc9d8xA4yHoXHrThOqw9g6BDk+nPNiX44l7/O8enyw8X5RearpXx8dnPSOqQXRNqR2jXCRA1Ouj1EmMIBrKHUcJoxog6gZnpBXnXeiwhGf3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f+uzWxKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f+uzWxKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B300DC32782;
	Sat, 10 Aug 2024 01:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723252510;
	bh=mHb4+1V+84eZKzLYFJi0rOdh0tfcOJghlBiTyFtGOBM=;
	h=Date:To:From:Subject:From;
	b=f+uzWxKrFOLU09IVYIhguyCgGCpwq6mnRLwhDf1pdIBhHmgYcVnCHE3RiRFYBb8Wj
	 /xVc9A89eireXIjHQJ+5Ybw7idsTLg61BMGpy2KSbpckFFJoKI4COu1CHBJst9+3Uc
	 KQANb+0tmxGbfIkE433mC8HEq2L021d32N6caUFk=
Date: Fri, 09 Aug 2024 18:15:10 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,shy828301@gmail.com,mgorman@suse.de,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa-no-task_numa_fault-call-if-pmd-is-changed.patch added to mm-hotfixes-unstable branch
Message-Id: <20240810011510.B300DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/numa: no task_numa_fault() call if PMD is changed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-numa-no-task_numa_fault-call-if-pmd-is-changed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa-no-task_numa_fault-call-if-pmd-is-changed.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-numa-no-task_numa_fault-call-if-pte-is-changed.patch
mm-numa-no-task_numa_fault-call-if-pmd-is-changed.patch
memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

