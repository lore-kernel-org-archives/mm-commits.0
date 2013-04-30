From: akpm@linux-foundation.org
Subject: [merged] arm-set-the-page-table-freeing-ceiling-to-task_size.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:55 -0700
Message-ID: <20130430184755.8648F5A4082__6616.75768574259$1367347685$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36250 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab3D3Sr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:56 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so85123vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, hughd@google.com, linux@arm.linux.org.uk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: set the page table freeing ceiling to TASK_SIZE
has been removed from the -mm tree.  Its filename was
     arm-set-the-page-table-freeing-ceiling-to-task_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: arm: set the page table freeing ceiling to TASK_SIZE

ARM processors with LPAE enabled use 3 levels of page tables, with an
entry in the top level (pgd) covering 1GB of virtual space.  Because of
the branch relocation limitations on ARM, the loadable modules are mapped
16MB below PAGE_OFFSET, making the corresponding 1GB pgd shared between
kernel modules and user space.

If free_pgtables() is called with the default ceiling 0, free_pgd_range()
(and subsequently called functions) also frees the page table shared
between user space and kernel modules (which is normally handled by the
ARM-specific pgd_free() function).  This patch changes defines the ARM
USER_PGTABLES_CEILING to TASK_SIZE when CONFIG_ARM_LPAE is enabled.

Note that the pgd_free() function already checks the presence of the
shared pmd page allocated by pgd_alloc() and frees it, though with ceiling
0 this wasn't necessary.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/arm/include/asm/pgtable.h~arm-set-the-page-table-freeing-ceiling-to-task_size arch/arm/include/asm/pgtable.h
--- a/arch/arm/include/asm/pgtable.h~arm-set-the-page-table-freeing-ceiling-to-task_size
+++ a/arch/arm/include/asm/pgtable.h
@@ -61,6 +61,15 @@ extern void __pgd_error(const char *file
 #define FIRST_USER_ADDRESS	PAGE_SIZE
 
 /*
+ * Use TASK_SIZE as the ceiling argument for free_pgtables() and
+ * free_pgd_range() to avoid freeing the modules pmd when LPAE is enabled (pmd
+ * page shared between user and kernel).
+ */
+#ifdef CONFIG_ARM_LPAE
+#define USER_PGTABLES_CEILING	TASK_SIZE
+#endif
+
+/*
  * The pgprot_* and protection_map entries will be fixed up in runtime
  * to include the cachable and bufferable bits based on memory policy,
  * as well as any architecture dependent bits like global/ASID and SMP
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

