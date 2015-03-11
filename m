From: akpm@linux-foundation.org
Subject: + mm-change-ioremap-to-set-up-huge-i-o-mappings-fix.patch added
 to -mm tree
Date: Wed, 11 Mar 2015 13:04:16 -0700
Message-ID: <55009fc0.9/fi2Eq+N9RLtq4t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbbCKUER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 16:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, fengguang.wu@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: Fix build errors in asm-generic/pgtable.h
has been added to the -mm tree.  Its filename is
     mm-change-ioremap-to-set-up-huge-i-o-mappings-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-ioremap-to-set-up-huge-i-o-mappings-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-ioremap-to-set-up-huge-i-o-mappings-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: Fix build errors in asm-generic/pgtable.h

Fix build errors in pud_set_huge() and pmd_set_huge() in
asm-generic/pgtable.h on some architectures in linux-next
and -mm trees.

C-stype code needs be used under #ifndef __ASSEMBLY__.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-change-ioremap-to-set-up-huge-i-o-mappings-fix include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-change-ioremap-to-set-up-huge-i-o-mappings-fix
+++ a/include/asm-generic/pgtable.h
@@ -697,12 +697,6 @@ static inline int pmd_protnone(pmd_t pmd
 
 #endif /* CONFIG_MMU */
 
-#endif /* !__ASSEMBLY__ */
-
-#ifndef io_remap_pfn_range
-#define io_remap_pfn_range remap_pfn_range
-#endif
-
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
 int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
@@ -717,4 +711,10 @@ static inline int pmd_set_huge(pmd_t *pm
 }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
+#endif /* !__ASSEMBLY__ */
+
+#ifndef io_remap_pfn_range
+#define io_remap_pfn_range remap_pfn_range
+#endif
+
 #endif /* _ASM_GENERIC_PGTABLE_H */
_

Patches currently in -mm which might be from toshi.kani@hp.com are

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
lib-add-huge-i-o-map-capability-interfaces-fix.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings-fix.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch
linux-next.patch

