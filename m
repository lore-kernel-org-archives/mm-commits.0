Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113EF58203;
	Wed,  7 Aug 2024 19:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059484; cv=none; b=eEAuLBG/xShnNUYNF1HUEOkZadYYspFUKLx7hlHFWA9LiD8sxLYD6ItQkiCyz5AR0xs0Eqmn+QR5mowrltueNRHFFckBrzHeZowDQMC6PkaV9bw/qy/sFRMZMSioidTKdkORzYRwQt97MVNDPnKA/M9lML5rhEUoJk5ehJ8Upuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059484; c=relaxed/simple;
	bh=8210c0fGKL1IT9ZC/AF8fHWLQWhm4JsRTeaP59BE/sU=;
	h=Date:To:From:Subject:Message-Id; b=SvN2OXgI30pfz5HIYgCNthKWlceddtyEN7E+k0bMD99uBwe2XWx+kdUdjoG5FzhMqzVWrkrZRAcNZUXrvnNylc3LJhgFCOFp3jvnRruNm810zBAk4t3zFc6D/f2bYD+FYUXu3ivxQwngRCtqhkjL3x7oT3U7iAWNqpnBFJkSPXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j2NfsGv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j2NfsGv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FB6C32781;
	Wed,  7 Aug 2024 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723059483;
	bh=8210c0fGKL1IT9ZC/AF8fHWLQWhm4JsRTeaP59BE/sU=;
	h=Date:To:From:Subject:From;
	b=j2NfsGv2WyzrvI4nFKxB58ljZeXLk4Im8xviAbJ2LsIfSSbriBy274x3bwhWzTxrl
	 /TuigPBGz2lCoVK/FTz2fr1PyE+qd7eSUIT2isn+PVhHKf6gdn9f/UUoI5k6izoqUW
	 yKf54gI8g7wUA7E7gaCFfGAp5Ehda0X4dEs6SjpI=
Date: Wed, 07 Aug 2024 12:38:02 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa-no-task_numa_fault-call-if-page-table-is-changed.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807193803.86FB6C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/numa: no task_numa_fault() call if page table is changed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-numa-no-task_numa_fault-call-if-page-table-is-changed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa-no-task_numa_fault-call-if-page-table-is-changed.patch

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
Subject: mm/numa: no task_numa_fault() call if page table is changed
Date: Wed, 7 Aug 2024 14:47:29 -0400

When handling a numa page fault, task_numa_fault() should be called by a
process that restores the page table of the faulted folio to avoid
duplicated stats counting.  Commit b99a342d4f11 ("NUMA balancing: reduce
TLB flush via delaying mapping on hint page fault") restructured
do_numa_page() and do_huge_pmd_numa_page() and did not avoid
task_numa_fault() call in the second page table check after a numa
migration failure.  Fix it by making all !pte_same()/!pmd_same() return
immediately.

This issue can cause task_numa_fault() being called more than necessary
and lead to unexpected numa balancing results (It is hard to tell whether
the issue will cause positive or negative performance impact due to
duplicated numa fault counting).

Link: https://lkml.kernel.org/r/20240807184730.1266736-1-ziy@nvidia.com
Fixes: b99a342d4f11 ("NUMA balancing: reduce TLB flush via delaying mapping on hint page fault")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Closes: https://lore.kernel.org/linux-mm/87zfqfw0yw.fsf@yhuang6-desk2.ccr.corp.intel.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++--
 mm/memory.c      |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-numa-no-task_numa_fault-call-if-page-table-is-changed
+++ a/mm/huge_memory.c
@@ -1738,10 +1738,11 @@ vm_fault_t do_huge_pmd_numa_page(struct
 		goto out_map;
 	}
 
-out:
+count_fault:
 	if (nid != NUMA_NO_NODE)
 		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
 
+out:
 	return 0;
 
 out_map:
@@ -1753,7 +1754,7 @@ out_map:
 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, pmd);
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	spin_unlock(vmf->ptl);
-	goto out;
+	goto count_fault;
 }
 
 /*
--- a/mm/memory.c~mm-numa-no-task_numa_fault-call-if-page-table-is-changed
+++ a/mm/memory.c
@@ -5371,9 +5371,10 @@ static vm_fault_t do_numa_page(struct vm
 		goto out_map;
 	}
 
-out:
+count_fault:
 	if (nid != NUMA_NO_NODE)
 		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+out:
 	return 0;
 out_map:
 	/*
@@ -5387,7 +5388,7 @@ out_map:
 		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
 					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	goto out;
+	goto count_fault;
 }
 
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-numa-no-task_numa_fault-call-if-page-table-is-changed.patch
memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch
mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch

