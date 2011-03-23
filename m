From: akpm@linux-foundation.org
Subject: + ia64-fix-build-breakage-in-asm-thread_infoh.patch added to -mm tree
Date: Wed, 23 Mar 2011 10:59:42 -0700
Message-ID: <201103231803.p2NI3IDo021030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796Ab1CWSDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 14:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony.luck@intel.com


The patch titled
     ia64: fix build breakage in asm/thread_info.h
has been added to the -mm tree.  Its filename is
     ia64-fix-build-breakage-in-asm-thread_infoh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-floppy-driver-if-config_isa_dma_api-is-enabled.patch
x86-allow-config_isa_dma_api-to-be-disabled.patch
ia64-fix-build-breakage-in-asm-thread_infoh.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch

