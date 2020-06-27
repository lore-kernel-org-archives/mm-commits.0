From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 arm64-use-page_kernel_rox-directly-in-alloc_insn_page.patch removed from
 -mm tree
Date: Fri, 26 Jun 2020 20:34:08 -0700
Message-ID: <20200627033408.W5sSOv29_%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0DeJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:34:09 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, david@redhat.com, decui@microsoft.com, hch@lst.de, jeyu@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, vkuznets@redhat.com, wei.liu@kernel.org, will@kernel.org


The patch titled
     Subject: arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page
has been removed from the -mm tree.  Its filename was
     arm64-use-page_kernel_rox-directly-in-alloc_insn_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page

Use PAGE_KERNEL_ROX directly instead of allocating RWX and setting the
page read-only just after the allocation.

Link: http://lkml.kernel.org/r/20200618064307.32739-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/probes/kprobes.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/arch/arm64/kernel/probes/kprobes.c~arm64-use-page_kernel_rox-directly-in-alloc_insn_page
+++ a/arch/arm64/kernel/probes/kprobes.c
@@ -120,15 +120,9 @@ int __kprobes arch_prepare_kprobe(struct
 
 void *alloc_insn_page(void)
 {
-	void *page;
-
-	page = vmalloc_exec(PAGE_SIZE);
-	if (page) {
-		set_memory_ro((unsigned long)page, 1);
-		set_vm_flush_reset_perms(page);
-	}
