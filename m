From: akpm@linux-foundation.org
Subject: [folded] lib-flexible-array-implementation-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 29 Jul 2009 14:51:31 -0700
Message-ID: <200907292151.n6TLpVxU030859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbZG2VwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 17:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     lib-flexible-array-implementation-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-flexible-array-implementation-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-flexible-array-implementation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-flexible-array-implementation-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#101: FILE: include/linux/flex_array.h:43:
+int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags);

ERROR: return is not a function, parentheses are not required
#271: FILE: lib/flex_array.c:151:
+	return (element_nr % __elements_per_part(fa->element_size));

WARNING: line over 80 characters
#311: FILE: lib/flex_array.c:191:
+int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags)

ERROR: code indent should use tabs where possible
#354: FILE: lib/flex_array.c:234:
+      ^Iend_part = fa_element_to_part_nr(fa, end);$

total: 2 errors, 2 warnings, 323 lines checked

./patches/lib-flexible-array-implementation.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |    3 ++-
 lib/flex_array.c           |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/flex_array.h~lib-flexible-array-implementation-checkpatch-fixes include/linux/flex_array.h
--- a/include/linux/flex_array.h~lib-flexible-array-implementation-checkpatch-fixes
+++ a/include/linux/flex_array.h
@@ -40,7 +40,8 @@ struct flex_array *flex_array_alloc(int 
 int flex_array_prealloc(struct flex_array *fa, int start, int end, gfp_t flags);
 void flex_array_free(struct flex_array *fa);
 void flex_array_free_parts(struct flex_array *fa);
-int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags);
+int flex_array_put(struct flex_array *fa, int element_nr, void *src,
+		gfp_t flags);
 void *flex_array_get(struct flex_array *fa, int element_nr);
 
 #endif /* _FLEX_ARRAY_H */
diff -puN lib/flex_array.c~lib-flexible-array-implementation-checkpatch-fixes lib/flex_array.c
--- a/lib/flex_array.c~lib-flexible-array-implementation-checkpatch-fixes
+++ a/lib/flex_array.c
@@ -148,7 +148,7 @@ void flex_array_free(struct flex_array *
 
 static int fa_index_inside_part(struct flex_array *fa, int element_nr)
 {
-	return (element_nr % __elements_per_part(fa->element_size));
+	return element_nr % __elements_per_part(fa->element_size);
 }
 
 static int index_inside_part(struct flex_array *fa, int element_nr)
@@ -231,7 +231,7 @@ int flex_array_prealloc(struct flex_arra
 	if (elements_fit_in_base(fa))
 		return 0;
 	start_part = fa_element_to_part_nr(fa, start);
-      	end_part = fa_element_to_part_nr(fa, end);
+	end_part = fa_element_to_part_nr(fa, end);
 	for (part_nr = start_part; part_nr <= end_part; part_nr++) {
 		part = __fa_get_part(fa, part_nr, flags);
 		if (!part)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-flexible-array-implementation.patch
lib-flexible-array-implementation-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio-checkpatch-fixes.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse-fix.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
watchdog-add-sbc-fitpc2-watchdog-driver-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ummunotify-userspace-support-for-mmu-notifications-cleanup.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
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

