From: akpm@linux-foundation.org
Subject: + uml-use-get_free_pages-to-allocate-kernel-stacks.patch added to -mm tree
Date: Tue, 19 Jun 2007 11:55:22 -0700
Message-ID: <200706191855.l5JItM8m018517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763660AbXFSS4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 14:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: use get_free_pages to allocate kernel stacks
has been added to the -mm tree.  Its filename is
     uml-use-get_free_pages-to-allocate-kernel-stacks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: use get_free_pages to allocate kernel stacks
From: Jeff Dike <jdike@addtoit.com>

For some reason, I was using kmalloc instead of get_free_pages for kernel
stacks.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/thread_info.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

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

hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
uml-add-stack-usage-monitoring.patch
