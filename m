From: akpm@linux-foundation.org
Subject: - usb_gigaset-suspend-support.patch removed from -mm tree
Date: Tue, 06 Nov 2007 13:22:10 -0800
Message-ID: <200711062022.lA6KM8w2007838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbXKFUWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 15:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     usb_gigaset: suspend support
has been removed from the -mm tree.  Its filename was
     usb_gigaset-suspend-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: usb_gigaset: suspend support
From: Tilman Schmidt <tilman@imap.cc>

The following two patches add minimal suspend/resume support to the USB based
Gigaset ISDN drivers, bas_gigaset and usb_gigaset.  Only the USB aspects are
handled so far; the ISDN subsystem is not notified in any way, for lack of
information about how to do that.

The base driver (bas_gigaset) will not close an open ISDN connection, but
refuse to suspend if a connection is active.  The M105 driver (usb_gigaset)
ignores active connections, so as the device is powered from USB, any
connection will drop when the USB port is powered down.  These are policy
decisions and as such open to discussion.

This code survives a "test mode" STD without any ill effects.  I could not
test a "real" suspend/resume cycle yet because so far I do not have any test
machine with working suspend.



This patch:

Add basic suspend/resume support to the usb_gigaset driver.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/usb-gigaset.c |   78 ++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/gigaset/usb-gigaset.c~usb_gigaset-suspend-support drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~usb_gigaset-suspend-support
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -104,10 +104,16 @@ MODULE_DEVICE_TABLE(usb, gigaset_table);
  * flags per packet.
  */
 
+/* functions called if a device of this driver is connected/disconnected */
 static int gigaset_probe(struct usb_interface *interface,
 			 const struct usb_device_id *id);
 static void gigaset_disconnect(struct usb_interface *interface);
 
+/* functions called before/after suspend */
+static int gigaset_suspend(struct usb_interface *intf, pm_message_t message);
+static int gigaset_resume(struct usb_interface *intf);
+static int gigaset_pre_reset(struct usb_interface *intf);
+
 static struct gigaset_driver *driver = NULL;
 static struct cardstate *cardstate = NULL;
 
@@ -117,6 +123,11 @@ static struct usb_driver gigaset_usb_dri
 	.probe =	gigaset_probe,
 	.disconnect =	gigaset_disconnect,
 	.id_table =	gigaset_table,
+	.suspend =	gigaset_suspend,
+	.resume =	gigaset_resume,
+	.reset_resume =	gigaset_resume,
+	.pre_reset =	gigaset_pre_reset,
+	.post_reset =	gigaset_resume,
 };
 
 struct usb_cardstate {
@@ -831,7 +842,7 @@ static void gigaset_disconnect(struct us
 	usb_set_intfdata(interface, NULL);
 	tasklet_kill(&cs->write_tasklet);
 
-	usb_kill_urb(ucs->bulk_out_urb);	/* FIXME: only if active? */
+	usb_kill_urb(ucs->bulk_out_urb);
 
 	kfree(ucs->bulk_out_buffer);
 	usb_free_urb(ucs->bulk_out_urb);
@@ -847,6 +858,71 @@ static void gigaset_disconnect(struct us
 	gigaset_unassign(cs);
 }
 
+/* gigaset_suspend
+ * This function is called before the USB connection is suspended or reset.
+ */
+static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct cardstate *cs;
+	struct usb_cardstate *ucs;
+
+	if ((cs = usb_get_intfdata(intf)) == NULL ||
+	    (ucs = cs->hw.usb) == NULL) {
+		err("%s: no cardstate", __func__);
+		return -EFAULT;
+	}
+
+	//FIXME stop common module activities? ISDN_STAT_STOP? block open()?
+
+	/* stop submitting bulk URBs */
+	tasklet_disable(&cs->write_tasklet);
+
+	/* kill pending read URB */
+	usb_kill_urb(ucs->read_urb);
+
+	gig_dbg(DEBUG_INIT, "suspend complete");
+	return 0;
+}
+
+/* gigaset_resume
+ * This function is called after the USB connection has been resumed or reset.
+ */
+static int gigaset_resume(struct usb_interface *intf)
+{
+	struct cardstate *cs;
+	struct usb_cardstate *ucs;
+	int rc;
+
+	if ((cs = usb_get_intfdata(intf)) == NULL ||
+	    (ucs = cs->hw.usb) == NULL) {
+		err("%s: no cardstate", __func__);
+		return -EFAULT;
+	}
+
+	/* resubmit interrupt URB */
+	if ((rc = usb_submit_urb(ucs->read_urb, GFP_KERNEL)) != 0) {
+		dev_err(cs->dev, "Could not submit URB (error %d)\n", -rc);
+		return rc;
+	}
+
+	/* restart submission of bulk URBs */
+	tasklet_enable(&cs->write_tasklet);
+
+	//FIXME restart common m. activities? ISDN_STAT_START? unblock open()?
+
+	gig_dbg(DEBUG_INIT, "resume complete");
+	return 0;
+}
+
+/* gigaset_pre_reset
+ * This function is called before the USB connection is reset.
+ */
+static int gigaset_pre_reset(struct usb_interface *intf)
+{
+	/* same as suspend */
+	return gigaset_suspend(intf, PMSG_ON);
+}
+
 static const struct gigaset_ops ops = {
 	gigaset_write_cmd,
 	gigaset_write_room,
_

Patches currently in -mm which might be from tilman@imap.cc are

usb_gigaset-suspend-support.patch
bas_gigaset-suspend-support.patch
bas_gigaset-suspend-support-fix.patch
