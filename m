From: akpm@linux-foundation.org
Subject: - net-irda-proper-prototypes.patch removed from -mm tree
Date: Mon, 05 Feb 2007 18:13:44 -0800
Message-ID: <200702060213.l162DiYu007620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965460AbXBFCRD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 21:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     net/irda/: proper prototypes
has been removed from the -mm tree.  Its filename was
     net-irda-proper-prototypes.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: net/irda/: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

Add proper prototypes for some functions in include/net/irda/irda.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/irda/irda.h |   15 +++++++++++++++
 net/irda/irmod.c        |   13 -------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff -puN include/net/irda/irda.h~net-irda-proper-prototypes include/net/irda/irda.h
--- a/include/net/irda/irda.h~net-irda-proper-prototypes
+++ a/include/net/irda/irda.h
@@ -113,4 +113,19 @@ do { if(!(expr)) { \
 #define IAS_IRCOMM_ID 0x2343
 #define IAS_IRLPT_ID  0x9876
 
+struct net_device;
+struct packet_type;
+
+void irda_proc_register(void);
+void irda_proc_unregister(void);
+
+int irda_sysctl_register(void);
+void irda_sysctl_unregister(void);
+
+int irsock_init(void);
+void irsock_cleanup(void);
+
+int irlap_driver_rcv(struct sk_buff *skb, struct net_device *dev,
+		     struct packet_type *ptype, struct net_device *orig_dev);
+
 #endif /* NET_IRDA_H */
diff -puN net/irda/irmod.c~net-irda-proper-prototypes net/irda/irmod.c
--- a/net/irda/irmod.c~net-irda-proper-prototypes
+++ a/net/irda/irmod.c
@@ -42,19 +42,6 @@
 #include <net/irda/irttp.h>		/* irttp_init */
 #include <net/irda/irda_device.h>	/* irda_device_init */
 
-/* irproc.c */
-extern void irda_proc_register(void);
-extern void irda_proc_unregister(void);
-/* irsysctl.c */
-extern int  irda_sysctl_register(void);
-extern void irda_sysctl_unregister(void);
-/* af_irda.c */
-extern int  irsock_init(void);
-extern void irsock_cleanup(void);
-/* irlap_frame.c */
-extern int  irlap_driver_rcv(struct sk_buff *, struct net_device *, 
-			     struct packet_type *, struct net_device *);
-
 /*
  * Module parameters
  */
_

Patches currently in -mm which might be from bunk@stusta.de are

v9fs_vfs_mkdir-fix-a-double-free.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
cx88-videoc-remove-struct-radionorms.patch
if-0-v4l_printk_ioctl_arg.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
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
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
cleanup-x86_64-mm-vmi-timer.patch
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
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
