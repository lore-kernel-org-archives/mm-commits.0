From: akpm@linux-foundation.org
Subject: [merged]
 dont-touch-single-threaded-ptes-which-are-on-the-right-node.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:23:43 -0800
Message-ID: <58519c3f.tq44l5S3AHfcJ9qM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44026 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756518AbcLNTXo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mgorman@suse.de, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: don't touch single threaded PTEs which are on the right node
has been removed from the -mm tree.  Its filename was
     dont-touch-single-threaded-ptes-which-are-on-the-right-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[ak@linux.intel.com: v3: Minor updates from Mel. Change code layout]
  Link: http://lkml.kernel.org/r/1476382117-5440-1-git-send-email-andi@firstfloor.org
Link: http://lkml.kernel.org/r/1476288949-20970-1-git-send-email-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/mprotect.c~dont-touch-single-threaded-ptes-which-are-on-the-right-node mm/mprotect.c
--- a/mm/mprotect.c~dont-touch-single-threaded-ptes-which-are-on-the-right-node
+++ a/mm/mprotect.c
@@ -69,11 +69,17 @@ static unsigned long change_pte_range(st
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	unsigned long pages = 0;
+	int target_node = NUMA_NO_NODE;
 
 	pte = lock_pte_protection(vma, pmd, addr, prot_numa, &ptl);
 	if (!pte)
 		return 0;
 
+	/* Get target node for single threaded private VMAs */
+	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
+	    atomic_read(&vma->vm_mm->mm_users) == 1)
+		target_node = numa_node_id();
+
 	arch_enter_lazy_mmu_mode();
 	do {
 		oldpte = *pte;
@@ -95,6 +101,13 @@ static unsigned long change_pte_range(st
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


