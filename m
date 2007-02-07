From: akpm@linux-foundation.org
Subject: - if-0-v4l_printk_ioctl_arg.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:33 -0800
Message-ID: <200702071951.l17JpXW0025166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161430AbXBGTyx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     #if 0 v4l_printk_ioctl_arg()
has been removed from the -mm tree.  Its filename was
     if-0-v4l_printk_ioctl_arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: #if 0 v4l_printk_ioctl_arg()
From: Adrian Bunk <bunk@stusta.de>

v4l_printk_ioctl_arg() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/v4l2-common.c |    7 ++++++-
 include/media/v4l2-common.h       |    3 ---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/v4l2-common.c~if-0-v4l_printk_ioctl_arg drivers/media/video/v4l2-common.c
--- a/drivers/media/video/v4l2-common.c~if-0-v4l_printk_ioctl_arg
+++ a/drivers/media/video/v4l2-common.c
@@ -272,11 +272,13 @@ char *v4l2_type_names[] = {
 	[V4L2_BUF_TYPE_SLICED_VBI_OUTPUT]  = "slicec-vbi-out",
 };
 
+#if 0
 static char *v4l2_memory_names[] = {
 	[V4L2_MEMORY_MMAP]    = "mmap",
 	[V4L2_MEMORY_USERPTR] = "userptr",
 	[V4L2_MEMORY_OVERLAY] = "overlay",
 };
+#endif  /*  0  */
 
 #define prt_names(a,arr) (((a)>=0)&&((a)<ARRAY_SIZE(arr)))?arr[a]:"unknown"
 
@@ -420,6 +422,7 @@ static const char *v4l2_int_ioctls[] = {
 };
 #define V4L2_INT_IOCTLS ARRAY_SIZE(v4l2_int_ioctls)
 
+#if 0
 static void v4l_print_pix_fmt (char *s, struct v4l2_pix_format *fmt)
 {
 	printk ("%s: width=%d, height=%d, format=%d, field=%s, "
@@ -428,6 +431,7 @@ static void v4l_print_pix_fmt (char *s, 
 		prt_names(fmt->field,v4l2_field_names),
 		fmt->bytesperline,fmt->sizeimage,fmt->colorspace);
 };
+#endif  /*  0  */
 
 /* Common ioctl debug function. This function can be used by
    external ioctl messages as well as internal V4L ioctl */
@@ -467,6 +471,7 @@ void v4l_printk_ioctl(unsigned int cmd)
 	}
 }
 
+#if 0
 /* Common ioctl debug function. This function can be used by
    external ioctl messages as well as internal V4L ioctl and its
    arguments */
@@ -1037,6 +1042,7 @@ void v4l_printk_ioctl_arg(char *s,unsign
 	}
 	}
 }
+#endif  /*  0  */
 
 /* ----------------------------------------------------------------- */
 
@@ -1545,7 +1551,6 @@ EXPORT_SYMBOL(v4l2_prio_check);
 EXPORT_SYMBOL(v4l2_field_names);
 EXPORT_SYMBOL(v4l2_type_names);
 EXPORT_SYMBOL(v4l_printk_ioctl);
-EXPORT_SYMBOL(v4l_printk_ioctl_arg);
 
 EXPORT_SYMBOL(v4l2_ctrl_next);
 EXPORT_SYMBOL(v4l2_ctrl_check);
diff -puN include/media/v4l2-common.h~if-0-v4l_printk_ioctl_arg include/media/v4l2-common.h
--- a/include/media/v4l2-common.h~if-0-v4l_printk_ioctl_arg
+++ a/include/media/v4l2-common.h
@@ -64,9 +64,6 @@
 /* Prints the ioctl in a human-readable format */
 extern void v4l_printk_ioctl(unsigned int cmd);
 
-/* Prints the ioctl and arg in a human-readable format */
-extern void v4l_printk_ioctl_arg(char *s,unsigned int cmd, void *arg);
-
 /* Use this macro for non-I2C drivers. Pass the driver name as the first arg. */
 #define v4l_print_ioctl(name, cmd)  		 \
 	do {  					 \
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
v9fs_vfs_mkdir-fix-a-double-free.patch
git-acpi.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
net-wanrouter-wanmainc-cleanups.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
cleanup-x86_64-mm-vmi-timer.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
debug-shared-irqs-kconfig-fix.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
