From: akpm@linux-foundation.org
Subject: +
 mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry.patch
 added to -mm tree
Date: Wed, 01 Nov 2017 14:14:25 -0700
Message-ID: <59fa3931.jSAurAGlInJkZTaS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933191AbdKAVO0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2017 17:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zi.yan@cs.rutgers.edu, fengguang.wu@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: deposit page table when copying a PMD migration entry
has been added to the -mm tree.  Its filename is
     mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <zi.yan@cs.rutgers.edu>
Subject: mm/huge_memory.c: deposit page table when copying a PMD migration entry

We need to deposit pre-allocated PTE page table when a PMD migration entry
is copied in copy_huge_pmd().  Otherwise, we will leak the pre-allocated
page and cause a NULL pointer dereference later in zap_huge_pmd().

The missing counters during PMD migration entry copy process are added as
well.

The bug report is here: https://lkml.org/lkml/2017/10/29/214

Link: http://lkml.kernel.org/r/20171030144636.4836-1-zi.yan@sent.com
Fixes: 84c3fc4e9c563 ("mm: thp: check pmd migration entry in common path")
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/huge_memory.c~mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry mm/huge_memory.c
--- a/mm/huge_memory.c~mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry
+++ a/mm/huge_memory.c
@@ -941,6 +941,9 @@ int copy_huge_pmd(struct mm_struct *dst_
 				pmd = pmd_swp_mksoft_dirty(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
+		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		atomic_long_inc(&dst_mm->nr_ptes);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 		set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 		ret = 0;
 		goto out_unlock;
_

Patches currently in -mm which might be from zi.yan@cs.rutgers.edu are

mm-migration-deposit-page-table-when-copying-a-pmd-migration-entry.patch

