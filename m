From: akpm@linux-foundation.org
Subject: [merged] arch-x86-oprofile-op_model_amdc-perform-initialisation-on-a-single-cpu.patch removed from -mm tree
Date: Mon, 03 Jan 2011 10:52:22 -0800
Message-ID: <201101031853.p03Irenx023076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439Ab1ACSyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 13:54:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, atswartz@gmail.com, error27@gmail.com, mingo@elte.hu, rjw@sisk.pl, robert.richter@amd.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     arch/x86/oprofile/op_model_amd.c: perform initialisation on a single CPU
has been removed from the -mm tree.  Its filename was
     arch-x86-oprofile-op_model_amdc-perform-initialisation-on-a-single-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/oprofile/op_model_amd.c: perform initialisation on a single CPU
From: Andrew Morton <akpm@linux-foundation.org>

[    7.034377] BUG: using smp_processor_id() in preemptible [00000000] code:
modprobe/483
[    7.034385] caller is setup_APIC_eilvt+0x155/0x180
[    7.034389] Pid: 483, comm: modprobe Not tainted 2.6.37-rc1-20101110+ #1
[    7.034392] Call Trace:
[    7.034400]  [<ffffffff812a2b72>] debug_smp_processor_id+0xd2/0xf0
[    7.034404]  [<ffffffff8101e985>] setup_APIC_eilvt+0x155/0x180
[    7.034413]  [<ffffffffa002e168>] op_amd_init+0x88/0x2b0 [oprofile]
[    7.034420]  [<ffffffffa0043000>] ? oprofile_init+0x0/0x42 [oprofile]
[    7.034425]  [<ffffffffa0043315>] op_nmi_init+0x249/0x2af [oprofile]
[    7.034431]  [<ffffffffa00430b4>] oprofile_arch_init+0x11/0x29 [oprofile]
[    7.034437]  [<ffffffffa0043010>] oprofile_init+0x10/0x42 [oprofile]
[    7.034441]  [<ffffffff810001e3>] do_one_initcall+0x43/0x170
[    7.034445]  [<ffffffff8108a52a>] sys_init_module+0xba/0x200
[    7.034449]  [<ffffffff8100285b>] system_call_fastpath+0x16/0x1b

Not sure if it fixes a real bug - presumably not, if all CPUs are the same.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=22812

Reported-by: <atswartz@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>		[2.6.37.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/oprofile/op_model_amd.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/x86/oprofile/op_model_amd.c~arch-x86-oprofile-op_model_amdc-perform-initialisation-on-a-single-cpu arch/x86/oprofile/op_model_amd.c
--- a/arch/x86/oprofile/op_model_amd.c~arch-x86-oprofile-op_model_amdc-perform-initialisation-on-a-single-cpu
+++ a/arch/x86/oprofile/op_model_amd.c
@@ -710,7 +710,13 @@ struct op_x86_model_spec op_amd_spec;
 
 static int op_amd_init(struct oprofile_operations *ops)
 {
+	/*
+	 * init_ibs() preforms implictly cpu-local operations, so pin this
+	 * thread to its current CPU
+	 */
+	preempt_disable();
 	init_ibs();
+	preempt_enable();
 	create_arch_files = ops->create_files;
 	ops->create_files = setup_ibs_files;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-mn10300-kernel-irqc-fix-build.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
ramoops-fix-types-remove-typecasts.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

