From: akpm@osdl.org
Subject: + x86_64-re-add-a-newline-to-restore_context.patch added to -mm tree
Date: Mon, 08 Jan 2007 20:38:14 -0800
Message-ID: <200701090438.l094cEvB028535@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40395 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXAIEle (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 23:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ak@muc.de


The patch titled
     x86_64: re-add a newline to RESTORE_CONTEXT
has been added to the -mm tree.  Its filename is
     x86_64-re-add-a-newline-to-restore_context.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: re-add a newline to RESTORE_CONTEXT
From: Adrian Bunk <bunk@stusta.de>

RESTORE_CONTEXT lost a newline in
commit 658fdbef66e5e9be79b457edc2cbbb3add840aa9:
http://www.mail-archive.com/kgdb-bugreport@lists.sourceforge.net/msg00559.html

Reported by Steven M. Christey.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-x86_64/system.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86_64/system.h~x86_64-re-add-a-newline-to-restore_context include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~x86_64-re-add-a-newline-to-restore_context
+++ a/include/asm-x86_64/system.h
@@ -15,7 +15,7 @@
 
 /* frame pointer must be last for get_wchan */
 #define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\n\t"
 
 #define __EXTRA_CLOBBER  \
 	,"rcx","rbx","rdx","r8","r9","r10","r11","r12","r13","r14","r15"
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-alsa.patch
git-dvb.patch
make-usbvision_rvfree-static.patch
git-gfs2-nmw.patch
git-ieee1394.patch
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
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
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
