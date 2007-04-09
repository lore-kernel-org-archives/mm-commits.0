From: akpm@linux-foundation.org
Subject: - i386-enable-4k-stacks-by-default.patch removed from -mm tree
Date: Mon, 09 Apr 2007 16:33:23 -0700
Message-ID: <200704092333.l39NXOjk026408@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35844 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbXDIXd3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 19:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, gcoady@gmail.com, mm-commits@vger.kernel.org


The patch titled
     i386: enable 4k stacks by default
has been removed from the -mm tree.  Its filename was
     i386-enable-4k-stacks-by-default.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: i386: enable 4k stacks by default
From: Adrian Bunk <bunk@stusta.de>

This patch enables 4k stacks by default.

4k stacks have become a well-tested feature used fore a long time in Fedora
and even in RHEL 4.

There are no known problems in in-kernel code with 4k stacks still present
after Neil's patch that went into -mm nearly two months ago.

Defaulting to 4k stacks in -mm kernel will give some more testing coverage
and should show whether there are really no problems left.

Keeping the option for now should make the people happy who want to use the
experimental -mm kernel but don't trust the well-tested 4k stacks.

Additionally, make it more obvious that available stack space is not being
halved.

Signed-off-by: Grant Coady <gcoady@gmail.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.debug |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/i386/Kconfig.debug~i386-enable-4k-stacks-by-default arch/i386/Kconfig.debug
--- a/arch/i386/Kconfig.debug~i386-enable-4k-stacks-by-default
+++ a/arch/i386/Kconfig.debug
@@ -57,14 +57,16 @@ config DEBUG_RODATA
 	  If in doubt, say "N".
 
 config 4KSTACKS
-	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on DEBUG_KERNEL
+	bool "Use 4Kb for kernel stacks instead of 8Kb" if DEBUG_KERNEL
+	depends on n
+	default y
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates
 	  running more threads on a system and also reduces the pressure
 	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
+	  will also use separate 4Kb IRQ stacks to compensate for the
+	  reduced stackspace.
 
 config X86_FIND_SMP_CONFIG
 	bool
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
net-possible-cleanups.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
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
