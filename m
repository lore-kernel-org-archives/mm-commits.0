From: akpm@linux-foundation.org
Subject: - no-longer-include-asm-kdebugh.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:51 -0700
Message-ID: <200705090255.l492tpc7009974@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032370AbXEIC4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     no longer #include <asm/kdebug.h>
has been removed from the -mm tree.  Its filename was
     no-longer-include-asm-kdebugh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: no longer #include <asm/kdebug.h>
From: Adrian Bunk <bunk@stusta.de>

Include the new linux/kdebug.h instead of asm/kdebug.h.

Simply remove the asm/kdebug.h include if both had been included.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/dis.c            |    2 +-
 drivers/char/ipmi/ipmi_watchdog.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/s390/kernel/dis.c~no-longer-include-asm-kdebugh arch/s390/kernel/dis.c
--- a/arch/s390/kernel/dis.c~no-longer-include-asm-kdebugh
+++ a/arch/s390/kernel/dis.c
@@ -23,6 +23,7 @@
 #include <linux/kallsyms.h>
 #include <linux/reboot.h>
 #include <linux/kprobes.h>
+#include <linux/kdebug.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -33,7 +34,6 @@
 #include <asm/s390_ext.h>
 #include <asm/lowcore.h>
 #include <asm/debug.h>
-#include <asm/kdebug.h>
 
 #ifndef CONFIG_64BIT
 #define ONELONG "%08lx: "
diff -puN drivers/char/ipmi/ipmi_watchdog.c~no-longer-include-asm-kdebugh drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~no-longer-include-asm-kdebugh
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -61,7 +61,6 @@
    how it will work.  So in the unlikely event that another
    architecture supports this, we can figure out a good generic
    mechanism for it at that time. */
-#include <asm/kdebug.h>
 #define HAVE_DIE_NMI_POST
 #endif
 
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
