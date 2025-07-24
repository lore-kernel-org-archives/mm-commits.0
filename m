Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E6B61FFE
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 22:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394533; cv=none; b=HgR6dFtFaATMBgR4Mv8hgMXjFe2RhiZYgSlMRoNMOWvBvJlB3a7Ta+Gxg4juVLzWF/VuRZIeL007boYplQZt8rOMfbaTey3e99NHcmbEF3/xcAYby2sUTBDuho29CwGOR9SRt/0xsT1+c2aodc4qt4PZvoOzgDCCEdH6vWd9Hxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394533; c=relaxed/simple;
	bh=yj85EMyVEXZXsE81lh3zy3kYCtkyUQwYqM+NUhtmgT4=;
	h=Date:To:From:Subject:Message-Id; b=FhnjxMjft+V6zw/euzJVZrr+v39mt/MliUBx/k+ZumfxruwloXkOp5Z2sSamrG20F5vBrQ1Jum9N2UbQhD1HsbdP8RF0FlCbGi2NN+sUrQwLJlIMxnYECid5/ngFRd6msk+oAcTTwXX7lB/fT45TTD6CJMV+hFgVx0ZI139Sibs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g2VKjVzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g2VKjVzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEDCC4CEED;
	Thu, 24 Jul 2025 22:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753394532;
	bh=yj85EMyVEXZXsE81lh3zy3kYCtkyUQwYqM+NUhtmgT4=;
	h=Date:To:From:Subject:From;
	b=g2VKjVzp9406kzQXN6xqdEvdv3FjsGMQ0nRLW+HrMki2JKDN9u1RIJAcc+tyJxYjz
	 kKpee6Z5rrc6FOrwCqL9ohakMEEihmGj0+4igITRP7ugh1W2wJwTXs6aNd6zhwQiPG
	 UTXuijbvu9m5ocGNGCUXYcr2AOsDczdDcF/Dd4qI=
Date: Thu, 24 Jul 2025 15:02:11 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,thiago.bauermann@linaro.org,ryan.roberts@arm.com,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,joern@logfs.org,hughd@google.com,dev.jain@arm.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,brahmajit.xyz@gmail.com,baolin.wang@linux.alibaba.com,avagin@gmail.com,andrii@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch added to mm-new branch
Message-Id: <20250724220212.6AEDCC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/smaps: fix race between smaps_hugetlb_range and migration
has been added to the -mm mm-new branch.  Its filename is
     mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/smaps: fix race between smaps_hugetlb_range and migration
Date: Thu, 24 Jul 2025 17:09:56 +0800

Patch series "hold PTL for several .hugetlb_entry callbacks", v2.

Patch #1 fixes a race between smaps_hugetlb_range() and migration by
holding PTL in smaps_hugetlb_range().

To avoid operating on stale pages, add PTL for several .hugetlb_entry
callbacks too.  We don't hold PTL in __s390_enable_skey_hugetlb() and
prot_none_hugetlb_entry(), since the mmap write lock is held.  We don't
hold PTL in hwpoison_hugetlb_range() too, since it only reads the pte and
doesn't operate the page.


This patch (of 3):

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
mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch
fs-proc-task_mmu-hold-ptl-in-pagemap_hugetlb_range-and-gather_hugetlb_stats.patch
mm-mincore-hold-ptl-in-mincore_hugetlb.patch

