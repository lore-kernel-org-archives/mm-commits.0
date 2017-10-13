From: akpm@linux-foundation.org
Subject: [patch 16/18] kmemleak: clear stale pointers from task stacks
Date: Fri, 13 Oct 2017 15:58:22 -0700
Message-ID: <59e1450e.h0sYoRrk0BSHL8Rm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdJMW6X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, khlebnikov@yandex-team.ru, catalin.marinas@arm.com

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
