From: akpm@linux-foundation.org
Subject: [merged] kcov-add-missing-include-linux-schedh.patch removed from -mm tree
Date: Fri, 09 Dec 2016 12:51:19 -0800
Message-ID: <584b1947.WOBOHZrE1cBU5tPH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752965AbcLIUvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2016 15:51:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangkefeng.wang@huawei.com, aryabinin@virtuozzo.com, dvyukov@google.com, james.morse@arm.com, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: add missing #include <linux/sched.h>
has been removed from the -mm tree.  Its filename was
     kcov-add-missing-include-linux-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kcov: add missing #include <linux/sched.h>

  In __sanitizer_cov_trace_pc we use task_struct and fields within it,
  but as we haven't included <linux/sched.h>, it is not guaranteed to be
  defined. While we usually happen to acquire the definition through a
  transitive include, this is fragile (and hasn't been true in the past,
  causing issues with backports).

  Include <linux/sched.h> to avoid any fragility.

[mark.rutland@arm.com: rewrote changelog]
Link: http://lkml.kernel.org/r/1481007384-27529-1-git-send-email-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kcov.c~kcov-add-missing-include-linux-schedh kernel/kcov.c
--- a/kernel/kcov.c~kcov-add-missing-include-linux-schedh
+++ a/kernel/kcov.c
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


