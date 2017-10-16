From: akpm@linux-foundation.org
Subject: [merged]
 kmemleak-clear-stale-pointers-from-task-stacks.patch removed from -mm tree
Date: Mon, 16 Oct 2017 12:55:58 -0700
Message-ID: <20171016195558.6EUEgWGxR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755892AbdJPTz7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 15:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: clear stale pointers from task stacks
has been removed from the -mm tree.  Its filename was
     kmemleak-clear-stale-pointers-from-task-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 # define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_NOTRACK | \
 				 __GFP_ZERO)
 #else
diff -puN kernel/fork.c~kmemleak-clear-stale-pointers-from-task-stacks kernel/fork.c
--- a/kernel/fork.c~kmemleak-clear-stale-pointers-from-task-stacks
+++ a/kernel/fork.c
@@ -215,6 +215,10 @@ static unsigned long *alloc_thread_stack
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

kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch
proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch

