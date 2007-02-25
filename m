From: akpm@linux-foundation.org
Subject: + i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:09:51 -0800
Message-ID: <200702251309.l1PD9rjS029981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35917 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958AbXBYNN0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:13:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ak@muc.de


The patch titled
     i386 asm-offsets.c: workaround for a -Wmissing-prototypes warning
has been added to the -mm tree.  Its filename is
     i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 asm-offsets.c: workaround for a -Wmissing-prototypes warning
From: Adrian Bunk <bunk@stusta.de>

Work around a warning with -Wmissing-prototypes in
arch/i386/kernel/asm-offsets.c

The warning isn't gcc's fault - asm-offsets.c is simply a special file.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/asm-offsets.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/i386/kernel/asm-offsets.c~i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning arch/i386/kernel/asm-offsets.c
--- a/arch/i386/kernel/asm-offsets.c~i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning
+++ a/arch/i386/kernel/asm-offsets.c
@@ -25,6 +25,9 @@
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
+/* workaround for a warning with -Wmissing-prototypes */
+void foo(void);
+
 void foo(void)
 {
 	OFFSET(SIGCONTEXT_eax, sigcontext, eax);
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
drivers-video-sm501fbc-make-4-functions-static.patch
fix-the-sysctl=n-compilation.patch
git-cpufreq.patch
make-kernel-kmodckmod_mk-static.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
make-pvr2_encoder_prep_config-static.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
mtd_ubi_debug-must-depend-on-sysfs.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
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
make-drivers-usb-misc-iowarriorciowarrior_ids-static.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
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
