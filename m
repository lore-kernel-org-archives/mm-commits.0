From: akpm@linux-foundation.org
Subject: + mm-fix-ptep_modify_-for-no-mmu-systems.patch added to -mm tree
Date: Wed, 16 Jul 2008 13:44:34 -0700
Message-ID: <200807162044.m6GKiYOf012071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbYGPUot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 16:44:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, bunk@kernel.org, jeremy.fitzhardinge@citrix.com, vapier.adi@gmail.com


The patch titled
     mm: fix ptep_modify_* for no-MMU systems
has been added to the -mm tree.  Its filename is
     mm-fix-ptep_modify_-for-no-mmu-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix ptep_modify_* for no-MMU systems
From: Jeremy Fitzhardinge <jeremy@goop.org>

Fixes build problem:
 the functions added to asm-generic/pgtable.h are only used by
 mm/mprotect.c (a MMU-only file), but they were not added inside of the
 CONFIG_MMU ifdef block.  since the functions rely on things inside of
 CONFIG_MMU (the lines just above in pgtable.h), we get build failure
 on all no-mmu setups:
   CC      init/main.o
 In file included from include/asm/pgtable.h:94,
                  from include/linux/mm.h:39,
                  from include/asm/dma.h:39,
                  from include/linux/bootmem.h:8,
                  from init/main.c:27:
 include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
 include/asm-generic/pgtable.h:210: error: implicit declaration of
 function 'ptep_get_and_clear'
 include/asm-generic/pgtable.h:210: error: incompatible types in return
 make[1]: *** [init/main.o] Error 1
 make: *** [init/main.o] Error 2

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/pgtable.h~mm-fix-ptep_modify_-for-no-mmu-systems include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-fix-ptep_modify_-for-no-mmu-systems
+++ a/include/asm-generic/pgtable.h
@@ -195,7 +195,6 @@ static inline int pmd_none_or_clear_bad(
 	}
 	return 0;
 }
-#endif /* CONFIG_MMU */
 
 static inline pte_t __ptep_modify_prot_start(struct mm_struct *mm,
 					     unsigned long addr,
@@ -253,6 +252,7 @@ static inline void ptep_modify_prot_comm
 	__ptep_modify_prot_commit(mm, addr, ptep, pte);
 }
 #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
+#endif /* CONFIG_MMU */
 
 /*
  * A facility to provide lazy MMU batching.  This allows PTE updates and
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
mm-fix-ptep_modify_-for-no-mmu-systems.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch

