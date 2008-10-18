From: akpm@linux-foundation.org
Subject: - w1-ds2490c-reset-ds2490-in-init.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:16 -0700
Message-ID: <200810182320.m9INKGnj029704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbYJRXUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: ds2490.c reset ds2490 in init
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-reset-ds2490-in-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: ds2490.c reset ds2490 in init
From: David Fries <david@fries.net>

Reset the device in init as it can be in a bad state.  This is necessary
because a block write will wait for data to be placed in the output buffer
and block any later commands which will keep accumulating and the device
will not be idle.  Another case is removing the ds2490 module while a bus
search is in progress, somehow a few commands get through, but the input
transfers fail leaving data in the input buffer.  This will cause the next
read to fail see the note in ds_recv_data.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-reset-ds2490-in-init drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-reset-ds2490-in-init
+++ a/drivers/w1/masters/ds2490.c
@@ -316,6 +316,15 @@ static int ds_recv_data(struct ds_device
 	int count, err;
 	struct ds_status st;
 
+	/* Careful on size.  If size is less than what is available in
+	 * the input buffer, the device fails the bulk transfer and
+	 * clears the input buffer.  It could read the maximum size of
+	 * the data buffer, but then do you return the first, last, or
+	 * some set of the middle size bytes?  As long as the rest of
+	 * the code is correct there will be size bytes waiting.  A
+	 * call to ds_wait_status will wait until the device is idle
+	 * and any data to be received would have been available.
+	 */
 	count = 0;
 	err = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_DATA_IN]),
 				buf, size, &count, 1000);
@@ -824,6 +833,18 @@ static int ds_w1_init(struct ds_device *
 {
 	memset(&dev->master, 0, sizeof(struct w1_bus_master));
 
+	/* Reset the device as it can be in a bad state.
+	 * This is necessary because a block write will wait for data
+	 * to be placed in the output buffer and block any later
+	 * commands which will keep accumulating and the device will
+	 * not be idle.  Another case is removing the ds2490 module
+	 * while a bus search is in progress, somehow a few commands
+	 * get through, but the input transfers fail leaving data in
+	 * the input buffer.  This will cause the next read to fail
+	 * see the note in ds_recv_data.
+	 */
+	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+
 	dev->master.data	= dev;
 	dev->master.touch_bit	= &ds9490r_touch_bit;
 	/* read_bit and write_bit in w1_bus_master are expected to set and
_

Patches currently in -mm which might be from david@fries.net are

origin.patch

