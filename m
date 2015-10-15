From: akpm@linux-foundation.org
Subject: + zsmalloc-use-preempth-for-in_interrupt.patch added to -mm tree
Date: Thu, 15 Oct 2015 12:43:24 -0700
Message-ID: <562001dc.ZTel8INjkb3EVmyn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbbJOTnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use preempt.h for in_interrupt()
has been added to the -mm tree.  Its filename is
     zsmalloc-use-preempth-for-in_interrupt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-use-preempth-for-in_interrupt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-use-preempth-for-in_interrupt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -58,7 +58,7 @@
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

maintainers-add-myself-as-zsmalloc-reviewer.patch
zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

