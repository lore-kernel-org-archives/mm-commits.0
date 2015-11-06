From: akpm@linux-foundation.org
Subject: [merged] mm-clear_soft_dirty_pmd-requires-thp.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:16:21 -0800
Message-ID: <563d0a95.nxDAzNiPbHedTZp9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162955AbbKFUQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clear_soft_dirty_pmd() requires THP
has been removed from the -mm tree.  Its filename was
     mm-clear_soft_dirty_pmd-requires-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: mm: clear_soft_dirty_pmd() requires THP

Don't build clear_soft_dirty_pmd() if transparent huge pages are not
enabled.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-clear_soft_dirty_pmd-requires-thp fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-clear_soft_dirty_pmd-requires-thp
+++ a/fs/proc/task_mmu.c
@@ -801,7 +801,14 @@ static inline void clear_soft_dirty(stru
 		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
 }
+#else
+static inline void clear_soft_dirty(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *pte)
+{
+}
+#endif
 
+#if defined(CONFIG_MEM_SOFT_DIRTY) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
 static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
@@ -815,14 +822,7 @@ static inline void clear_soft_dirty_pmd(
 
 	set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 }
-
 #else
-
-static inline void clear_soft_dirty(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *pte)
-{
-}
