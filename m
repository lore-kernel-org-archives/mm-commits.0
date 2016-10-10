From: akpm@linux-foundation.org
Subject: [merged] mm-bootmemc-replace-kzalloc-by-kzalloc_node.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:44:28 -0700
Message-ID: <57fc19cc.dsXoRNBGtuQf5AWy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36753 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbcJJWo3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/bootmem.c: replace kzalloc() by kzalloc_node()
has been removed from the -mm tree.  Its filename was
     mm-bootmemc-replace-kzalloc-by-kzalloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: mm/bootmem.c: replace kzalloc() by kzalloc_node()

In ___alloc_bootmem_node_nopanic(), replace kzalloc() by kzalloc_node() in
order to allocate memory within given node preferentially when slab is
available

Link: http://lkml.kernel.org/r/1f487f12-6af4-5e4f-a28c-1de2361cdcd8@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN mm/bootmem.c~mm-bootmemc-replace-kzalloc-by-kzalloc_node mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmemc-replace-kzalloc-by-kzalloc_node
+++ a/mm/bootmem.c
@@ -11,15 +11,12 @@
 #include <linux/init.h>
 #include <linux/pfn.h>
 #include <linux/slab.h>
-#include <linux/bootmem.h>
 #include <linux/export.h>
 #include <linux/kmemleak.h>
 #include <linux/range.h>
-#include <linux/memblock.h>
 #include <linux/bug.h>
 #include <linux/io.h>
-
-#include <asm/processor.h>
+#include <linux/bootmem.h>
 
 #include "internal.h"
 
@@ -712,7 +709,7 @@ void * __init ___alloc_bootmem_node_nopa
 	void *ptr;
 
 	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc(size, GFP_NOWAIT);
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 again:
 
 	/* do not panic in alloc_bootmem_bdata() */
@@ -738,9 +735,6 @@ again:
 void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
-
 	return ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
 }
 
@@ -812,10 +806,6 @@ void * __init __alloc_bootmem_node_high(
 
 }
 
-#ifndef ARCH_LOW_ADDRESS_LIMIT
-#define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
-#endif
