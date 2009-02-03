From: akpm@linux-foundation.org
Subject: [folded] mm-unify-some-pmd_-functions-fix-for-m68k-sun3.patch removed from -mm tree
Date: Tue, 03 Feb 2009 12:17:55 -0800
Message-ID: <200902032017.n13KHuPc026076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbZBCUSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 15:18:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     mm: unify some pmd_*() functions fix for m68k sun3
has been removed from the -mm tree.  Its filename was
     mm-unify-some-pmd_-functions-fix-for-m68k-sun3.patch

This patch was dropped because it was folded into mm-unify-some-pmd_-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: unify some pmd_*() functions fix for m68k sun3
From: Andrea Righi <righi.andrea@gmail.com>

sun3_defconfig fails with:

    CC      mm/memory.o
  mm/memory.c: In function 'free_pmd_range':
  mm/memory.c:176: error: implicit declaration of function '__pmd_free_tlb'
  mm/memory.c: In function '__pmd_alloc':
  mm/memory.c:2903: error: implicit declaration of function 'pmd_alloc_one_bug'
  mm/memory.c:2903: warning: initialization makes pointer from integer without a cast
  mm/memory.c:2917: error: implicit declaration of function 'pmd_free'
  make[3]: *** [mm/memory.o] Error 1

Add the missing include.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/sun3_pgalloc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m68k/include/asm/sun3_pgalloc.h~mm-unify-some-pmd_-functions-fix-for-m68k-sun3 arch/m68k/include/asm/sun3_pgalloc.h
--- a/arch/m68k/include/asm/sun3_pgalloc.h~mm-unify-some-pmd_-functions-fix-for-m68k-sun3
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -11,6 +11,7 @@
 #define _SUN3_PGALLOC_H
 
 #include <asm/tlb.h>
+#include <asm-generic/pgtable-nopmd.h>
 
 /* FIXME - when we get this compiling */
 /* erm, now that it's compiling, what do we do with it? */
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

fbmem-copy_from-to_user-with-mutex-held-v3.patch
mm-unify-some-pmd_-functions.patch
mm-unify-some-pmd_-functions-fix-for-m68k-sun3.patch
mm-unify-some-pmd_-functions-and-move-them-in-a-distinct-include.patch

