From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kvm-mmuc-work-around-gcc-444-bug.patch removed
 from -mm tree
Date: Thu, 11 Jun 2015 14:01:35 -0700
Message-ID: <5579f72f.T+TvvYSMKnd/DQTQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbbFKVBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jun 2015 17:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, guangrong.xiao@linux.intel.com, pbonzini@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/kvm/mmu.c: work around gcc-4.4.4 bug
has been removed from the -mm tree.  Its filename was
     arch-x86-kvm-mmuc-work-around-gcc-444-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/kvm/mmu.c: work around gcc-4.4.4 bug

arch/x86/kvm/mmu.c: In function 'kvm_mmu_pte_write':
arch/x86/kvm/mmu.c:4256: error: unknown field 'cr0_wp' specified in initializer
arch/x86/kvm/mmu.c:4257: error: unknown field 'cr4_pae' specified in initializer
arch/x86/kvm/mmu.c:4257: warning: excess elements in union initializer
...

gcc-4.4.4 (at least) has issues when using anonymous unions in
initializers.

Fixes: edc90b7dc4ceef6 ("KVM: MMU: fix SMAP virtualization")
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/x86/kvm/mmu.c~arch-x86-kvm-mmuc-work-around-gcc-444-bug arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~arch-x86-kvm-mmuc-work-around-gcc-444-bug
+++ a/arch/x86/kvm/mmu.c
@@ -4215,13 +4215,13 @@ void kvm_mmu_pte_write(struct kvm_vcpu *
 	u64 entry, gentry, *spte;
 	int npte;
 	bool remote_flush, local_flush, zap_page;
-	union kvm_mmu_page_role mask = (union kvm_mmu_page_role) {
-		.cr0_wp = 1,
-		.cr4_pae = 1,
-		.nxe = 1,
-		.smep_andnot_wp = 1,
-		.smap_andnot_wp = 1,
-	};
+	union kvm_mmu_page_role mask = { };
+
+	mask.cr0_wp = 1;
+	mask.cr4_pae = 1;
+	mask.nxe = 1;
+	mask.smep_andnot_wp = 1;
+	mask.smap_andnot_wp = 1;
 
 	/*
 	 * If we don't have indirect shadow pages, it means no page is
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-runtime-enable-disable-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
revert-x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
linux-next.patch
reapply-x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
linux-next-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

