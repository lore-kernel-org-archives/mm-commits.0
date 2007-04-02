From: akpm@linux-foundation.org
Subject: - drivers-scsi-aacraid-cleanups.patch removed from -mm tree
Date: Sun, 01 Apr 2007 23:14:45 -0700
Message-ID: <200704020614.l326Ejqg025946@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39959 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933900AbXDBGUA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 02:20:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, James.Bottomley@steeleye.com, mark_salyzyn@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/aacraid/: cleanups
has been removed from the -mm tree.  Its filename was
     drivers-scsi-aacraid-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/aacraid/: cleanups
From: Adrian Bunk <bunk@stusta.de>

- proper prototypes for global code in aacraid.h
- aac_rx_start_adapter() can now become static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aacraid.h |    3 +++
 drivers/scsi/aacraid/linit.c   |    2 --
 drivers/scsi/aacraid/nark.c    |    3 ---
 drivers/scsi/aacraid/rkt.c     |    3 ---
 drivers/scsi/aacraid/rx.c      |    2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/aacraid/aacraid.h~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -1843,8 +1843,11 @@ struct aac_driver_ident* aac_get_driver_
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
 int aac_probe_container(struct aac_dev *dev, int cid);
+int _aac_rx_init(struct aac_dev *dev);
+int aac_rx_select_comm(struct aac_dev *dev, int comm);
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
 extern int startup_timeout;
 extern int aif_timeout;
+extern int expose_physicals;
diff -puN drivers/scsi/aacraid/linit.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/linit.c
@@ -82,8 +82,6 @@ static LIST_HEAD(aac_devices);
 static int aac_cfg_major = -1;
 char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
 
-extern int expose_physicals;
-
 /*
  * Because of the way Linux names scsi devices, the order in this table has
  * become important.  Check for on-board Raid first, add-in cards second.
diff -puN drivers/scsi/aacraid/nark.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/nark.c
--- a/drivers/scsi/aacraid/nark.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/nark.c
@@ -74,9 +74,6 @@ static int aac_nark_ioremap(struct aac_d
 
 int aac_nark_init(struct aac_dev * dev)
 {
-	extern int _aac_rx_init(struct aac_dev *dev);
-	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
diff -puN drivers/scsi/aacraid/rkt.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/rkt.c
--- a/drivers/scsi/aacraid/rkt.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/rkt.c
@@ -45,7 +45,6 @@
 static int aac_rkt_select_comm(struct aac_dev *dev, int comm)
 {
 	int retval;
-	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
 	retval = aac_rx_select_comm(dev, comm);
 	if (comm == AAC_COMM_MESSAGE) {
 		/*
@@ -97,8 +96,6 @@ static int aac_rkt_ioremap(struct aac_de
 
 int aac_rkt_init(struct aac_dev *dev)
 {
-	extern int _aac_rx_init(struct aac_dev *dev);
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
diff -puN drivers/scsi/aacraid/rx.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/rx.c
@@ -294,7 +294,7 @@ static void aac_rx_notify_adapter(struct
  *	Start up processing on an i960 based AAC adapter
  */
 
-void aac_rx_start_adapter(struct aac_dev *dev)
+static void aac_rx_start_adapter(struct aac_dev *dev)
 {
 	struct aac_init *init;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
fix-microcode-related-suspend-problem.patch
net-sunrpc-svcsockc-fix-a-check.patch
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
make-drivers-net-qla3xxxcphy_devices-static.patch
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
