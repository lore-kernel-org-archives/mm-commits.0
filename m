From: akpm@linux-foundation.org
Subject: + kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch added to -mm tree
Date: Thu, 15 Apr 2010 14:09:21 -0700
Message-ID: <201004152136.o3FLaTDU032663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757107Ab0DOVgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 17:36:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix
has been added to the -mm tree.  Its filename is
     kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch

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
Subject: kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/timb_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/timb_dma.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix drivers/dma/timb_dma.c
--- a/drivers/dma/timb_dma.c~kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix
+++ a/drivers/dma/timb_dma.c
@@ -188,7 +188,7 @@ static void __td_unmap_descs(struct timb
 static int td_fill_desc(struct timb_dma_chan *td_chan, u8 *dma_desc,
 	struct scatterlist *sg, bool last)
 {
-	if (sg_dma_len(sg) > USHORT_MAX) {
+	if (sg_dma_len(sg) > USHRT_MAX) {
 		dev_err(chan2dev(&td_chan->chan), "Too big sg element\n");
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51-fix.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
drivers-acpi-use-kasprintf-fix.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
jfs-free-sbi-memory-in-error-path.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix-fix-2.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
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

