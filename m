From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-pci-nommuc-dont-initialise-sg-dma_length.patch added to -mm tree
Date: Mon, 05 Apr 2010 16:58:54 -0700
Message-ID: <201004052358.o35Nwtkx016926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756954Ab0DEX7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 19:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/kernel/pci-nommu.c: don't initialise sg->dma_length
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-pci-nommuc-dont-initialise-sg-dma_length.patch

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
Subject: arch/x86/kernel/pci-nommu.c: don't initialise sg->dma_length
From: Andrew Morton <akpm@linux-foundation.org>

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> We can remove dma_length in > pci-nommu.c though (there is no point of
> setting dma_length here).
>

This breaks the build when "asm-generic: add NEED_SG_DMA_LENGTH to define
sg_dma_len()" is applied.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-nommu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/pci-nommu.c~arch-x86-kernel-pci-nommuc-dont-initialise-sg-dma_length arch/x86/kernel/pci-nommu.c
--- a/arch/x86/kernel/pci-nommu.c~arch-x86-kernel-pci-nommuc-dont-initialise-sg-dma_length
+++ a/arch/x86/kernel/pci-nommu.c
@@ -68,7 +68,6 @@ static int nommu_map_sg(struct device *h
 		s->dma_address = sg_phys(s);
 		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
 			return 0;
-		s->dma_length = s->length;
 	}
 	flush_write_buffers();
 	return nents;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-remove-temporary-for_each_bit.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
exit-fix-oops-in-sync_mm_rss-fix.patch
drivers-char-amiserialc-add-missing-local_irq_restore.patch
mxser-spin_lock-=-spin_lock_irq-fix.patch
ratelimit-annotate-___ratelimit-fix.patch
rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
ipc-mqueuec-let-message-queue-timeout-use-hrtimers-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
arch-x86-kernel-pci-nommuc-dont-initialise-sg-dma_length.patch
asm-generic-add-need_sg_dma_length-to-define-sg_dma_len-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

