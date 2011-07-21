From: akpm@linux-foundation.org
Subject: + mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch added to -mm tree
Date: Thu, 21 Jul 2011 15:36:59 -0700
Message-ID: <201107212236.p6LMaxHP013376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab1GUWhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 18:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, darren.hart@intel.com


The patch titled
     mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix
has been added to the -mm tree.  Its filename is
     mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch

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
Subject: mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix some nits Darren saw, fiddle comment layout

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Darren Hart <darren.hart@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff -puN include/linux/mm.h~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix include/linux/mm.h
diff -puN kernel/futex.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix kernel/futex.c
diff -puN mm/memory.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix mm/memory.c
--- a/mm/memory.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix
+++ a/mm/memory.c
@@ -1806,30 +1806,29 @@ next_page:
 EXPORT_SYMBOL(__get_user_pages);
 
 /*
- * fixup_user_fault() - manually resolve a user page  fault
+ * fixup_user_fault() - manually resolve a user page fault
  * @tsk:	the task_struct to use for page fault accounting, or
  *		NULL if faults are not to be recorded.
  * @mm:		mm_struct of target mm
  * @address:	user address
  * @fault_flags:flags to pass down to handle_mm_fault()
  *
- * This is meant to be called in the specific scenario where for
- * locking reasons we try to access user memory in atomic context
- * (within a pagefault_disable() section), this returns -EFAULT,
- * and we want to resolve the user fault before trying again.
+ * This is meant to be called in the specific scenario where for locking reasons
+ * we try to access user memory in atomic context (within a pagefault_disable()
+ * section), this returns -EFAULT, and we want to resolve the user fault before
+ * trying again.
  *
  * Typically this is meant to be used by the futex code.
  *
- * The main difference with get_user_pages() is that this function
- * will unconditionally call handle_mm_fault() which will in turn
- * perform all the necessary SW fixup of the dirty and young bits
- * in the PTE, while handle_mm_fault() only guarantees to update
- * these in the struct page.
- *
- * This is important for some architectures where those bits also
- * gate the access permission to the page because their are
- * maintained in software. On such architecture, gup() will not
- * be enough to make a subsequent access succeed.
+ * The main difference with get_user_pages() is that this function will
+ * unconditionally call handle_mm_fault() which will in turn perform all the
+ * necessary SW fixup of the dirty and young bits in the PTE, while
+ * handle_mm_fault() only guarantees to update these in the struct page.
+ *
+ * This is important for some architectures where those bits also gate the
+ * access permission to the page because they are maintained in software.  On
+ * such architectures, gup() will not be enough to make a subsequent access
+ * succeed.
  *
  * This should be called with the mm_sem held for read.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

