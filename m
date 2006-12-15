From: akpm@osdl.org
Subject: + drivers-isdn-pcbit-proper-prototypes.patch added to -mm tree
Date: Thu, 14 Dec 2006 16:53:40 -0800
Message-ID: <200612150053.kBF0rei1002040@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47320 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556AbWLOA44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 19:56:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, kkeil@suse.de


The patch titled
     drivers/isdn/pcbit/: proper prototypes
has been added to the -mm tree.  Its filename is
     drivers-isdn-pcbit-proper-prototypes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/pcbit/: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

Add correct prototypes in header files for global functions and variables.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/pcbit/drv.c    |    4 ----
 drivers/isdn/pcbit/edss1.c  |    6 ------
 drivers/isdn/pcbit/edss1.h  |    7 +++++--
 drivers/isdn/pcbit/layer2.c |   16 ----------------
 drivers/isdn/pcbit/module.c |    3 ---
 drivers/isdn/pcbit/pcbit.h  |    8 +++++++-
 6 files changed, 12 insertions(+), 32 deletions(-)

diff -puN drivers/isdn/pcbit/drv.c~drivers-isdn-pcbit-proper-prototypes drivers/isdn/pcbit/drv.c
--- a/drivers/isdn/pcbit/drv.c~drivers-isdn-pcbit-proper-prototypes
+++ a/drivers/isdn/pcbit/drv.c
@@ -774,10 +774,6 @@ static void pcbit_logstat(struct pcbit_d
 	dev->dev_if->statcallb(&ictl);
 }
 	
-extern char * isdn_state_table[];
-extern char * strisdnevent(unsigned short);
-
-
 void pcbit_state_change(struct pcbit_dev * dev, struct pcbit_chan * chan, 
 			unsigned short i, unsigned short ev, unsigned short f)
 {
diff -puN drivers/isdn/pcbit/edss1.c~drivers-isdn-pcbit-proper-prototypes drivers/isdn/pcbit/edss1.c
--- a/drivers/isdn/pcbit/edss1.c~drivers-isdn-pcbit-proper-prototypes
+++ a/drivers/isdn/pcbit/edss1.c
@@ -35,12 +35,6 @@
 #include "callbacks.h"
 
 
-extern void pcbit_state_change(struct pcbit_dev *, struct pcbit_chan *, 
-                               unsigned short i, unsigned short ev, 
-                               unsigned short f);
-
-extern struct pcbit_dev * dev_pcbit[MAX_PCBIT_CARDS];
-
 char * isdn_state_table[] = {
   "Closed",
   "Call initiated",
diff -puN drivers/isdn/pcbit/edss1.h~drivers-isdn-pcbit-proper-prototypes drivers/isdn/pcbit/edss1.h
--- a/drivers/isdn/pcbit/edss1.h~drivers-isdn-pcbit-proper-prototypes
+++ a/drivers/isdn/pcbit/edss1.h
@@ -90,9 +90,12 @@ struct fsm_timer_entry {
 	unsigned long timeout;          /* in seconds */
 };
 
+extern char * isdn_state_table[];
+
+void pcbit_fsm_event(struct pcbit_dev *, struct pcbit_chan *,
+		     unsigned short event, struct callb_data *);
+char * strisdnevent(ushort ev);
 
-extern void pcbit_fsm_event(struct pcbit_dev *, struct pcbit_chan *,
-			    unsigned short event, struct callb_data *);
 #endif
 
 
diff -puN drivers/isdn/pcbit/layer2.c~drivers-isdn-pcbit-proper-prototypes drivers/isdn/pcbit/layer2.c
--- a/drivers/isdn/pcbit/layer2.c~drivers-isdn-pcbit-proper-prototypes
+++ a/drivers/isdn/pcbit/layer2.c
@@ -47,22 +47,6 @@
 #undef DEBUG_FRAG
 
 
-
-/*
- *  task queue struct
- */
-
-
-
-/*
- *  Layer 3 packet demultiplexer
- *  drv.c
- */
-
-extern void pcbit_l3_receive(struct pcbit_dev *dev, ulong msg,
-			     struct sk_buff *skb,
-			     ushort hdr_len, ushort refnum);
-
 /*
  *  Prototypes
  */
diff -puN drivers/isdn/pcbit/module.c~drivers-isdn-pcbit-proper-prototypes drivers/isdn/pcbit/module.c
--- a/drivers/isdn/pcbit/module.c~drivers-isdn-pcbit-proper-prototypes
+++ a/drivers/isdn/pcbit/module.c
@@ -32,9 +32,6 @@ module_param_array(irq, int, NULL, 0);
 static int num_boards;
 struct pcbit_dev * dev_pcbit[MAX_PCBIT_CARDS];
 
-extern void pcbit_terminate(int board);
-extern int pcbit_init_dev(int board, int mem_base, int irq);
-
 static int __init pcbit_init(void)
 {
 	int board;
diff -puN drivers/isdn/pcbit/pcbit.h~drivers-isdn-pcbit-proper-prototypes drivers/isdn/pcbit/pcbit.h
--- a/drivers/isdn/pcbit/pcbit.h~drivers-isdn-pcbit-proper-prototypes
+++ a/drivers/isdn/pcbit/pcbit.h
@@ -166,6 +166,12 @@ struct pcbit_ioctl {
 #define L2_RUNNING  5
 #define L2_ERROR    6
 
-extern void pcbit_deliver(struct work_struct *work);
+void pcbit_deliver(struct work_struct *work);
+int pcbit_init_dev(int board, int mem_base, int irq);
+void pcbit_terminate(int board);
+void pcbit_l3_receive(struct pcbit_dev * dev, ulong msg, struct sk_buff * skb,
+		      ushort hdr_len, ushort refnum);
+void pcbit_state_change(struct pcbit_dev * dev, struct pcbit_chan * chan, 
+			unsigned short i, unsigned short ev, unsigned short f);
 
 #endif
_

Patches currently in -mm which might be from bunk@stusta.de are

make-kernel-printkcignore_loglevel_setup-static.patch
fs-sysv-proper-prototypes-for-2-functions.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
acpi-make-code-static.patch
git-alsa.patch
proper-prototype-for-drivers-base-initcdriver_init.patch
usbvision-possible-cleanups.patch
git-gfs2-nmw.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

