From: akpm@linux-foundation.org
Subject: + memblock-nobootmem-allow-alloc_bootmem-to-take-0-as-low-limit.patch added to -mm tree
Date: Mon, 09 May 2011 15:57:50 -0700
Message-ID: <201105092257.p49MvoM4024065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab1EIW6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 18:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, hpa@zytor.com, lucas.demarchi@profusion.mobi, mingo@elte.hu, olaf@aepfle.de, tj@kernel.org


The patch titled
     memblock/nobootmem: allow alloc_bootmem() to take 0 as low limit
has been added to the -mm tree.  Its filename is
     memblock-nobootmem-allow-alloc_bootmem-to-take-0-as-low-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memblock/nobootmem: allow alloc_bootmem() to take 0 as low limit
From: Yinghai Lu <yinghai@kernel.org>

The bootmem wrapper with memblock supports top-down now, so we do not need
to set the low limit to __pa(MAX_DMA_ADDRESS).

The logic should be: good to allocate above __pa(MAX_DMA_ADDRESS), but it
is ok if we can not find memory above 16M on system that has a small
amount of RAM.

Signed-off-by: Yinghai LU <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN include/linux/bootmem.h~memblock-nobootmem-allow-alloc_bootmem-to-take-0-as-low-limit include/linux/bootmem.h
--- a/include/linux/bootmem.h~memblock-nobootmem-allow-alloc_bootmem-to-take-0-as-low-limit
+++ a/include/linux/bootmem.h
@@ -99,24 +99,31 @@ extern void *__alloc_bootmem_low_node(pg
 				      unsigned long align,
 				      unsigned long goal);
 
+#ifdef CONFIG_NO_BOOTMEM
+/* We are using top down, so it is safe to use 0 here */
+#define BOOTMEM_LOW_LIMIT 0
+#else
+#define BOOTMEM_LOW_LIMIT __pa(MAX_DMA_ADDRESS)
+#endif
+
 #define alloc_bootmem(x) \
-	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_align(x, align) \
-	__alloc_bootmem(x, align, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, align, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_nopanic(x) \
-	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_pages(x) \
-	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, PAGE_SIZE, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_pages_nopanic(x) \
-	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, PAGE_SIZE, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_node_nopanic(pgdat, x) \
-	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_pages_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, BOOTMEM_LOW_LIMIT)
 #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
-	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, BOOTMEM_LOW_LIMIT)
 
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
_

Patches currently in -mm which might be from yinghai@kernel.org are

mm-use-alloc_bootmem_node_nopanic-on-really-needed-path.patch
mm-use-alloc_bootmem_node_nopanic-on-really-needed-path-fix.patch
linux-next.patch
memblock-nobootmem-allow-alloc_bootmem-to-take-0-as-low-limit.patch
memblock-nobootmem-remove-code-for-alloc_bootmem_node_high.patch
memblock-add-error-return-when-config_have_memblock-is-not-set.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

