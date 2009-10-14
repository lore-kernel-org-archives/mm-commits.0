From: akpm@linux-foundation.org
Subject: + spi-controller-driver-for-designware-spi-core-fix.patch added to -mm tree
Date: Tue, 13 Oct 2009 20:50:11 -0700
Message-ID: <200910140413.n9E4D6ex018045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbZJNENr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Oct 2009 00:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david-b@pacbell.net, feng.tang@intel.com


The patch titled
     spi-controller-driver-for-designware-spi-core-fix
has been added to the -mm tree.  Its filename is
     spi-controller-driver-for-designware-spi-core-fix.patch

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
Subject: spi-controller-driver-for-designware-spi-core-fix
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "dw_spi_resume_host" [drivers/spi/dw_spi_pci.ko] undefined!
ERROR: "dw_spi_suspend_host" [drivers/spi/dw_spi_pci.ko] undefined!
ERROR: "dw_spi_add_host" [drivers/spi/dw_spi_pci.ko] undefined!

Cc: David Brownell <david-b@pacbell.net>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/dw_spi.c |    3 +++
 linux/spi/dw_spi.h   |    0 
 2 files changed, 3 insertions(+)

diff -puN drivers/spi/Kconfig~spi-controller-driver-for-designware-spi-core-fix drivers/spi/Kconfig
diff -puN drivers/spi/Makefile~spi-controller-driver-for-designware-spi-core-fix drivers/spi/Makefile
diff -puN drivers/spi/dw_spi.c~spi-controller-driver-for-designware-spi-core-fix drivers/spi/dw_spi.c
--- a/drivers/spi/dw_spi.c~spi-controller-driver-for-designware-spi-core-fix
+++ a/drivers/spi/dw_spi.c
@@ -889,6 +889,7 @@ err_free_master:
 exit:
 	return ret;
 }
+EXPORT_SYMBOL(dw_spi_add_host);
 
 void __devexit dw_spi_remove_host(struct dw_spi *dws)
 {
@@ -924,6 +925,7 @@ int dw_spi_suspend_host(struct dw_spi *d
 	spi_set_clk(dws, 0);
 	return ret;
 }
+EXPORT_SYMBOL(dw_spi_suspend_host);
 
 int dw_spi_resume_host(struct dw_spi *dws)
 {
@@ -935,6 +937,7 @@ int dw_spi_resume_host(struct dw_spi *dw
 		dev_err(&dws->master->dev, "fail to start queue (%d)\n", ret);
 	return ret;
 }
+EXPORT_SYMBOL(dw_spi_resume_host);
 
 MODULE_AUTHOR("Feng Tang <feng.tang@intel.com>");
 MODULE_DESCRIPTION("Driver for DesignWare SPI controller core");
diff -puN include/linux/spi/dw_spi.h~spi-controller-driver-for-designware-spi-core-fix include/linux/spi/dw_spi.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
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

