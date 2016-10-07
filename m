From: akpm@linux-foundation.org
Subject: [patch 053/127] mm/bootmem.c: replace kzalloc() by kzalloc_node()
Date: Fri, 07 Oct 2016 16:59:27 -0700
Message-ID: <57f836df.NTWWgAs3lwgDaiVk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39225 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755575AbcJHAAO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zijun_hu@htc.com, mingo@elte.hu

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
