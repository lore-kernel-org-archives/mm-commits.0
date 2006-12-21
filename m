From: akpm@osdl.org
Subject: + net-irda-proper-prototypes.patch added to -mm tree
Date: Wed, 20 Dec 2006 16:51:50 -0800
Message-ID: <200612210051.kBL0poQX011629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54482 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161100AbWLUAzI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:55:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, samuel@sortiz.org


The patch titled
     net/irda/: proper prototypes
has been added to the -mm tree.  Its filename is
     net-irda-proper-prototypes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net/irda/: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

Add proper prototypes for some functions in include/net/irda/irda.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
git-acpi.patch
git-alsa.patch
usbvision-possible-cleanups.patch
drivers-media-video-cafe_ccicc-fix-null-dereference.patch
git-gfs2-nmw.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
git-net.patch
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
lumpy-reclaim-cleanup.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
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

