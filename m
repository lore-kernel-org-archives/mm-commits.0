From: akpm@linux-foundation.org
Subject: + arm64-add-support-for-folded-p4d-page-tables-fix.patch
 added to -mm tree
Date: Thu, 30 Apr 2020 12:08:23 -0700
Message-ID: <20200430190823.zkFXkXqMy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgD3TI0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 15:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: arm64: kvm: fix gcc-10 shift warning
has been added to the -mm tree.  Its filename is
     arm64-add-support-for-folded-p4d-page-tables-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-add-support-for-folded-p4d-page-tables-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-add-support-for-folded-p4d-page-tables-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: arm64: kvm: fix gcc-10 shift warning

gcc-10 warns that the 32-bit zero cannot be shifted more than
32 bits to the right:

arch/arm64/kvm/../../../virt/kvm/arm/mmu.c: In function 'clear_hyp_p4d_entry':
arch/arm64/include/asm/pgtable.h:630:35: error: right shift count >= width of type [-Werror=shift-count-overflow]
  630 | #define pud_index(addr)  (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
      |                                   ^~
arch/arm64/include/asm/memory.h:271:45: note: in definition of macro '__phys_to_virt'
  271 | #define __phys_to_virt(x) ((unsigned long)((x) - physvirt_offset))
      |                                             ^
arch/arm64/include/asm/pgtable.h:633:42: note: in expansion of macro '__va'
  633 | #define pud_offset(dir, addr)  ((pud_t *)__va(pud_offset_phys((dir), (addr))))
      |                                          ^~~~
arch/arm64/include/asm/pgtable.h:632:73: note: in expansion of macro 'pud_index'
  632 | #define pud_offset_phys(dir, addr) (p4d_page_paddr(READ_ONCE(*(dir))) + pud_index(addr) * sizeof(pud_t))
      |                                                                         ^~~~~~~~~
arch/arm64/include/asm/pgtable.h:633:47: note: in expansion of macro 'pud_offset_phys'
  633 | #define pud_offset(dir, addr)  ((pud_t *)__va(pud_offset_phys((dir), (addr))))
      |                                               ^~~~~~~~~~~~~~~
arch/arm64/kvm/../../../virt/kvm/arm/mmu.c:510:36: note: in expansion of macro 'pud_offset'
  510 |  pud_t *pud_table __maybe_unused = pud_offset(p4d, 0);
      |                                    ^~~~~~~~~~

This is harmless, and the warning is a little bit silly for
a zero constant, but it's trivial to fix by making it an
unsigned long, so do that.

Link: http://lkml.kernel.org/r/20200429185657.4085975-1-arnd@arndb.de
Fixes: 22998131ab33 ("arm64: add support for folded p4d page tables")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/arm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/arm/mmu.c~arm64-add-support-for-folded-p4d-page-tables-fix
+++ a/virt/kvm/arm/mmu.c
@@ -507,7 +507,7 @@ static void clear_hyp_pgd_entry(pgd_t *p
 
 static void clear_hyp_p4d_entry(p4d_t *p4d)
 {
-	pud_t *pud_table __maybe_unused = pud_offset(p4d, 0);
+	pud_t *pud_table __maybe_unused = pud_offset(p4d, 0UL);
 	VM_BUG_ON(p4d_huge(*p4d));
 	p4d_clear(p4d);
 	pud_free(NULL, pud_table);
_

Patches currently in -mm which might be from arnd@arndb.de are

arm64-add-support-for-folded-p4d-page-tables-fix.patch
ubsan-fix-gcc-10-warnings.patch
initramfs-fix-another-section-mismatch.patch
