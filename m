From: akpm@linux-foundation.org
Subject: - uml-use-get_free_pages-to-allocate-kernel-stacks.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:51:05 -0700
Message-ID: <200707162051.l6GKp5jn001372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758710AbXGPVWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:22:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: use get_free_pages to allocate kernel stacks
has been removed from the -mm tree.  Its filename was
     uml-use-get_free_pages-to-allocate-kernel-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: use get_free_pages to allocate kernel stacks
From: Jeff Dike <jdike@addtoit.com>

For some reason, I was using kmalloc instead of get_free_pages for kernel
stacks.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/thread_info.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/asm-um/thread_info.h~uml-use-get_free_pages-to-allocate-kernel-stacks include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~uml-use-get_free_pages-to-allocate-kernel-stacks
+++ a/include/asm-um/thread_info.h
@@ -54,8 +54,10 @@ static inline struct thread_info *curren
 
 /* thread information allocation */
 #define alloc_thread_info(tsk) \
-	((struct thread_info *) kmalloc(THREAD_SIZE, GFP_KERNEL))
-#define free_thread_info(ti) kfree(ti)
+	((struct thread_info *) __get_free_pages(GFP_KERNEL, \
+						 CONFIG_KERNEL_STACK_ORDER))
+#define free_thread_info(ti) \
+	free_pages((unsigned long)(ti),CONFIG_KERNEL_STACK_ORDER)
 
 #endif
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
hostfs-convert-to-new-aops.patch
