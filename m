From: akpm@linux-foundation.org
Subject: [merged] arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch removed from -mm tree
Date: Mon, 24 Aug 2009 12:00:03 -0700
Message-ID: <200908241900.n7OJ03Ma031280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959AbZHXTAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 15:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     arch/m68k/include/asm/motorola_pgalloc.h: fix kunmap arg
has been removed from the -mm tree.  Its filename was
     arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/m68k/include/asm/motorola_pgalloc.h: fix kunmap arg
From: Andrew Morton <akpm@linux-foundation.org>

arch/m68k/include/asm/motorola_pgalloc.h: In function 'pte_alloc_one':
arch/m68k/include/asm/motorola_pgalloc.h:44: warning: passing argument 1 of 'kunmap' from incompatible pointer type

Also, remove unneeded test for kmap() failure.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/motorola_pgalloc.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN arch/m68k/include/asm/motorola_pgalloc.h~arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg arch/m68k/include/asm/motorola_pgalloc.h
--- a/arch/m68k/include/asm/motorola_pgalloc.h~arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -36,12 +36,10 @@ static inline pgtable_t pte_alloc_one(st
 		return NULL;
 
 	pte = kmap(page);
-	if (pte) {
-		__flush_page_to_ram(pte);
-		flush_tlb_kernel_page(pte);
-		nocache_page(pte);
-	}
-	kunmap(pte);
+	__flush_page_to_ram(pte);
+	flush_tlb_kernel_page(pte);
+	nocache_page(pte);
+	kunmap(page);
 	pgtable_page_ctor(page);
 	return page;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-amdc-fix-x86_64-allnoconfig-build.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
video-initial-support-for-adv7180-update-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
leds-gpio-leds-fix-typographics-fault.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch
slram-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-use-registerd-physmem-information-fix.patch
kcore-use-registerd-physmem-information-checkpatch-fixes.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
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

