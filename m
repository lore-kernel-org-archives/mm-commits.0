From: akpm@linux-foundation.org
Subject: + mm-memoryc-mark-functions-as-static.patch added to -mm tree
Date: Fri, 07 Feb 2014 14:31:25 -0800
Message-ID: <52f55ebd.b4ThIE5E1xXyisNO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaBGWb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:31:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: + mm-memoryc-mark-functions-as-static.patch added to -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,riel@redhat.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:31:25 -0800


The patch titled
     Subject: mm/memory.c: mark functions as static
has been added to the -mm tree.  Its filename is
     mm-memoryc-mark-functions-as-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-mark-functions-as-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-mark-functions-as-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/memory.c: mark functions as static

mark functions as static in memory.c because they are not used outside
this file.

This eliminates the following warnings in mm/memory.c:
mm/memory.c:3530:5: warning: no previous prototype for `numa_migrate_prep' [-Wmissing-prototypes]
mm/memory.c:3545:5: warning: no previous prototype for `do_numa_page' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-memoryc-mark-functions-as-static mm/memory.c
--- a/mm/memory.c~mm-memoryc-mark-functions-as-static
+++ a/mm/memory.c
@@ -3530,7 +3530,7 @@ static int do_nonlinear_fault(struct mm_
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
-int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
 				unsigned long addr, int page_nid,
 				int *flags)
 {
@@ -3545,7 +3545,7 @@ int numa_migrate_prep(struct page *page,
 	return mpol_misplaced(page, vma, addr);
 }
 
-int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
+static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		   unsigned long addr, pte_t pte, pte_t *ptep, pmd_t *pmd)
 {
 	struct page *page = NULL;
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch

