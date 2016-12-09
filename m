From: akpm@linux-foundation.org
Subject: + kcov-add-more-missing-include.patch added to -mm tree
Date: Fri, 09 Dec 2016 13:58:00 -0800
Message-ID: <584b28e8.PIW8aSDtgzVrUrD6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbcLIV5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2016 16:57:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangkefeng.wang@huawei.com, aryabinin@virtuozzo.com, dvyukov@google.com, james.morse@arm.com, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: add more missing include
has been added to the -mm tree.  Its filename is
     kcov-add-more-missing-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-add-more-missing-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-add-more-missing-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kcov: add more missing include

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

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

kcov-add-more-missing-include.patch

