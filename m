From: akpm@linux-foundation.org
Subject: + um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch added to -mm tree
Date: Tue, 20 Mar 2012 12:33:37 -0700
Message-ID: <20120320193337.A6AC7A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:54646 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab2CTTdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Mar 2012 15:33:39 -0400
Received: by yenq2 with SMTP id q2so69858yen.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Mar 2012 12:33:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, jdike@addtoit.com, richard@nod.at


The patch titled
     Subject: um/kernel/trap.c: port OOM changes to handle_page_fault()
has been added to the -mm tree.  Its filename is
     um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: um/kernel/trap.c: port OOM changes to handle_page_fault()

Commit d065bd810b6deb6 ("mm: retry page fault when blocking on disk
transfer") and commit 37b23e0525 ("x86,mm: make pagefault killable")

The above commits introduced changes into the x86 pagefault handler
for making the page fault handler retryable as well as killable.

These changes reduce the mmap_sem hold time, which is crucial
during OOM killer invocation.

Port these changes to um.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/trap.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN arch/um/kernel/trap.c~um-kernel-trapc-port-oom-changes-to-handle_page_fault arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~um-kernel-trapc-port-oom-changes-to-handle_page_fault
+++ a/arch/um/kernel/trap.c
@@ -30,6 +30,8 @@ int handle_page_fault(unsigned long addr
 	pmd_t *pmd;
 	pte_t *pte;
 	int err = -EFAULT;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+				 (is_write ? FAULT_FLAG_WRITE : 0);
 
 	*code_out = SEGV_MAPERR;
 
@@ -40,6 +42,7 @@ int handle_page_fault(unsigned long addr
 	if (in_atomic())
 		goto out_nosemaphore;
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
 	if (!vma)
@@ -65,7 +68,11 @@ good_area:
 	do {
 		int fault;
 
-		fault = handle_mm_fault(mm, vma, address, is_write ? FAULT_FLAG_WRITE : 0);
+		fault = handle_mm_fault(mm, vma, address, flags);
+
+		if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+			goto out_nosemaphore;
+
 		if (unlikely(fault & VM_FAULT_ERROR)) {
 			if (fault & VM_FAULT_OOM) {
 				goto out_of_memory;
@@ -75,10 +82,17 @@ good_area:
 			}
 			BUG();
 		}
-		if (fault & VM_FAULT_MAJOR)
-			current->maj_flt++;
-		else
-			current->min_flt++;
+		if (flags & FAULT_FLAG_ALLOW_RETRY) {
+			if (fault & VM_FAULT_MAJOR)
+				current->maj_flt++;
+			else
+				current->min_flt++;
+			if (fault & VM_FAULT_RETRY) {
+				flags &= ~FAULT_FLAG_ALLOW_RETRY;
+
+				goto retry;
+			}
+		}
 
 		pgd = pgd_offset(mm, address);
 		pud = pud_offset(pgd, address);
_
Subject: Subject: um/kernel/trap.c: port OOM changes to handle_page_fault()

Patches currently in -mm which might be from consul.kautuk@gmail.com are

rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
page_allocc-remove-add_from_early_node_map.patch
page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument.patch
mmapc-fix-comment-for-__insert_vm_struct.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch

