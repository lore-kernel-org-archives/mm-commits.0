From: akpm@linux-foundation.org
Subject: +
 arm64-use-page_kernel_rox-directly-in-alloc_insn_page.patch added to -mm tree
Date: Sat, 20 Jun 2020 19:19:47 -0700
Message-ID: <20200621021947.7wBRl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbgFUCTs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 22:19:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will@kernel.org, wei.liu@kernel.org, vkuznets@redhat.com, peterz@infradead.org, jeyu@kernel.org, decui@microsoft.com, david@redhat.com, catalin.marinas@arm.com, hch@lst.de


The patch titled
     Subject: arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page
has been added to the -mm tree.  Its filename is
     arm64-use-page_kernel_rox-directly-in-alloc_insn_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-use-page_kernel_rox-directly-in-alloc_insn_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-use-page_kernel_rox-directly-in-alloc_insn_page.patch

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
Subject: arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page

Use PAGE_KERNEL_ROX directly instead of allocating RWX and setting the
page read-only just after the allocation.

Link: http://lkml.kernel.org/r/20200618064307.32739-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
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
