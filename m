From: akpm@linux-foundation.org
Subject: [merged]
 mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch removed from -mm tree
Date: Tue, 11 Jul 2017 12:25:37 -0700
Message-ID: <20170711192537.TdpeHVddN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932722AbdGKTZi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan/kasan.c: rename XXX_is_zero to XXX_is_nonzero
has been removed from the -mm tree.  Its filename was
     mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/kasan/kasan.c: rename XXX_is_zero to XXX_is_nonzero

They return positive value, that is, true, if non-zero value is found. 
Rename them to reduce confusion.

Link: http://lkml.kernel.org/r/20170516012350.GA16015@js1304-desktop
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/kasan/kasan.c~mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero
+++ a/mm/kasan/kasan.c
@@ -160,7 +160,7 @@ static __always_inline bool memory_is_po
 	return *shadow_addr;
 }
 
-static __always_inline unsigned long bytes_is_zero(const u8 *start,
+static __always_inline unsigned long bytes_is_nonzero(const u8 *start,
 					size_t size)
 {
 	while (size) {
@@ -173,7 +173,7 @@ static __always_inline unsigned long byt
 	return 0;
 }
 
-static __always_inline unsigned long memory_is_zero(const void *start,
+static __always_inline unsigned long memory_is_nonzero(const void *start,
 						const void *end)
 {
 	unsigned int words;
@@ -181,11 +181,11 @@ static __always_inline unsigned long mem
 	unsigned int prefix = (unsigned long)start % 8;
 
 	if (end - start <= 16)
-		return bytes_is_zero(start, end - start);
+		return bytes_is_nonzero(start, end - start);
 
 	if (prefix) {
 		prefix = 8 - prefix;
-		ret = bytes_is_zero(start, prefix);
+		ret = bytes_is_nonzero(start, prefix);
 		if (unlikely(ret))
 			return ret;
 		start += prefix;
@@ -194,12 +194,12 @@ static __always_inline unsigned long mem
 	words = (end - start) / 8;
 	while (words) {
 		if (unlikely(*(u64 *)start))
-			return bytes_is_zero(start, 8);
+			return bytes_is_nonzero(start, 8);
 		start += 8;
 		words--;
 	}
 
-	return bytes_is_zero(start, (end - start) % 8);
+	return bytes_is_nonzero(start, (end - start) % 8);
 }
 
 static __always_inline bool memory_is_poisoned_n(unsigned long addr,
@@ -207,7 +207,7 @@ static __always_inline bool memory_is_po
 {
 	unsigned long ret;
 
-	ret = memory_is_zero(kasan_mem_to_shadow((void *)addr),
+	ret = memory_is_nonzero(kasan_mem_to_shadow((void *)addr),
 			kasan_mem_to_shadow((void *)addr + size - 1) + 1);
 
 	if (unlikely(ret)) {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


