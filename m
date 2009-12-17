From: akpm@linux-foundation.org
Subject: + arch-x86-tools-chkobjdumpawk-fix-it.patch added to -mm tree
Date: Thu, 17 Dec 2009 15:26:36 -0800
Message-ID: <200912172326.nBHNQaQl024796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbZLQX1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 18:27:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de


The patch titled
     arch/x86/tools/chkobjdump.awk: fix it
has been added to the -mm tree.  Its filename is
     arch-x86-tools-chkobjdumpawk-fix-it.patch

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
Subject: arch/x86/tools/chkobjdump.awk: fix it
From: Andrew Morton <akpm@linux-foundation.org>

It says

Warning: objdump version  is older than 2.19
Warning: Skipping posttest.

because it used the wrong field from `objdump -v':

akpm:/usr/src/25> /opt/crosstool/gcc-4.0.2-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-objdump -v
GNU objdump 2.16.1
Copyright 2005 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License.  This program has absolutely no warranty.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/tools/chkobjdump.awk |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/tools/chkobjdump.awk~arch-x86-tools-chkobjdumpawk-fix-it arch/x86/tools/chkobjdump.awk
--- a/arch/x86/tools/chkobjdump.awk~arch-x86-tools-chkobjdumpawk-fix-it
+++ a/arch/x86/tools/chkobjdump.awk
@@ -9,7 +9,7 @@ BEGIN {
 }
 
 /^GNU/ {
-	split($4, ver, ".");
+	split($3, ver, ".");
 	if (ver[1] > od_ver ||
 	    (ver[1] == od_ver && ver[2] >= od_sver)) {
 		exit 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
readahead-add-blk_run_backing_dev.patch
kfifo-move-struct-kfifo-in-place-fix.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-tools-chkobjdumpawk-fix-it.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

