From: akpm@osdl.org
Subject: + fix-gfs2-circular-dependency.patch added to -mm tree
Date: Sun, 28 Jan 2007 15:44:24 -0800
Message-ID: <200701282344.l0SNiOF9006200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005AbXA1Xro (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:47:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, swhiteho@redhat.com


The patch titled
     fix GFS2 circular dependency
has been added to the -mm tree.  Its filename is
     fix-gfs2-circular-dependency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix GFS2 circular dependency
From: Adrian Bunk <bunk@stusta.de>

This patch fixes a circular dependency by letting GFS2_FS_LOCKING_DLM
and DLM depend on instead of select SYSFS.

Since SYSFS depends on EMBEDDED this change shouldn't cause any problems
for users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/dlm/Kconfig  |    3 +--
 fs/gfs2/Kconfig |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/dlm/Kconfig~fix-gfs2-circular-dependency fs/dlm/Kconfig
--- a/fs/dlm/Kconfig~fix-gfs2-circular-dependency
+++ a/fs/dlm/Kconfig
@@ -3,9 +3,8 @@ menu "Distributed Lock Manager"
 
 config DLM
 	tristate "Distributed Lock Manager (DLM)"
-	depends on IPV6 || IPV6=n
+	depends on SYSFS && (IPV6 || IPV6=n)
 	select CONFIGFS_FS
-	select SYSFS
 	select IP_SCTP if DLM_SCTP
 	help
 	A general purpose distributed lock manager for kernel or userspace
diff -puN fs/gfs2/Kconfig~fix-gfs2-circular-dependency fs/gfs2/Kconfig
--- a/fs/gfs2/Kconfig~fix-gfs2-circular-dependency
+++ a/fs/gfs2/Kconfig
@@ -34,11 +34,10 @@ config GFS2_FS_LOCKING_NOLOCK
 
 config GFS2_FS_LOCKING_DLM
 	tristate "GFS2 DLM locking module"
-	depends on GFS2_FS && NET && INET && (IPV6 || IPV6=n)
+	depends on GFS2_FS && SYSFS && NET && INET && (IPV6 || IPV6=n)
 	select IP_SCTP if DLM_SCTP
 	select CONFIGFS_FS
 	select DLM
-	select SYSFS
 	help
 	Multiple node locking module for GFS2
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
git-gfs2-nmw.patch
fix-gfs2-circular-dependency.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
git-libata-all.patch
fix-config_sata_sis=y-compile-error.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
remove-one-remaining-define-bcm_tso-1.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
nf_conntrack_h323-must-depend-on-ipv6-ipv6=n.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
usb_rtl8150-must-select-mii.patch
x86_64-re-add-a-newline-to-restore_context.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
