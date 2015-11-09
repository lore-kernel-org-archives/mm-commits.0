From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-use-preempth-for-in_interrupt.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:45:10 -0800
Message-ID: <5640f7c6.NsU6s+Kq78Mp1AP6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbKITpK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use preempt.h for in_interrupt()
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-preempth-for-in_interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: use preempt.h for in_interrupt()

A cosmetic change.

Commit c60369f01125 ("staging: zsmalloc: prevent mappping in interrupt
context") added in_interrupt() check to zs_map_object() and 'hardirq.h'
include; but in_interrupt() macro is defined in 'preempt.h' not in
'hardirq.h', so include it instead.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-preempth-for-in_interrupt mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-preempth-for-in_interrupt
+++ a/mm/zsmalloc.c
@@ -59,7 +59,7 @@
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
 #include <linux/vmalloc.h>
-#include <linux/hardirq.h>
+#include <linux/preempt.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/debugfs.h>
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


