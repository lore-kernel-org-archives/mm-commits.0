From: akpm@linux-foundation.org
Subject: + sched-implement-180-bit-sched-bitmap.patch added to -mm tree
Date: Sat, 10 Mar 2007 22:24:48 -0800
Message-ID: <200703110624.l2B6OnWt005859@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37771 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228AbXCKGZD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 01:25:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com


The patch titled
     sched: implement 180 bit sched bitmap
has been added to the -mm tree.  Its filename is
     sched-implement-180-bit-sched-bitmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: implement 180 bit sched bitmap
From: Con Kolivas <kernel@kolivas.org>

Modify the sched_find_first_bit function to work on a 180bit long bitmap.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/sched.h |   10 ++++++----
 include/asm-s390/bitops.h          |   12 +-----------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff -puN include/asm-generic/bitops/sched.h~sched-implement-180-bit-sched-bitmap include/asm-generic/bitops/sched.h
--- a/include/asm-generic/bitops/sched.h~sched-implement-180-bit-sched-bitmap
+++ a/include/asm-generic/bitops/sched.h
@@ -6,8 +6,8 @@
 
 /*
  * Every architecture must define this function. It's the fastest
- * way of searching a 140-bit bitmap where the first 100 bits are
- * unlikely to be set. It's guaranteed that at least one of the 140
+ * way of searching a 180-bit bitmap where the first 100 bits are
+ * unlikely to be set. It's guaranteed that at least one of the 180
  * bits is cleared.
  */
 static inline int sched_find_first_bit(const unsigned long *b)
@@ -15,7 +15,7 @@ static inline int sched_find_first_bit(c
 #if BITS_PER_LONG == 64
 	if (unlikely(b[0]))
 		return __ffs(b[0]);
-	if (likely(b[1]))
+	if (b[1])
 		return __ffs(b[1]) + 64;
 	return __ffs(b[2]) + 128;
 #elif BITS_PER_LONG == 32
@@ -27,7 +27,9 @@ static inline int sched_find_first_bit(c
 		return __ffs(b[2]) + 64;
 	if (b[3])
 		return __ffs(b[3]) + 96;
-	return __ffs(b[4]) + 128;
+	if (b[4])
+		return __ffs(b[4]) + 128;
+	return __ffs(b[5]) + 160;
 #else
 #error BITS_PER_LONG not defined
 #endif
diff -puN include/asm-s390/bitops.h~sched-implement-180-bit-sched-bitmap include/asm-s390/bitops.h
--- a/include/asm-s390/bitops.h~sched-implement-180-bit-sched-bitmap
+++ a/include/asm-s390/bitops.h
@@ -729,17 +729,7 @@ find_next_bit (const unsigned long * add
 	return offset + find_first_bit(p, size);
 }
 
-/*
- * Every architecture must define this function. It's the fastest
- * way of searching a 140-bit bitmap where the first 100 bits are
- * unlikely to be set. It's guaranteed that at least one of the 140
- * bits is cleared.
- */
-static inline int sched_find_first_bit(unsigned long *b)
-{
-	return find_first_bit(b, 140);
-}
-
+#include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
 
 #include <asm-generic/bitops/fls.h>
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-implement-180-bit-sched-bitmap.patch
sched-dont-renice-kernel-threads.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
