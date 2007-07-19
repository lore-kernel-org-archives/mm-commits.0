From: akpm@linux-foundation.org
Subject: + powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:30:40 -0700
Message-ID: <200707190530.l6J5UeMp015681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933041AbXGSFa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Powerpc: include pagemap.h in asm/powerpc/tlb.h
has been added to the -mm tree.  Its filename is
     powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Powerpc: include pagemap.h in asm/powerpc/tlb.h
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Powerpc - Include pagemap.h in asm/powerpc/tlb.h

Fixes this powerpc build error in 2.6.22-rc6-mm1 for powerpc 64 :

In file included from include2/asm/tlb.h:60,
                 from /home/compudj/git/linux-2.6-lttng/arch/powerpc/mm/init_64.
c:56:
/home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
/home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
/home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h: In function 'tlb_remove_page':
/home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
make[2]: *** [arch/powerpc/mm/init_64.o] Error 1

release_pages is declared in linux/pagemap.h, but cannot be included in
linux/swap.h because of a sparc related comment:

/* only sparc can not include linux/pagemap.h in this file
 * so leave page_cache_release and release_pages undeclared... */
#define free_page_and_swap_cache(page) \
        page_cache_release(page)
#define free_pages_and_swap_cache(pages, nr) \
        release_pages((pages), (nr), 0);

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/tlb.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-powerpc/tlb.h~powerpc-include-pagemaph-in-asm-powerpc-tlbh include/asm-powerpc/tlb.h
--- a/include/asm-powerpc/tlb.h~powerpc-include-pagemaph-in-asm-powerpc-tlbh
+++ a/include/asm-powerpc/tlb.h
@@ -23,6 +23,8 @@
 #include <asm/mmu.h>
 #endif
 
+#include <linux/pagemap.h>
+
 struct mmu_gather;
 
 #define tlb_start_vma(tlb, vma)	do { } while (0)
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
git-kbuild.patch
