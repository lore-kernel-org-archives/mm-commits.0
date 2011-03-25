From: akpm@linux-foundation.org
Subject: [merged] ia64-fix-build-breakage-in-asm-thread_infoh.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:23:22 -0700
Message-ID: <201103250723.p2P7NHa1025715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1CYHXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:23:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix build breakage in asm/thread_info.h
has been removed from the -mm tree.  Its filename was
     ia64-fix-build-breakage-in-asm-thread_infoh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix build breakage in asm/thread_info.h
From: "Luck, Tony" <tony.luck@intel.com>

In commit 504f52b5439aaf26d3e2c1d45ec10fce38c8dd27
    mm: NUMA aware alloc_task_struct_node()

Eric Dumazet forgot a "\".  Add it.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/thread_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/include/asm/thread_info.h~ia64-fix-build-breakage-in-asm-thread_infoh arch/ia64/include/asm/thread_info.h
--- a/arch/ia64/include/asm/thread_info.h~ia64-fix-build-breakage-in-asm-thread_infoh
+++ a/arch/ia64/include/asm/thread_info.h
@@ -91,7 +91,7 @@ struct thread_info {
 					     KERNEL_STACK_SIZE_ORDER);		\
 	struct task_struct *ret = page ? page_address(page) : NULL;		\
 										\
-	ret;
+	ret;									\
 })
 #define free_task_struct(tsk)	free_pages((unsigned long) (tsk), KERNEL_STACK_SIZE_ORDER)
 
_

Patches currently in -mm which might be from tony.luck@intel.com are

origin.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

