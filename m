Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8E51272DB
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711480277; cv=none; b=hMnq39taFWlth7o5oPHvYcr5bjyds5HbuZRFUuNCkW6zI3ufvrnysFlSl7xtwEgdnq0QiD4iSCocvbsTOcdKXIwFfLiHoC9U+vr4bPlsWS7P90IwT9r0nLkZ2oBch+MZGTRJb6ybZvfGwNupsqEvOc/XWEfFOT0LNzsEuli32B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711480277; c=relaxed/simple;
	bh=deqGj4VmtwUshhfQTtecJUcXK25L7e1dCibA9qo9c0g=;
	h=Date:To:From:Subject:Message-Id; b=t9H2za8TSga294y76wl6XnNxcgW2WUwwy7uXDrId9Chkp7wIJj6moNR4kuHOcn36FF70vDWnVyS1BdMjeODgH6jVXBq0qHasSsS2LvxCcuC7xiTJVmvQbOIt4Vv2UgQX6agaN/cK5c9EdXpfSjzGWz2F8du+UbqKfsQpVhg02h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QpeTtNAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QpeTtNAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9B1C433F1;
	Tue, 26 Mar 2024 19:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711480276;
	bh=deqGj4VmtwUshhfQTtecJUcXK25L7e1dCibA9qo9c0g=;
	h=Date:To:From:Subject:From;
	b=QpeTtNASkT9/vHbJEowSEykhIfCKuCNbSllsHYzRZs8+sOKRF/stHND57B1AQp1dq
	 UfKG42XMCz9xKYA/oYAybznRI+kXCteqZ2SQ08tG4StZa6VlcYbEzSUy05tp51Qlrp
	 zh4Cwb70znKUHTJ6MBwXBAPq269facJShgNrBpSA=
Date: Tue, 26 Mar 2024 12:11:16 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,mgorman@techsingularity.net,jhubbard@nvidia.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch added to mm-unstable branch
Message-Id: <20240326191116.BE9B1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: factor out the numa mapping rebuilding into a new helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: factor out the numa mapping rebuilding into a new helper
Date: Tue, 26 Mar 2024 19:51:24 +0800

Patch series "support multi-size THP numa balancing".

This patchset tries to support mTHP numa balancing, as a simple solution
to start, the NUMA balancing algorithm for mTHP will follow the THP
strategy as the basic support.


This patch (of 2):

To support large folio's numa balancing, factor out the numa mapping
rebuilding into a new helper as a preparation.

Link: https://lkml.kernel.org/r/cover.1711453317.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/0c9df470bd2a62af8cc707cf01e42c7c744dd927.1711453317.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper
+++ a/mm/memory.c
@@ -5054,6 +5054,20 @@ int numa_migrate_prep(struct folio *foli
 	return mpol_misplaced(folio, vmf, addr);
 }
 
+static void numa_rebuild_single_mapping(struct vm_fault *vmf, struct vm_area_struct *vma,
+					bool writable)
+{
+	pte_t pte, old_pte;
+
+	old_pte = ptep_modify_prot_start(vma, vmf->address, vmf->pte);
+	pte = pte_modify(old_pte, vma->vm_page_prot);
+	pte = pte_mkyoung(pte);
+	if (writable)
+		pte = pte_mkwrite(pte, vma);
+	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+}
+
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -5159,13 +5173,7 @@ out_map:
 	 * Make it present again, depending on how arch implements
 	 * non-accessible ptes, some can allow access by kernel mode.
 	 */
-	old_pte = ptep_modify_prot_start(vma, vmf->address, vmf->pte);
-	pte = pte_modify(old_pte, vma->vm_page_prot);
-	pte = pte_mkyoung(pte);
-	if (writable)
-		pte = pte_mkwrite(pte, vma);
-	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
-	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+	numa_rebuild_single_mapping(vmf, vma, writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	goto out;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch
mm-factor-out-the-numa-mapping-rebuilding-into-a-new-helper.patch
mm-support-multi-size-thp-numa-balancing.patch

