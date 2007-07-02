From: akpm@linux-foundation.org
Subject: - sparc64-add-linux-pagemaph-to-asm-tlbh.patch removed from -mm tree
Date: Mon, 02 Jul 2007 13:17:04 -0700
Message-ID: <200707022017.l62KH4Ha004835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbXGBUZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jul 2007 16:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     sparc64: add linux/pagemap.h to asm/tlb.h
has been removed from the -mm tree.  Its filename was
     sparc64-add-linux-pagemaph-to-asm-tlbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparc64: add linux/pagemap.h to asm/tlb.h
From: Alexey Dobriyan <adobriyan@sw.ru>

As seen on sparc64-allnoconfig:

  CC      arch/sparc64/mm/tlb.o
In file included from arch/sparc64/mm/tlb.c:19:
include/asm/tlb.h: In function 'tlb_flush_mmu':
include/asm/tlb.h:60: warning: implicit declaration of function 'release_pages'
include/asm/tlb.h: In function 'tlb_remove_page':
include/asm/tlb.h:92: warning: implicit declaration of function 'page_cache_release'

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc64/tlb.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/asm-sparc64/tlb.h~sparc64-add-linux-pagemaph-to-asm-tlbh include/asm-sparc64/tlb.h
--- a/include/asm-sparc64/tlb.h~sparc64-add-linux-pagemaph-to-asm-tlbh
+++ a/include/asm-sparc64/tlb.h
@@ -2,6 +2,7 @@
 #define _SPARC64_TLB_H
 
 #include <linux/swap.h>
+#include <linux/pagemap.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
_

Patches currently in -mm which might be from adobriyan@sw.ru are

make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch
