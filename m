From: akpm@linux-foundation.org
Subject: + uml-eliminate-a-piece-of-debugging-code.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:09:47 -0700
Message-ID: <200704280009.l3S09lPI011226@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757938AbXD1AJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: eliminate a piece of debugging code
has been added to the -mm tree.  Its filename is
     uml-eliminate-a-piece-of-debugging-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: eliminate a piece of debugging code
From: Jeff Dike <jdike@addtoit.com>

I missed removing another piece of debugging in an earlier patch.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/tlb.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN arch/um/kernel/tlb.c~uml-eliminate-a-piece-of-debugging-code arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-eliminate-a-piece-of-debugging-code
+++ a/arch/um/kernel/tlb.c
@@ -252,7 +252,6 @@ void fix_range_common(struct mm_struct *
 					    &op_index, force, mmu, &flush,
 					    do_ops);
 	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
-	log_info("total flush time - %Ld nsecs\n", end_time - start_time);
 
 	if(!ret)
 		ret = (*do_ops)(mmu, ops, op_index, 1, &flush);
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
uml-eliminate-a-piece-of-debugging-code.patch
uml-more-page-fault-path-trimming.patch
uml-only-flush-areas-covered-by-vma.patch
uml-out-of-tmpfs-space-error-clarification.patch
uml-virtualized-time-fix.patch
