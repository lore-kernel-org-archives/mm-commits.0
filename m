From: akpm@linux-foundation.org
Subject: + dvb-usb-make-some-debug-vars-static.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:18:07 -0800
Message-ID: <200711090418.lA94I7Do028908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758224AbXKIESa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:18:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mchehab@infradead.org


The patch titled
     dvb-usb: make some debug vars static
has been added to the -mm tree.  Its filename is
     dvb-usb-make-some-debug-vars-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dvb-usb: make some debug vars static
From: Adrian Bunk <bunk@kernel.org>

This patch makes some needlessly global debug variables static.

opera1.h became so small that I removed it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/cxusb.c  |    5 ++++-
 drivers/media/dvb/dvb-usb/cxusb.h  |    5 -----
 drivers/media/dvb/dvb-usb/digitv.c |    3 ++-
 drivers/media/dvb/dvb-usb/digitv.h |    3 ---
 drivers/media/dvb/dvb-usb/opera1.c |    6 ++++--
 drivers/media/dvb/dvb-usb/opera1.h |    9 ---------
 drivers/media/dvb/dvb-usb/vp7045.c |    5 ++++-
 drivers/media/dvb/dvb-usb/vp7045.h |    5 -----
 8 files changed, 14 insertions(+), 27 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/cxusb.c~dvb-usb-make-some-debug-vars-static drivers/media/dvb/dvb-usb/cxusb.c
--- a/drivers/media/dvb/dvb-usb/cxusb.c~dvb-usb-make-some-debug-vars-static
+++ a/drivers/media/dvb/dvb-usb/cxusb.c
@@ -32,9 +32,12 @@
 #include "zl10353.h"
 
 /* debug */
-int dvb_usb_cxusb_debug;
+static int dvb_usb_cxusb_debug;
 module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug,0x01,args)
+#define deb_i2c(args...)    if (d->udev->descriptor.idVendor == USB_VID_MEDION) \
+				dprintk(dvb_usb_cxusb_debug,0x01,args)
 
 static int cxusb_ctrl_msg(struct dvb_usb_device *d,
 			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
diff -puN drivers/media/dvb/dvb-usb/cxusb.h~dvb-usb-make-some-debug-vars-static drivers/media/dvb/dvb-usb/cxusb.h
--- a/drivers/media/dvb/dvb-usb/cxusb.h~dvb-usb-make-some-debug-vars-static
+++ a/drivers/media/dvb/dvb-usb/cxusb.h
@@ -4,11 +4,6 @@
 #define DVB_USB_LOG_PREFIX "cxusb"
 #include "dvb-usb.h"
 
-extern int dvb_usb_cxusb_debug;
-#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug,0x01,args)
-#define deb_i2c(args...)    if (d->udev->descriptor.idVendor == USB_VID_MEDION) \
-				dprintk(dvb_usb_cxusb_debug,0x01,args)
-
 /* usb commands - some of it are guesses, don't have a reference yet */
 #define CMD_I2C_WRITE     0x08
 #define CMD_I2C_READ      0x09
diff -puN drivers/media/dvb/dvb-usb/digitv.c~dvb-usb-make-some-debug-vars-static drivers/media/dvb/dvb-usb/digitv.c
--- a/drivers/media/dvb/dvb-usb/digitv.c~dvb-usb-make-some-debug-vars-static
+++ a/drivers/media/dvb/dvb-usb/digitv.c
@@ -17,9 +17,10 @@
 #include "nxt6000.h"
 
 /* debug */
-int dvb_usb_digitv_debug;
+static int dvb_usb_digitv_debug;
 module_param_named(debug,dvb_usb_digitv_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+#define deb_rc(args...)   dprintk(dvb_usb_digitv_debug,0x01,args)
 
 static int digitv_ctrl_msg(struct dvb_usb_device *d,
 		u8 cmd, u8 vv, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
diff -puN drivers/media/dvb/dvb-usb/digitv.h~dvb-usb-make-some-debug-vars-static drivers/media/dvb/dvb-usb/digitv.h
--- a/drivers/media/dvb/dvb-usb/digitv.h~dvb-usb-make-some-debug-vars-static
+++ a/drivers/media/dvb/dvb-usb/digitv.h
@@ -8,9 +8,6 @@ struct digitv_state {
     int is_nxt6000;
 };
 
-extern int dvb_usb_digitv_debug;
-#define deb_rc(args...)   dprintk(dvb_usb_digitv_debug,0x01,args)
-
 /* protocol (from usblogging and the SDK:
  *
  * Always 7 bytes bulk message(s) for controlling
diff -puN drivers/media/dvb/dvb-usb/opera1.c~dvb-usb-make-some-debug-vars-static drivers/media/dvb/dvb-usb/opera1.c
--- a/drivers/media/dvb/dvb-usb/opera1.c~dvb-usb-make-some-debug-vars-static
+++ a/drivers/media/dvb/dvb-usb/opera1.c
@@ -10,7 +10,9 @@
 * see Documentation/dvb/README.dvb-usb for more information
 */
 
-#include "opera1.h"
+#define DVB_USB_LOG_PREFIX "opera"
+
+#include "dvb-usb.h"
 #include "stv0299.h"
 
 #define OPERA_READ_MSG 0
@@ -38,7 +40,7 @@ struct opera_rc_keys {
 	u32 event;
 };
 
-int dvb_usb_opera1_debug;
+static int dvb_usb_opera1_debug;
 module_param_named(debug, dvb_usb_opera1_debug, int, 0644);
 MODULE_PARM_DESC(debug,
 		 "set debugging level (1=info,xfer=2,pll=4,ts=8,err=16,rc=32,fw=64 (or-able))."
diff -puN drivers/media/dvb/dvb-usb/opera1.h~dvb-usb-make-some-debug-vars-static /dev/null
--- a/drivers/media/dvb/dvb-usb/opera1.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _OPERA1_H_
-#define _OPERA1_H_
-
-#define DVB_USB_LOG_PREFIX "opera"
-#include "dvb-usb.h"
-
-extern int dvb_usb_opera1_debug;
-#define deb_xfer(args...) dprintk(dvb_usb_opera1_debug,0x02,args)
-#endif
diff -puN drivers/media/dvb/dvb-usb/vp7045.c~dvb-usb-make-some-debug-vars-static drivers/media/dvb/dvb-usb/vp7045.c
--- a/drivers/media/dvb/dvb-usb/vp7045.c~dvb-usb-make-some-debug-vars-static
+++ a/drivers/media/dvb/dvb-usb/vp7045.c
@@ -15,9 +15,12 @@
 #include "vp7045.h"
 
 /* debug */
-int dvb_usb_vp7045_debug;
+static int dvb_usb_vp7045_debug;
 module_param_named(debug,dvb_usb_vp7045_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
+#define deb_info(args...) dprintk(dvb_usb_vp7045_debug,0x01,args)
+#define deb_xfer(args...) dprintk(dvb_usb_vp7045_debug,0x02,args)
+#define deb_rc(args...)   dprintk(dvb_usb_vp7045_debug,0x04,args)
 
 int vp7045_usb_op(struct dvb_usb_device *d, u8 cmd, u8 *out, int outlen, u8 *in, int inlen, int msec)
 {
diff -puN drivers/media/dvb/dvb-usb/vp7045.h~dvb-usb-make-some-debug-vars-static drivers/media/dvb/dvb-usb/vp7045.h
--- a/drivers/media/dvb/dvb-usb/vp7045.h~dvb-usb-make-some-debug-vars-static
+++ a/drivers/media/dvb/dvb-usb/vp7045.h
@@ -17,11 +17,6 @@
 #define DVB_USB_LOG_PREFIX "vp7045"
 #include "dvb-usb.h"
 
-extern int dvb_usb_vp7045_debug;
-#define deb_info(args...) dprintk(dvb_usb_vp7045_debug,0x01,args)
-#define deb_xfer(args...) dprintk(dvb_usb_vp7045_debug,0x02,args)
-#define deb_rc(args...)   dprintk(dvb_usb_vp7045_debug,0x04,args)
-
 /* vp7045 commands */
 
 /* Twinhan Vendor requests */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
dvb-bt8xx-dstc-make-code-static.patch
dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload.patch
dvb-usb-vp702xc-cleanups.patch
dvb-usb-make-some-debug-vars-static.patch
media-common-ir-functionsc-make-a-function-static.patch
cx88-mpegc-make-4-functions-static.patch
media-video-et61x251-make-5-functions-static.patch
git-hwmon.patch
fs-dlm-proper-prototypes.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
