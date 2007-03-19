From: akpm@linux-foundation.org
Subject: + remove-mmc_deselect_cards.patch added to -mm tree
Date: Mon, 19 Mar 2007 14:19:41 -0700
Message-ID: <200703192119.l2JLJfJt017550@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57071 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbXCSVXJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 17:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, drzeus@drzeus.cx


The patch titled
     remove mmc_deselect_cards()
has been added to the -mm tree.  Its filename is
     remove-mmc_deselect_cards.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86_p4_clockmod-must-select-cpu_freq_table.patch
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
lumpy-reclaim-v4.patch
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
