From: akpm@linux-foundation.org
Subject: + git-dvb-fixup.patch added to -mm tree
Date: Thu, 01 Mar 2007 20:42:35 -0800
Message-ID: <200703020442.l224gZ3L032654@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41584 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422882AbXCBEmh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:42:37 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l224gZAb004083
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 1 Mar 2007 20:42:35 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-dvb-fixup
has been added to the -mm tree.  Its filename is
     git-dvb-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-dvb-fixup
From: Andrew Morton <akpm@linux-foundation.org>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/v4l2-common.c |   45 ----------------------------
 include/linux/videodev2.h         |   14 --------
 2 files changed, 59 deletions(-)

diff -puN drivers/media/video/v4l2-common.c~git-dvb-fixup drivers/media/video/v4l2-common.c
--- a/drivers/media/video/v4l2-common.c~git-dvb-fixup
+++ a/drivers/media/video/v4l2-common.c
@@ -374,19 +374,6 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_LOG_STATUS)]       = "VIDIOC_LOG_STATUS",
 	[_IOC_NR(VIDIOC_G_EXT_CTRLS)]      = "VIDIOC_G_EXT_CTRLS",
 	[_IOC_NR(VIDIOC_S_EXT_CTRLS)]      = "VIDIOC_S_EXT_CTRLS",
-<<<<<<< HEAD/drivers/media/video/v4l2-common.c
-	[_IOC_NR(VIDIOC_TRY_EXT_CTRLS)]    = "VIDIOC_TRY_EXT_CTRLS",
-#if 1
-	[_IOC_NR(VIDIOC_ENUM_FRAMESIZES)]  = "VIDIOC_ENUM_FRAMESIZES",
-	[_IOC_NR(VIDIOC_ENUM_FRAMEINTERVALS)] = "VIDIOC_ENUM_FRAMEINTERVALS",
-	[_IOC_NR(VIDIOC_G_ENC_INDEX)] 	   = "VIDIOC_G_ENC_INDEX",
-	[_IOC_NR(VIDIOC_ENCODER_CMD)] 	   = "VIDIOC_ENCODER_CMD",
-	[_IOC_NR(VIDIOC_TRY_ENCODER_CMD)]  = "VIDIOC_TRY_ENCODER_CMD",
-
-	[_IOC_NR(VIDIOC_DBG_S_REGISTER)]   = "VIDIOC_DBG_S_REGISTER",
-	[_IOC_NR(VIDIOC_DBG_G_REGISTER)]   = "VIDIOC_DBG_G_REGISTER",
-#endif
-=======
 	[_IOC_NR(VIDIOC_TRY_EXT_CTRLS)]    = "VIDIOC_TRY_EXT_CTRLS",
 #if 1
 	[_IOC_NR(VIDIOC_ENUM_FRAMESIZES)]  = "VIDIOC_ENUM_FRAMESIZES",
@@ -400,7 +387,6 @@ static const char *v4l2_ioctls[] = {
 
 	[_IOC_NR(VIDIOC_G_CHIP_IDENT)]     = "VIDIOC_G_CHIP_IDENT",
 #endif
->>>>>>> /drivers/media/video/v4l2-common.c
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -985,30 +971,6 @@ u32 v4l2_ctrl_next(const u32 * const * c
 	return **ctrl_classes;
 }
 
-<<<<<<< HEAD/drivers/media/video/v4l2-common.c
-int v4l2_chip_match_i2c_client(struct i2c_client *c, u32 match_type, u32 match_chip)
-{
-	switch (match_type) {
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		return (c != NULL && c->driver != NULL && c->driver->id == match_chip);
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		return (c != NULL && c->addr == match_chip);
-	default:
-		return 0;
-	}
-}
-
-int v4l2_chip_match_host(u32 match_type, u32 match_chip)
-{
-	switch (match_type) {
-	case V4L2_CHIP_MATCH_HOST:
-		return match_chip == 0;
-	default:
-		return 0;
-	}
-}
-
-=======
 int v4l2_chip_match_i2c_client(struct i2c_client *c, u32 match_type, u32 match_chip)
 {
 	switch (match_type) {
@@ -1047,7 +1009,6 @@ int v4l2_chip_match_host(u32 match_type,
 	}
 }
 
->>>>>>> /drivers/media/video/v4l2-common.c
 /* ----------------------------------------------------------------- */
 
 EXPORT_SYMBOL(v4l2_norm_to_name);
@@ -1071,16 +1032,10 @@ EXPORT_SYMBOL(v4l2_ctrl_query_menu);
 EXPORT_SYMBOL(v4l2_ctrl_query_fill);
 EXPORT_SYMBOL(v4l2_ctrl_query_fill_std);
 
-<<<<<<< HEAD/drivers/media/video/v4l2-common.c
-EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
-EXPORT_SYMBOL(v4l2_chip_match_host);
-
-=======
 EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
 EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
 EXPORT_SYMBOL(v4l2_chip_match_host);
 
->>>>>>> /drivers/media/video/v4l2-common.c
 /*
  * Local variables:
  * c-basic-offset: 8
diff -puN include/linux/videodev2.h~git-dvb-fixup include/linux/videodev2.h
--- a/include/linux/videodev2.h~git-dvb-fixup
+++ a/include/linux/videodev2.h
@@ -1395,9 +1395,6 @@ struct v4l2_register {
 	__u32 match_type; /* Match type */
 	__u32 match_chip; /* Match this chip, meaning determined by match_type */
 	__u64 reg;
-<<<<<<< HEAD/include/linux/videodev2.h
-	__u64 val;
-=======
 	__u64 val;
 };
 
@@ -1407,7 +1404,6 @@ struct v4l2_chip_ident {
 	__u32 match_chip;  /* Match this chip, meaning determined by match_type */
 	__u32 ident;       /* chip identifier as specified in <media/v4l2-chip-ident.h> */
 	__u32 revision;    /* chip revision, chip specific */
->>>>>>> /include/linux/videodev2.h
 };
 
 /*
@@ -1476,15 +1472,6 @@ struct v4l2_chip_ident {
 #if 1
 #define VIDIOC_ENUM_FRAMESIZES	_IOWR ('V', 74, struct v4l2_frmsizeenum)
 #define VIDIOC_ENUM_FRAMEINTERVALS	_IOWR ('V', 75, struct v4l2_frmivalenum)
-<<<<<<< HEAD/include/linux/videodev2.h
-#define VIDIOC_G_ENC_INDEX      _IOR  ('V', 76, struct v4l2_enc_idx)
-#define VIDIOC_ENCODER_CMD      _IOWR ('V', 77, struct v4l2_encoder_cmd)
-#define VIDIOC_TRY_ENCODER_CMD  _IOWR ('V', 78, struct v4l2_encoder_cmd)
-
-/* Experimental, only implemented if CONFIG_VIDEO_ADV_DEBUG is defined */
-#define	VIDIOC_DBG_S_REGISTER 	_IOW  ('V', 79, struct v4l2_register)
-#define	VIDIOC_DBG_G_REGISTER 	_IOWR ('V', 80, struct v4l2_register)
-=======
 #define VIDIOC_G_ENC_INDEX      _IOR  ('V', 76, struct v4l2_enc_idx)
 #define VIDIOC_ENCODER_CMD      _IOWR ('V', 77, struct v4l2_encoder_cmd)
 #define VIDIOC_TRY_ENCODER_CMD  _IOWR ('V', 78, struct v4l2_encoder_cmd)
@@ -1494,7 +1481,6 @@ struct v4l2_chip_ident {
 #define	VIDIOC_DBG_G_REGISTER 	_IOWR ('V', 80, struct v4l2_register)
 
 #define VIDIOC_G_CHIP_IDENT     _IOWR ('V', 81, struct v4l2_chip_ident)
->>>>>>> /include/linux/videodev2.h
 #endif
 
 #ifdef __OLD_VIDIOC_
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-hid-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
log-reason-why-tsc-was-marked-unstable-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
