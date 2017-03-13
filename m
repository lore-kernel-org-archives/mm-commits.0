From: akpm@linux-foundation.org
Subject: + kasan-add-a-prototype-of-task_struct-to-avoid-warning.patch
 added to -mm tree
Date: Mon, 13 Mar 2017 12:32:57 -0700
Message-ID: <58c6f3e9.Zu7x0V7Hi7eYboUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbdCMTc7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2017 15:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@kernel.org, arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add a prototype of task_struct to avoid warning
has been added to the -mm tree.  Its filename is
     kasan-add-a-prototype-of-task_struct-to-avoid-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-add-a-prototype-of-task_struct-to-avoid-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-a-prototype-of-task_struct-to-avoid-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mhiramat@kernel.org are

kasan-add-a-prototype-of-task_struct-to-avoid-warning.patch

