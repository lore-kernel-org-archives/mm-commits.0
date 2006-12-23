From: akpm@osdl.org
Subject: - fs-sysv-proper-prototypes-for-2-functions.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:42 -0800
Message-ID: <200612230753.kBN7rgTw010151@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49950 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbWLWH5E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:57:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     fs/sysv/: proper prototypes for 2 functions
has been removed from the -mm tree.  Its filename was
     fs-sysv-proper-prototypes-for-2-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/sysv/: proper prototypes for 2 functions
From: Adrian Bunk <bunk@stusta.de>

Add proper prototypes for sysv_{init,destroy}_icache() in sysv.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/sysv/super.c |    3 ---
 fs/sysv/sysv.h  |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/sysv/super.c~fs-sysv-proper-prototypes-for-2-functions fs/sysv/super.c
--- a/fs/sysv/super.c~fs-sysv-proper-prototypes-for-2-functions
+++ a/fs/sysv/super.c
@@ -528,9 +528,6 @@ static struct file_system_type v7_fs_typ
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-extern int sysv_init_icache(void) __init;
-extern void sysv_destroy_icache(void);
-
 static int __init init_sysv_fs(void)
 {
 	int error;
diff -puN fs/sysv/sysv.h~fs-sysv-proper-prototypes-for-2-functions fs/sysv/sysv.h
--- a/fs/sysv/sysv.h~fs-sysv-proper-prototypes-for-2-functions
+++ a/fs/sysv/sysv.h
@@ -143,6 +143,9 @@ extern int sysv_sync_inode(struct inode 
 extern int sysv_sync_file(struct file *, struct dentry *, int);
 extern void sysv_set_inode(struct inode *, dev_t);
 extern int sysv_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int sysv_init_icache(void);
+extern void sysv_destroy_icache(void);
+
 
 /* dir.c */
 extern struct sysv_dir_entry *sysv_find_entry(struct dentry *, struct page **);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

