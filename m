From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-detect-negative-size-in-memory-operation-function-fix-2.patch removed
 from -mm tree
Date: Wed, 01 Apr 2020 20:33:25 -0700
Message-ID: <20200402033325.w0hiNDGg0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732498AbgDBDd0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:33:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, rdunlap@infradead.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan-detect-negative-size-in-memory-operation-function-fix-2
has been removed from the -mm tree.  Its filename was
     kasan-detect-negative-size-in-memory-operation-function-fix-2.patch

This patch was dropped because it was folded into kasan-detect-negative-size-in-memory-operation-function.patch

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: kasan-detect-negative-size-in-memory-operation-function-fix-2

fix objtool warning

mm/kasan/common.o: warning: objtool: kasan_report()+0x13: call to report_enabled() with UACCESS enabled


Link: http://lkml.kernel.org/r/20200305095436.GV2596@hirez.programming.kicks-ass.net
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Walter Wu <walter-zh.wu@mediatek.com>
Tested-by: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/kasan/common.c~kasan-detect-negative-size-in-memory-operation-function-fix-2
+++ a/mm/kasan/common.c
@@ -641,16 +641,17 @@ extern bool report_enabled(void);
 
 bool kasan_report(unsigned long addr, size_t size, bool is_write, unsigned long ip)
 {
-	unsigned long flags;
+	unsigned long flags = user_access_save();
+	bool ret = false;
 
-	if (likely(!report_enabled()))
-		return false;
+	if (likely(report_enabled())) {
+		__kasan_report(addr, size, is_write, ip);
+		ret = true;
+	}
 
-	flags = user_access_save();
-	__kasan_report(addr, size, is_write, ip);
 	user_access_restore(flags);
 
-	return true;
+	return ret;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
_

Patches currently in -mm which might be from peterz@infradead.org are

kasan-detect-negative-size-in-memory-operation-function.patch
