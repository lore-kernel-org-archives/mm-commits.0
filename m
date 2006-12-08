From: akpm@osdl.org
Subject: - struct-path-convert-ppc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:40 -0800
Message-ID: <200612082004.kB8K4e4j002211@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57377 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426299AbWLHUEq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert ppc
has been removed from the -mm tree.  Its filename was
     struct-path-convert-ppc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert ppc
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ppc/8xx_io/cs4218_tdm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/ppc/8xx_io/cs4218_tdm.c~struct-path-convert-ppc arch/ppc/8xx_io/cs4218_tdm.c
--- a/arch/ppc/8xx_io/cs4218_tdm.c~struct-path-convert-ppc
+++ a/arch/ppc/8xx_io/cs4218_tdm.c
@@ -2165,7 +2165,7 @@ static int sq_release(struct inode *inod
 	int rc = 0;
 
 	if (sq.busy)
-		rc = sq_fsync(file, file->f_dentry);
+		rc = sq_fsync(file, file->f_path.dentry);
 	sound.soft = sound.dsp;
 	sound.hard = sound.dsp;
 	sound_silence();
@@ -2218,25 +2218,25 @@ static int sq_ioctl(struct inode *inode,
 		return 0;
 	case SNDCTL_DSP_POST:
 	case SNDCTL_DSP_SYNC:
-		return sq_fsync(file, file->f_dentry);
+		return sq_fsync(file, file->f_path.dentry);
 
 		/* ++TeSche: before changing any of these it's
 		 * probably wise to wait until sound playing has
 		 * settled down. */
 	case SNDCTL_DSP_SPEED:
-		sq_fsync(file, file->f_dentry);
+		sq_fsync(file, file->f_path.dentry);
 		IOCTL_IN(arg, data);
 		return IOCTL_OUT(arg, sound_set_speed(data));
 	case SNDCTL_DSP_STEREO:
-		sq_fsync(file, file->f_dentry);
+		sq_fsync(file, file->f_path.dentry);
 		IOCTL_IN(arg, data);
 		return IOCTL_OUT(arg, sound_set_stereo(data));
 	case SOUND_PCM_WRITE_CHANNELS:
-		sq_fsync(file, file->f_dentry);
+		sq_fsync(file, file->f_path.dentry);
 		IOCTL_IN(arg, data);
 		return IOCTL_OUT(arg, sound_set_stereo(data-1)+1);
 	case SNDCTL_DSP_SETFMT:
-		sq_fsync(file, file->f_dentry);
+		sq_fsync(file, file->f_path.dentry);
 		IOCTL_IN(arg, data);
 		return IOCTL_OUT(arg, sound_set_format(data));
 	case SNDCTL_DSP_GETFMTS:
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

