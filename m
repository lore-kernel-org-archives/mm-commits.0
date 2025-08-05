Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274CB230BFF
	for <mm-commits@vger.kernel.org>; Tue,  5 Aug 2025 20:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754426369; cv=none; b=s0+Ve8foC7/PX1ZMjZhERJHyKIWU1fj5y+8oz1ayFE98fTcl2/7vU09M8BZWODensPwQ1JQl5sE56O5y+D/ZjMZ/SNoaetDEleydZ1ntxauqIdS0Ru5ARCRhtfl3pj3L3LoZYVcD6oGP1kbxc0PrWvd8v025Flj1cPjUIgTXh3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754426369; c=relaxed/simple;
	bh=yQEN/O1xlFEn786PXzYhBVyTPEA8ckwtozX9w9iNGe8=;
	h=Date:To:From:Subject:Message-Id; b=Zab+iBCCgo2Qw3zT6d8hcpWfkbypQtLD0m33NashKHcARam98gXMpxY6bO+uvN9tMFs714bB9iqlVD5ntTTEh30wUvCC8omu9BXcqiJAjrQQSI2AxX5abX0lx1uiWSP2mtFg5zeR/FBCvWD5gM+H+6J47NDx9rSx3rNN2PjAWgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dDHb6KKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dDHb6KKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9725BC4CEF0;
	Tue,  5 Aug 2025 20:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754426368;
	bh=yQEN/O1xlFEn786PXzYhBVyTPEA8ckwtozX9w9iNGe8=;
	h=Date:To:From:Subject:From;
	b=dDHb6KKgRYVqvn7Al6dSvyNxnwHxNJERV5x2TNyBMQE/iLJRR6AAQKRg0HTwRF4CL
	 BHx3cKWbXEdrE3DWxiKP5Akrfi+Zdw+Dz809ygQ8KuB5qAG0D1XQqF9q5CKGhMEKWB
	 lmDI1E7fYdqRawGt3p0GVqwTk6kMgANuZibPECr8=
Date: Tue, 05 Aug 2025 13:39:28 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,thiago.bauermann@linaro.org,ryan.roberts@arm.com,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,joern@logfs.org,hughd@google.com,dev.jain@arm.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,brahmajit.xyz@gmail.com,baolin.wang@linux.alibaba.com,avagin@gmail.com,andrii@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch removed from -mm tree
Message-Id: <20250805203928.9725BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/smaps: fix race between smaps_hugetlb_range and migration
has been removed from the -mm tree.  Its filename was
     mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/smaps: fix race between smaps_hugetlb_range and migration
Date: Thu, 24 Jul 2025 17:09:56 +0800

smaps_hugetlb_range() handles the pte without holdling ptl, and may be
concurrenct with migration, leaing to BUG_ON in pfn_swap_entry_to_page(). 
The race is as follows.

smaps_hugetlb_range              migrate_pages
  huge_ptep_get
                                   remove_migration_ptes
				   folio_unlock
  pfn_swap_entry_folio
    BUG_ON

To fix it, hold ptl lock in smaps_hugetlb_range().

Link: https://lkml.kernel.org/r/20250724090958.455887-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20250724090958.455887-2-tujinjiang@huawei.com
Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration
+++ a/fs/proc/task_mmu.c
@@ -1148,10 +1148,13 @@ static int smaps_hugetlb_range(pte_t *pt
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t ptent = huge_ptep_get(walk->mm, addr, pte);
 	struct folio *folio = NULL;
 	bool present = false;
+	spinlock_t *ptl;
+	pte_t ptent;
 
+	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, pte);
+	ptent = huge_ptep_get(walk->mm, addr, pte);
 	if (pte_present(ptent)) {
 		folio = page_folio(pte_page(ptent));
 		present = true;
@@ -1170,6 +1173,7 @@ static int smaps_hugetlb_range(pte_t *pt
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
+	spin_unlock(ptl);
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

