From: akpm@linux-foundation.org
Subject: - drivers-isdn-pcbit-proper-prototypes.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:03 -0800
Message-ID: <200702122246.l1CMk3de013761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45623 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030386AbXBLWtU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/pcbit/: proper prototypes
has been removed from the -mm tree.  Its filename was
     drivers-isdn-pcbit-proper-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/isdn/pcbit/: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

Add correct prototypes in header files for global functions and variables.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
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
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
