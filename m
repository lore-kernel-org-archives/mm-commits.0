From: akpm@linux-foundation.org
Subject: - saa7134-fix-modules=n-compilation.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:16 -0800
Message-ID: <200703152157.l2FLvGbo027623@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42671 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbXCOWAg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:00:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     saa7134: fix MODULES=n compilation
has been removed from the -mm tree.  Its filename was
     saa7134-fix-modules=n-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: saa7134: fix MODULES=n compilation
From: Adrian Bunk <bunk@stusta.de>

This patch fixes the following compile error with CONFIG_MODULES=n:

  CC      drivers/media/video/saa7134/saa7134-core.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c:979:24: error: macro "request_submodules" passed 1 arguments, but takes just 0
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c: In function 'saa7134_initdev':
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c:979: error: 'request_submodules' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c:979: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c:979: error: for each function it appears in.)
make[5]: *** [drivers/media/video/saa7134/saa7134-core.o] Error 1

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/saa7134/saa7134-core.c~saa7134-fix-modules=n-compilation drivers/media/video/saa7134/saa7134-core.c
--- a/drivers/media/video/saa7134/saa7134-core.c~saa7134-fix-modules=n-compilation
+++ a/drivers/media/video/saa7134/saa7134-core.c
@@ -203,7 +203,7 @@ static void request_submodules(struct sa
 }
 
 #else
-#define request_submodules()
+#define request_submodules(dev)
 #endif /* CONFIG_MODULES */
 
 /* ------------------------------------------------------------------ */
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
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
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
x86_p4_clockmod-must-select-cpu_freq_table.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
