From: akpm@linux-foundation.org
Subject: - i386-mmzone-use-__maybe_unused.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:38 -0700
Message-ID: <200705092154.l49LscJc003181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759070AbXEIVzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     i386 mmzone: use __maybe_unused
has been removed from the -mm tree.  Its filename was
     i386-mmzone-use-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 mmzone: use __maybe_unused
From: David Rientjes <rientjes@google.com>

Replace automatic variable instances of __attribute__ ((unused)) with
__maybe_unused.

Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mmzone.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-i386/mmzone.h~i386-mmzone-use-__maybe_unused include/asm-i386/mmzone.h
--- a/include/asm-i386/mmzone.h~i386-mmzone-use-__maybe_unused
+++ a/include/asm-i386/mmzone.h
@@ -122,21 +122,21 @@ static inline int pfn_valid(int pfn)
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x)					\
 ({									\
-	struct pglist_data  __attribute__ ((unused))			\
+	struct pglist_data  __maybe_unused			\
 				*__alloc_bootmem_node__pgdat = (pgdat);	\
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES,	\
 						__pa(MAX_DMA_ADDRESS));	\
 })
 #define alloc_bootmem_pages_node(pgdat, x)				\
 ({									\
-	struct pglist_data  __attribute__ ((unused))			\
+	struct pglist_data  __maybe_unused			\
 				*__alloc_bootmem_node__pgdat = (pgdat);	\
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE,		\
 						__pa(MAX_DMA_ADDRESS))	\
 })
 #define alloc_bootmem_low_pages_node(pgdat, x)				\
 ({									\
-	struct pglist_data  __attribute__ ((unused))			\
+	struct pglist_data  __maybe_unused			\
 				*__alloc_bootmem_node__pgdat = (pgdat);	\
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0);		\
 })
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
frv-gdb-use-__maybe_unused.patch
