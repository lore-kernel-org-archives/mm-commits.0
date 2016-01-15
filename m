From: akpm@linux-foundation.org
Subject: [nacked] arm64-fix-add-kasan-bug.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:37:04 -0800
Message-ID: <56997490.OCNl5VVoy2kJ4Ih8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbcAOWhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:37:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, catalin.marinas@arm.com, long.wanglong@huawei.com, qiuxishi@huawei.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: fix add kasan bug
has been removed from the -mm tree.  Its filename was
     arm64-fix-add-kasan-bug.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: arm64: fix add kasan bug

In general, each process have 16kb stack space to use, but stack need
extra space to store red_zone when kasan enable.  the patch fix above
question.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Wang Long <long.wanglong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/thread_info.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN arch/arm64/include/asm/thread_info.h~arm64-fix-add-kasan-bug arch/arm64/include/asm/thread_info.h
--- a/arch/arm64/include/asm/thread_info.h~arm64-fix-add-kasan-bug
+++ a/arch/arm64/include/asm/thread_info.h
@@ -23,13 +23,24 @@
 
 #include <linux/compiler.h>
 
+#ifdef CONFIG_KASAN
+#define KASAN_STACK_ORDER 1
+#else
+#define KASAN_STACK_ORDER 0
+#endif
+
 #ifdef CONFIG_ARM64_4K_PAGES
-#define THREAD_SIZE_ORDER	2
+#define THREAD_SIZE_ORDER	(2 + KASAN_STACK_ORDER)
 #elif defined(CONFIG_ARM64_16K_PAGES)
-#define THREAD_SIZE_ORDER	0
+#define THREAD_SIZE_ORDER	(0 + KASAN_STACK_ORDER)
 #endif
 
+#ifdef CONFIG_KASAN
+#define THREAD_SIZE		32768
+#else
 #define THREAD_SIZE		16384
+#endif
+
 #define THREAD_START_SP		(THREAD_SIZE - 16)
 
 #ifndef __ASSEMBLY__
_

Patches currently in -mm which might be from zhongjiang@huawei.com are


