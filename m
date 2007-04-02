From: akpm@linux-foundation.org
Subject: - drivers-scsi-aic7xxx-make-functions-static.patch removed from -mm tree
Date: Sun, 01 Apr 2007 23:14:41 -0700
Message-ID: <200704020614.l326Efdi025940@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933929AbXDBGR5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 02:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, hare@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/aic7xxx/: make functions static
has been removed from the -mm tree.  Its filename was
     drivers-scsi-aic7xxx-make-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/aic7xxx/: make functions static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c  |    6 ++++--
 drivers/scsi/aic7xxx/aic79xx_osm.h  |    2 --
 drivers/scsi/aic7xxx/aic7xxx.h      |    5 -----
 drivers/scsi/aic7xxx/aic7xxx_core.c |    2 +-
 4 files changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-make-functions-static drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-make-functions-static
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -363,6 +363,8 @@ static int ahd_linux_run_command(struct 
 				 struct scsi_cmnd *);
 static void ahd_linux_setup_tag_info_global(char *p);
 static int  aic79xx_setup(char *c);
+static void ahd_freeze_simq(struct ahd_softc *ahd);
+static void ahd_release_simq(struct ahd_softc *ahd);
 
 static int ahd_linux_unit;
 
@@ -2016,13 +2018,13 @@ ahd_linux_queue_cmd_complete(struct ahd_
 	cmd->scsi_done(cmd);
 }
 
-void
+static void
 ahd_freeze_simq(struct ahd_softc *ahd)
 {
 	scsi_block_requests(ahd->platform_data->host);
 }
 
-void
+static void
 ahd_release_simq(struct ahd_softc *ahd)
 {
 	scsi_unblock_requests(ahd->platform_data->host);
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-make-functions-static drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-make-functions-static
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -837,8 +837,6 @@ int	ahd_platform_alloc(struct ahd_softc 
 void	ahd_platform_free(struct ahd_softc *ahd);
 void	ahd_platform_init(struct ahd_softc *ahd);
 void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
-void	ahd_freeze_simq(struct ahd_softc *ahd);
-void	ahd_release_simq(struct ahd_softc *ahd);
 
 static __inline void
 ahd_freeze_scb(struct scb *scb)
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-make-functions-static drivers/scsi/aic7xxx/aic7xxx.h
--- a/drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-make-functions-static
+++ a/drivers/scsi/aic7xxx/aic7xxx.h
@@ -1278,11 +1278,6 @@ typedef enum {
 	AHC_QUEUE_TAGGED
 } ahc_queue_alg;
 
-void			ahc_set_tags(struct ahc_softc *ahc,
-				     struct scsi_cmnd *cmd,
-				     struct ahc_devinfo *devinfo,
-				     ahc_queue_alg alg);
-
 /**************************** Target Mode *************************************/
 #ifdef AHC_TARGET_MODE
 void		ahc_send_lstate_events(struct ahc_softc *,
diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-aic7xxx-make-functions-static drivers/scsi/aic7xxx/aic7xxx_core.c
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-aic7xxx-make-functions-static
+++ a/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2073,7 +2073,7 @@ ahc_set_width(struct ahc_softc *ahc, str
 /*
  * Update the current state of tagged queuing for a given target.
  */
-void
+static void
 ahc_set_tags(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
 	     struct ahc_devinfo *devinfo, ahc_queue_alg alg)
 {
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
