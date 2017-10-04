From: akpm@linux-foundation.org
Subject: + mm-account-pud-page-tables-fix.patch added to -mm tree
Date: Wed, 04 Oct 2017 15:14:24 -0700
Message-ID: <59d55d40.g6DVOstXFj50bh3p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdJDWOZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-account-pud-page-tables-fix
has been added to the -mm tree.  Its filename is
     mm-account-pud-page-tables-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-account-pud-page-tables-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-account-pud-page-tables-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -51,7 +51,7 @@ void task_mem(struct seq_file *m, struct
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
mm-account-pud-page-tables-fix.patch
mm-add-infrastructure-for-get_user_pages_fast-benchmarking.patch

