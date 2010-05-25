From: akpm@linux-foundation.org
Subject: + s3fb-add-support-for-s3-trio3d-1x-2x-checkpatch-fixes.patch added to -mm tree
Date: Tue, 25 May 2010 12:47:03 -0700
Message-ID: <201005251947.o4PJl3O6011334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758519Ab0EYTrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 15:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, linux@rainbow-software.org


The patch titled
     s3fb-add-support-for-s3-trio3d-1x-2x-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     s3fb-add-support-for-s3-trio3d-1x-2x-checkpatch-fixes.patch

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
Subject: s3fb-add-support-for-s3-trio3d-1x-2x-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#58: FILE: drivers/video/s3fb.c:351:
+		vga_wseq(NULL, 0x12, (n - 2) | ((r & 3) << 6));	/* n and two bits of r */

ERROR: space required before the open parenthesis '('
#166: FILE: drivers/video/s3fb.c:904:
+		switch(vga_rcrt(NULL, 0x2f)) {

ERROR: space required before the open parenthesis '('
#201: FILE: drivers/video/s3fb.c:990:
+		switch((regval & 0xE0) >> 5) {

WARNING: line over 80 characters
#222: FILE: drivers/video/s3fb.c:1194:
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A13), .driver_data = CHIP_36X_TRIO3D_1X_2X},

total: 2 errors, 2 warnings, 195 lines checked

./patches/s3fb-add-support-for-s3-trio3d-1x-2x.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/s3fb.c~s3fb-add-support-for-s3-trio3d-1x-2x-checkpatch-fixes drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-add-support-for-s3-trio3d-1x-2x-checkpatch-fixes
+++ a/drivers/video/s3fb.c
@@ -901,7 +901,7 @@ static int __devinit s3_identification(i
 	}
 
 	if (chip == CHIP_36X_TRIO3D_1X_2X) {
-		switch(vga_rcrt(NULL, 0x2f)) {
+		switch (vga_rcrt(NULL, 0x2f)) {
 		case 0x00:
 			return CHIP_360_TRIO3D_1X;
 		case 0x01:
@@ -987,7 +987,7 @@ static int __devinit s3_pci_probe(struct
 	if (par->chip == CHIP_360_TRIO3D_1X ||
 	    par->chip == CHIP_362_TRIO3D_2X ||
 	    par->chip == CHIP_368_TRIO3D_2X) {
-		switch((regval & 0xE0) >> 5) {
+		switch ((regval & 0xE0) >> 5) {
 		case 0: /* 8MB -- only 4MB usable for display */
 		case 1: /* 4MB with 32-bit bus */
 		case 2:	/* 4MB */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
lib-kobject_ueventc-fix-conig_net=n-warning.patch
dib3000mc-reduce-large-stack-usage-fix.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
s3fb-add-support-for-s3-trio3d-1x-2x-checkpatch-fixes.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-4.patch
memcg-clean-up-memory-thresholds-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs-checkpatch-fixes.patch
pids-increase-pid_max-based-on-num_possible_cpus-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-fix.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch

