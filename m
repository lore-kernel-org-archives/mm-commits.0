From: akpm@linux-foundation.org
Subject: - init-do_mountsc-proper-prepare_namespace-prototype.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:03 -0700
Message-ID: <200705090245.l492j3lA008698@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969012AbXEICpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     init/do_mounts.c: proper prepare_namespace() prototype
has been removed from the -mm tree.  Its filename was
     init-do_mountsc-proper-prepare_namespace-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -77,7 +77,8 @@ extern char *saved_command_line;
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

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
