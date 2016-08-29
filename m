From: akpm@linux-foundation.org
Subject: + mm-bootmemc-replace-kzalloc-by-kzalloc_node.patch added to -mm
 tree
Date: Mon, 29 Aug 2016 16:28:04 -0700
Message-ID: <57c4c504.ZsUPzSaR1TIrc/GP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40173 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754081AbcH2X2G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 19:28:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/bootmem.c: replace kzalloc() by kzalloc_node()
has been added to the -mm tree.  Its filename is
     mm-bootmemc-replace-kzalloc-by-kzalloc_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bootmemc-replace-kzalloc-by-kzalloc_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bootmemc-replace-kzalloc-by-kzalloc_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
