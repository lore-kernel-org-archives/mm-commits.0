From: akpm@linux-foundation.org
Subject: +
 dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3.patch added
 to -mm tree
Date: Mon, 17 Oct 2016 13:29:59 -0700
Message-ID: <580534c7.Eoq4k3ZvHO5NNTLU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56313 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759384AbcJQUaA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 16:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mgorman@suse.de, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3
has been added to the -mm tree.  Its filename is
     dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3

v3: Minor updates from Mel. Change code layout.

Link: http://lkml.kernel.org/r/1476382117-5440-1-git-send-email-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/mprotect.c~dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3 mm/mprotect.c
--- a/mm/mprotect.c~dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3
+++ a/mm/mprotect.c
@@ -70,16 +70,16 @@ static unsigned long change_pte_range(st
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	unsigned long pages = 0;
-	int target_node = -1;
+	int target_node = NUMA_NO_NODE;
 
 	pte = lock_pte_protection(vma, pmd, addr, prot_numa, &ptl);
 	if (!pte)
 		return 0;
 
-	if (prot_numa &&
-	    !(vma->vm_flags & VM_SHARED) &&
+	/* Get target node for single threaded private VMAs */
+	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
 	    atomic_read(&vma->vm_mm->mm_users) == 1)
-	    target_node = cpu_to_node(raw_smp_processor_id());
+		target_node = numa_node_id();
 
 	arch_enter_lazy_mmu_mode();
 	do {
_

Patches currently in -mm which might be from ak@linux.intel.com are

dont-touch-single-threaded-ptes-which-are-on-the-right-node.patch
dont-touch-single-threaded-ptes-which-are-on-the-right-node-v3.patch

