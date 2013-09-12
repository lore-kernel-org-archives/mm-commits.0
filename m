From: akpm@linux-foundation.org
Subject: [merged]
 mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:45:09 -0700
Message-ID: <523219c5.R6+zydiq9UU0gkXp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab3ILTpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: [merged] mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch removed from -mm tree
To: gang.chen@asianux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:09 -0700


The patch titled
     Subject: mm/mremap.c: call pud_free() after fail calling pmd_alloc()
has been removed from the -mm tree.  Its filename was
     mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/mremap.c: call pud_free() after fail calling pmd_alloc()

In alloc_new_pmd(), if pud_alloc() was called successfully, but
pmd_alloc() fails, avoid leaking `pud'.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mremap.c~mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc mm/mremap.c
--- a/mm/mremap.c~mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc
+++ a/mm/mremap.c
@@ -25,6 +25,7 @@
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 #include "internal.h"
 
@@ -62,8 +63,10 @@ static pmd_t *alloc_new_pmd(struct mm_st
 		return NULL;
 
 	pmd = pmd_alloc(mm, pud, addr);
-	if (!pmd)
+	if (!pmd) {
+		pud_free(mm, pud);
 		return NULL;
+	}
 
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
h8300-kernel-timer-timer8c-add-missing-semicolon.patch
mm-kconfig-add-mmu-dependency-for-migration.patch

