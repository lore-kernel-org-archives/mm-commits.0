From: akpm@linux-foundation.org
Subject: +
 dont-touch-single-threaded-ptes-which-are-on-the-right-node.patch added to
 -mm tree
Date: Wed, 12 Oct 2016 16:18:46 -0700
Message-ID: <57fec4d6.bszm03+/GjsTn0/9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933112AbcJLXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 19:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mgorman@techsingularity.net, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: don't touch single threaded PTEs which are on the right node
has been added to the -mm tree.  Its filename is
     dont-touch-single-threaded-ptes-which-are-on-the-right-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dont-touch-single-threaded-ptes-which-are-on-the-right-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dont-touch-single-threaded-ptes-which-are-on-the-right-node.patch

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
Subject: mm/mprotect.c: don't touch single threaded PTEs which are on the right node

We had some problems with pages getting unmapped in single threaded
affinitized processes.  It was tracked down to NUMA scanning.

In this case it doesn't make any sense to unmap pages if the process is
single threaded and the page is already on the node the process is running
on.

Add a check for this case into the numa protection code, and skip
unmapping if true.

In theory the process could be migrated later, but we will eventually
rescan and unmap and migrate then.

In theory this could be made more fancy: remembering this state per
process or even whole mm.  However that would need extra tracking and be
more complicated, and the simple check seems to work fine so far.

Link: http://lkml.kernel.org/r/1476288949-20970-1-git-send-email-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/mprotect.c~dont-touch-single-threaded-ptes-which-are-on-the-right-node mm/mprotect.c
--- a/mm/mprotect.c~dont-touch-single-threaded-ptes-which-are-on-the-right-node
+++ a/mm/mprotect.c
@@ -70,11 +70,17 @@ static unsigned long change_pte_range(st
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	unsigned long pages = 0;
+	int target_node = -1;
 
 	pte = lock_pte_protection(vma, pmd, addr, prot_numa, &ptl);
 	if (!pte)
 		return 0;
 
+	if (prot_numa &&
+	    !(vma->vm_flags & VM_SHARED) &&
+	    atomic_read(&vma->vm_mm->mm_users) == 1)
+	    target_node = cpu_to_node(raw_smp_processor_id());
+
 	arch_enter_lazy_mmu_mode();
 	do {
 		oldpte = *pte;
@@ -96,6 +102,13 @@ static unsigned long change_pte_range(st
 				/* Avoid TLB flush if possible */
 				if (pte_protnone(oldpte))
 					continue;
+
+				/*
+				 * Don't mess with PTEs if page is already on the node
+				 * a single-threaded process is running on.
+				 */
+				if (target_node == page_to_nid(page))
+					continue;
 			}
 
 			ptent = ptep_modify_prot_start(mm, addr, pte);
_

Patches currently in -mm which might be from ak@linux.intel.com are

dont-touch-single-threaded-ptes-which-are-on-the-right-node.patch

