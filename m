From: akpm@linux-foundation.org
Subject: - remove-mmc_deselect_cards.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:21:07 -0700
Message-ID: <200704112321.l3BNL7PT017548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35990 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030473AbXDKXY1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     remove mmc_deselect_cards()
has been removed from the -mm tree.  Its filename was
     remove-mmc_deselect_cards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove mmc_deselect_cards()
From: Adrian Bunk <bunk@stusta.de>

mmc_deselect_cards() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc_ops.c |    5 -----
 drivers/mmc/core/mmc_ops.h |    1 -
 2 files changed, 6 deletions(-)

diff -puN drivers/mmc/core/mmc_ops.c~remove-mmc_deselect_cards drivers/mmc/core/mmc_ops.c
--- a/drivers/mmc/core/mmc_ops.c~remove-mmc_deselect_cards
+++ a/drivers/mmc/core/mmc_ops.c
@@ -53,11 +53,6 @@ int mmc_select_card(struct mmc_card *car
 	return _mmc_select_card(card->host, card);
 }
 
-int mmc_deselect_cards(struct mmc_host *host)
-{
-	return _mmc_select_card(host, NULL);
-}
-
 int mmc_go_idle(struct mmc_host *host)
 {
 	int err;
diff -puN drivers/mmc/core/mmc_ops.h~remove-mmc_deselect_cards drivers/mmc/core/mmc_ops.h
--- a/drivers/mmc/core/mmc_ops.h~remove-mmc_deselect_cards
+++ a/drivers/mmc/core/mmc_ops.h
@@ -13,7 +13,6 @@
 #define _MMC_MMC_OPS_H
 
 int mmc_select_card(struct mmc_card *card);
-int mmc_deselect_cards(struct mmc_host *host);
 int mmc_go_idle(struct mmc_host *host);
 int mmc_send_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_all_send_cid(struct mmc_host *host, u32 *cid);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
net-possible-cleanups.patch
fs-ocfs2-make-3-functions-static.patch
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
maps2-add-proc-kpagemap-interface-fix.patch
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
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
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
mutex-subsystem-synchro-test-module.patch
