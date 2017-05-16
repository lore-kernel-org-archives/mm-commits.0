From: akpm@linux-foundation.org
Subject: + mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch added to
 -mm tree
Date: Tue, 16 May 2017 14:01:43 -0700
Message-ID: <591b68b7.j4ILo/rIQOZhZquj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbdEPVBo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 17:01:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan/kasan.c: rename XXX_is_zero to XXX_is_nonzero
has been added to the -mm tree.  Its filename is
     mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -224,7 +224,7 @@ static __always_inline bool memory_is_po
 	return false;
 }
 
-static __always_inline unsigned long bytes_is_zero(const u8 *start,
+static __always_inline unsigned long bytes_is_nonzero(const u8 *start,
 					size_t size)
 {
 	while (size) {
@@ -237,7 +237,7 @@ static __always_inline unsigned long byt
 	return 0;
 }
 
-static __always_inline unsigned long memory_is_zero(const void *start,
+static __always_inline unsigned long memory_is_nonzero(const void *start,
 						const void *end)
 {
 	unsigned int words;
@@ -245,11 +245,11 @@ static __always_inline unsigned long mem
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
@@ -258,12 +258,12 @@ static __always_inline unsigned long mem
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
@@ -271,7 +271,7 @@ static __always_inline bool memory_is_po
 {
 	unsigned long ret;
 
-	ret = memory_is_zero(kasan_mem_to_shadow((void *)addr),
+	ret = memory_is_nonzero(kasan_mem_to_shadow((void *)addr),
 			kasan_mem_to_shadow((void *)addr + size - 1) + 1);
 
 	if (unlikely(ret)) {
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

zram-introduce-zram_entry-to-prepare-dedup-functionality.patch
zram-implement-deduplication-in-zram.patch
zram-make-deduplication-feature-optional.patch
zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch
mm-kasan-use-kasan_zero_pud-for-p4d-table.patch
mm-kasan-rename-xxx_is_zero-to-xxx_is_nonzero.patch

