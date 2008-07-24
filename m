From: akpm@linux-foundation.org
Subject: - add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:20:44 -0700
Message-ID: <200807242320.m6ONKilT010352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbYGXXVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, apw@shadowen.org, cl@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     add a helper function to test if an object is on the stack
has been removed from the -mm tree.  Its filename was
     add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Christoph Lameter <cl@linux-foundation.org>
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
@@ -1973,6 +1973,13 @@ static inline unsigned long *end_of_stac
 
 #endif
 
+static inline int object_is_on_stack(void *obj)
+{
+	void *stack = task_stack_page(current);
+
+	return (obj >= stack) && (obj < (stack + THREAD_SIZE));
+}
+
 extern void thread_info_cache_init(void);
 
 /* set thread flags in other task's structures
diff -puN lib/debugobjects.c~add-a-helper-function-to-test-if-an-object-is-on-the-stack lib/debugobjects.c
--- a/lib/debugobjects.c~add-a-helper-function-to-test-if-an-object-is-on-the-stack
+++ a/lib/debugobjects.c
@@ -226,15 +226,13 @@ debug_object_fixup(int (*fixup)(void *ad
 
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

origin.patch
linux-next.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
clean-up-duplicated-alloc-free_thread_info.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sdhci-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch

