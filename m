Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D1A4A1E
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 22:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723157466; cv=none; b=HulgaBn6DEpJscqWBzJmwW5k0roMqZp3nSCelLkuAgtYDoTbYEwmA7iMDs0Pg9QSM5BN4uTOc2uDjOIGb+knUYCGCIeh21R69fpI+6Cij6lTRGVEMuEcS6pCCQHZo3mc+yG4l9XDiT0PpLHfO4LrAcfpeggj+GoHLmH+x4BHnYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723157466; c=relaxed/simple;
	bh=yVCy19sDVpBI//8bapA+NW8HAoQDDpFEWUdXGvKsoKE=;
	h=Date:To:From:Subject:Message-Id; b=jC9QtT3oKCHglsF5jN71x8JZ6KqBekEmQvuSOWaYIKhSQjlr9K7mcmIO8HptyN6Pw4YJpFE88VC9qNjN9hKFiNgHiUy4G0/WPQLW//L43goK4AUAC2UesCwJ39pdiAas745aHhEdrb++3ric9rZzFkP/e1GJ3Vc+EtOo+qOVX9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RbBjLjWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RbBjLjWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF013C32782;
	Thu,  8 Aug 2024 22:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723157465;
	bh=yVCy19sDVpBI//8bapA+NW8HAoQDDpFEWUdXGvKsoKE=;
	h=Date:To:From:Subject:From;
	b=RbBjLjWGvlIKxA8/uJgq5mJKZThy/Axcgqi5dePQuabhZSI1DBh+JypbnDvLuOGvB
	 +9ZQ9SeOjvs/+YdFzlYbHIZNjTarlYKm5CtH6rpuh+oXPj/GjgcGgtF7CVqMUjykIr
	 +5H48jtU+rjsqJyWxmKXQZZWTRmBvyM+zjJiDMs0=
Date: Thu, 08 Aug 2024 15:51:05 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240808225105.CF013C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix.patch

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
Subject: mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix
Date: Thu, 08 Aug 2024 11:12:54 -0400

code simplification, per David

Link: https://lkml.kernel.org/r/819987AD-273B-4AFB-9447-39F32664EBDE@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++-----------
 mm/memory.c      |   19 ++++++++-----------
 2 files changed, 15 insertions(+), 22 deletions(-)

--- a/mm/huge_memory.c~mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix
+++ a/mm/huge_memory.c
@@ -1685,7 +1685,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
 		spin_unlock(vmf->ptl);
-		goto out;
+		return 0;
 	}
 
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
@@ -1728,23 +1728,16 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATED;
 		nid = target_nid;
+		goto out;
 	} else {
 		flags |= TNF_MIGRATE_FAIL;
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 		if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
 			spin_unlock(vmf->ptl);
-			goto out;
+			return 0;
 		}
-		goto out_map;
 	}
 
-count_fault:
-	if (nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
-
-out:
-	return 0;
-
 out_map:
 	/* Restore the PMD */
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
@@ -1754,7 +1747,10 @@ out_map:
 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, pmd);
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	spin_unlock(vmf->ptl);
-	goto count_fault;
+out:
+	if (nid != NUMA_NO_NODE)
+		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
+	return 0;
 }
 
 /*
--- a/mm/memory.c~mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix
+++ a/mm/memory.c
@@ -5295,7 +5295,7 @@ static vm_fault_t do_numa_page(struct vm
 
 	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		goto out;
+		return 0;
 	}
 
 	pte = pte_modify(old_pte, vma->vm_page_prot);
@@ -5358,24 +5358,18 @@ static vm_fault_t do_numa_page(struct vm
 	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		nid = target_nid;
 		flags |= TNF_MIGRATED;
+		goto out;
 	} else {
 		flags |= TNF_MIGRATE_FAIL;
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					       vmf->address, &vmf->ptl);
 		if (unlikely(!vmf->pte))
-			goto out;
+			return 0;
 		if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			goto out;
+			return 0;
 		}
-		goto out_map;
 	}
-
-count_fault:
-	if (nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, nid, nr_pages, flags);
-out:
-	return 0;
 out_map:
 	/*
 	 * Make it present again, depending on how arch implements
@@ -5388,7 +5382,10 @@ out_map:
 		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
 					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-	goto count_fault;
+out:
+	if (nid != NUMA_NO_NODE)
+		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+	return 0;
 }
 
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-numa-no-task_numa_fault-call-if-page-table-is-changed.patch
mm-numa-no-task_numa_fault-call-if-page-table-is-changed-fix.patch
memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_use_access_time-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch
mm-migrate-move-common-code-to-numa_migrate_check-was-numa_migrate_prep.patch

