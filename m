From: akpm@linux-foundation.org
Subject: + mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch
 added to -mm tree
Date: Tue, 20 Aug 2013 16:20:14 -0700
Message-ID: <5213f9ae.DZFmbmm6dDjAsHdt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3HTXUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 19:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 16:20:14 -0700


The patch titled
     Subject: mm/mremap.c: call pud_free() after fail calling pmd_alloc()
has been added to the -mm tree.  Its filename is
     mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -24,6 +24,7 @@
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/pgalloc.h>
 
 #include "internal.h"
 
@@ -61,8 +62,10 @@ static pmd_t *alloc_new_pmd(struct mm_st
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

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
mm-page_allocc-use-__paginginit-instead-of-__init.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
linux-next.patch
mm-kconfig-add-mmu-dependency-for-migration.patch
mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch

