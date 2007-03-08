From: akpm@linux-foundation.org
Subject: + make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch added to -mm tree
Date: Thu, 08 Mar 2007 00:42:41 -0800
Message-ID: <200703080842.l288gf0R023357@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58367 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030303AbXCHIp6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 03:45:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, zach@vmware.com


The patch titled
     make arch/i386/kernel/vmi.c:vmi_pmd_clear() static
has been added to the -mm tree.  Its filename is
     make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make arch/i386/kernel/vmi.c:vmi_pmd_clear() static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the needlessly global vmi_pmd_clear() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/vmi.c~make-arch-i386-kernel-vmicvmi_pmd_clear-static arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~make-arch-i386-kernel-vmicvmi_pmd_clear-static
+++ a/arch/i386/kernel/vmi.c
@@ -517,7 +517,7 @@ static void vmi_pte_clear(struct mm_stru
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
-void vmi_pmd_clear(pmd_t *pmd)
+static void vmi_pmd_clear(pmd_t *pmd)
 {
 	const pte_t pte = { 0 };
 	vmi_check_page_type(__pa(pmd) >> PAGE_SHIFT, VMI_PAGE_PMD);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
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
