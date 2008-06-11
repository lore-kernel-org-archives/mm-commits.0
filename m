From: akpm@linux-foundation.org
Subject: + add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch added to -mm tree
Date: Tue, 10 Jun 2008 22:51:51 -0700
Message-ID: <200806110551.m5B5pp7E015691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019AbYFKFwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 01:52:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, apw@shadowen.org, clameter@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     add a helper function to test if an object is on the stack
has been added to the -mm tree.  Its filename is
     add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add a helper function to test if an object is on the stack
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

lib/debugobjects.c has a function to test if an object is on the stack. 
The block layer and ide needs it (they need to avoid DMA from/to stack
buffers).  This patch moves the function to include/linux/sched.h so that
everyone can use it.

lib/debugobjects.c uses current->stack but this patch uses a
task_stack_page() accessor, which is a preferable way to access the stack.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    7 +++++++
 lib/debugobjects.c    |    4 +---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN include/linux/sched.h~add-a-helper-function-to-test-if-an-object-is-on-the-stack include/linux/sched.h
--- a/include/linux/sched.h~add-a-helper-function-to-test-if-an-object-is-on-the-stack
+++ a/include/linux/sched.h
@@ -1970,6 +1970,13 @@ static inline unsigned long *end_of_stac
 
 #endif
 
+static inline int object_is_on_stack(void *obj)
+{
+	void *stack = task_stack_page(current);
+
+	return (obj >= stack) && (obj < (stack + THREAD_SIZE));
+}
+
 extern void thread_info_cache_init(void);
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
diff -puN lib/debugobjects.c~add-a-helper-function-to-test-if-an-object-is-on-the-stack lib/debugobjects.c
--- a/lib/debugobjects.c~add-a-helper-function-to-test-if-an-object-is-on-the-stack
+++ a/lib/debugobjects.c
@@ -231,15 +231,13 @@ debug_object_fixup(int (*fixup)(void *ad
 
 static void debug_object_is_on_stack(void *addr, int onstack)
 {
-	void *stack = current->stack;
 	int is_on_stack;
 	static int limit;
 
 	if (limit > 4)
 		return;
 
-	is_on_stack = (addr >= stack && addr < (stack + THREAD_SIZE));
-
+	is_on_stack = object_is_on_stack(addr);
 	if (is_on_stack == onstack)
 		return;
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
scsi-sr-avoids-useless-buffer-allocation.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
clean-up-duplicated-alloc-free_thread_info.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch

