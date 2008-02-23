From: akpm@linux-foundation.org
Subject: - mips-fix-sni_rm-eisa=n-compilation.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:09 -0800
Message-ID: <200802232022.m1NKM9wV013401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761447AbYBWU3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     mips: fix SNI_RM EISA=n compilation
has been removed from the -mm tree.  Its filename was
     mips-fix-sni_rm-eisa=n-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: fix SNI_RM EISA=n compilation
From: Adrian Bunk <bunk@kernel.org>

Fix the following build error with CONFIG_EISA=n caused by commit
231a35d37293ab88d325a9cb94e5474c156282c0:

  LD      .tmp_vmlinux1
arch/mips/sni/built-in.o: In function `snirm_a20r_setup_devinit':
a20r.c:(.init.text+0x42c): undefined reference to `sni_eisa_root_init'
a20r.c:(.init.text+0x42c): relocation truncated to fit: R_MIPS_26 against `sni_eisa_root_init'
arch/mips/sni/built-in.o: In function `snirm_setup_devinit':
rm200.c:(.init.text+0x52c): undefined reference to `sni_eisa_root_init'
rm200.c:(.init.text+0x52c): relocation truncated to fit: R_MIPS_26 against `sni_eisa_root_init'

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/sni.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/asm-mips/sni.h~mips-fix-sni_rm-eisa=n-compilation include/asm-mips/sni.h
--- a/include/asm-mips/sni.h~mips-fix-sni_rm-eisa=n-compilation
+++ a/include/asm-mips/sni.h
@@ -228,7 +228,14 @@ extern void sni_pcimt_irq_init(void);
 extern void sni_cpu_time_init(void);
 
 /* eisa init for RM200/400 */
+#ifdef CONFIG_EISA
 extern int sni_eisa_root_init(void);
+#else
+static inline int sni_eisa_root_init(void)
+{
+	return 0;
+}
+#endif
 
 /* common irq stuff */
 extern void (*sni_hwint)(void);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
