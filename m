From: akpm@linux-foundation.org
Subject: + proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch added to -mm tree
Date: Mon, 07 Dec 2009 13:01:19 -0800
Message-ID: <200912072101.nB7L1KUt020859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965021AbZLGVBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 16:01:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, isdn@linux-pingi.de, tilman@imap.cc


The patch titled
     proc_fops-convert-drivers-isdn-to-seq_file-fix2
has been added to the -mm tree.  Its filename is
     proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch

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
Subject: proc_fops-convert-drivers-isdn-to-seq_file-fix2
From: Andrew Morton <akpm@linux-foundation.org>

when CONFIG_PROC_FS=n:

drivers/isdn/gigaset/capi.c:2206: error: implicit declaration of function 'PDE'
drivers/isdn/gigaset/capi.c:2206: error: invalid type argument of '->'


when CONFIG_PROC_FS=y:

drivers/isdn/hysdn/hycapi.c:469: error: implicit declaration of function 'PDE'
drivers/isdn/hysdn/hycapi.c:469: error: invalid type argument of '->'
drivers/isdn/hysdn/hycapi.c:472: error: variable 'hycapi_proc_fops' has initializer but incomplete type
drivers/isdn/hysdn/hycapi.c:473: error: unknown field 'owner' specified in initializer
drivers/isdn/hysdn/hycapi.c:473: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:473: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:474: error: unknown field 'open' specified in initializer
drivers/isdn/hysdn/hycapi.c:474: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:474: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:475: error: unknown field 'read' specified in initializer
drivers/isdn/hysdn/hycapi.c:475: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:475: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:476: error: unknown field 'llseek' specified in initializer
drivers/isdn/hysdn/hycapi.c:476: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:476: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:477: error: unknown field 'release' specified in initializer
drivers/isdn/hysdn/hycapi.c:477: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:477: warning: (near initialization for 'hycapi_proc_fops')

Needs to #include <linux/proc_fs.h>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/capi.c |    1 +
 drivers/isdn/hysdn/hycapi.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/isdn/gigaset/capi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix2 drivers/isdn/gigaset/capi.c
--- a/drivers/isdn/gigaset/capi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix2
+++ a/drivers/isdn/gigaset/capi.c
@@ -13,6 +13,7 @@
 
 #include "gigaset.h"
 #include <linux/ctype.h>
+#include <linux/proc_fs.h>
 #include <linux/isdn/capilli.h>
 #include <linux/isdn/capicmd.h>
 #include <linux/isdn/capiutil.h>
diff -puN drivers/isdn/hysdn/hycapi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix2 drivers/isdn/hysdn/hycapi.c
--- a/drivers/isdn/hysdn/hycapi.c~proc_fops-convert-drivers-isdn-to-seq_file-fix2
+++ a/drivers/isdn/hysdn/hycapi.c
@@ -14,6 +14,7 @@
 #include <linux/signal.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/proc_fs.h>
 #include <linux/netdevice.h>
 
 #define	VER_DRIVER	0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
drivers-staging-wlags49_h2-remove-cvs-metadata.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
net-rfkill-corec-work-around-gcc-402-silliness.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
lib-introduce-strim-checkpatch-fixes.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
ip2-remove-ifdef-module-from-ip2mainc-fix-2.patch
drivers-edac-amd64_edacc-fix-use-uninitialised-bug.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
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

