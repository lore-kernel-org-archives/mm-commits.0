From: akpm@linux-foundation.org
Subject: [patch 036/114] kcov: add more missing includes
Date: Wed, 14 Dec 2016 15:05:46 -0800
Message-ID: <5851d04a.bOGBXqYlBGqlQ0Kz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933408AbcLNXFr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, wangkefeng.wang@huawei.com, aryabinin@virtuozzo.com, dvyukov@google.com, james.morse@arm.com, mark.rutland@arm.com

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kcov: add more missing includes

It is fragile that some definitions acquired via transitive
dependencies, as shown in below:

atomic_*        (<linux/atomic.h>)
ENOMEM/EN*      (<linux/errno.h>)
EXPORT_SYMBOL   (<linux/export.h>)
device_initcall (<linux/init.h>)
preempt_*       (<linux/preempt.h>)

Include them to prevent possible issues.

Link: http://lkml.kernel.org/r/1481163221-40170-1-git-send-email-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/kcov.c~kcov-add-more-missing-include kernel/kcov.c
--- a/kernel/kcov.c~kcov-add-more-missing-include
+++ a/kernel/kcov.c
@@ -1,11 +1,16 @@
 #define pr_fmt(fmt) "kcov: " fmt
 
 #define DISABLE_BRANCH_PROFILING
+#include <linux/atomic.h>
 #include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/export.h>
 #include <linux/types.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/preempt.h>
 #include <linux/printk.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
_
