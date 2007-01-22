From: akpm@osdl.org
Subject: + drivers-isdn-sc-proper-prototypes.patch added to -mm tree
Date: Mon, 22 Jan 2007 14:20:30 -0800
Message-ID: <200701222220.l0MMKUYT003836@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57971 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523AbXAVWYC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 17:24:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, kkeil@suse.de


The patch titled
     drivers/isdn/sc/: proper prototypes
has been added to the -mm tree.  Its filename is
     drivers-isdn-sc-proper-prototypes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/sc/: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

Add proper prototypes in a header file for global code under
drivers/isdn/sc/.

Since the GNU C compiler is now able do tell us that caller and callee
disagreed about the number of arguments of setup_buffers(), this patch
also fixes this bug.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/sc/card.h      |   30 ++++++++++++++++++++++++++++++
 drivers/isdn/sc/command.c   |   17 ++---------------
 drivers/isdn/sc/event.c     |    3 ---
 drivers/isdn/sc/init.c      |    6 ------
 drivers/isdn/sc/interrupt.c |   10 ----------
 drivers/isdn/sc/ioctl.c     |   10 ----------
 drivers/isdn/sc/message.c   |   10 ----------
 drivers/isdn/sc/packet.c    |   10 ----------
 drivers/isdn/sc/scioc.h     |    6 ++++++
 drivers/isdn/sc/shmem.c     |    6 ------
 drivers/isdn/sc/timer.c     |    8 --------
 11 files changed, 38 insertions(+), 78 deletions(-)

diff -puN drivers/isdn/sc/card.h~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/card.h
--- a/drivers/isdn/sc/card.h~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/card.h
@@ -26,7 +26,9 @@
 #include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/isdnif.h>
+#include <linux/irqreturn.h>
 #include "message.h"
+#include "scioc.h"
 
 /*
  * Amount of time to wait for a reset to complete
@@ -98,4 +100,32 @@ typedef struct {
 	spinlock_t lock;		/* local lock */
 } board;
 
+
+extern board *sc_adapter[];
+extern int cinst;
+
+void memcpy_toshmem(int card, void *dest, const void *src, size_t n);
+void memcpy_fromshmem(int card, void *dest, const void *src, size_t n);
+int get_card_from_id(int driver);
+int indicate_status(int card, int event, ulong Channel, char *Data);
+irqreturn_t interrupt_handler(int interrupt, void *cardptr);
+int sndpkt(int devId, int channel, struct sk_buff *data);
+void rcvpkt(int card, RspMessage *rcvmsg);
+int command(isdn_ctrl *cmd);
+int reset(int card);
+int startproc(int card);
+int send_and_receive(int card, unsigned int procid, unsigned char type,
+		     unsigned char class, unsigned char code,
+		     unsigned char link, unsigned char data_len,
+		     unsigned char *data,  RspMessage *mesgdata, int timeout);
+void flushreadfifo (int card);
+int sendmessage(int card, unsigned int procid, unsigned int type,
+		unsigned int class, unsigned int code, unsigned int link,
+		unsigned int data_len, unsigned int *data);
+int receivemessage(int card, RspMessage *rspmsg);
+int sc_ioctl(int card, scs_ioctl *data);
+int setup_buffers(int card, int c);
+void check_reset(unsigned long data);
+void check_phystat(unsigned long data);
+
 #endif /* CARD_H */
diff -puN drivers/isdn/sc/command.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/command.c
--- a/drivers/isdn/sc/command.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/command.c
@@ -31,19 +31,6 @@ static int setl2(int card, unsigned long
 static int setl3(int card, unsigned long arg);
 static int acceptb(int card, unsigned long channel);
 
-extern int cinst;
-extern board *sc_adapter[];
-
-extern int sc_ioctl(int, scs_ioctl *);
-extern int setup_buffers(int, int, unsigned int);
-extern int indicate_status(int, int,ulong,char*);
-extern void check_reset(unsigned long);
-extern int send_and_receive(int, unsigned int, unsigned char, unsigned char,
-                unsigned char, unsigned char, unsigned char, unsigned char *,
-                RspMessage *, int);
-extern int sendmessage(int, unsigned int, unsigned int, unsigned int,
-                unsigned int, unsigned int, unsigned int, unsigned int *);
-
 #ifdef DEBUG
 /*
  * Translate command codes to strings
@@ -208,7 +195,7 @@ static int answer(int card, unsigned lon
 		return -ENODEV;
 	}
 
-	if(setup_buffers(card, channel+1, BUFFER_SIZE)) {
+	if(setup_buffers(card, channel+1)) {
 		hangup(card, channel+1);
 		return -ENOBUFS;
 	}
@@ -297,7 +284,7 @@ static int acceptb(int card, unsigned lo
 		return -ENODEV;
 	}
 
-	if(setup_buffers(card, channel+1, BUFFER_SIZE))
+	if(setup_buffers(card, channel+1))
 	{
 		hangup(card, channel+1);
 		return -ENOBUFS;
diff -puN drivers/isdn/sc/event.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/event.c
--- a/drivers/isdn/sc/event.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/event.c
@@ -20,9 +20,6 @@
 #include "message.h"
 #include "card.h"
 
-extern int cinst;
-extern board *sc_adapter[];
-
 #ifdef DEBUG
 static char *events[] = { "ISDN_STAT_STAVAIL",
 			  "ISDN_STAT_ICALL",
diff -puN drivers/isdn/sc/init.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/init.c
--- a/drivers/isdn/sc/init.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/init.c
@@ -35,12 +35,6 @@ module_param_array(irq, int, NULL, 0);
 module_param_array(ram, int, NULL, 0);
 module_param(do_reset, bool, 0);
 
-extern irqreturn_t interrupt_handler(int, void *);
-extern int sndpkt(int, int, int, struct sk_buff *);
-extern int command(isdn_ctrl *);
-extern int indicate_status(int, int, ulong, char*);
-extern int reset(int);
-
 static int identify_board(unsigned long, unsigned int);
 
 static int __init sc_init(void)
diff -puN drivers/isdn/sc/interrupt.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/interrupt.c
--- a/drivers/isdn/sc/interrupt.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/interrupt.c
@@ -21,16 +21,6 @@
 #include "card.h"
 #include <linux/interrupt.h>
 
-extern int indicate_status(int, int, ulong, char *);
-extern void check_phystat(unsigned long);
-extern int receivemessage(int, RspMessage *);
-extern int sendmessage(int, unsigned int, unsigned int, unsigned int,
-        unsigned int, unsigned int, unsigned int, unsigned int *);
-extern void rcvpkt(int, RspMessage *);
-
-extern int cinst;
-extern board *sc_adapter[];
-
 static int get_card_from_irq(int irq)
 {
 	int i;
diff -puN drivers/isdn/sc/ioctl.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/ioctl.c
--- a/drivers/isdn/sc/ioctl.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/ioctl.c
@@ -12,16 +12,6 @@
 #include "card.h"
 #include "scioc.h"
 
-extern int indicate_status(int, int, unsigned long, char *);
-extern int startproc(int);
-extern int reset(int);
-extern int send_and_receive(int, unsigned int, unsigned char,unsigned char,
-		unsigned char,unsigned char, 
-		unsigned char, unsigned char *, RspMessage *, int);
-
-extern board *sc_adapter[];
-
-
 static int GetStatus(int card, boardInfo *);
 
 /*
diff -puN drivers/isdn/sc/message.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/message.c
--- a/drivers/isdn/sc/message.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/message.c
@@ -22,16 +22,6 @@
 #include "message.h"
 #include "card.h"
 
-extern board *sc_adapter[];
-extern unsigned int cinst;
-
-/*
- * Obligatory function prototypes
- */
-extern int indicate_status(int,ulong,char*);
-extern int scm_command(isdn_ctrl *);
-
-
 /*
  * receive a message from the board
  */
diff -puN drivers/isdn/sc/packet.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/packet.c
--- a/drivers/isdn/sc/packet.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/packet.c
@@ -20,16 +20,6 @@
 #include "message.h"
 #include "card.h"
 
-extern board *sc_adapter[];
-extern unsigned int cinst;
-
-extern int get_card_from_id(int);
-extern int indicate_status(int, int,ulong, char*);
-extern void memcpy_toshmem(int, void *, const void *, size_t);
-extern void memcpy_fromshmem(int, void *, const void *, size_t);
-extern int sendmessage(int, unsigned int, unsigned int, unsigned int,
-                unsigned int, unsigned int, unsigned int, unsigned int *);
-
 int sndpkt(int devId, int channel, struct sk_buff *data)
 {
 	LLData	ReqLnkWrite;
diff -puN drivers/isdn/sc/scioc.h~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/scioc.h
--- a/drivers/isdn/sc/scioc.h~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/scioc.h
@@ -1,3 +1,6 @@
+#ifndef __ISDN_SC_SCIOC_H__
+#define __ISDN_SC_SCIOC_H__
+
 /*
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
@@ -103,3 +106,6 @@ typedef struct {
 		POTInfo potsinfo;
 	} info;
 } boardInfo;
+
+#endif  /*  __ISDN_SC_SCIOC_H__  */
+
diff -puN drivers/isdn/sc/shmem.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/shmem.c
--- a/drivers/isdn/sc/shmem.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/shmem.c
@@ -22,12 +22,6 @@
 #include "card.h"
 
 /*
- * Main adapter array
- */
-extern board *sc_adapter[];
-extern int cinst;
-
-/*
  *
  */
 void memcpy_toshmem(int card, void *dest, const void *src, size_t n)
diff -puN drivers/isdn/sc/timer.c~drivers-isdn-sc-proper-prototypes drivers/isdn/sc/timer.c
--- a/drivers/isdn/sc/timer.c~drivers-isdn-sc-proper-prototypes
+++ a/drivers/isdn/sc/timer.c
@@ -20,14 +20,6 @@
 #include "message.h"
 #include "card.h"
 
-extern board *sc_adapter[];
-
-extern void flushreadfifo(int);
-extern int  startproc(int);
-extern int  indicate_status(int, int, unsigned long, char *);
-extern int  sendmessage(int, unsigned int, unsigned int, unsigned int,
-        unsigned int, unsigned int, unsigned int, unsigned int *);
-
 
 /*
  * Write the proper values into the I/O ports following a reset
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
git-mtd.patch
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
usb_rtl8150-must-select-mii.patch
x86_64-re-add-a-newline-to-restore_context.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
more-ftape-removal.patch
cleanup-linux-byteorder-swabbh.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
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
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
