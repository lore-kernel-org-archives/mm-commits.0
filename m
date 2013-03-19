From: akpm@linux-foundation.org
Subject: + arm-set-the-page-table-freeing-ceiling-to-task_size.patch added to -mm tree
Date: Tue, 19 Mar 2013 14:14:04 -0700
Message-ID: <20130319211404.D6DEE31C1FB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:33690 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933979Ab3CSVOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 17:14:06 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so92850ves.5
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 14:14:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, hughd@google.com, linux@arm.linux.org.uk, stable@vger.kernel.org


The patch titled
     Subject: arm: set the page table freeing ceiling to TASK_SIZE
has been added to the -mm tree.  Its filename is
     arm-set-the-page-table-freeing-ceiling-to-task_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-arm-use-common-help-functions-to-free-reserved-pages.patch
mm-allow-arch-code-to-control-the-user-page-table-ceiling.patch
arm-set-the-page-table-freeing-ceiling-to-task_size.patch

