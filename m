From: akpm@linux-foundation.org
Subject: + no-longer-include-asm-kdebugh.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:55:41 -0700
Message-ID: <200703282355.l2SNtf8u023171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36088 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965818AbXC1X6z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:58:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     no longer #include <asm/kdebug.h>
has been added to the -mm tree.  Its filename is
     no-longer-include-asm-kdebugh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-spi-fix-section-mismatches.patch
drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
remove-the-warn_on-in-arch-x86_64-kernel-acpi-sleepcinit_low_mapping.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
make-mptspi_target_destroy-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
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
