From: akpm@linux-foundation.org
Subject: + init-do_mountsc-proper-prepare_namespace-prototype.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:24 -0800
Message-ID: <200702272058.l1RKwSSM028382@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52064 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbXB0VBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:01:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     init/do_mounts.c: proper prepare_namespace() prototype
has been added to the -mm tree.  Its filename is
     init-do_mountsc-proper-prepare_namespace-prototype.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: init/do_mounts.c: proper prepare_namespace() prototype
From: Adrian Bunk <bunk@stusta.de>

Add a proper protype for prepare_namespace() in include/linux/init.h.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    3 ++-
 init/do_mounts.c     |    1 +
 init/main.c          |    1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/init.h~init-do_mountsc-proper-prepare_namespace-prototype include/linux/init.h
--- a/include/linux/init.h~init-do_mountsc-proper-prepare_namespace-prototype
+++ a/include/linux/init.h
@@ -80,7 +80,8 @@ extern char *saved_command_line;
 extern unsigned int reset_devices;
 
 /* used by init/main.c */
-extern void setup_arch(char **);
+void setup_arch(char **);
+void prepare_namespace(void);
 
 #endif
   
diff -puN init/do_mounts.c~init-do_mountsc-proper-prepare_namespace-prototype init/do_mounts.c
--- a/init/do_mounts.c~init-do_mountsc-proper-prepare_namespace-prototype
+++ a/init/do_mounts.c
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/mount.h>
 #include <linux/device.h>
+#include <linux/init.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
diff -puN init/main.c~init-do_mountsc-proper-prepare_namespace-prototype init/main.c
--- a/init/main.c~init-do_mountsc-proper-prepare_namespace-prototype
+++ a/init/main.c
@@ -94,7 +94,6 @@ extern void pidmap_init(void);
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
 extern void free_initmem(void);
-extern void prepare_namespace(void);
 #ifdef	CONFIG_ACPI
 extern void acpi_early_init(void);
 #else
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
drivers-video-sm501fbc-make-4-functions-static.patch
fix-the-sysctl=n-compilation.patch
remove-the-jffs-maintainers-entry.patch
drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix.patch
git-cpufreq.patch
make-kernel-kmodckmod_mk-static.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
make-pvr2_encoder_prep_config-static.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
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
