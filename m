From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unneeded-includes-of-asm-pgalloch-fix.patch
 added to -mm tree
Date: Wed, 08 Jul 2020 15:20:12 -0700
Message-ID: <20200708222012.bdgtCSh0A%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgGHWUN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 18:20:13 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, sfr@canb.auug.org.au


The patch titled
     Subject: powerpc: fix compilation warning caused by missing include of asm/pgalloc.h
has been added to the -mm tree.  Its filename is
     mm-remove-unneeded-includes-of-asm-pgalloch-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unneeded-includes-of-asm-pgalloch-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unneeded-includes-of-asm-pgalloch-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: powerpc: fix compilation warning caused by missing include of asm/pgalloc.h

Recent rework of asm/pgalloc.h caused a compilation warning reported by
kbuild bot:

All warnings (new ones prefixed by >>):

>> arch/powerpc/mm/nohash/tlb.c:409:6: warning: no previous prototype for
>> 'tlb_flush_pgtable' [-Wmissing-prototypes]
     409 | void tlb_flush_pgtable(struct mmu_gather *tlb, unsigned long address)
         |      ^~~~~~~~~~~~~~~~~

Add missing include of asm/pgtable.h to arch/powerpc/mm/nohash/tlb.c to
make tlb_flush_pgtable() prototype visible there.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/nohash/tlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/mm/nohash/tlb.c~mm-remove-unneeded-includes-of-asm-pgalloch-fix
+++ a/arch/powerpc/mm/nohash/tlb.c
@@ -34,6 +34,7 @@
 #include <linux/of_fdt.h>
 #include <linux/hugetlb.h>
 
+#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <asm/code-patching.h>
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unneeded-includes-of-asm-pgalloch.patch
mm-remove-unneeded-includes-of-asm-pgalloch-fix.patch
opeinrisc-switch-to-generic-version-of-pte-allocation.patch
xtensa-switch-to-generic-version-of-pte-allocation.patch
asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one.patch
asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch
asm-generic-pgalloc-provide-generic-pgd_free.patch
mm-move-lib-ioremapc-to-mm.patch
mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch
