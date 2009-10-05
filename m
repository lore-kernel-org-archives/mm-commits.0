From: akpm@linux-foundation.org
Subject: [merged] drivers-input-inputc-fix-config_pm=n-warning.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:37:58 -0700
Message-ID: <200910051837.n95IbwKr015928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754465AbZJESjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/input/input.c: fix CONFIG_PM=n warning
has been removed from the -mm tree.  Its filename was
     drivers-input-inputc-fix-config_pm=n-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/input/input.c: fix CONFIG_PM=n warning
From: Andrew Morton <akpm@linux-foundation.org>

drivers/input/input.c:1277: warning: 'input_dev_reset' defined but not used

Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/input.c~drivers-input-inputc-fix-config_pm=n-warning drivers/input/input.c
--- a/drivers/input/input.c~drivers-input-inputc-fix-config_pm=n-warning
+++ a/drivers/input/input.c
@@ -1273,6 +1273,7 @@ static int input_dev_uevent(struct devic
 		}						\
 	} while (0)
 
+#ifdef CONFIG_PM
 static void input_dev_reset(struct input_dev *dev, bool activate)
 {
 	if (!dev->event)
@@ -1287,7 +1288,6 @@ static void input_dev_reset(struct input
 	}
 }
 
-#ifdef CONFIG_PM
 static int input_dev_suspend(struct device *dev)
 {
 	struct input_dev *input_dev = to_input_dev(dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
st-fix-test-of-value-range-in-st_set_options.patch
sparc32-convert-to-asm-generic-hardirqh.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
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

