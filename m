From: akpm@linux-foundation.org
Subject: [withdrawn] shrink_slab-handle-bad-shrinkers.patch removed from -mm tree
Date: Thu, 25 Jun 2009 17:19:48 -0700
Message-ID: <200906260019.n5Q0Jmgo016542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbZFZAUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 20:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jirislaby@gmail.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     shrink_slab(): handle bad shrinkers
has been removed from the -mm tree.  Its filename was
     shrink_slab-handle-bad-shrinkers.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shrink_slab(): handle bad shrinkers
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~shrink_slab-handle-bad-shrinkers mm/vmscan.c
--- a/mm/vmscan.c~shrink_slab-handle-bad-shrinkers
+++ a/mm/vmscan.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
+#include <linux/kallsyms.h>
 #include <linux/vmstat.h>
 #include <linux/file.h>
 #include <linux/writeback.h>
@@ -218,7 +219,13 @@ unsigned long shrink_slab(unsigned long 
 		unsigned long total_scan;
 		unsigned long max_pass = (*shrinker->shrink)(0, gfp_mask);
 
-		delta = (4 * scanned) / shrinker->seeks;
+		if (!shrinker->seeks) {
+			print_symbol("shrinker %s has zero seeks\n",
+				(unsigned long)shrinker->shrink);
+			delta = (4 * scanned) / DEFAULT_SEEKS;
+		} else {
+			delta = (4 * scanned) / shrinker->seeks;
+		}
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
 		shrinker->nr += delta;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

