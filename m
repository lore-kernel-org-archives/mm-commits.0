From: akpm@osdl.org
Subject: + cleanup-linux-byteorder-swabbh.patch added to -mm tree
Date: Thu, 11 Jan 2007 13:17:42 -0800
Message-ID: <200701112117.l0BLHg5T003285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbXAKVU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 16:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     cleanup linux/byteorder/swabb.h
has been added to the -mm tree.  Its filename is
     cleanup-linux-byteorder-swabbh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup linux/byteorder/swabb.h
From: Adrian Bunk <bunk@stusta.de>

- no longer a userspace header
- add #include <linux/types.h> for in-kernel compilation

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/byteorder/Kbuild  |    1 -
 include/linux/byteorder/swabb.h |   13 ++++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff -puN include/linux/byteorder/Kbuild~cleanup-linux-byteorder-swabbh include/linux/byteorder/Kbuild
--- a/include/linux/byteorder/Kbuild~cleanup-linux-byteorder-swabbh
+++ a/include/linux/byteorder/Kbuild
@@ -2,5 +2,4 @@ header-y += big_endian.h
 header-y += little_endian.h
 
 unifdef-y += generic.h
-unifdef-y += swabb.h
 unifdef-y += swab.h
diff -puN include/linux/byteorder/swabb.h~cleanup-linux-byteorder-swabbh include/linux/byteorder/swabb.h
--- a/include/linux/byteorder/swabb.h~cleanup-linux-byteorder-swabbh
+++ a/include/linux/byteorder/swabb.h
@@ -25,6 +25,8 @@
  *
  */
 
+#include <linux/types.h>
+
 #define ___swahw32(x) \
 ({ \
 	__u32 __x = (x); \
@@ -77,19 +79,14 @@
 /*
  * Allow constant folding
  */
-#if defined(__GNUC__) && defined(__OPTIMIZE__)
-#  define __swahw32(x) \
+#define __swahw32(x) \
 (__builtin_constant_p((__u32)(x)) ? \
  ___swahw32((x)) : \
  __fswahw32((x)))
-#  define __swahb32(x) \
+#define __swahb32(x) \
 (__builtin_constant_p((__u32)(x)) ? \
  ___swahb32((x)) : \
  __fswahb32((x)))
-#else
-#  define __swahw32(x) __fswahw32(x)
-#  define __swahb32(x) __fswahb32(x)
-#endif /* OPTIMIZE */
 
 
 static inline __u32 __fswahw32(__u32 x)
@@ -128,13 +125,11 @@ static inline void __swahb32s(__u32 *add
  */
 #endif /* __BYTEORDER_HAS_U64__ */
 
-#if defined(__KERNEL__)
 #define swahw32 __swahw32
 #define swahb32 __swahb32
 #define swahw32p __swahw32p
 #define swahb32p __swahb32p
 #define swahw32s __swahw32s
 #define swahb32s __swahb32s
-#endif
 
 #endif /* _LINUX_BYTEORDER_SWABB_H */
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-libata-all.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
make-isa_bridge-alpha-only.patch
git-scsi-rc-fixes.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
x86_64-re-add-a-newline-to-restore_context.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
make-hdlc_setup-static-again.patch
voyager-remove-smp_tune_scheduling-fixme.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
net-wanrouter-wanmainc-cleanups.patch
more-ftape-removal.patch
cleanup-linux-byteorder-swabbh.patch
mips-remove-smp_tune_scheduling.patch
