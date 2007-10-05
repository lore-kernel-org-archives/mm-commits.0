From: akpm@linux-foundation.org
Subject: - powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:24 -0700
Message-ID: <200710051956.l95JuO1X022350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760957AbXJET4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, galak@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Powerpc: include pagemap.h in asm/powerpc/tlb.h
has been removed from the -mm tree.  Its filename was
     powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Kumar Gala <galak@kernel.crashing.org>
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

git-powerpc.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
local_t-documentation-update-2.patch
local_t-update-documentation.patch
change-struct-marker-users.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-alignment-fix.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
linux-kernel-markers-documentation.patch
