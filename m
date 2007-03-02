From: akpm@linux-foundation.org
Subject: - drivers-video-sm501fbc-make-4-functions-static.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:05:50 -0800
Message-ID: <200703020505.l2255oeR000746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422773AbXCBFJK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:09:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/sm501fb.c: make 4 functions static
has been removed from the -mm tree.  Its filename was
     drivers-video-sm501fbc-make-4-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/video/sm501fb.c: make 4 functions static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/sm501fb.c~drivers-video-sm501fbc-make-4-functions-static drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~drivers-video-sm501fbc-make-4-functions-static
+++ a/drivers/video/sm501fb.c
@@ -136,8 +136,8 @@ static inline void sm501fb_sync_regs(str
 #define SM501_MEMF_CRT			(4)
 #define SM501_MEMF_ACCEL		(8)
 
-int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
-		    unsigned int why, size_t size)
+static int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
+			   unsigned int why, size_t size)
 {
 	unsigned int ptr = 0;
 
@@ -926,7 +926,7 @@ static int sm501fb_blank_crt(int blank_m
  * set or change the hardware cursor parameters
 */
 
-int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
+static int sm501fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	struct sm501fb_par  *par = info->par;
 	struct sm501fb_info *fbi = par->info;
@@ -1225,7 +1225,7 @@ static struct sm501fb_info *sm501fb_info
  * initialise hw cursor parameters
 */
 
-int sm501_init_cursor(struct fb_info *fbi, unsigned int reg_base)
+static int sm501_init_cursor(struct fb_info *fbi, unsigned int reg_base)
 {
 	struct sm501fb_par *par = fbi->par;
 	struct sm501fb_info *info = par->info;
@@ -1768,7 +1768,7 @@ static struct platform_driver sm501fb_dr
 	},
 };
 
-int __devinit sm501fb_init(void)
+static int __devinit sm501fb_init(void)
 {
 	return platform_driver_register(&sm501fb_driver);
 }
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
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
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-cleanup.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
