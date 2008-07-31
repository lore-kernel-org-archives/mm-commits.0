From: akpm@linux-foundation.org
Subject: + w1-ds2490c-reset-ds2490-in-init.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:45 -0700
Message-ID: <200807310316.m6V3GjJ2001213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844AbYGaDSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: ds2490.c reset ds2490 in init
has been added to the -mm tree.  Its filename is
     w1-ds2490c-reset-ds2490-in-init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch

