From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 02 Oct 2012 12:31:03 -0700
Message-ID: <20121002193105.C9BDB200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:49775 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab2JBTbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2012 15:31:10 -0400
Received: by bkwq16 with SMTP id q16so465167bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Oct 2012 12:31:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/regulator/tps6586x.txt |    3 ---
 arch/Kconfig                                             |    3 ---
 arch/s390/Kconfig                                        |    6 ------
 arch/x86/Kconfig                                         |    5 -----
 arch/x86/kernel/cpu/common.c                             |    3 ---
 arch/x86/kernel/entry_64.S                               |    3 ---
 arch/x86/kernel/signal.c                                 |    3 ---
 arch/x86/kernel/traps.c                                  |    3 ---
 drivers/hid/hid-multitouch.c                             |    3 ---
 drivers/hid/hid-picolcd_debugfs.c                        |    4 ----
 drivers/hid/hid-wiimote-ext.c                            |    5 -----
 drivers/scsi/ipr.c                                       |    4 ----
 drivers/video/backlight/88pm860x_bl.c                    |    9 ---------
 kernel/sched/fair.c                                      |    3 ---
 14 files changed, 57 deletions(-)

diff -puN Documentation/devicetree/bindings/regulator/tps6586x.txt~linux-next-git-rejects Documentation/devicetree/bindings/regulator/tps6586x.txt
--- a/Documentation/devicetree/bindings/regulator/tps6586x.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/regulator/tps6586x.txt
@@ -41,11 +41,8 @@ Example:
 		#gpio-cells = <2>;
 		gpio-controller;
 
-<<<<<<< HEAD
-=======
 		ti,system-power-controller;
 
->>>>>>> linux-next/akpm-base
 		sys-supply = <&some_reg>;
 		vin-sm0-supply = <&some_reg>;
 		vin-sm1-supply = <&some_reg>;
diff -puN arch/Kconfig~linux-next-git-rejects arch/Kconfig
--- a/arch/Kconfig~linux-next-git-rejects
+++ a/arch/Kconfig
@@ -297,8 +297,6 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
-<<<<<<< HEAD
-=======
 config HAVE_MOD_ARCH_SPECIFIC
 	bool
 	help
@@ -318,7 +316,6 @@ config MODULES_USE_ELF_REL
 	  Modules only use ELF REL relocations.  Modules with ELF RELA
 	  relocations will give an error.
 
->>>>>>> linux-next/akpm-base
 config HAVE_RCU_USER_QS
 	bool
 	help
diff -puN arch/s390/Kconfig~linux-next-git-rejects arch/s390/Kconfig
--- a/arch/s390/Kconfig~linux-next-git-rejects
+++ a/arch/s390/Kconfig
@@ -50,15 +50,12 @@ config PGSTE
 	def_bool y if KVM
 
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-<<<<<<< HEAD
-=======
 	def_bool y
 
 config KEXEC
 	def_bool y
 
 config AUDIT_ARCH
->>>>>>> linux-next/akpm-base
 	def_bool y
 
 config S390
@@ -96,10 +93,7 @@ config S390
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_CMPXCHG_LOCAL
-<<<<<<< HEAD
-=======
 	select HAVE_CMPXCHG_DOUBLE
->>>>>>> linux-next/akpm-base
 	select HAVE_VIRT_CPU_ACCOUNTING
 	select VIRT_CPU_ACCOUNTING
 	select ARCH_DISCARD_MEMBLOCK
diff -puN arch/x86/Kconfig~linux-next-git-rejects arch/x86/Kconfig
--- a/arch/x86/Kconfig~linux-next-git-rejects
+++ a/arch/x86/Kconfig
@@ -102,16 +102,11 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
-<<<<<<< HEAD
-	select HAVE_RCU_USER_QS if X86_64
-	select HAVE_IRQ_TIME_ACCOUNTING
-=======
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select HAVE_RCU_USER_QS if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select GENERIC_KERNEL_THREAD
->>>>>>> linux-next/akpm-base
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN arch/x86/kernel/cpu/common.c~linux-next-git-rejects arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/common.c
@@ -1310,10 +1310,7 @@ void __cpuinit cpu_init(void)
 	dbg_restore_debug_regs();
 
 	fpu_init();
-<<<<<<< HEAD
 	xsave_init();
-=======
->>>>>>> linux-next/akpm-base
 
 	if (is_uv_system())
 		uv_cpu_init();
diff -puN arch/x86/kernel/entry_64.S~linux-next-git-rejects arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S~linux-next-git-rejects
+++ a/arch/x86/kernel/entry_64.S
@@ -57,10 +57,7 @@
 #include <asm/percpu.h>
 #include <asm/asm.h>
 #include <asm/rcu.h>
-<<<<<<< HEAD
-=======
 #include <asm/smap.h>
->>>>>>> linux-next/akpm-base
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
diff -puN arch/x86/kernel/signal.c~linux-next-git-rejects arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~linux-next-git-rejects
+++ a/arch/x86/kernel/signal.c
@@ -840,13 +840,10 @@ do_notify_resume(struct pt_regs *regs, v
 	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
 		fire_user_return_notifiers();
 
-<<<<<<< HEAD
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
 #endif /* CONFIG_X86_32 */
 
-=======
->>>>>>> linux-next/akpm-base
 	rcu_user_enter();
 }
 
diff -puN arch/x86/kernel/traps.c~linux-next-git-rejects arch/x86/kernel/traps.c
--- a/arch/x86/kernel/traps.c~linux-next-git-rejects
+++ a/arch/x86/kernel/traps.c
@@ -646,11 +646,8 @@ dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
 	exception_enter(regs);
-<<<<<<< HEAD
-=======
 	BUG_ON(use_eager_fpu());
 
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_MATH_EMULATION
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
diff -puN drivers/hid/hid-multitouch.c~linux-next-git-rejects drivers/hid/hid-multitouch.c
--- a/drivers/hid/hid-multitouch.c~linux-next-git-rejects
+++ a/drivers/hid/hid-multitouch.c
@@ -117,11 +117,8 @@ struct mt_device {
 #define MT_CLS_TOPSEED				0x0105
 #define MT_CLS_PANASONIC			0x0106
 #define MT_CLS_FLATFROG				0x0107
-<<<<<<< HEAD
 #define MT_CLS_GENERALTOUCH_TWOFINGERS		0x0108
 #define MT_CLS_GENERALTOUCH_PWT_TENFINGERS	0x0109
-=======
->>>>>>> linux-next/akpm-base
 
 #define MT_DEFAULT_MAXCONTACT	10
 
diff -puN drivers/hid/hid-picolcd_debugfs.c~linux-next-git-rejects drivers/hid/hid-picolcd_debugfs.c
--- a/drivers/hid/hid-picolcd_debugfs.c~linux-next-git-rejects
+++ a/drivers/hid/hid-picolcd_debugfs.c
@@ -402,11 +402,7 @@ void picolcd_debug_out_report(struct pic
 #define BUFF_SZ 256
 
 	/* Avoid unnecessary overhead if debugfs is disabled */
-<<<<<<< HEAD
 	if (list_empty(&hdev->debug_list))
-=======
-	if (!hdev->debug_events)
->>>>>>> linux-next/akpm-base
 		return;
 
 	buff = kmalloc(BUFF_SZ, GFP_ATOMIC);
diff -puN drivers/hid/hid-wiimote-ext.c~linux-next-git-rejects drivers/hid/hid-wiimote-ext.c
--- a/drivers/hid/hid-wiimote-ext.c~linux-next-git-rejects
+++ a/drivers/hid/hid-wiimote-ext.c
@@ -585,12 +585,7 @@ static void handler_balance_board(struct
 		} else {
 			tmp = val[i] - ext->calib[i][1];
 			tmp *= 1700;
-<<<<<<< HEAD
-			tmp /= ext->calib[i][2] - ext->calib[i][1];
-			tmp += 1700;
-=======
 			tmp /= ext->calib[i][2] - ext->calib[i][1] + 1700;
->>>>>>> linux-next/akpm-base
 		}
 		val[i] = tmp;
 	}
diff -puN drivers/scsi/ipr.c~linux-next-git-rejects drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~linux-next-git-rejects
+++ a/drivers/scsi/ipr.c
@@ -6400,11 +6400,7 @@ static int ipr_invalid_adapter(struct ip
 
 	if ((ioa_cfg->type == 0x5702) && (ioa_cfg->pdev->revision < 4)) {
 		for (i = 0; i < ARRAY_SIZE(ipr_blocked_processors); i++) {
-<<<<<<< HEAD
-			if (__is_processor(ipr_blocked_processors[i]))
-=======
 			if (pvr_version_is(ipr_blocked_processors[i]))
->>>>>>> linux-next/akpm-base
 				return 1;
 		}
 	}
diff -puN drivers/video/backlight/88pm860x_bl.c~linux-next-git-rejects drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~linux-next-git-rejects
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -203,18 +203,9 @@ static int pm860x_backlight_probe(struct
 	data->i2c = (chip->id == CHIP_PM8606) ? chip->client	\
 			: chip->companion;
 	data->current_brightness = MAX_BRIGHTNESS;
-<<<<<<< HEAD
-	data->pwm = pdata->pwm;
-	data->iset = pdata->iset;
-	data->port = pdata->flags;
-	if (data->port < 0) {
-		dev_err(&pdev->dev, "wrong platform data is assigned");
-		return -EINVAL;
-=======
 	if (pdata) {
 		data->pwm = pdata->pwm;
 		data->iset = pdata->iset;
->>>>>>> linux-next/akpm-base
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
diff -puN kernel/sched/fair.c~linux-next-git-rejects kernel/sched/fair.c
--- a/kernel/sched/fair.c~linux-next-git-rejects
+++ a/kernel/sched/fair.c
@@ -3011,8 +3011,6 @@ select_task_rq_fair(struct task_struct *
 	rcu_read_lock();
 	if (sched_feat_numa(NUMA_BIAS) && node != -1) {
 		/*
-<<<<<<< HEAD
-=======
 		 * For fork,exec find the idlest cpu in the home-node.
 		 */
 		if (sd_flag & (SD_BALANCE_FORK|SD_BALANCE_EXEC)) {
@@ -3043,7 +3041,6 @@ find_sd:
 			continue;
 
 		/*
->>>>>>> linux-next/akpm-base
 		 * If both cpu and prev_cpu are part of this domain,
 		 * cpu is a valid SD_WAKE_AFFINE target.
 		 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
audith-replace-defines-with-c-stubs.patch
audith-replace-defines-with-c-stubs-fix.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
fs-block_devc-set_blocksize-use-mapping_mapped.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

