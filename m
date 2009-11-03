From: akpm@linux-foundation.org
Subject: + mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch added to -mm tree
Date: Mon, 02 Nov 2009 23:58:42 -0800
Message-ID: <200911030758.nA37wgej024131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421AbZKCH7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 02:59:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agust@denx.de, krzysztof.h1@poczta.fm, valentin.sitdikov@siemens.com


The patch titled
     mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix
has been added to the -mm tree.  Its filename is
     mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch

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
Subject: mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix
From: Andrew Morton <akpm@linux-foundation.org>

- clean up comments
- remove do-nothing tests
- use min()

Cc: Anatolij Gustschin <agust@denx.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Valentin Sitdikov <valentin.sitdikov@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xxfb_accel.c |   28 ++++++++++++----------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix drivers/video/mb862xx/mb862xxfb_accel.c
--- a/drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix
+++ a/drivers/video/mb862xx/mb862xxfb_accel.c
@@ -66,8 +66,10 @@ static void mb86290fb_copyarea(struct fb
 	mb862xxfb_write_fifo(6, cmd, info);
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit1(u32 *cmd, u16 step, u16 dx, u16 dy,
 				 u16 width, u16 height, u32 fgcolor,
 				 u32 bgcolor, const struct fb_image *image,
@@ -113,8 +115,10 @@ static void mb86290fb_imageblit1(u32 *cm
 	}
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 8bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 8bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit8(u32 *cmd, u16 step, u16 dx, u16 dy,
 				 u16 width, u16 height, u32 fgcolor,
 				 u32 bgcolor, const struct fb_image *image,
@@ -150,8 +154,10 @@ static void mb86290fb_imageblit8(u32 *cm
 	}
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 16bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 16bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit16(u32 *cmd, u16 step, u16 dx, u16 dy,
 				  u16 width, u16 height, u32 fgcolor,
 				  u32 bgcolor, const struct fb_image *image,
@@ -195,12 +201,10 @@ static void mb86290fb_imageblit(struct f
 	mdr = (GDC_ROP_COPY << 9);
 	x2 = image->dx + image->width;
 	y2 = image->dy + image->height;
-	dx = image->dx > 0 ? image->dx : 0;
-	dy = image->dy > 0 ? image->dy : 0;
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
-	x2 = x2 < vxres ? x2 : vxres;
-	y2 = y2 < vyres ? y2 : vyres;
+	x2 = min(x2, vxres);
+	y2 = min(y2, vyres);
 	width = x2 - dx;
 	height = y2 - dy;
 
@@ -265,8 +269,8 @@ static void mb86290fb_fillrect(struct fb
 	 * hardware clipping by writing to framebuffer directly. */
 	x2 = rect->dx + rect->width;
 	y2 = rect->dy + rect->height;
-	x2 = x2 < vxres ? x2 : vxres;
-	y2 = y2 < vyres ? y2 : vyres;
+	x2 = min(x2, vxres);
+	y2 = min(y2, vyres);
 	width = x2 - rect->dx;
 	height = y2 - rect->dy;
 	if (info->fix.visual == FB_VISUAL_TRUECOLOR ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-move-thread_size-definition-outside-ifndef-assembly.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
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
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
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

