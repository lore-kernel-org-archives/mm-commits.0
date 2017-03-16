From: akpm@linux-foundation.org
Subject: [patch 2/6] kasan: add a prototype of task_struct to avoid
 warning
Date: Thu, 16 Mar 2017 16:40:21 -0700
Message-ID: <58cb2265.XhOkCgiYxYlMb2Uw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752642AbdCQASB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 20:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhiramat@kernel.org, arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com

From: Masami Hiramatsu <mhiramat@kernel.org>
Subject: kasan: add a prototype of task_struct to avoid warning

Add a prototype of task_struct to fix below warning on arm64.

In file included from arch/arm64/kernel/probes/kprobes.c:19:0:
include/linux/kasan.h:81:132: error: 'struct task_struct' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
 static inline void kasan_unpoison_task_stack(struct task_struct *task) {}

As same as other types (kmem_cache, page, and vm_struct) this adds a
prototype of task_struct data structure on top of kasan.h.

[arnd] A related warning was fixed before, but now appears in a different
line in the same file in v4.11-rc2. The patch from Masami Hiramatsu
still seems appropriate, so let's take his version.

Fixes: 71af2ed5eeea ("kasan, sched/headers: Remove <linux/sched.h> from <linux/kasan.h>")
Link: https://patchwork.kernel.org/patch/9569839/
Link: http://lkml.kernel.org/r/20170313141517.3397802-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Alexander Potapenko <glider@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/kasan.h~kasan-add-a-prototype-of-task_struct-to-avoid-warning include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-add-a-prototype-of-task_struct-to-avoid-warning
+++ a/include/linux/kasan.h
@@ -6,6 +6,7 @@
 struct kmem_cache;
 struct page;
 struct vm_struct;
+struct task_struct;
 
 #ifdef CONFIG_KASAN
 
_
