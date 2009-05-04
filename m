From: akpm@linux-foundation.org
Subject: + revert-genirq-assert-that-irq-handlers-are-indeed-running-in-hardirq-context.patch added to -mm tree
Date: Mon, 04 May 2009 14:29:06 -0700
Message-ID: <200905042129.n44LT6rM004728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbZEDVdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de


The patch titled
     revert "genirq: assert that irq handlers are indeed running in hardirq context"
has been added to the -mm tree.  Its filename is
     revert-genirq-assert-that-irq-handlers-are-indeed-running-in-hardirq-context.patch

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
Subject: revert "genirq: assert that irq handlers are indeed running in hardirq context"
From: Andrew Morton <akpm@linux-foundation.org>

: commit 044d408409cc4e1bc75c886e27ca85c270db104c
: Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
: AuthorDate: Mon Mar 2 16:13:32 2009 +0100
: Commit:     Ingo Molnar <mingo@elte.hu>
: CommitDate: Tue Mar 3 00:05:45 2009 +0100
: 
:     genirq: assert that irq handlers are indeed running in hardirq context

causes warnings to appear on ARM.  Eg,

WARNING: at /build/linux/kernel/irq/handle.c:353 handle_IRQ_event+0x58/0xd8()
BUG: IRQ handler called from non-hardirq context!
Backtrace:
[<c0460e60>] (handle_IRQ_event+0x0/0xd8) from [<c046257c>] (handle_edge_irq+0x114/0x150)
[<c0462468>] (handle_edge_irq+0x0/0x150) from [<c0461b80>] (resend_irqs+0x48/0x80)
[<c0461b38>] (resend_irqs+0x0/0x80) from [<c043ffa8>] (tasklet_action+0x88/0xe0)
[<c043ff20>] (tasklet_action+0x0/0xe0) from [<c043f9e0>] (__do_softirq+0x68/0x104)

Reported-by: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/handle.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/irq/handle.c~revert-genirq-assert-that-irq-handlers-are-indeed-running-in-hardirq-context kernel/irq/handle.c
--- a/kernel/irq/handle.c~revert-genirq-assert-that-irq-handlers-are-indeed-running-in-hardirq-context
+++ a/kernel/irq/handle.c
@@ -362,8 +362,6 @@ irqreturn_t handle_IRQ_event(unsigned in
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	WARN_ONCE(!in_irq(), "BUG: IRQ handler called from non-hardirq context!");
-
 	if (!(action->flags & IRQF_DISABLED))
 		local_irq_enable_in_hardirq();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
mtd-fix-timeout-in-m25p80-driver-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
revert-genirq-assert-that-irq-handlers-are-indeed-running-in-hardirq-context.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-borked-on-non-x86.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

