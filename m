From: akpm@linux-foundation.org
Subject: + drivers-isdn-gigaset-new-m101-driver-v2.patch added to -mm tree
Date: Fri, 09 Feb 2007 02:25:40 -0800
Message-ID: <200702091025.l19APenC010660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946304AbXBIKZv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 05:25:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, hjlipp@web.de


The patch titled
     drivers/isdn/gigaset: new M101 driver (v2)
has been added to the -mm tree.  Its filename is
     drivers-isdn-gigaset-new-m101-driver-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/gigaset: new M101 driver (v2)
From: Tilman Schmidt <tilman@imap.cc>

This patch adds the line discipline based driver for the Gigaset M101
wireless RS232 adapter. It also improves the documentation a bit.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Hansjoerg Lipp <hjlipp@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/isdn/README.gigaset  |   65 +-
 drivers/isdn/gigaset/Kconfig       |   25 
 drivers/isdn/gigaset/Makefile      |    2 
 drivers/isdn/gigaset/asyncdata.c   |    5 
 drivers/isdn/gigaset/common.c      |   20 
 drivers/isdn/gigaset/ev-layer.c    |    2 
 drivers/isdn/gigaset/ser-gigaset.c |  837 +++++++++++++++++++++++++++
 include/linux/gigaset_dev.h        |    2 
 8 files changed, 916 insertions(+), 42 deletions(-)

diff -puN Documentation/isdn/README.gigaset~drivers-isdn-gigaset-new-m101-driver-v2 Documentation/isdn/README.gigaset
--- a/Documentation/isdn/README.gigaset~drivers-isdn-gigaset-new-m101-driver-v2
+++ a/Documentation/isdn/README.gigaset
@@ -8,29 +8,33 @@ GigaSet 307x Device Driver
      This release supports the connection of the Gigaset 307x/417x family of
      ISDN DECT bases via Gigaset M101 Data, Gigaset M105 Data or direct USB
      connection. The following devices are reported to be compatible:
-     307x/417x:
-        Gigaset SX255isdn
-        Gigaset SX353isdn
-        Sinus 45 [AB] isdn (Deutsche Telekom)
-        Sinus 721X/XA
+
+     Bases:
+        Siemens Gigaset 3070/3075 isdn
+        Siemens Gigaset 4170/4175 isdn
+        Siemens Gigaset SX205/255
+        Siemens Gigaset SX353
+        T-Com Sinus 45 [AB] isdn
+        T-Com Sinus 721X[A] [SE]
         Vox Chicago 390 ISDN (KPN Telecom)
-     M101:
-        Sinus 45 Data 1 (Telekom)
-     M105:
-        Gigaset USB Adapter DECT
-        Sinus 45 Data 2 (Telekom)
-        Sinus 721 data
+
+     RS232 data boxes:
+        Siemens Gigaset M101 Data
+        T-Com Sinus 45 Data 1
+
+     USB data boxes:
+        Siemens Gigaset M105 Data
+        Siemens Gigaset USB Adapter DECT
+        T-Com Sinus 45 Data 2
+        T-Com Sinus 721 data
         Chicago 390 USB (KPN)
+
      See also http://www.erbze.info/sinus_gigaset.htm and
               http://gigaset307x.sourceforge.net/
 
      We had also reports from users of Gigaset M105 who could use the drivers
      with SX 100 and CX 100 ISDN bases (only in unimodem mode, see section 2.4.)
      If you have another device that works with our driver, please let us know.
-     For example, Gigaset SX205isdn/Sinus 721 X SE and Gigaset SX303isdn bases
-     are just versions without answering machine of models known to work, so
-     they should work just as well; but so far we are lacking positive reports
-     on these.
 
      Chances of getting an USB device to work are good if the output of
         lsusb
@@ -60,14 +64,28 @@ GigaSet 307x Device Driver
      To get the device working, you have to load the proper kernel module. You
      can do this using
          modprobe modulename
-     where modulename is usb_gigaset (M105) or bas_gigaset (direct USB
-     connection to the base).
+     where modulename is ser_gigaset (M101), usb_gigaset (M105), or
+     bas_gigaset (direct USB connection to the base).
+
+     The module ser_gigaset provides a serial line discipline N_GIGASET_M101
+     which drives the device through the regular serial line driver. To use it,
+     run the Gigaset M101 daemon "gigasetm101d" (also available from
+     http://sourceforge.net/projects/gigaset307x/) with the device file of the
+     RS232 port to the M101 as an argument, for example:
+	 gigasetm101d /dev/ttyS1
+     This will open the device file, set its line discipline to N_GIGASET_M101,
+     and then sleep in the background, keeping the device open so that the
+     line discipline remains active. To deactivate it, kill the daemon, for
+     example with
+	 killall gigasetm101d
+     before disconnecting the device.
 
 2.2. Device nodes for user space programs
      ------------------------------------
      The device can be accessed from user space (eg. by the user space tools
      mentioned in 1.2.) through the device nodes:
 
+     - /dev/ttyGS0 for M101 (RS232 data boxes)
      - /dev/ttyGU0 for M105 (USB data boxes)
      - /dev/ttyGB0 for the base driver (direct USB connection)
 
@@ -168,6 +186,19 @@ GigaSet 307x Device Driver
      You can also use /sys/class/tty/ttyGxy/cidmode for changing the CID mode
      setting (ttyGxy is ttyGU0 or ttyGB0).
 
+2.6. M105 Undocumented USB Requests
+     ------------------------------
+
+     The Gigaset M105 USB data box understands a couple of useful, but
+     undocumented USB commands. These requests are not used in normal
+     operation (for wireless access to the base), but are needed for access
+     to the M105's own configuration mode (registration to the base, baudrate
+     and line format settings, device status queries) via the gigacontr
+     utility. Their use is disabled in the driver by default for safety
+     reasons but can be enabled by setting the kernel configuration option
+     "Support for undocumented USB requests" (GIGASET_UNDOCREQ) to "Y" and
+     recompiling.
+
 
 3.   Troubleshooting
      ---------------
diff -puN drivers/isdn/gigaset/asyncdata.c~drivers-isdn-gigaset-new-m101-driver-v2 drivers/isdn/gigaset/asyncdata.c
--- a/drivers/isdn/gigaset/asyncdata.c~drivers-isdn-gigaset-new-m101-driver-v2
+++ a/drivers/isdn/gigaset/asyncdata.c
@@ -13,6 +13,11 @@
  * =====================================================================
  */
 
+/* not set by Kbuild when building both ser_gigaset and usb_gigaset */
+#ifndef KBUILD_MODNAME
+#define KBUILD_MODNAME "asy_gigaset"
+#endif
+
 #include "gigaset.h"
 #include <linux/crc-ccitt.h>
 #include <linux/bitrev.h>
diff -puN drivers/isdn/gigaset/common.c~drivers-isdn-gigaset-new-m101-driver-v2 drivers/isdn/gigaset/common.c
--- a/drivers/isdn/gigaset/common.c~drivers-isdn-gigaset-new-m101-driver-v2
+++ a/drivers/isdn/gigaset/common.c
@@ -906,20 +906,7 @@ void gigaset_shutdown(struct cardstate *
 	gig_dbg(DEBUG_CMD, "scheduling SHUTDOWN");
 	gigaset_schedule_event(cs);
 
-	if (wait_event_interruptible(cs->waitqueue, !cs->waiting)) {
-		warn("%s: aborted", __func__);
-		//FIXME
-	}
-
-	if (atomic_read(&cs->mstate) != MS_LOCKED) {
-		//FIXME?
-		//gigaset_baud_rate(cs, B115200);
-		//gigaset_set_line_ctrl(cs, CS8);
-		//gigaset_set_modem_ctrl(cs, TIOCM_DTR|TIOCM_RTS, 0);
-		//cs->control_state = 0;
-	} else {
-		//FIXME use some saved values?
-	}
+	wait_event(cs->waitqueue, !cs->waiting);
 
 	cleanup_cs(cs);
 
@@ -942,10 +929,7 @@ void gigaset_stop(struct cardstate *cs)
 	gig_dbg(DEBUG_CMD, "scheduling STOP");
 	gigaset_schedule_event(cs);
 
-	if (wait_event_interruptible(cs->waitqueue, !cs->waiting)) {
-		warn("%s: aborted", __func__);
-		//FIXME
-	}
+	wait_event(cs->waitqueue, !cs->waiting);
 
 	cleanup_cs(cs);
 
diff -puN drivers/isdn/gigaset/ev-layer.c~drivers-isdn-gigaset-new-m101-driver-v2 drivers/isdn/gigaset/ev-layer.c
--- a/drivers/isdn/gigaset/ev-layer.c~drivers-isdn-gigaset-new-m101-driver-v2
+++ a/drivers/isdn/gigaset/ev-layer.c
@@ -1015,7 +1015,7 @@ static void finish_shutdown(struct cards
 
 	cs->cmd_result = -ENODEV;
 	cs->waiting = 0;
-	wake_up_interruptible(&cs->waitqueue);
+	wake_up(&cs->waitqueue);
 }
 
 static void do_shutdown(struct cardstate *cs)
diff -puN drivers/isdn/gigaset/Kconfig~drivers-isdn-gigaset-new-m101-driver-v2 drivers/isdn/gigaset/Kconfig
--- a/drivers/isdn/gigaset/Kconfig~drivers-isdn-gigaset-new-m101-driver-v2
+++ a/drivers/isdn/gigaset/Kconfig
@@ -7,7 +7,13 @@ config ISDN_DRV_GIGASET
 	select CRC_CCITT
 	select BITREVERSE
 	help
-	  Say m here if you have a Gigaset or Sinus isdn device.
+	  This driver supports the Siemens Gigaset SX205/255 family of
+	  ISDN DECT bases, including the predecessors Gigaset 3070/3075
+	  and 4170/4175 and their T-Com versions Sinus 45isdn and Sinus
+	  721X.
+	  If you have one of these devices, say M here and for at least
+	  one of the connection specific parts that follow.
+	  This will build a module called "gigaset".
 
 if ISDN_DRV_GIGASET!=n
 
@@ -15,14 +21,25 @@ config GIGASET_BASE
 	tristate "Gigaset base station support"
 	depends on ISDN_DRV_GIGASET && USB
 	help
-	  Say m here if you need to communicate with the base
-	  directly via USB.
+	  Say M here if you want to use the USB interface of the Gigaset
+	  base for connection to your system.
+	  This will build a module called "bas_gigaset".
 
 config GIGASET_M105
 	tristate "Gigaset M105 support"
 	depends on ISDN_DRV_GIGASET && USB
 	help
-	  Say m here if you need the driver for the Gigaset M105 device.
+	  Say M here if you want to connect to the Gigaset base via DECT
+	  using a Gigaset M105 (Sinus 45 Data 2) USB DECT device.
+	  This will build a module called "usb_gigaset".
+
+config GIGASET_M101
+	tristate "Gigaset M101 support"
+	depends on ISDN_DRV_GIGASET
+	help
+	  Say M here if you want to connect to the Gigaset base via DECT
+	  using a Gigaset M101 (Sinus 45 Data 1) RS232 DECT device.
+	  This will build a module called "ser_gigaset".
 
 config GIGASET_DEBUG
 	bool "Gigaset debugging"
diff -puN drivers/isdn/gigaset/Makefile~drivers-isdn-gigaset-new-m101-driver-v2 drivers/isdn/gigaset/Makefile
--- a/drivers/isdn/gigaset/Makefile~drivers-isdn-gigaset-new-m101-driver-v2
+++ a/drivers/isdn/gigaset/Makefile
@@ -1,6 +1,8 @@
 gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o
 usb_gigaset-y := usb-gigaset.o asyncdata.o
 bas_gigaset-y := bas-gigaset.o isocdata.o
+ser_gigaset-y := ser-gigaset.o asyncdata.o
 
 obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
 obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
+obj-$(CONFIG_GIGASET_M105) += ser_gigaset.o gigaset.o
diff -puN /dev/null drivers/isdn/gigaset/ser-gigaset.c
--- /dev/null
+++ a/drivers/isdn/gigaset/ser-gigaset.c
@@ -0,0 +1,837 @@
+/* This is the serial hardware link layer (HLL) for the Gigaset 307x isdn
+ * DECT base (aka Sinus 45 isdn) using the RS232 DECT data module M101,
+ * written as a line discipline.
+ *
+ * =====================================================================
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ * =====================================================================
+ */
+
+#include "gigaset.h"
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/tty.h>
+#include <linux/poll.h>
+
+/* Version Information */
+#define DRIVER_AUTHOR "Tilman Schmidt"
+#define DRIVER_DESC "Serial Driver for Gigaset 307x using Siemens M101"
+
+#define GIGASET_MINORS     1
+#define GIGASET_MINOR      0
+#define GIGASET_MODULENAME "ser_gigaset"
+#define GIGASET_DEVNAME    "ttyGS"
+
+/* length limit according to Siemens 3070usb-protokoll.doc ch. 2.1 */
+#define IF_WRITEBUF 264
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_LDISC(N_GIGASET_M101);
+
+static int startmode = SM_ISDN;
+module_param(startmode, int, S_IRUGO);
+MODULE_PARM_DESC(startmode, "initial operation mode");
+static int cidmode = 1;
+module_param(cidmode, int, S_IRUGO);
+MODULE_PARM_DESC(cidmode, "stay in CID mode when idle");
+
+static struct gigaset_driver *driver;
+
+struct ser_cardstate {
+	struct platform_device	dev;
+	struct tty_struct	*tty;
+	atomic_t		refcnt;
+	struct mutex		dead_mutex;
+};
+
+static struct platform_driver device_driver = {
+	.driver = {
+		.name = GIGASET_MODULENAME,
+	},
+};
+
+static void flush_send_queue(struct cardstate *);
+
+/* transmit data from current open skb
+ * result: number of bytes sent or error code < 0
+ */
+static int write_modem(struct cardstate *cs)
+{
+	struct tty_struct *tty = cs->hw.ser->tty;
+	struct bc_state *bcs = &cs->bcs[0];	/* only one channel */
+	struct sk_buff *skb = bcs->tx_skb;
+	int sent;
+
+	if (!tty || !tty->driver || !skb)
+		return -EFAULT;
+
+	if (!skb->len) {
+		dev_kfree_skb_any(skb);
+		bcs->tx_skb = NULL;
+		return -EINVAL;
+	}
+
+	set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+	sent = tty->driver->write(tty, skb->data, skb->len);
+	gig_dbg(DEBUG_OUTPUT, "write_modem: sent %d", sent);
+	if (sent < 0) {
+		/* error */
+		flush_send_queue(cs);
+		return sent;
+	}
+	skb_pull(skb, sent);
+	if (!skb->len) {
+		/* skb sent completely */
+		gigaset_skb_sent(bcs, skb);
+
+		gig_dbg(DEBUG_INTR, "kfree skb (Adr: %lx)!",
+			(unsigned long) skb);
+		dev_kfree_skb_any(skb);
+		bcs->tx_skb = NULL;
+	}
+	return sent;
+}
+
+/*
+ * transmit first queued command buffer
+ * result: number of bytes sent or error code < 0
+ */
+static int send_cb(struct cardstate *cs)
+{
+	struct tty_struct *tty = cs->hw.ser->tty;
+	struct cmdbuf_t *cb, *tcb;
+	unsigned long flags;
+	int sent = 0;
+
+	if (!tty || !tty->driver)
+		return -EFAULT;
+
+	cb = cs->cmdbuf;
+	if (!cb)
+		return 0;	/* nothing to do */
+
+	if (cb->len) {
+		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+		sent = tty->driver->write(tty, cb->buf + cb->offset, cb->len);
+		if (sent < 0) {
+			/* error */
+			gig_dbg(DEBUG_OUTPUT, "send_cb: write error %d", sent);
+			flush_send_queue(cs);
+			return sent;
+		}
+		cb->offset += sent;
+		cb->len -= sent;
+		gig_dbg(DEBUG_OUTPUT, "send_cb: sent %d, left %u, queued %u",
+			sent, cb->len, cs->cmdbytes);
+	}
+
+	while (cb && !cb->len) {
+		spin_lock_irqsave(&cs->cmdlock, flags);
+		cs->cmdbytes -= cs->curlen;
+		tcb = cb;
+		cs->cmdbuf = cb = cb->next;
+		if (cb) {
+			cb->prev = NULL;
+			cs->curlen = cb->len;
+		} else {
+			cs->lastcmdbuf = NULL;
+			cs->curlen = 0;
+		}
+		spin_unlock_irqrestore(&cs->cmdlock, flags);
+
+		if (tcb->wake_tasklet)
+			tasklet_schedule(tcb->wake_tasklet);
+		kfree(tcb);
+	}
+	return sent;
+}
+
+/*
+ * send queue tasklet
+ * If there is already a skb opened, put data to the transfer buffer
+ * by calling "write_modem".
+ * Otherwise take a new skb out of the queue.
+ */
+static void gigaset_modem_fill(unsigned long data)
+{
+	struct cardstate *cs = (struct cardstate *) data;
+	struct bc_state *bcs;
+	int sent = 0;
+
+	if (!cs || !(bcs = cs->bcs)) {
+		gig_dbg(DEBUG_OUTPUT, "%s: no cardstate", __func__);
+		return;
+	}
+	if (!bcs->tx_skb) {
+		/* no skb is being sent; send command if any */
+		sent = send_cb(cs);
+		gig_dbg(DEBUG_OUTPUT, "%s: send_cb -> %d", __func__, sent);
+		if (sent)
+			/* something sent or error */
+			return;
+
+		/* no command to send; get skb */
+		if (!(bcs->tx_skb = skb_dequeue(&bcs->squeue)))
+			/* no skb either, nothing to do */
+			return;
+
+		gig_dbg(DEBUG_INTR, "Dequeued skb (Adr: %lx)",
+			(unsigned long) bcs->tx_skb);
+	}
+
+	/* send skb */
+	gig_dbg(DEBUG_OUTPUT, "%s: tx_skb", __func__);
+	if (write_modem(cs) < 0)
+		gig_dbg(DEBUG_OUTPUT, "%s: write_modem failed", __func__);
+}
+
+/*
+ * throw away all data queued for sending
+ */
+static void flush_send_queue(struct cardstate *cs)
+{
+	struct sk_buff *skb;
+	struct cmdbuf_t *cb;
+	unsigned long flags;
+
+	/* command queue */
+	spin_lock_irqsave(&cs->cmdlock, flags);
+	while ((cb = cs->cmdbuf) != NULL) {
+		cs->cmdbuf = cb->next;
+		if (cb->wake_tasklet)
+			tasklet_schedule(cb->wake_tasklet);
+		kfree(cb);
+	}
+	cs->cmdbuf = cs->lastcmdbuf = NULL;
+	cs->cmdbytes = cs->curlen = 0;
+	spin_unlock_irqrestore(&cs->cmdlock, flags);
+
+	/* data queue */
+	if (cs->bcs->tx_skb)
+		dev_kfree_skb_any(cs->bcs->tx_skb);
+	while ((skb = skb_dequeue(&cs->bcs->squeue)) != NULL)
+		dev_kfree_skb_any(skb);
+}
+
+
+/* Gigaset Driver Interface */
+/* ======================== */
+
+/*
+ * queue an AT command string for transmission to the Gigaset device
+ * parameters:
+ *	cs		controller state structure
+ *	buf		buffer containing the string to send
+ *	len		number of characters to send
+ *	wake_tasklet	tasklet to run when transmission is complete, or NULL
+ * return value:
+ *	number of bytes queued, or error code < 0
+ */
+static int gigaset_write_cmd(struct cardstate *cs, const unsigned char *buf,
+                             int len, struct tasklet_struct *wake_tasklet)
+{
+	struct cmdbuf_t *cb;
+	unsigned long flags;
+
+	gigaset_dbg_buffer(atomic_read(&cs->mstate) != MS_LOCKED ?
+	                     DEBUG_TRANSCMD : DEBUG_LOCKCMD,
+	                   "CMD Transmit", len, buf);
+
+	if (len <= 0)
+		return 0;
+
+	if (!(cb = kmalloc(sizeof(struct cmdbuf_t) + len, GFP_ATOMIC))) {
+		dev_err(cs->dev, "%s: out of memory!\n", __func__);
+		return -ENOMEM;
+	}
+
+	memcpy(cb->buf, buf, len);
+	cb->len = len;
+	cb->offset = 0;
+	cb->next = NULL;
+	cb->wake_tasklet = wake_tasklet;
+
+	spin_lock_irqsave(&cs->cmdlock, flags);
+	cb->prev = cs->lastcmdbuf;
+	if (cs->lastcmdbuf)
+		cs->lastcmdbuf->next = cb;
+	else {
+		cs->cmdbuf = cb;
+		cs->curlen = len;
+	}
+	cs->cmdbytes += len;
+	cs->lastcmdbuf = cb;
+	spin_unlock_irqrestore(&cs->cmdlock, flags);
+
+	spin_lock_irqsave(&cs->lock, flags);
+	if (cs->connected)
+		tasklet_schedule(&cs->write_tasklet);
+	spin_unlock_irqrestore(&cs->lock, flags);
+	return len;
+}
+
+/*
+ * tty_driver.write_room interface routine
+ * return number of characters the driver will accept to be written
+ * parameter:
+ *	controller state structure
+ * return value:
+ *	number of characters
+ */
+static int gigaset_write_room(struct cardstate *cs)
+{
+	unsigned bytes;
+
+	bytes = cs->cmdbytes;
+	return bytes < IF_WRITEBUF ? IF_WRITEBUF - bytes : 0;
+}
+
+/*
+ * tty_driver.chars_in_buffer interface routine
+ * return number of characters waiting to be sent
+ * parameter:
+ *	controller state structure
+ * return value:
+ *	number of characters
+ */
+static int gigaset_chars_in_buffer(struct cardstate *cs)
+{
+	return cs->cmdbytes;
+}
+
+/*
+ * implementation of ioctl(GIGASET_BRKCHARS)
+ * parameter:
+ *	controller state structure
+ * return value:
+ *	-EINVAL (unimplemented function)
+ */
+static int gigaset_brkchars(struct cardstate *cs, const unsigned char buf[6])
+{
+	/* not implemented */
+	return -EINVAL;
+}
+
+/*
+ * Open B channel
+ * Called by "do_action" in ev-layer.c
+ */
+static int gigaset_init_bchannel(struct bc_state *bcs)
+{
+	/* nothing to do for M10x */
+	gigaset_bchannel_up(bcs);
+	return 0;
+}
+
+/*
+ * Close B channel
+ * Called by "do_action" in ev-layer.c
+ */
+static int gigaset_close_bchannel(struct bc_state *bcs)
+{
+	/* nothing to do for M10x */
+	gigaset_bchannel_down(bcs);
+	return 0;
+}
+
+/*
+ * Set up B channel structure
+ * This is called by "gigaset_initcs" in common.c
+ */
+static int gigaset_initbcshw(struct bc_state *bcs)
+{
+	/* unused */
+	bcs->hw.ser = NULL;
+	return 1;
+}
+
+/*
+ * Free B channel structure
+ * Called by "gigaset_freebcs" in common.c
+ */
+static int gigaset_freebcshw(struct bc_state *bcs)
+{
+	/* unused */
+	return 1;
+}
+
+/*
+ * Reinitialize B channel structure
+ * This is called by "bcs_reinit" in common.c
+ */
+static void gigaset_reinitbcshw(struct bc_state *bcs)
+{
+	/* nothing to do for M10x */
+}
+
+/*
+ * Free hardware specific device data
+ * This will be called by "gigaset_freecs" in common.c
+ */
+static void gigaset_freecshw(struct cardstate *cs)
+{
+	tasklet_kill(&cs->write_tasklet);
+	if (!cs->hw.ser)
+		return;
+	dev_set_drvdata(&cs->hw.ser->dev.dev, NULL);
+	platform_device_unregister(&cs->hw.ser->dev);
+	kfree(cs->hw.ser);
+	cs->hw.ser = NULL;
+}
+
+static void gigaset_device_release(struct device *dev)
+{
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+
+	/* adapted from platform_device_release() in drivers/base/platform.c */
+	//FIXME is this actually necessary?
+	kfree(dev->platform_data);
+	kfree(pdev->resource);
+}
+
+/*
+ * Set up hardware specific device data
+ * This is called by "gigaset_initcs" in common.c
+ */
+static int gigaset_initcshw(struct cardstate *cs)
+{
+	int rc;
+
+	if (!(cs->hw.ser = kzalloc(sizeof(struct ser_cardstate), GFP_KERNEL))) {
+		err("%s: out of memory!", __func__);
+		return 0;
+	}
+
+	cs->hw.ser->dev.name = GIGASET_MODULENAME;
+	cs->hw.ser->dev.id = cs->minor_index;
+	cs->hw.ser->dev.dev.release = gigaset_device_release;
+	if ((rc = platform_device_register(&cs->hw.ser->dev)) != 0) {
+		err("error %d registering platform device", rc);
+		kfree(cs->hw.ser);
+		cs->hw.ser = NULL;
+		return 0;
+	}
+	dev_set_drvdata(&cs->hw.ser->dev.dev, cs);
+
+	tasklet_init(&cs->write_tasklet,
+	             &gigaset_modem_fill, (unsigned long) cs);
+	return 1;
+}
+
+/*
+ * set modem control lines
+ * Parameters:
+ *	card state structure
+ *	modem control line state ([TIOCM_DTR]|[TIOCM_RTS])
+ * Called by "gigaset_start" and "gigaset_enterconfigmode" in common.c
+ * and by "if_lock" and "if_termios" in interface.c
+ */
+static int gigaset_set_modem_ctrl(struct cardstate *cs, unsigned old_state, unsigned new_state)
+{
+	struct tty_struct *tty = cs->hw.ser->tty;
+	unsigned int set, clear;
+
+	if (!tty || !tty->driver || !tty->driver->tiocmset)
+		return -EFAULT;
+	set = new_state & ~old_state;
+	clear = old_state & ~new_state;
+	if (!set && !clear)
+		return 0;
+	gig_dbg(DEBUG_IF, "tiocmset set %x clear %x", set, clear);
+	return tty->driver->tiocmset(tty, NULL, set, clear);
+}
+
+static int gigaset_baud_rate(struct cardstate *cs, unsigned cflag)
+{
+	return -EINVAL;
+}
+
+static int gigaset_set_line_ctrl(struct cardstate *cs, unsigned cflag)
+{
+	return -EINVAL;
+}
+
+static struct gigaset_ops ops = {
+	gigaset_write_cmd,
+	gigaset_write_room,
+	gigaset_chars_in_buffer,
+	gigaset_brkchars,
+	gigaset_init_bchannel,
+	gigaset_close_bchannel,
+	gigaset_initbcshw,
+	gigaset_freebcshw,
+	gigaset_reinitbcshw,
+	gigaset_initcshw,
+	gigaset_freecshw,
+	gigaset_set_modem_ctrl,
+	gigaset_baud_rate,
+	gigaset_set_line_ctrl,
+	gigaset_m10x_send_skb,	/* asyncdata.c */
+	gigaset_m10x_input,	/* asyncdata.c */
+};
+
+
+/* Line Discipline Interface */
+/* ========================= */
+
+/* helper functions for cardstate refcounting */
+static struct cardstate *cs_get(struct tty_struct *tty)
+{
+	struct cardstate *cs = tty->disc_data;
+
+	if (!cs || !cs->hw.ser) {
+		gig_dbg(DEBUG_ANY, "%s: no cardstate", __func__);
+		return NULL;
+	}
+	atomic_inc(&cs->hw.ser->refcnt);
+	return cs;
+}
+
+static void cs_put(struct cardstate *cs)
+{
+	if (atomic_dec_and_test(&cs->hw.ser->refcnt))
+		mutex_unlock(&cs->hw.ser->dead_mutex);
+}
+
+/*
+ * Called by the tty driver when the line discipline is pushed onto the tty.
+ * Called in process context.
+ */
+static int
+gigaset_tty_open(struct tty_struct *tty)
+{
+	struct cardstate *cs;
+
+	gig_dbg(DEBUG_INIT, "Starting HLL for Gigaset M101");
+
+	info(DRIVER_AUTHOR);
+	info(DRIVER_DESC);
+
+	if (!driver) {
+		err("%s: no driver structure", __func__);
+		return -ENODEV;
+	}
+
+	/* allocate memory for our device state and intialize it */
+	if (!(cs = gigaset_initcs(driver, 1, 1, 0, cidmode,
+				  GIGASET_MODULENAME)))
+		goto error;
+
+	cs->dev = &cs->hw.ser->dev.dev;
+	cs->hw.ser->tty = tty;
+	mutex_init(&cs->hw.ser->dead_mutex);
+	atomic_set(&cs->hw.ser->refcnt, 1);
+
+	tty->disc_data = cs;
+
+	/* OK.. Initialization of the datastructures and the HW is done.. Now
+	 * startup system and notify the LL that we are ready to run
+	 */
+	if (startmode == SM_LOCKED)
+		atomic_set(&cs->mstate, MS_LOCKED);
+	if (!gigaset_start(cs)) {
+		tasklet_kill(&cs->write_tasklet);
+		goto error;
+	}
+
+	gig_dbg(DEBUG_INIT, "Startup of HLL done");
+	mutex_lock(&cs->hw.ser->dead_mutex);
+	return 0;
+
+error:
+	gig_dbg(DEBUG_INIT, "Startup of HLL failed");
+	tty->disc_data = NULL;
+	gigaset_freecs(cs);
+	return -ENODEV;
+}
+
+/*
+ * Called by the tty driver when the line discipline is removed.
+ * Called from process context.
+ */
+static void
+gigaset_tty_close(struct tty_struct *tty)
+{
+	struct cardstate *cs = tty->disc_data;
+
+	gig_dbg(DEBUG_INIT, "Stopping HLL for Gigaset M101");
+
+	if (!cs) {
+		gig_dbg(DEBUG_INIT, "%s: no cardstate", __func__);
+		return;
+	}
+
+	/* prevent other callers from entering ldisc methods */
+	tty->disc_data = NULL;
+
+	if (!cs->hw.ser)
+		err("%s: no hw cardstate", __func__);
+	else {
+		/* wait for running methods to finish */
+		if (!atomic_dec_and_test(&cs->hw.ser->refcnt))
+			mutex_lock(&cs->hw.ser->dead_mutex);
+	}
+
+	/* stop operations */
+	gigaset_stop(cs);
+	tasklet_kill(&cs->write_tasklet);
+	flush_send_queue(cs);
+	cs->dev = NULL;
+	gigaset_freecs(cs);
+
+	gig_dbg(DEBUG_INIT, "Shutdown of HLL done");
+}
+
+/*
+ * Called by the tty driver when the tty line is hung up.
+ * Wait for I/O to driver to complete and unregister ISDN device.
+ * This is already done by the close routine, so just call that.
+ * Called from process context.
+ */
+static int gigaset_tty_hangup(struct tty_struct *tty)
+{
+	gigaset_tty_close(tty);
+	return 0;
+}
+
+/*
+ * Read on the tty.
+ * Unused, received data goes only to the Gigaset driver.
+ */
+static ssize_t
+gigaset_tty_read(struct tty_struct *tty, struct file *file,
+		 unsigned char __user *buf, size_t count)
+{
+	return -EAGAIN;
+}
+
+/*
+ * Write on the tty.
+ * Unused, transmit data comes only from the Gigaset driver.
+ */
+static ssize_t
+gigaset_tty_write(struct tty_struct *tty, struct file *file,
+		  const unsigned char *buf, size_t count)
+{
+	return -EAGAIN;
+}
+
+/*
+ * Ioctl on the tty.
+ * Called in process context only.
+ * May be re-entered by multiple ioctl calling threads.
+ */
+static int
+gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
+		  unsigned int cmd, unsigned long arg)
+{
+	struct cardstate *cs = cs_get(tty);
+	int rc, val;
+	int __user *p = (int __user *)arg;
+
+	if (!cs)
+		return -ENXIO;
+
+	switch (cmd) {
+	case TCGETS:
+	case TCGETA:
+		/* pass through to underlying serial device */
+		rc = n_tty_ioctl(tty, file, cmd, arg);
+		break;
+
+	case TCFLSH:
+		/* flush our buffers and the serial port's buffer */
+		switch (arg) {
+		case TCIFLUSH:
+			/* no own input buffer to flush */
+			break;
+		case TCIOFLUSH:
+		case TCOFLUSH:
+			flush_send_queue(cs);
+			break;
+		}
+		/* flush the serial port's buffer */
+		rc = n_tty_ioctl(tty, file, cmd, arg);
+		break;
+
+	case FIONREAD:
+		/* unused, always return zero */
+		val = 0;
+		rc = put_user(val, p);
+		break;
+
+	default:
+		rc = -ENOIOCTLCMD;
+	}
+
+	cs_put(cs);
+	return rc;
+}
+
+/*
+ * Poll on the tty.
+ * Unused, always return zero.
+ */
+static unsigned int
+gigaset_tty_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
+{
+	return 0;
+}
+
+/*
+ * Called by the tty driver when a block of data has been received.
+ * Will not be re-entered while running but other ldisc functions
+ * may be called in parallel.
+ * Can be called from hard interrupt level as well as soft interrupt
+ * level or mainline.
+ * Parameters:
+ *	tty	tty structure
+ *	buf	buffer containing received characters
+ *	cflags	buffer containing error flags for received characters (ignored)
+ *	count	number of received characters
+ */
+static void
+gigaset_tty_receive(struct tty_struct *tty, const unsigned char *buf,
+		    char *cflags, int count)
+{
+	struct cardstate *cs = cs_get(tty);
+	unsigned tail, head, n;
+	struct inbuf_t *inbuf;
+
+	if (!cs)
+		return;
+	if (!(inbuf = cs->inbuf)) {
+		dev_err(cs->dev, "%s: no inbuf\n", __func__);
+		cs_put(cs);
+		return;
+	}
+
+	tail = atomic_read(&inbuf->tail);
+	head = atomic_read(&inbuf->head);
+	gig_dbg(DEBUG_INTR, "buffer state: %u -> %u, receive %u bytes",
+		head, tail, count);
+
+	if (head <= tail) {
+		/* possible buffer wraparound */
+		n = min_t(unsigned, count, RBUFSIZE - tail);
+		memcpy(inbuf->data + tail, buf, n);
+		tail = (tail + n) % RBUFSIZE;
+		buf += n;
+		count -= n;
+	}
+
+	if (count > 0) {
+		/* tail < head and some data left */
+		n = head - tail - 1;
+		if (count > n) {
+			dev_err(cs->dev,
+				"inbuf overflow, discarding %d bytes\n",
+				count - n);
+			count = n;
+		}
+		memcpy(inbuf->data + tail, buf, count);
+		tail += count;
+	}
+
+	gig_dbg(DEBUG_INTR, "setting tail to %u", tail);
+	atomic_set(&inbuf->tail, tail);
+
+	/* Everything was received .. Push data into handler */
+	gig_dbg(DEBUG_INTR, "%s-->BH", __func__);
+	gigaset_schedule_event(cs);
+	cs_put(cs);
+}
+
+/*
+ * Called by the tty driver when there's room for more data to send.
+ */
+static void
+gigaset_tty_wakeup(struct tty_struct *tty)
+{
+	struct cardstate *cs = cs_get(tty);
+
+	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+	if (!cs)
+		return;
+	tasklet_schedule(&cs->write_tasklet);
+	cs_put(cs);
+}
+
+static struct tty_ldisc gigaset_ldisc = {
+	.owner		= THIS_MODULE,
+	.magic		= TTY_LDISC_MAGIC,
+	.name		= "ser_gigaset",
+	.open		= gigaset_tty_open,
+	.close		= gigaset_tty_close,
+	.hangup		= gigaset_tty_hangup,
+	.read		= gigaset_tty_read,
+	.write		= gigaset_tty_write,
+	.ioctl		= gigaset_tty_ioctl,
+	.poll		= gigaset_tty_poll,
+	.receive_buf	= gigaset_tty_receive,
+	.write_wakeup	= gigaset_tty_wakeup,
+};
+
+
+/* Initialization / Shutdown */
+/* ========================= */
+
+static int __init ser_gigaset_init(void)
+{
+	int rc;
+
+	gig_dbg(DEBUG_INIT, "%s", __func__);
+	if ((rc = platform_driver_register(&device_driver)) != 0) {
+		err("error %d registering platform driver", rc);
+		return rc;
+	}
+
+	/* allocate memory for our driver state and intialize it */
+	if (!(driver = gigaset_initdriver(GIGASET_MINOR, GIGASET_MINORS,
+					  GIGASET_MODULENAME, GIGASET_DEVNAME,
+					  &ops, THIS_MODULE)))
+		goto error;
+
+	if ((rc = tty_register_ldisc(N_GIGASET_M101, &gigaset_ldisc)) != 0) {
+		err("error %d registering line discipline", rc);
+		goto error;
+	}
+
+	return 0;
+
+error:
+	if (driver) {
+		gigaset_freedriver(driver);
+		driver = NULL;
+	}
+	platform_driver_unregister(&device_driver);
+	return rc;
+}
+
+static void __exit ser_gigaset_exit(void)
+{
+	int rc;
+
+	gig_dbg(DEBUG_INIT, "%s", __func__);
+
+	if (driver) {
+		gigaset_freedriver(driver);
+		driver = NULL;
+	}
+
+	if ((rc = tty_unregister_ldisc(N_GIGASET_M101)) != 0)
+		err("error %d unregistering line discipline", rc);
+
+	platform_driver_unregister(&device_driver);
+}
+
+module_init(ser_gigaset_init);
+module_exit(ser_gigaset_exit);
diff -puN include/linux/gigaset_dev.h~drivers-isdn-gigaset-new-m101-driver-v2 include/linux/gigaset_dev.h
--- a/include/linux/gigaset_dev.h~drivers-isdn-gigaset-new-m101-driver-v2
+++ a/include/linux/gigaset_dev.h
@@ -9,8 +9,6 @@
  *    published by the Free Software Foundation; either version 2 of
  *    the License, or (at your option) any later version.
  * =====================================================================
- * Version: $Id: gigaset_dev.h,v 1.4.4.4 2005/11/21 22:28:09 hjlipp Exp $
- * =====================================================================
  */
 
 #ifndef GIGASET_INTERFACE_H
_

Patches currently in -mm which might be from tilman@imap.cc are

char-tty_wakeup-cleanup.patch
consolidate-line-discipline-number-definitions-v2.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
fix-sparse-warnings-from-asmnet-checksumh.patch
drivers-isdn-gigaset-reduce-mutex-scope.patch
drivers-isdn-gigaset-reduce-kernel-message-spam.patch
drivers-isdn-gigaset-new-m101-driver-v2.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
