From: akpm@linux-foundation.org
Subject: + mm-kasan-get-rid-of-speculative-shadow-checks.patch added to
 -mm tree
Date: Thu, 01 Jun 2017 14:51:59 -0700
Message-ID: <59308c7f.2elqXFP3+rpRTclk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60250 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAVwA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 17:52:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, catalin.marinas@arm.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: get rid of speculative shadow checks
has been added to the -mm tree.  Its filename is
     mm-kasan-get-rid-of-speculative-shadow-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-get-rid-of-speculative-shadow-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-get-rid-of-speculative-shadow-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: get rid of speculative shadow checks

For some unaligned memory accesses we have to check additional byte of the
shadow memory.  Currently we load that byte speculatively to have only
single load + branch on the optimistic fast path.

However, this approach have some downsides:
 - It's unaligned access, so this prevents porting KASAN on architectures
    which doesn't support unaligned accesses.
 - We have to map additional shadow page to prevent crash if
    speculative load happens near the end of the mapped memory.
    This would significantly complicate upcoming memory hotplug support.

I wasn't able to notice any performance degradation with this patch.  So
these speculative loads is just a pain with no gain, let's remove them.

Link: http://lkml.kernel.org/r/20170601162338.23540-1-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   98 +++++++--------------------------------------
 1 file changed, 16 insertions(+), 82 deletions(-)

diff -puN mm/kasan/kasan.c~mm-kasan-get-rid-of-speculative-shadow-checks mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-get-rid-of-speculative-shadow-checks
+++ a/mm/kasan/kasan.c
@@ -134,94 +134,30 @@ static __always_inline bool memory_is_po
 	return false;
 }
 
-static __always_inline bool memory_is_poisoned_2(unsigned long addr)
+static __always_inline bool memory_is_poisoned_2_4_8(unsigned long addr,
+						unsigned long size)
 {
-	u16 *shadow_addr = (u16 *)kasan_mem_to_shadow((void *)addr);
-
-	if (unlikely(*shadow_addr)) {
-		if (memory_is_poisoned_1(addr + 1))
-			return true;
-
-		/*
-		 * If single shadow byte covers 2-byte access, we don't
-		 * need to do anything more. Otherwise, test the first
-		 * shadow byte.
-		 */
-		if (likely(((addr + 1) & KASAN_SHADOW_MASK) != 0))
-			return false;
-
-		return unlikely(*(u8 *)shadow_addr);
-	}
-
-	return false;
-}
+	u8 *shadow_addr = (u8 *)kasan_mem_to_shadow((void *)addr);
 
-static __always_inline bool memory_is_poisoned_4(unsigned long addr)
-{
-	u16 *shadow_addr = (u16 *)kasan_mem_to_shadow((void *)addr);
-
-	if (unlikely(*shadow_addr)) {
-		if (memory_is_poisoned_1(addr + 3))
-			return true;
-
-		/*
-		 * If single shadow byte covers 4-byte access, we don't
-		 * need to do anything more. Otherwise, test the first
-		 * shadow byte.
-		 */
-		if (likely(((addr + 3) & KASAN_SHADOW_MASK) >= 3))
-			return false;
+	/*
+	 * Access crosses 8(shadow size)-byte boundary. Such access maps
+	 * into 2 shadow bytes, so we need to check them both.
+	 */
+	if (unlikely(((addr + size - 1) & KASAN_SHADOW_MASK) < size - 1))
+		return *shadow_addr || memory_is_poisoned_1(addr + size - 1);
 
-		return unlikely(*(u8 *)shadow_addr);
-	}
-
-	return false;
-}
-
-static __always_inline bool memory_is_poisoned_8(unsigned long addr)
-{
-	u16 *shadow_addr = (u16 *)kasan_mem_to_shadow((void *)addr);
-
-	if (unlikely(*shadow_addr)) {
-		if (memory_is_poisoned_1(addr + 7))
-			return true;
-
-		/*
-		 * If single shadow byte covers 8-byte access, we don't
-		 * need to do anything more. Otherwise, test the first
-		 * shadow byte.
-		 */
-		if (likely(IS_ALIGNED(addr, KASAN_SHADOW_SCALE_SIZE)))
-			return false;
-
-		return unlikely(*(u8 *)shadow_addr);
-	}
-
-	return false;
+	return memory_is_poisoned_1(addr + size - 1);
 }
 
 static __always_inline bool memory_is_poisoned_16(unsigned long addr)
 {
-	u32 *shadow_addr = (u32 *)kasan_mem_to_shadow((void *)addr);
-
-	if (unlikely(*shadow_addr)) {
-		u16 shadow_first_bytes = *(u16 *)shadow_addr;
-
-		if (unlikely(shadow_first_bytes))
-			return true;
-
-		/*
-		 * If two shadow bytes covers 16-byte access, we don't
-		 * need to do anything more. Otherwise, test the last
-		 * shadow byte.
-		 */
-		if (likely(IS_ALIGNED(addr, KASAN_SHADOW_SCALE_SIZE)))
-			return false;
+	u16 *shadow_addr = (u16 *)kasan_mem_to_shadow((void *)addr);
 
-		return memory_is_poisoned_1(addr + 15);
-	}
+	/* Unaligned 16-bytes access maps into 3 shadow bytes. */
+	if (unlikely(!IS_ALIGNED(addr, KASAN_SHADOW_SCALE_SIZE)))
+		return *shadow_addr || memory_is_poisoned_1(addr + 15);
 
-	return false;
+	return *shadow_addr;
 }
 
 static __always_inline unsigned long bytes_is_zero(const u8 *start,
@@ -292,11 +228,9 @@ static __always_inline bool memory_is_po
 		case 1:
 			return memory_is_poisoned_1(addr);
 		case 2:
-			return memory_is_poisoned_2(addr);
 		case 4:
-			return memory_is_poisoned_4(addr);
 		case 8:
-			return memory_is_poisoned_8(addr);
+			return memory_is_poisoned_2_4_8(addr, size);
 		case 16:
 			return memory_is_poisoned_16(addr);
 		default:
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-get-rid-of-speculative-shadow-checks.patch
x86-kasan-dont-allocate-extra-shadow-memory.patch
arm64-kasan-dont-allocate-extra-shadow-memory.patch
mm-kasan-add-support-for-memory-hotplug.patch

