From: akpm@linux-foundation.org
Subject: - m68k-discontinuous-memory-support-fix.patch removed from -mm tree
Date: Thu, 31 May 2007 00:39:44 -0700
Message-ID: <200705310739.l4V7dh3k015249@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbXEaHjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 03:39:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k-discontinuous-memory-support fix
has been removed from the -mm tree.  Its filename was
     m68k-discontinuous-memory-support-fix.patch

This patch was dropped because it was folded into m68k-discontinuous-memory-support.patch

------------------------------------------------------
Subject: m68k-discontinuous-memory-support fix
From: Geert Uytterhoeven <geert@linux-m68k.org>

macros which evaluate their args more than once are dangerous.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/virtconvert.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/asm-m68k/virtconvert.h~m68k-discontinuous-memory-support-fix include/asm-m68k/virtconvert.h
--- a/include/asm-m68k/virtconvert.h~m68k-discontinuous-memory-support-fix
+++ a/include/asm-m68k/virtconvert.h
@@ -30,10 +30,11 @@ static inline void *phys_to_virt(unsigne
 #define page_to_phys(page) \
 	__pa(PAGE_OFFSET + (((page) - pg_data_map[0].node_mem_map) << PAGE_SHIFT))
 #else
-#define page_to_phys(page) ({						\
+#define page_to_phys(_page) ({						\
+	struct page *__page = _page;					\
 	struct pglist_data *pgdat;					\
-	pgdat = pg_data_table[page_to_nid(page)];			\
-	page_to_pfn(page) << PAGE_SHIFT;				\
+	pgdat = pg_data_table[page_to_nid(__page)];			\
+	page_to_pfn(__page) << PAGE_SHIFT;				\
 })
 #endif
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-runtime-patching-infrastructure.patch
m68k-discontinuous-memory-support.patch
m68k-discontinuous-memory-support-fix.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-scsi-misc.patch
m68k-parenthesis-balance.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
