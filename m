From: akpm@linux-foundation.org
Subject: + x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch added to -mm tree
Date: Tue, 18 Oct 2011 16:01:16 -0700
Message-ID: <201110182341.p9INfWDS000608@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:54919 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1JRXls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 19:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, john.stultz@linaro.org, mingo@redhat.com, steiner@sgi.com, tglx@linutronix.de


The patch titled
     Subject: x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix
has been added to the -mm tree.  Its filename is
     x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix

fix CONFIG_SMP=n build

arch/x86/kernel/tsc.c: In function 'calibrate_delay_is_known':
arch/x86/kernel/tsc.c:1012: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
arch/x86/kernel/tsc.c:1012: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
arch/x86/kernel/tsc.c:1006: warning: unused variable 'cpu'

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/tsc.c |    3 ++-
 calibrate.c           |    0 
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/smpboot.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix arch/x86/kernel/smpboot.c
diff -puN arch/x86/kernel/tsc.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix
+++ a/arch/x86/kernel/tsc.c
@@ -995,6 +995,7 @@ void __init tsc_init(void)
 	check_system_tsc_reliable();
 }
 
+#ifdef CONFIG_SMP
 /*
  * If we have a constant TSC and are using the TSC for the delay loop,
  * we can skip clock calibration if another cpu in the same socket has already
@@ -1013,4 +1014,4 @@ unsigned long __cpuinit calibrate_delay_
 			return cpu_data(i).loops_per_jiffy;
 	return 0;
 }
-
+#endif
diff -puN init/calibrate.c~x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix init/calibrate.c
_
Subject: Subject: x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-xfs-xfs_trans_ailc-fix-build.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
fs-nameic-remove-unused-getname_flags.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
sysctl-add-support-for-poll-fix.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch

