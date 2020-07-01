From: akpm@linux-foundation.org
Subject: +
 vmalloc-fix-the-owner-argument-for-the-new-__vmalloc_node_range-callers.patch
 added to -mm tree
Date: Tue, 30 Jun 2020 19:17:23 -0700
Message-ID: <20200701021723.jtjC_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgGACRZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:17:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ardb@kernel.org, hch@lst.de


The patch titled
     Subject: vmalloc: fix the owner argument for the new __vmalloc_node_range callers
has been added to the -mm tree.  Its filename is
     vmalloc-fix-the-owner-argument-for-the-new-__vmalloc_node_range-callers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmalloc-fix-the-owner-argument-for-the-new-__vmalloc_node_range-callers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-fix-the-owner-argument-for-the-new-__vmalloc_node_range-callers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: vmalloc: fix the owner argument for the new __vmalloc_node_range callers

Fix the recently added new __vmalloc_node_range callers to pass the
correct values as the owner for display in /proc/vmallocinfo.

Link: http://lkml.kernel.org/r/20200627075649.2455097-1-hch@lst.de
Fixes: 800e26b81311 ("x86/hyperv: allocate the hypercall page with only read and execute bits")
Fixes: 10d5e97c1bf8 ("arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page")
Fixes: 7a0e27b2a0ce ("mm: remove vmalloc_exec")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/probes/kprobes.c |    2 +-
 arch/x86/hyperv/hv_init.c          |    3 ++-
 kernel/module.c                    |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/probes/kprobes.c~vmalloc-fix-the-owner-argument-for-the-new-__vmalloc_node_range-callers
+++ a/arch/arm64/kernel/probes/kprobes.c
@@ -122,7 +122,7 @@ void *alloc_insn_page(void)
 {
 	return __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START, VMALLOC_END,
 			GFP_KERNEL, PAGE_KERNEL_ROX, VM_FLUSH_RESET_PERMS,
-			NUMA_NO_NODE, __func__);
+			NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 /* arm kprobe: install breakpoint in text */
--- a/arch/x86/hyperv/hv_init.c~vmalloc-fix-the-owner-argument-for-the-new-__vmalloc_node_range-callers
+++ a/arch/x86/hyperv/hv_init.c
@@ -377,7 +377,8 @@ void __init hyperv_init(void)
 
 	hv_hypercall_pg = __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START,
 			VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_ROX,
-			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE, __func__);
+			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
+			__builtin_return_address(0));
 	if (hv_hypercall_pg == NULL) {
 		wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 		goto remove_cpuhp_state;
--- a/kernel/module.c~vmalloc-fix-the-owner-argument-for-the-new-__vmalloc_node_range-callers
+++ a/kernel/module.c
@@ -2785,7 +2785,7 @@ void * __weak module_alloc(unsigned long
 {
 	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
 			GFP_KERNEL, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS,
-			NUMA_NO_NODE, __func__);
+			NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 bool __weak module_init_section(const char *name)
_

Patches currently in -mm which might be from hch@lst.de are

vmalloc-fix-the-owner-argument-for-the-new-__vmalloc_node_range-callers.patch
