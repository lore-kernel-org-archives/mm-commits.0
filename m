Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAEF2874E3
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 20:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779221518; cv=none; b=NMs3g1MWsNnLPfqNOltUWDa4KNgBKr2RmxpjQnkSMuTLZ/wsKnG5RjMCrd73y3PtfTOIKzSLLD+NinIdWMpM6oG5UGTT7GCMGH3etsAL0ZRA/I3NROCUEsX6JrjVxSNPr7Mjsfs4K6R4SXbpK9fiaFGDJ0+UWvbUY3akkJvfTjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779221518; c=relaxed/simple;
	bh=yqPIxbUoF10d4vP8AsQ9wI4wd3dVoUZkl42eDkNUfOo=;
	h=Date:To:From:Subject:Message-Id; b=TZdevOQ7FG2X75722PCvcySc888beFNYUwGdII8nLLytHWrx1WeyinP2jYAsyW83vpP6fj2qC0ulBXOD1va9xSTSNeW9mCVKqngbCmt+eEIJDg/bPU+qc8gbYq+qoyvmS3YWgNjTgDahwAI/u2Ko6Mx2KHRKqkCjM77gONgrSkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZQwhZfZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZQwhZfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7751F00893;
	Tue, 19 May 2026 20:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779221517;
	bh=9q2EtWo06RdcfvYD466+8C8iL3+Rf9YU0N4Sy+4puE0=;
	h=Date:To:From:Subject;
	b=qZQwhZfZ+mBeo1woDbU3Dl1NmawjWSeXNDeItoOD8GHTNzfnEk/Vju8t4xKFpSC4I
	 51W+UXILDoj9RHJZjB7XCJnxUrBCwYavkn96X+cN5q40RhcJHyp2tGPyj+yZApjUAr
	 MJnahDZlrbZeQB0Qvc6wO2QjbSJrG+sI2NfetGNc=
Date: Tue, 19 May 2026 13:11:56 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-avoid-false-positive-lockdep-assertion-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260519201157.0B7751F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-avoid-false-positive-lockdep-assertion-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-avoid-false-positive-lockdep-assertion-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-avoid-false-positive-lockdep-assertion-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm-hugetlb-avoid-false-positive-lockdep-assertion-fix
Date: Thu, 14 May 2026 10:45:38 +0100

account for the !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING case

Link: https://lore.kernel.org/agWZsPGYid08uU6O@lucifer
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-false-positive-lockdep-assertion-fix
+++ a/mm/hugetlb.c
@@ -118,6 +118,9 @@ static int hugetlb_acct_memory(struct hs
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
+static int __huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
@@ -6970,6 +6973,13 @@ pte_t *huge_pmd_share(struct mm_struct *
 	return NULL;
 }
 
+static int __huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		bool check_locks)
+{
+	return 0;
+}
+
 int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
_

Patches currently in -mm which might be from ljs@kernel.org are

revert-mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-hugetlb-avoid-false-positive-lockdep-assertion.patch
mm-hugetlb-avoid-false-positive-lockdep-assertion-fix.patch

