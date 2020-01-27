From: akpm@linux-foundation.org
Subject: [failures]
 mm-mremap-start-addresses-are-properly-aligned.patch removed from -mm tree
Date: Sun, 26 Jan 2020 18:59:34 -0800
Message-ID: <20200127025934.j30eI0ga-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0C7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 26 Jan 2020 21:59:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, thellstrom@vmware.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/mremap: start addresses are properly aligned
has been removed from the -mm tree.  Its filename was
     mm-mremap-start-addresses-are-properly-aligned.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/mremap: start addresses are properly aligned

After previous cleanup, extent is the minimal step for both source and
destination.  This means when extent is HPAGE_PMD_SIZE or PMD_SIZE,
old_addr and new_addr are properly aligned too.

Since these two functions are only invoked in move_page_tables, it is safe
to remove the check now.

Link: http://lkml.kernel.org/r/20200117232254.2792-6-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ---
 mm/mremap.c      |    3 ---
 2 files changed, 6 deletions(-)

--- a/mm/huge_memory.c~mm-mremap-start-addresses-are-properly-aligned
+++ a/mm/huge_memory.c
@@ -1878,9 +1878,6 @@ bool move_huge_pmd(struct vm_area_struct
 	struct mm_struct *mm = vma->vm_mm;
 	bool force_flush = false;
 
-	if ((old_addr & ~HPAGE_PMD_MASK) || (new_addr & ~HPAGE_PMD_MASK))
-		return false;
-
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have release it.
--- a/mm/mremap.c~mm-mremap-start-addresses-are-properly-aligned
+++ a/mm/mremap.c
@@ -199,9 +199,6 @@ static bool move_normal_pmd(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmd;
 
-	if ((old_addr & ~PMD_MASK) || (new_addr & ~PMD_MASK))
-		return false;
