From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 20:12:50 -0700
Message-ID: <20200609031250.ZogSL9hyx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDMv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elver@google.com, ira.weiny@intel.com, linux@roeck-us.net, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: microblaze: fix page table traversal in setup_rt_frame()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix.patch

This patch was dropped because it was folded into mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: microblaze: fix page table traversal in setup_rt_frame()

The replacement of long folded page table traversal with the direct access
to PMD entry wrongly used the kernel page table in setup_rt_frame()
function instead of the process (current->mm) page table.

Fix it.

Link: http://lkml.kernel.org/r/20200518191511.GD1118872@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/microblaze/kernel/signal.c~mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix
+++ a/arch/microblaze/kernel/signal.c
@@ -194,7 +194,7 @@ static int setup_rt_frame(struct ksignal
 
 	address = ((unsigned long)frame->tramp);
 #ifdef CONFIG_MMU
-	pmdp = pmd_off_k(address);
+	pmdp = pmd_off(current->mm, address);
 
 	preempt_disable();
 	ptep = pte_offset_map(pmdp, address);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
