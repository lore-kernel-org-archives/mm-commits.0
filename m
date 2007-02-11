From: akpm@linux-foundation.org
Subject: - cleanup-linux-byteorder-swabbh.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:05 -0800
Message-ID: <200702112254.l1BMs5vd016167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60726 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901AbXBKW5S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:57:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     cleanup linux/byteorder/swabb.h
has been removed from the -mm tree.  Its filename was
     cleanup-linux-byteorder-swabbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanup linux/byteorder/swabb.h
From: Adrian Bunk <bunk@stusta.de>

- no longer a userspace header
- add #include <linux/types.h> for in-kernel compilation

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
ifdef-acpi_future_usage-acpi_os_readable.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
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
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
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
