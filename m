From: akpm@linux-foundation.org
Subject: - video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs.patch removed from -mm tree
Date: Thu, 28 Feb 2008 16:59:46 -0800
Message-ID: <200802290059.m1T0xkeJ029911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761030AbYB2BA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:00:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     video: add a clamp() macro to kernel.h and replace two existing defs
has been removed from the -mm tree.  Its filename was
     video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: add a clamp() macro to kernel.h and replace two existing defs
From: Harvey Harrison <harvey.harrison@gmail.com>

Clamps a value to be within a given range with strict typechecking.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bt8xx/bttvp.h    |    2 --
 drivers/media/video/usbvideo/vicam.c |    6 ------
 include/linux/kernel.h               |   13 +++++++++++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/media/video/bt8xx/bttvp.h~video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs drivers/media/video/bt8xx/bttvp.h
--- a/drivers/media/video/bt8xx/bttvp.h~video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs
+++ a/drivers/media/video/bt8xx/bttvp.h
@@ -82,8 +82,6 @@
 /* Limits scaled width, which must be a multiple of 4. */
 #define MAX_HACTIVE (0x3FF & -4)
 
-#define clamp(x, low, high) min (max (low, x), high)
-
 #define BTTV_NORMS    (\
 		V4L2_STD_PAL    | V4L2_STD_PAL_N | \
 		V4L2_STD_PAL_Nc | V4L2_STD_SECAM | \
diff -puN drivers/media/video/usbvideo/vicam.c~video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs drivers/media/video/usbvideo/vicam.c
--- a/drivers/media/video/usbvideo/vicam.c~video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs
+++ a/drivers/media/video/usbvideo/vicam.c
@@ -70,12 +70,6 @@
 
 #define VICAM_HEADER_SIZE       64
 
-#define clamp( x, l, h )        max_t( __typeof__( x ),         \
-				       ( l ),                   \
-				       min_t( __typeof__( x ),  \
-					      ( h ),            \
-					      ( x ) ) )
-
 /* Not sure what all the bytes in these char
  * arrays do, but they're necessary to make
  * the camera work.
diff -puN include/linux/kernel.h~video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs include/linux/kernel.h
--- a/include/linux/kernel.h~video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs
+++ a/include/linux/kernel.h
@@ -352,6 +352,19 @@ static inline int __attribute__ ((format
 	_x > _y ? _x : _y; })
 
 /*
+ * Clamp a value to within a given range with strict type checking
+ */
+#define clamp(val, min, max) ({ \
+	typeof(val) __val = (val); \
+	typeof(min) __min = (min); \
+	typeof(max) __max = (max); \
+	(void) (&__val == &__min); \
+	(void) (&__val == &__max); \
+	__val = __val < __min ? __min: __val; \
+	__val > __max ? __max: __val; })
+
+
+/*
  * ..and if you can't take the strict
  * types, you can specify one yourself.
  *
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs.patch
git-x86.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-net.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
kernel-add-clamp-and-clamp_t-macros.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch

