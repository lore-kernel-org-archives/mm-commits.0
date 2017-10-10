From: akpm@linux-foundation.org
Subject: + kmemleak-clear-stale-pointers-from-task-stacks.patch added to
 -mm tree
Date: Tue, 10 Oct 2017 15:18:27 -0700
Message-ID: <59dd4733.e4ECtKCXbrRdPn0Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36440 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdJJWSa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 18:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: clear stale pointers from task stacks
has been added to the -mm tree.  Its filename is
     kmemleak-clear-stale-pointers-from-task-stacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-clear-stale-pointers-from-task-stacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-clear-stale-pointers-from-task-stacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: kmemleak: clear stale pointers from task stacks

Kmemleak considers any pointers on task stacks as references.  This patch
clears newly allocated and reused vmap stacks.

Link: http://lkml.kernel.org/r/150728990124.744199.8403409836394318684.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thread_info.h |    2 +-
 kernel/fork.c               |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/thread_info.h~kmemleak-clear-stale-pointers-from-task-stacks include/linux/thread_info.h
--- a/include/linux/thread_info.h~kmemleak-clear-stale-pointers-from-task-stacks
+++ a/include/linux/thread_info.h
@@ -42,7 +42,7 @@ enum {
 #define THREAD_ALIGN	THREAD_SIZE
 #endif
 
-#ifdef CONFIG_DEBUG_STACK_USAGE
+#if IS_ENABLED(CONFIG_DEBUG_STACK_USAGE) || IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)
 # define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
 #else
 # define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT)
diff -puN kernel/fork.c~kmemleak-clear-stale-pointers-from-task-stacks kernel/fork.c
--- a/kernel/fork.c~kmemleak-clear-stale-pointers-from-task-stacks
+++ a/kernel/fork.c
@@ -216,6 +216,10 @@ static unsigned long *alloc_thread_stack
 		if (!s)
 			continue;
 
+#ifdef CONFIG_DEBUG_KMEMLEAK
+		/* Clear stale pointers from reused stack. */
+		memset(s->addr, 0, THREAD_SIZE);
+#endif
 		tsk->stack_vm_area = s;
 		return s->addr;
 	}
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kmemleak-clear-stale-pointers-from-task-stacks.patch
kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch

