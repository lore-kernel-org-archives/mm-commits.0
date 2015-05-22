From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 22 May 2015 13:07:27 -0700
Message-ID: <555f8c7f.eHb2J5C+jPQ3JGhk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbbEVUH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 16:07:28 -0400
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

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/x86.c      |    6 ------
 drivers/clk/clk.c       |   10 ----------
 drivers/hid/wacom_wac.c |    6 ------
 3 files changed, 22 deletions(-)

diff -puN arch/x86/kvm/x86.c~linux-next-git-rejects arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~linux-next-git-rejects
+++ a/arch/x86/kvm/x86.c
@@ -7151,11 +7151,6 @@ void kvm_put_guest_fpu(struct kvm_vcpu *
 	fpu_save_init(&vcpu->arch.guest_fpu);
 	__kernel_fpu_end();
 	++vcpu->stat.fpu_reload;
-<<<<<<< HEAD
-	if (!vcpu->arch.eager_fpu)
-		kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
-
-=======
 	/*
 	 * If using eager FPU mode, or if the guest is a frequent user
 	 * of the FPU, just leave the FPU active for next time.
@@ -7166,7 +7161,6 @@ void kvm_put_guest_fpu(struct kvm_vcpu *
 		if (++vcpu->fpu_counter < 5)
 			kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	}
->>>>>>> linux-next/akpm-base
 	trace_kvm_fpu(0);
 }
 
diff -puN drivers/clk/clk.c~linux-next-git-rejects drivers/clk/clk.c
--- a/drivers/clk/clk.c~linux-next-git-rejects
+++ a/drivers/clk/clk.c
@@ -1108,11 +1108,7 @@ static struct clk_core *__clk_set_parent
 		clk_core_prepare(parent);
 		flags = clk_enable_lock();
 		clk_core_enable(parent);
-<<<<<<< HEAD
-		clk_core_enable(clk);
-=======
 		clk_core_enable(core);
->>>>>>> linux-next/akpm-base
 		clk_enable_unlock(flags);
 	}
 
@@ -1165,15 +1161,9 @@ static int __clk_set_parent(struct clk_c
 		clk_reparent(core, old_parent);
 		clk_enable_unlock(flags);
 
-<<<<<<< HEAD
-		if (clk->prepare_count) {
-			flags = clk_enable_lock();
-			clk_core_disable(clk);
-=======
 		if (core->prepare_count) {
 			flags = clk_enable_lock();
 			clk_core_disable(core);
->>>>>>> linux-next/akpm-base
 			clk_core_disable(parent);
 			clk_enable_unlock(flags);
 			clk_core_unprepare(parent);
diff -puN drivers/hid/wacom_wac.c~linux-next-git-rejects drivers/hid/wacom_wac.c
--- a/drivers/hid/wacom_wac.c~linux-next-git-rejects
+++ a/drivers/hid/wacom_wac.c
@@ -1075,14 +1075,8 @@ static int wacom_wac_finger_count_touche
 	if (!touch_max)
 		return 0;
 
-<<<<<<< HEAD
-	/* non-HID_GENERIC single touch input doesn't call this routine */
-	if ((touch_max == 1) && (wacom->features.type == HID_GENERIC))
-		return wacom->hid_data.tipswitch &&
-=======
 	if (touch_max == 1)
 		return test_bit(BTN_TOUCH, input->key) &&
->>>>>>> linux-next/akpm-base
 		       !wacom->shared->stylus_in_proximity;
 
 	for (i = 0; i < input->mt->num_slots; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
arch-x86-kvm-mmuc-work-around-gcc-444-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

