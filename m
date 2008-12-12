From: akpm@linux-foundation.org
Subject: - fork_init-fix-division-by-zero.patch removed from -mm tree
Date: Thu, 11 Dec 2008 17:07:16 -0800
Message-ID: <200812120107.mBC17GZo012583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbYLLBHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 20:07:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yur@emcraft.com, yanok@emcraft.com, mm-commits@vger.kernel.org


The patch titled
     fork_init: fix division by zero
has been removed from the -mm tree.  Its filename was
     fork_init-fix-division-by-zero.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fork_init: fix division by zero
From: Yuri Tikhonov <yur@emcraft.com>

Fix a divide-by-zero error for the cases of really big PAGE_SIZEs (e.g. 
256KB on ppc44x).  Support for big page sizes on 44x is not present in the
current kernel yet, but coming soon.

Also this patch fixes the comment for the max_threads settings, as this
didn't match the things actually done in the code.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN kernel/fork.c~fork_init-fix-division-by-zero kernel/fork.c
--- a/kernel/fork.c~fork_init-fix-division-by-zero
+++ a/kernel/fork.c
@@ -69,6 +69,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/div64.h>
 
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
@@ -185,10 +186,15 @@ void __init fork_init(unsigned long memp
 
 	/*
 	 * The default maximum number of threads is set to a safe
-	 * value: the thread structures can take up at most half
-	 * of memory.
+	 * value: the thread structures can take up at most
+	 * (1/8) part of memory.
 	 */
-	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
+	{
+		/* max_threads = (mempages * PAGE_SIZE) / THREAD_SIZE / 8; */
+		u64 m = mempages * PAGE_SIZE;
+		do_div(m, THREAD_SIZE * 8);
+		max_threads = m;
+	}
 
 	/*
 	 * we need to allow at least 20 threads to boot a system
_

Patches currently in -mm which might be from yur@emcraft.com are

linux-next.patch
fork_init-fix-division-by-zero.patch

