From: akpm@linux-foundation.org
Subject: - usb_gigaset-suspend-support-v3.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:26 -0800
Message-ID: <200802070026.m170Q71K006857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41766 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933409AbYBGApu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tilman@imap.cc, gregkh@suse.de, hjlipp@web.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb_gigaset: suspend support
has been removed from the -mm tree.  Its filename was
     usb_gigaset-suspend-support-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb_gigaset: suspend support
From: Tilman Schmidt <tilman@imap.cc>

Add basic suspend/resume support to the usb_gigaset driver for the Siemens
Gigaset M105 USB DECT adapter.

Only the USB aspects are handled so far; the ISDN subsystem is not notified in
any way, for lack of information about how to do that.  The driver does not
check for active connections before suspending.  They will be dropped when the
device loses USB power.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/usb-gigaset.c |   56 +++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff -puN drivers/isdn/gigaset/usb-gigaset.c~usb_gigaset-suspend-support-v3 drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~usb_gigaset-suspend-support-v3
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -109,6 +109,11 @@ static int gigaset_probe(struct usb_inte
 			 const struct usb_device_id *id);
 static void gigaset_disconnect(struct usb_interface *interface);
 
+/* functions called before/after suspend */
+static int gigaset_suspend(struct usb_interface *intf, pm_message_t message);
+static int gigaset_resume(struct usb_interface *intf);
+static int gigaset_pre_reset(struct usb_interface *intf);
+
 static struct gigaset_driver *driver = NULL;
 static struct cardstate *cardstate = NULL;
 
@@ -118,6 +123,11 @@ static struct usb_driver gigaset_usb_dri
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
@@ -845,6 +855,52 @@ static void gigaset_disconnect(struct us
 	gigaset_unassign(cs);
 }
 
+/* gigaset_suspend
+ * This function is called before the USB connection is suspended or reset.
+ */
+static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct cardstate *cs = usb_get_intfdata(intf);
+
+	/* stop activity */
+	cs->connected = 0;	/* prevent rescheduling */
+	usb_kill_urb(cs->hw.usb->read_urb);
+	tasklet_kill(&cs->write_tasklet);
+	usb_kill_urb(cs->hw.usb->bulk_out_urb);
+
+	gig_dbg(DEBUG_SUSPEND, "suspend complete");
+	return 0;
+}
+
+/* gigaset_resume
+ * This function is called after the USB connection has been resumed or reset.
+ */
+static int gigaset_resume(struct usb_interface *intf)
+{
+	struct cardstate *cs = usb_get_intfdata(intf);
+	int rc;
+
+	/* resubmit interrupt URB */
+	cs->connected = 1;
+	rc = usb_submit_urb(cs->hw.usb->read_urb, GFP_KERNEL);
+	if (rc) {
+		dev_err(cs->dev, "Could not submit read URB (error %d)\n", -rc);
+		return rc;
+	}
+
+	gig_dbg(DEBUG_SUSPEND, "resume complete");
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

origin.patch
