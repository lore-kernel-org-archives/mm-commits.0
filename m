From: akpm@linux-foundation.org
Subject: [to-be-updated]
 kasan-use-is_aligned-in-memory_is_poisoned_8.patch removed from -mm tree
Date: Tue, 15 Sep 2015 11:12:49 -0700
Message-ID: <55f85fa1.axTqenbG2iZCNZC3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbIOSMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 14:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use IS_ALIGNED in memory_is_poisoned_8()
has been removed from the -mm tree.  Its filename was
     kasan-use-is_aligned-in-memory_is_poisoned_8.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: kasan: use IS_ALIGNED in memory_is_poisoned_8()

Use IS_ALIGNED() to determine whether the shadow span two bytes.  It
generates less code and more readable.  Add some comments in shadow check
functions.

Please apply "kasan: fix last shadow judgement in memory_is_poisoned_16()"
first.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-use-is_aligned-in-memory_is_poisoned_8 mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-use-is_aligned-in-memory_is_poisoned_8
+++ a/mm/kasan/kasan.c
@@ -86,6 +86,10 @@ static __always_inline bool memory_is_po
 		if (memory_is_poisoned_1(addr + 1))
 			return true;
 
+		/*
+		 * If the shadow spans two bytes, the first byte should
+		 * be zero.
+		 */
 		if (likely(((addr + 1) & KASAN_SHADOW_MASK) != 0))
 			return false;
 
@@ -103,6 +107,10 @@ static __always_inline bool memory_is_po
 		if (memory_is_poisoned_1(addr + 3))
 			return true;
 
+		/*
+		 * If the shadow spans two bytes, the first byte should
+		 * be zero.
+		 */
 		if (likely(((addr + 3) & KASAN_SHADOW_MASK) >= 3))
 			return false;
 
@@ -120,7 +128,11 @@ static __always_inline bool memory_is_po
 		if (memory_is_poisoned_1(addr + 7))
 			return true;
 
-		if (likely(((addr + 7) & KASAN_SHADOW_MASK) >= 7))
+		/*
+		 * If the shadow spans two bytes, the first byte should
+		 * be zero.
+		 */
+		if (likely(IS_ALIGNED(addr, KASAN_SHADOW_SCALE_SIZE)))
 			return false;
 
 		return unlikely(*(u8 *)shadow_addr);
@@ -139,7 +151,12 @@ static __always_inline bool memory_is_po
 		if (unlikely(shadow_first_bytes))
 			return true;
 
-		if (likely(IS_ALIGNED(addr, 8)))
+		/*
+		 * If the shadow spans three bytes, we should continue to
+		 * check the last byte. The first two bytes which we
+		 * checked above should always be zero.
+		 */
+		if (likely(IS_ALIGNED(addr, KASAN_SHADOW_SCALE_SIZE)))
 			return false;
 
 		return memory_is_poisoned_1(addr + 15);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

kasan-fix-last-shadow-judgement-in-memory_is_poisoned_16.patch

