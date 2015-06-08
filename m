From: akpm@linux-foundation.org
Subject: + linux-next-rejects-git-rejects.patch added to -mm tree
Date: Mon, 08 Jun 2015 13:09:16 -0700
Message-ID: <5575f66c.G5VCpr4rtKhqkY4W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbbFHUJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2015 16:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects-git-rejects.patch

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
Subject: linux-next-rejects-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event.h          |    5 -
 arch/x86/kernel/cpu/perf_event_intel.c    |   69 --------------------
 arch/x86/kernel/cpu/perf_event_intel_pt.c |    6 -
 drivers/gpu/drm/i915/intel_ringbuffer.c   |    3 
 drivers/tty/serial/amba-pl011.c           |   17 ----
 drivers/usb/musb/musb_core.c              |    4 -
 tools/testing/selftests/x86/Makefile      |    4 -
 7 files changed, 108 deletions(-)

diff -puN arch/x86/kernel/cpu/perf_event.h~linux-next-rejects-git-rejects arch/x86/kernel/cpu/perf_event.h
--- a/arch/x86/kernel/cpu/perf_event.h~linux-next-rejects-git-rejects
+++ a/arch/x86/kernel/cpu/perf_event.h
@@ -526,11 +526,6 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 
-<<<<<<< HEAD
-	void		(*commit_scheduling)(struct cpu_hw_events *cpuc, int idx, int cntr);
-
-=======
->>>>>>> linux-next/akpm-base
 	void		(*start_scheduling)(struct cpu_hw_events *cpuc);
 
 	void		(*commit_scheduling)(struct cpu_hw_events *cpuc, int idx, int cntr);
diff -puN arch/x86/kernel/cpu/perf_event_intel.c~linux-next-rejects-git-rejects arch/x86/kernel/cpu/perf_event_intel.c
--- a/arch/x86/kernel/cpu/perf_event_intel.c~linux-next-rejects-git-rejects
+++ a/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2003,28 +2003,6 @@ intel_get_excl_constraints(struct cpu_hw
 	 */
 	if (WARN_ON_ONCE(!excl_cntrs))
 		return c;
-<<<<<<< HEAD
-	/*
-	 * event requires exclusive counter access
-	 * across HT threads
-	 */
-	is_excl = c->flags & PERF_X86_EVENT_EXCL;
-	if (is_excl && !(event->hw.flags & PERF_X86_EVENT_EXCL_ACCT)) {
-		event->hw.flags |= PERF_X86_EVENT_EXCL_ACCT;
-		if (!cpuc->n_excl++)
-			WRITE_ONCE(excl_cntrs->has_exclusive[tid], 1);
-	}
-
-	/*
-	 * xl = state of current HT
-	 * xlo = state of sibling HT
-	 */
-	xl = &excl_cntrs->states[tid];
-	xlo = &excl_cntrs->states[o_tid];
-
-	cx = c;
-=======
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * because we modify the constraint, we need
@@ -2162,11 +2140,6 @@ static void intel_put_excl_constraints(s
 	if (WARN_ON_ONCE(!excl_cntrs))
 		return;
 
-<<<<<<< HEAD
-	xl = &excl_cntrs->states[tid];
-	xlo = &excl_cntrs->states[o_tid];
-=======
->>>>>>> linux-next/akpm-base
 	if (hwc->flags & PERF_X86_EVENT_EXCL_ACCT) {
 		hwc->flags &= ~PERF_X86_EVENT_EXCL_ACCT;
 		if (!--cpuc->n_excl)
@@ -2222,44 +2195,6 @@ static void intel_put_event_constraints(
 	 */
 	if (cpuc->excl_cntrs)
 		intel_put_excl_constraints(cpuc, event);
-<<<<<<< HEAD
-}
-
-static void intel_commit_scheduling(struct cpu_hw_events *cpuc, int idx, int cntr)
-{
-	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
-	struct event_constraint *c = cpuc->event_constraint[idx];
-	struct intel_excl_states *xlo, *xl;
-	int tid = cpuc->excl_thread_id;
-	int o_tid = 1 - tid;
-	int is_excl;
-
-	if (cpuc->is_fake || !c)
-		return;
-
-	is_excl = c->flags & PERF_X86_EVENT_EXCL;
-
-	if (!(c->flags & PERF_X86_EVENT_DYNAMIC))
-		return;
-
-	WARN_ON_ONCE(!excl_cntrs);
-
-	if (!excl_cntrs)
-		return;
-
-	xl = &excl_cntrs->states[tid];
-	xlo = &excl_cntrs->states[o_tid];
-
-	WARN_ON_ONCE(!raw_spin_is_locked(&excl_cntrs->lock));
-
-	if (cntr >= 0) {
-		if (is_excl)
-			xlo->init_state[cntr] = INTEL_EXCL_EXCLUSIVE;
-		else
-			xlo->init_state[cntr] = INTEL_EXCL_SHARED;
-	}
-=======
->>>>>>> linux-next/akpm-base
 }
 
 static void intel_pebs_aliases_core2(struct perf_event *event)
@@ -2652,11 +2587,7 @@ static void intel_pmu_cpu_starting(int c
 		cpuc->lbr_sel = &cpuc->shared_regs->regs[EXTRA_REG_LBR];
 
 	if (x86_pmu.flags & PMU_FL_EXCL_CNTRS) {
-<<<<<<< HEAD
-		for_each_cpu(i, topology_thread_cpumask(cpu)) {
-=======
 		for_each_cpu(i, topology_sibling_cpumask(cpu)) {
->>>>>>> linux-next/akpm-base
 			struct intel_excl_cntrs *c;
 
 			c = per_cpu(cpu_hw_events, i).excl_cntrs;
diff -puN arch/x86/kernel/cpu/perf_event_intel_pt.c~linux-next-rejects-git-rejects arch/x86/kernel/cpu/perf_event_intel_pt.c
--- a/arch/x86/kernel/cpu/perf_event_intel_pt.c~linux-next-rejects-git-rejects
+++ a/arch/x86/kernel/cpu/perf_event_intel_pt.c
@@ -613,12 +613,6 @@ static int pt_buffer_reset_markers(struc
 {
 	unsigned long head = local64_read(&buf->head);
 	unsigned long idx, npages, wakeup;
-<<<<<<< HEAD
-
-	if (buf->snapshot)
-		return 0;
-=======
->>>>>>> linux-next/akpm-base
 
 	/* can't stop in the middle of an output region */
 	if (buf->output_off + handle->size + 1 <
diff -puN drivers/gpu/drm/i915/intel_ringbuffer.c~linux-next-rejects-git-rejects drivers/gpu/drm/i915/intel_ringbuffer.c
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c~linux-next-rejects-git-rejects
+++ a/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1030,8 +1030,6 @@ static int skl_init_workarounds(struct i
 				  HDC_FENCE_DEST_SLM_DISABLE |
 				  HDC_BARRIER_PERFORMANCE_DISABLE);
 
-<<<<<<< HEAD
-=======
 	if (INTEL_REVID(dev) <= SKL_REVID_D0) {
 		/*
 		 *Use Force Non-Coherent whenever executing a 3D context. This
@@ -1043,7 +1041,6 @@ static int skl_init_workarounds(struct i
 				  HDC_FORCE_NON_COHERENT);
 	}
 
->>>>>>> linux-next/akpm-base
 	return skl_tune_iz_hashing(ring);
 }
 
diff -puN drivers/tty/serial/amba-pl011.c~linux-next-rejects-git-rejects drivers/tty/serial/amba-pl011.c
--- a/drivers/tty/serial/amba-pl011.c~linux-next-rejects-git-rejects
+++ a/drivers/tty/serial/amba-pl011.c
@@ -1259,23 +1259,11 @@ __acquires(&uap->port.lock)
 	spin_lock(&uap->port.lock);
 }
 
-<<<<<<< HEAD
-/*
- * Transmit a character
- *
- * Returns true if the character was successfully queued to the FIFO.
- * Returns false otherwise.
- */
-static bool pl011_tx_char(struct uart_amba_port *uap, unsigned char c)
-{
-	if (readw(uap->port.membase + UART01x_FR) & UART01x_FR_TXFF)
-=======
 static bool pl011_tx_char(struct uart_amba_port *uap, unsigned char c,
 			  bool from_irq)
 {
 	if (unlikely(!from_irq) &&
 	    readw(uap->port.membase + UART01x_FR) & UART01x_FR_TXFF)
->>>>>>> linux-next/akpm-base
 		return false; /* unable to transmit character */
 
 	writew(c, uap->port.membase + UART01x_DR);
@@ -1290,13 +1278,8 @@ static void pl011_tx_chars(struct uart_a
 	int count = uap->fifosize >> 1;
 
 	if (uap->port.x_char) {
-<<<<<<< HEAD
-		if (!pl011_tx_char(uap, uap->port.x_char))
-			goto done;
-=======
 		if (!pl011_tx_char(uap, uap->port.x_char, from_irq))
 			return;
->>>>>>> linux-next/akpm-base
 		uap->port.x_char = 0;
 		--count;
 	}
diff -puN drivers/usb/musb/musb_core.c~linux-next-rejects-git-rejects drivers/usb/musb/musb_core.c
--- a/drivers/usb/musb/musb_core.c~linux-next-rejects-git-rejects
+++ a/drivers/usb/musb/musb_core.c
@@ -2032,11 +2032,7 @@ musb_init_controller(struct device *dev,
 	if (musb->ops->quirks)
 		musb->io.quirks = musb->ops->quirks;
 
-<<<<<<< HEAD
-	/* Most devices use indexed offset or flat offset */
-=======
 	/* Set default ep access to indexed offset or flat offset ops */
->>>>>>> linux-next/akpm-base
 	if (musb->io.quirks & MUSB_INDEXED_EP) {
 		musb->io.ep_offset = musb_indexed_ep_offset;
 		musb->io.ep_select = musb_indexed_ep_select;
diff -puN tools/testing/selftests/x86/Makefile~linux-next-rejects-git-rejects tools/testing/selftests/x86/Makefile
--- a/tools/testing/selftests/x86/Makefile~linux-next-rejects-git-rejects
+++ a/tools/testing/selftests/x86/Makefile
@@ -4,11 +4,7 @@ include ../lib.mk
 
 .PHONY: all all_32 all_64 warn_32bit_failure clean
 
-<<<<<<< HEAD
-TARGETS_C_BOTHBITS := sigreturn single_step_syscall
-=======
 TARGETS_C_BOTHBITS := sigreturn single_step_syscall sysret_ss_attrs
->>>>>>> linux-next/akpm-base
 TARGETS_C_32BIT_ONLY := entry_from_vm86
 
 TARGETS_C_32BIT_ALL := $(TARGETS_C_BOTHBITS) $(TARGETS_C_32BIT_ONLY)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
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
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
oom-split-out-forced-oom-killer-checkpatch-fixes.patch
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
ipcshm-move-bug_on-check-into-shm_lock-fix-2.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
revert-x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
linux-next.patch
reapply-x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
linux-next-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
linux-next-rejects-git-rejects.patch

