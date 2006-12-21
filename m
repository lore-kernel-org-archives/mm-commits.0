From: akpm@osdl.org
Subject: + drivers-isdn-hisax-proper-prototypes.patch added to -mm tree
Date: Wed, 20 Dec 2006 16:51:06 -0800
Message-ID: <200612210051.kBL0p6rO011611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54453 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161093AbWLUAyX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:54:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, kkeil@suse.de


The patch titled
     drivers/isdn/hisax/: proper prototypes
has been added to the -mm tree.  Its filename is
     drivers-isdn-hisax-proper-prototypes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/hisax/: proper prototypes
From: Adrian Bunk <bunk@stusta.de>

- add functions prototypes for some global functions to header files

- remove unneeded "extern"s from some function prototypes

You might note that this patch results in a new warning - that's due to the
fact that with a proper prototype gcc is able to discover a broken
work_struct conversion.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/isar.c   |    1 -
 drivers/isdn/hisax/isdnl1.h |   17 ++++++++---------
 drivers/isdn/hisax/isdnl3.c |   12 ------------
 drivers/isdn/hisax/isdnl3.h |   26 ++++++++++++++++----------
 4 files changed, 24 insertions(+), 32 deletions(-)

diff -puN drivers/isdn/hisax/isar.c~drivers-isdn-hisax-proper-prototypes drivers/isdn/hisax/isar.c
--- a/drivers/isdn/hisax/isar.c~drivers-isdn-hisax-proper-prototypes
+++ a/drivers/isdn/hisax/isar.c
@@ -431,7 +431,6 @@ reterror:
 	return(ret);
 }
 
-extern void BChannel_bh(struct BCState *);
 #define B_LL_NOCARRIER	8
 #define B_LL_CONNECT	9
 #define B_LL_OK		10
diff -puN drivers/isdn/hisax/isdnl1.h~drivers-isdn-hisax-proper-prototypes drivers/isdn/hisax/isdnl1.h
--- a/drivers/isdn/hisax/isdnl1.h~drivers-isdn-hisax-proper-prototypes
+++ a/drivers/isdn/hisax/isdnl1.h
@@ -21,12 +21,11 @@
 #define B_XMTBUFREADY	1
 #define B_ACKPENDING	2
 
-extern void debugl1(struct IsdnCardState *cs, char *fmt, ...);
-extern void DChannel_proc_xmt(struct IsdnCardState *cs);
-extern void DChannel_proc_rcv(struct IsdnCardState *cs);
-extern void l1_msg(struct IsdnCardState *cs, int pr, void *arg);
-extern void l1_msg_b(struct PStack *st, int pr, void *arg);
-
-#ifdef L2FRAME_DEBUG
-extern void Logl2Frame(struct IsdnCardState *cs, struct sk_buff *skb, char *buf, int dir);
-#endif
+void debugl1(struct IsdnCardState *cs, char *fmt, ...);
+void DChannel_proc_xmt(struct IsdnCardState *cs);
+void DChannel_proc_rcv(struct IsdnCardState *cs);
+void l1_msg(struct IsdnCardState *cs, int pr, void *arg);
+void l1_msg_b(struct PStack *st, int pr, void *arg);
+void Logl2Frame(struct IsdnCardState *cs, struct sk_buff *skb, char *buf,
+		int dir);
+void BChannel_bh(struct work_struct *work);
diff -puN drivers/isdn/hisax/isdnl3.c~drivers-isdn-hisax-proper-prototypes drivers/isdn/hisax/isdnl3.c
--- a/drivers/isdn/hisax/isdnl3.c~drivers-isdn-hisax-proper-prototypes
+++ a/drivers/isdn/hisax/isdnl3.c
@@ -231,18 +231,6 @@ no_l3_proto_spec(struct PStack *st, isdn
 	return(-1);
 }
 
-#ifdef	CONFIG_HISAX_EURO
-extern void setstack_dss1(struct PStack *st);
-#endif
-
-#ifdef  CONFIG_HISAX_NI1
-extern void setstack_ni1(struct PStack *st);
-#endif
-
-#ifdef	CONFIG_HISAX_1TR6
-extern void setstack_1tr6(struct PStack *st);
-#endif
-
 struct l3_process
 *getl3proc(struct PStack *st, int cr)
 {
diff -puN drivers/isdn/hisax/isdnl3.h~drivers-isdn-hisax-proper-prototypes drivers/isdn/hisax/isdnl3.h
--- a/drivers/isdn/hisax/isdnl3.h~drivers-isdn-hisax-proper-prototypes
+++ a/drivers/isdn/hisax/isdnl3.h
@@ -25,13 +25,19 @@ struct stateentry {
 
 #define l3_debug(st, fmt, args...) HiSax_putstatus(st->l1.hardware, "l3 ", fmt, ## args)
 
-extern void newl3state(struct l3_process *pc, int state);
-extern void L3InitTimer(struct l3_process *pc, struct L3Timer *t);
-extern void L3DelTimer(struct L3Timer *t);
-extern int L3AddTimer(struct L3Timer *t, int millisec, int event);
-extern void StopAllL3Timer(struct l3_process *pc);
-extern struct sk_buff *l3_alloc_skb(int len);
-extern struct l3_process *new_l3_process(struct PStack *st, int cr);
-extern void release_l3_process(struct l3_process *p);
-extern struct l3_process *getl3proc(struct PStack *st, int cr);
-extern void l3_msg(struct PStack *st, int pr, void *arg);
+struct PStack;
+
+void newl3state(struct l3_process *pc, int state);
+void L3InitTimer(struct l3_process *pc, struct L3Timer *t);
+void L3DelTimer(struct L3Timer *t);
+int L3AddTimer(struct L3Timer *t, int millisec, int event);
+void StopAllL3Timer(struct l3_process *pc);
+struct sk_buff *l3_alloc_skb(int len);
+struct l3_process *new_l3_process(struct PStack *st, int cr);
+void release_l3_process(struct l3_process *p);
+struct l3_process *getl3proc(struct PStack *st, int cr);
+void l3_msg(struct PStack *st, int pr, void *arg);
+void setstack_dss1(struct PStack *st);
+void setstack_ni1(struct PStack *st);
+void setstack_1tr6(struct PStack *st);
+
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

