From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-serial-sierrac-fix-config_pm=n-build.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:38 -0700
Message-ID: <200909241937.n8OJbc5g004964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbZIXTiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, epasheva@sierrawireless.com, greg@kroah.com, oliver@neukum.org, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/serial/sierra.c: fix CONFIG_PM=n build
has been removed from the -mm tree.  Its filename was
     drivers-usb-serial-sierrac-fix-config_pm=n-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/serial/sierra.c: fix CONFIG_PM=n build
From: Andrew Morton <akpm@linux-foundation.org>

drivers/usb/serial/sierra.c: In function 'sierra_suspend':
drivers/usb/serial/sierra.c:936: error: 'struct usb_device' has no member named 'auto_pm'

Repairs

commit e6929a9020acbeb04d9a3ad9a88234c15be808fd
Author: Oliver Neukum <oliver@neukum.org>
Date:   Fri Sep 4 23:19:53 2009 +0200

    USB: support for autosuspend in sierra while online

Cc: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Elina Pasheva <epasheva@sierrawireless.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/sierra.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/usb/serial/sierra.c~drivers-usb-serial-sierrac-fix-config_pm=n-build drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~drivers-usb-serial-sierrac-fix-config_pm=n-build
+++ a/drivers/usb/serial/sierra.c
@@ -912,6 +912,7 @@ static void sierra_release(struct usb_se
 	}
 }
 
+#ifdef CONFIG_PM
 static void stop_read_write_urbs(struct usb_serial *serial)
 {
 	int i, j;
@@ -988,6 +989,10 @@ static int sierra_resume(struct usb_seri
 
 	return ec ? -EIO : 0;
 }
+#else
+#define sierra_suspend NULL
+#define sierra_resume NULL
+#endif
 
 static struct usb_serial_driver sierra_device = {
 	.driver = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
procfs-disable-per-task-stack-usage-on-nommu.patch
hugetlb_file_setup-use-c-not-cpp.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
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

