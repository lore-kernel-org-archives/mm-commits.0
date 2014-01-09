From: akpm@linux-foundation.org
Subject: [merged]
 mm-move-change_prot_numa-outside-config_arch_uses_numa_prot_none.patch
 removed from -mm tree
Date: Wed, 08 Jan 2014 16:37:01 -0800
Message-ID: <52cdef2d.BnUOPMOfomamuZfJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbaAIAhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 19:37:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] mm-move-change_prot_numa-outside-config_arch_uses_numa_prot_none.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,mgorman@suse.de,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 16:37:01 -0800


The patch titled
     Subject: mm: move change_prot_numa outside CONFIG_ARCH_USES_NUMA_PROT_NONE
has been removed from the -mm tree.  Its filename was
     mm-move-change_prot_numa-outside-config_arch_uses_numa_prot_none.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: move change_prot_numa outside CONFIG_ARCH_USES_NUMA_PROT_NONE

change_prot_numa should work even if _PAGE_NUMA != _PAGE_PROTNONE.  On
archs like ppc64 that don't use _PAGE_PROTNONE and also have a separate
page table outside linux pagetable, we just need to make sure that when
calling change_prot_numa we flush the hardware page table entry so that
next page access result in a numa fault.

We still need to make sure we use the numa faulting logic only when
CONFIG_NUMA_BALANCING is set.  This implies the migrate-on-fault (Lazy
migration) via mbind will only work if CONFIG_NUMA_BALANCING is set.

Previous discussion around the patch can be found at
http://article.gmane.org/gmane.linux.kernel.mm/109305

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/mempolicy.c     |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-move-change_prot_numa-outside-config_arch_uses_numa_prot_none include/linux/mm.h
--- a/include/linux/mm.h~mm-move-change_prot_numa-outside-config_arch_uses_numa_prot_none
+++ a/include/linux/mm.h
@@ -1892,7 +1892,7 @@ static inline pgprot_t vm_get_page_prot(
 }
 #endif
 
-#ifdef CONFIG_ARCH_USES_NUMA_PROT_NONE
+#ifdef CONFIG_NUMA_BALANCING
 unsigned long change_prot_numa(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
 #endif
diff -puN mm/mempolicy.c~mm-move-change_prot_numa-outside-config_arch_uses_numa_prot_none mm/mempolicy.c
--- a/mm/mempolicy.c~mm-move-change_prot_numa-outside-config_arch_uses_numa_prot_none
+++ a/mm/mempolicy.c
@@ -613,7 +613,7 @@ static inline int queue_pages_pgd_range(
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_USES_NUMA_PROT_NONE
+#ifdef CONFIG_NUMA_BALANCING
 /*
  * This is used to mark a range of virtual addresses to be inaccessible.
  * These are later cleared by a NUMA hinting fault. Depending on these
@@ -627,7 +627,6 @@ unsigned long change_prot_numa(struct vm
 			unsigned long addr, unsigned long end)
 {
 	int nr_updated;
-	BUILD_BUG_ON(_PAGE_NUMA != _PAGE_PROTNONE);
 
 	nr_updated = change_protection(vma, addr, end, vma->vm_page_prot, 0, 1);
 	if (nr_updated)
@@ -641,7 +640,7 @@ static unsigned long change_prot_numa(st
 {
 	return 0;
 }
-#endif /* CONFIG_ARCH_USES_NUMA_PROT_NONE */
+#endif /* CONFIG_NUMA_BALANCING */
 
 /*
  * Walk through page tables and collect pages to be migrated.
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch

