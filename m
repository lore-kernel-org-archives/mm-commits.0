From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 21 Apr 2020 17:55:04 -0700
Message-ID: <20200422005504.LhB3cfh5v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDVAzG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Apr 2020 20:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/svm/svm.c    |    3 ---
 arch/x86/kvm/vmx/nested.c |   25 -------------------------
 2 files changed, 28 deletions(-)

--- a/arch/x86/kvm/svm/svm.c~linux-next-git-rejects
+++ a/arch/x86/kvm/svm/svm.c
@@ -3299,8 +3299,6 @@ static void svm_cancel_injection(struct
 	svm_complete_interrupts(svm);
 }
 
-<<<<<<< HEAD
-=======
 static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	if (!is_guest_mode(vcpu) &&
@@ -3311,7 +3309,6 @@ static enum exit_fastpath_completion svm
 	return EXIT_FASTPATH_NONE;
 }
 
->>>>>>> linux-next/akpm-base
 void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
 static enum exit_fastpath_completion svm_vcpu_run(struct kvm_vcpu *vcpu)
--- a/arch/x86/kvm/vmx/nested.c~linux-next-git-rejects
+++ a/arch/x86/kvm/vmx/nested.c
@@ -5609,31 +5609,6 @@ static bool nested_vmx_exit_handled_vmcs
 }
 
 static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
-<<<<<<< HEAD
-{
-	u32 entry_intr_info = vmcs12->vm_entry_intr_info_field;
-
-	if (nested_cpu_has_mtf(vmcs12))
-		return true;
-
-	/*
-	 * An MTF VM-exit may be injected into the guest by setting the
-	 * interruption-type to 7 (other event) and the vector field to 0. Such
-	 * is the case regardless of the 'monitor trap flag' VM-execution
-	 * control.
-	 */
-	return entry_intr_info == (INTR_INFO_VALID_MASK
-				   | INTR_TYPE_OTHER_EVENT);
-}
-
-/*
- * Return true if we should exit from L2 to L1 to handle an exit, or false if we
- * should handle it ourselves in L0 (and then continue L2). Only call this
- * when in is_guest_mode (L2).
- */
-bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
-=======
->>>>>>> linux-next/akpm-base
 {
 	u32 entry_intr_info = vmcs12->vm_entry_intr_info_field;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
