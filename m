From: akpm@linux-foundation.org
Subject: + x86-fix-x86-fix-pageattr-handling-for-lpage-percpu-allocator-and-re-enable-it.patch added to -mm tree
Date: Wed, 15 Jul 2009 20:37:29 -0700
Message-ID: <200907160337.n6G3bTBj020101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757329AbZGPDjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 23:39:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, tj@kernel.org


The patch titled
     x86: fix "x86: fix pageattr handling for lpage percpu allocator and re-enable it"
has been added to the -mm tree.  Its filename is
     x86-fix-x86-fix-pageattr-handling-for-lpage-percpu-allocator-and-re-enable-it.patch

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
Subject: x86: fix "x86: fix pageattr handling for lpage percpu allocator and re-enable it"
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/mm/pageattr.c: In function 'cpa_process_alias':
arch/x86/mm/pageattr.c:749: error: implicit declaration of function 'pcpu_lpage_remapped'

Mutter.  All I did was type `make allnoconfig'.

Cc: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN include/linux/percpu.h~x86-fix-x86-fix-pageattr-handling-for-lpage-percpu-allocator-and-re-enable-it include/linux/percpu.h
--- a/include/linux/percpu.h~x86-fix-x86-fix-pageattr-handling-for-lpage-percpu-allocator-and-re-enable-it
+++ a/include/linux/percpu.h
@@ -96,7 +96,6 @@ extern ssize_t __init pcpu_lpage_first_c
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_map_fn_t map_fn);
 
-extern void *pcpu_lpage_remapped(void *kaddr);
 #else
 static inline int pcpu_lpage_build_unit_map(
 				size_t static_size, size_t reserved_size,
@@ -119,10 +118,6 @@ static inline ssize_t __init pcpu_lpage_
 	return -EINVAL;
 }
 
-static inline void *pcpu_lpage_remapped(void *kaddr)
-{
-	return NULL;
-}
 #endif
 
 /*
@@ -186,6 +181,15 @@ static inline void __init setup_per_cpu_
 
 #endif /* CONFIG_SMP */
 
+#if defined(CONFIG_NEED_MULTIPLE_NODES) && defined(CONFIG_SMP)
+extern void *pcpu_lpage_remapped(void *kaddr);
+#else
+static inline void *pcpu_lpage_remapped(void *kaddr)
+{
+	return NULL;
+}
+#endif
+
 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
 						       __alignof__(type))
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
x86-fix-x86-fix-pageattr-handling-for-lpage-percpu-allocator-and-re-enable-it.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

