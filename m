From: akpm@linux-foundation.org
Subject: [merged] kasan-use-is_aligned-in-memory_is_poisoned_8.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:53 -0800
Message-ID: <563d0af1.A9AxcbysmvRHY3Dx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163020AbbKFURy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use IS_ALIGNED in memory_is_poisoned_8()
has been removed from the -mm tree.  Its filename was
     kasan-use-is_aligned-in-memory_is_poisoned_8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: kasan: use IS_ALIGNED in memory_is_poisoned_8()

Use IS_ALIGNED() to determine whether the shadow span two bytes.  It
generates less code and more readable.  Also add some comments in shadow
check functions.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-use-is_aligned-in-memory_is_poisoned_8 mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-use-is_aligned-in-memory_is_poisoned_8
+++ a/mm/kasan/kasan.c
@@ -86,6 +86,11 @@ static __always_inline bool memory_is_po
 		if (memory_is_poisoned_1(addr + 1))
 			return true;
 
+		/*
+		 * If single shadow byte covers 2-byte access, we don't
+		 * need to do anything more. Otherwise, test the first
+		 * shadow byte.
+		 */
 		if (likely(((addr + 1) & KASAN_SHADOW_MASK) != 0))
 			return false;
 
@@ -103,6 +108,11 @@ static __always_inline bool memory_is_po
 		if (memory_is_poisoned_1(addr + 3))
 			return true;
 
+		/*
+		 * If single shadow byte covers 4-byte access, we don't
+		 * need to do anything more. Otherwise, test the first
+		 * shadow byte.
+		 */
 		if (likely(((addr + 3) & KASAN_SHADOW_MASK) >= 3))
 			return false;
 
@@ -120,7 +130,12 @@ static __always_inline bool memory_is_po
 		if (memory_is_poisoned_1(addr + 7))
 			return true;
 
-		if (likely(((addr + 7) & KASAN_SHADOW_MASK) >= 7))
+		/*
+		 * If single shadow byte covers 8-byte access, we don't
+		 * need to do anything more. Otherwise, test the first
+		 * shadow byte.
+		 */
+		if (likely(IS_ALIGNED(addr, KASAN_SHADOW_SCALE_SIZE)))
 			return false;
 
 		return unlikely(*(u8 *)shadow_addr);
@@ -139,7 +154,12 @@ static __always_inline bool memory_is_po
 		if (unlikely(shadow_first_bytes))
 			return true;
 
-		if (likely(IS_ALIGNED(addr, 8)))
+		/*
+		 * If two shadow bytes covers 16-byte access, we don't
+		 * need to do anything more. Otherwise, test the last
+		 * shadow byte.
+		 */
+		if (likely(IS_ALIGNED(addr, KASAN_SHADOW_SCALE_SIZE)))
 			return false;
 
 		return memory_is_poisoned_1(addr + 15);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are


