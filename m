From: akpm@linux-foundation.org
Subject: [folded-merged] mm-account-pud-page-tables-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 17:01:32 -0800
Message-ID: <5a0ce36c.8jL7b2DWObt6oBFJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbdKPBBd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:01:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-account-pud-page-tables-fix
has been removed from the -mm tree.  Its filename was
     mm-account-pud-page-tables-fix.patch

This patch was dropped because it was folded into mm-account-pud-page-tables.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm-account-pud-page-tables-fix

s/pmd_t/pud_t/

Link: http://lkml.kernel.org/r/20171004074305.x35eh5u7ybbt5kar@black.fi.intel.com
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-account-pud-page-tables-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-account-pud-page-tables-fix
+++ a/fs/proc/task_mmu.c
@@ -55,7 +55,7 @@ void task_mem(struct seq_file *m, struct
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	ptes = PTRS_PER_PTE * sizeof(pte_t) * atomic_long_read(&mm->nr_ptes);
 	pmds = PTRS_PER_PMD * sizeof(pmd_t) * mm_nr_pmds(mm);
-	puds = PTRS_PER_PUD * sizeof(pmd_t) * mm_nr_puds(mm);
+	puds = PTRS_PER_PUD * sizeof(pud_t) * mm_nr_puds(mm);
 	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-account-pud-page-tables.patch
mm-introduce-wrappers-to-access-mm-nr_ptes.patch
mm-consolidate-page-table-accounting.patch
mm-consolidate-page-table-accounting-fix.patch

