From: akpm@linux-foundation.org
Subject: + w1-ds2490c-simplify-and-fix-ds_touch_bit.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:39 -0700
Message-ID: <200807310316.m6V3Gda6001197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223AbYGaDRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: ds2490.c simplify and fix ds_touch_bit
has been added to the -mm tree.  Its filename is
     w1-ds2490c-simplify-and-fix-ds_touch_bit.patch

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
Subject: W1: ds2490.c simplify and fix ds_touch_bit
From: David Fries <david@fries.net>

Simplify and fix ds_touch_bit.  If a device is attached in the middle of a
bus search the status register will return more than the default 16 bytes.
 The additional bytes indicate that it has detected a new device.  The way
ds_wait_status is coded, if it doesn't read 16 status bytes it returns an
error value.  ds_touch_bit then will detect that error and return an
error.  In that case it doesn't read the input buffer and returns
uninitialized data.  It doesn't stop there.  The next transaction will not
expect the extra byte in the input buffer and the short read will cause an
error and clear out both the old byte and new data in the input buffer.

Just ignore the value of ds_wait_status.  It is still required to wait
until ds2490 is again idle and there is data to read when ds_recv_data is
called.  This also removes the while loop.  None of the other commands
wait and verify that the issued command is in the status register.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-simplify-and-fix-ds_touch_bit drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-simplify-and-fix-ds_touch_bit
+++ a/drivers/w1/masters/ds2490.c
@@ -490,28 +490,15 @@ static int ds_set_pullup(struct ds_devic
 
 static int ds_touch_bit(struct ds_device *dev, u8 bit, u8 *tbit)
 {
-	int err, count;
+	int err;
 	struct ds_status st;
-	u16 value = (COMM_BIT_IO | COMM_IM) | ((bit) ? COMM_D : 0);
-	u16 cmd;
 
-	err = ds_send_control(dev, value, 0);
+	err = ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit ? COMM_D : 0),
+		0);
 	if (err)
 		return err;
 
-	count = 0;
-	do {
-		err = ds_wait_status(dev, &st);
-		if (err)
-			return err;
-
-		cmd = st.command0 | (st.command1 << 8);
-	} while (cmd != value && ++count < 10);
-
-	if (err < 0 || count >= 10) {
-		printk(KERN_ERR "Failed to obtain status.\n");
-		return -EINVAL;
-	}
+	ds_wait_status(dev, &st);
 
 	err = ds_recv_data(dev, tbit, sizeof(*tbit));
 	if (err < 0)
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

