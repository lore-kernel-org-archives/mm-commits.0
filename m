From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-fix-smp-race-condition-between-thp-page-fault-and-madv_dontneed.patch removed from -mm tree
Date: Mon, 29 Feb 2016 12:24:36 -0800
Message-ID: <56d4a904.YYpoJpbrz1QMgs5y%akpm__44729.0163174786$1456777516$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbcB2UYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 15:24:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix SMP race condition between THP page fault and MADV_DONTNEED
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-smp-race-condition-between-thp-page-fault-and-madv_dontneed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: fix SMP race condition between THP page fault and MADV_DONTNEED

pmd_trans_unstable()/pmd_none_or_trans_huge_or_clear_bad() were introduced
to locklessy (but atomically) detect when a pmd is a regular (stable) pmd
or when the pmd is unstable and can infinitely transition from pmd_none()
and pmd_trans_huge() from under us, while only holding the mmap_sem for
reading (for writing not).

While holding the mmap_sem only for reading, MADV_DONTNEED can run from
under us and so before we can assume the pmd to be a regular stable pmd we
need to compare it against pmd_none() and pmd_trans_huge() in an atomic
way, with pmd_trans_unstable().  The old pmd_trans_huge() left a tiny
window for a race.

Useful applications are unlikely to notice the difference as doing
MADV_DONTNEED concurrently with a page fault would lead to undefined
behavior.

[akpm@linux-foundation.org: tidy up comment grammar/layout]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-thp-fix-smp-race-condition-between-thp-page-fault-and-madv_dontneed mm/memory.c
--- a/mm/memory.c~mm-thp-fix-smp-race-condition-between-thp-page-fault-and-madv_dontneed
+++ a/mm/memory.c
@@ -3404,8 +3404,18 @@ static int __handle_mm_fault(struct mm_s
 	if (unlikely(pmd_none(*pmd)) &&
 	    unlikely(__pte_alloc(mm, vma, pmd, address)))
 		return VM_FAULT_OOM;
-	/* if an huge pmd materialized from under us just retry later */
-	if (unlikely(pmd_trans_huge(*pmd) || pmd_devmap(*pmd)))
+	/*
+	 * If a huge pmd materialized under us just retry later.  Use
+	 * pmd_trans_unstable() instead of pmd_trans_huge() to ensure the pmd
+	 * didn't become pmd_trans_huge under us and then back to pmd_none, as
+	 * a result of MADV_DONTNEED running immediately after a huge pmd fault
+	 * in a different thread of this mm, in turn leading to a misleading
+	 * pmd_trans_huge() retval.  All we have to ensure is that it is a
+	 * regular pmd that we can walk with pte_offset_map() and we can do that
+	 * through an atomic read in C, which is what pmd_trans_unstable()
+	 * provides.
+	 */
+	if (unlikely(pmd_trans_unstable(pmd) || pmd_devmap(*pmd)))
 		return 0;
 	/*
 	 * A regular pmd is established and it can't morph into a huge pmd
_

Patches currently in -mm which might be from aarcange@redhat.com are

ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-3.patch

