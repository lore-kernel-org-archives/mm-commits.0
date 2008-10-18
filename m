From: akpm@linux-foundation.org
Subject: - w1-ds2490c-simplify-and-fix-ds_touch_bit.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:12 -0700
Message-ID: <200810182320.m9INKCaZ029683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbYJRXUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: ds2490.c simplify and fix ds_touch_bit
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-simplify-and-fix-ds_touch_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
