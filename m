From: akpm@linux-foundation.org
Subject: [folded] checkpatch-fix-false-export_symbol-warning-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 26 Oct 2009 16:47:24 -0700
Message-ID: <200910262347.n9QNlOum013265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbZJZXsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Oct 2009 19:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, apw@canonical.com, dwalker@fifo99.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch-fix-false-export_symbol-warning-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-false-export_symbol-warning-checkpatch-fixes.patch

This patch was dropped because it was folded into checkpatch-fix-false-export_symbol-warning.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch-fix-false-export_symbol-warning-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#63: FILE: scripts/checkpatch.pl:1445:
+			     substr($lines[$realline_next - 1], $off_next) =~ /^\s*$/)) {

WARNING: line over 80 characters
#84: FILE: scripts/checkpatch.pl:1716:
+		     $lines[$realline_next - 1] =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {

WARNING: line over 80 characters
#95: FILE: scripts/checkpatch.pl:1723:
+				^.(?:$Storage\s+)?$Type\s*\(\s*\*\s*\Q$name\E\s*\)\s*\(|

ERROR: code indent should use tabs where possible
#107: FILE: scripts/checkpatch.pl:1734:
+                    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||$

WARNING: line over 80 characters
#114: FILE: scripts/checkpatch.pl:1741:
+			WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);

total: 1 errors, 4 warnings, 85 lines checked

./patches/checkpatch-fix-false-export_symbol-warning.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN scripts/checkpatch.pl~checkpatch-fix-false-export_symbol-warning-checkpatch-fixes scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-false-export_symbol-warning-checkpatch-fixes
+++ a/scripts/checkpatch.pl
@@ -1731,7 +1731,7 @@ sub process {
 		}
 		if (!defined $suppress_export{$linenr} &&
 		    $prevline =~ /^.\s*$/ &&
-                    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
+		    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
 		     $line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
 #print "FOO B <$lines[$linenr - 1]>\n";
 			$suppress_export{$linenr} = 2;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
8250_pci-add-ibm-saturn-serial-card.patch
checkpatch-fix-false-export_symbol-warning.patch
checkpatch-fix-false-export_symbol-warning-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

