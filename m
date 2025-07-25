Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A004E257AF9
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486175; cv=none; b=cWUZKueeqmBg5+/ZB+mZkoLRKyQmK6/dvvdypAWGRuJ3LW+H469YWTjZRhMSmkWfXzOlPt6RjYqQL/eXtOaTICiqslgLod8kcjTNGYVYe1B/F/TnSBHxbyd2yjnG4V8+CjiX6PBLMOMlZ6PKjKU5CwTNs3Wu6EdM41bzy7YT5F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486175; c=relaxed/simple;
	bh=vKT3eQMEToxO3fViIXFkX+9u8Wfi38KFAEh/h8fcMqY=;
	h=Date:To:From:Subject:Message-Id; b=ARrE1klFkp82FCCUSMTTUvDlAEvnufsB1Hs1w60MsopdRCtC7r6GVNIW9obfFlrqVxfps9HqDLsFzZdRW3bHao6bs8YqBSkF/EuL9lNK0AGBfjgOiuxmKA2RqxoTDxYyO6CLil+S0d6cRISv9pwY8zCyYKgV3P5rLRfK3PaQyoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n/HOoDK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n/HOoDK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724E3C4CEE7;
	Fri, 25 Jul 2025 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753486175;
	bh=vKT3eQMEToxO3fViIXFkX+9u8Wfi38KFAEh/h8fcMqY=;
	h=Date:To:From:Subject:From;
	b=n/HOoDK1CffU+Vep30xRI5lmkdlEkPPAHByzsLtUEknzlOoDD8Gj6hmVrlMnXQfbO
	 WhWHXLopP4wBPd0Ig05Gq1JiWALa+oyc/+jspSFglZfnZDu33wtBtrkxO2gM7vGPsW
	 6dm4e2B5fTq3cd2vurfLV/9dHqWooRaETaSUSnuA=
Date: Fri, 25 Jul 2025 16:29:34 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,thiago.bauermann@linaro.org,ryan.roberts@arm.com,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,joern@logfs.org,hughd@google.com,dev.jain@arm.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,brahmajit.xyz@gmail.com,baolin.wang@linux.alibaba.com,avagin@gmail.com,andrii@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-hold-ptl-in-hwpoison_hugetlb_range.patch added to mm-unstable branch
Message-Id: <20250725232935.724E3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: hold PTL in hwpoison_hugetlb_range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-hold-ptl-in-hwpoison_hugetlb_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-hold-ptl-in-hwpoison_hugetlb_range.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/memory-failure: hold PTL in hwpoison_hugetlb_range
Date: Fri, 25 Jul 2025 11:31:12 +0800

Hold PTL in hwpoison_hugetlb_range() to avoid operating on stale page, as
hwpoison_pte_range() have done.

Link: https://lkml.kernel.org/r/20250725033112.2690158-1-tujinjiang@huawei.com
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

 mm/memory-failure.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-hold-ptl-in-hwpoison_hugetlb_range
+++ a/mm/memory-failure.c
@@ -837,11 +837,17 @@ static int hwpoison_hugetlb_range(pte_t
 			    struct mm_walk *walk)
 {
 	struct hwpoison_walk *hwp = walk->private;
-	pte_t pte = huge_ptep_get(walk->mm, addr, ptep);
 	struct hstate *h = hstate_vma(walk->vma);
+	spinlock_t *ptl;
+	pte_t pte;
+	int ret;
 
-	return check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
-				      hwp->pfn, &hwp->tk);
+	ptl = huge_pte_lock(h, walk->mm, ptep);
+	pte = huge_ptep_get(walk->mm, addr, ptep);
+	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
+					hwp->pfn, &hwp->tk);
+	spin_unlock(ptl);
+	return ret;
 }
 #else
 #define hwpoison_hugetlb_range	NULL
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch
mm-memory-failure-hold-ptl-in-hwpoison_hugetlb_range.patch
mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch
fs-proc-task_mmu-hold-ptl-in-pagemap_hugetlb_range-and-gather_hugetlb_stats.patch
mm-mincore-hold-ptl-in-mincore_hugetlb.patch

