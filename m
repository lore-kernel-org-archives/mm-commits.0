From: akpm@linux-foundation.org
Subject: - w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:02:15 -0700
Message-ID: <200807310302.m6V32FNL000558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763243AbYGaDCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: ds2490.c ds_write_bit, grouping error, disable readback
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: ds2490.c ds_write_bit, grouping error, disable readback
From: David Fries <david@fries.net>

ds_write_bit doesn't read the input buffer, so add COMM_ICP and a comment
that it will no longer generate a read back data byte.  If there is an
extra data byte later on then it will cause an error and discard what data
was there.  Corrected operator ordering for ds_send_control.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-ds_write_bit-grouping-error-disable-readback drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-ds_write_bit-grouping-error-disable-readback
+++ a/drivers/w1/masters/ds2490.c
@@ -525,7 +525,12 @@ static int ds_write_bit(struct ds_device
 	int err;
 	struct ds_status st;
 
-	err = ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit) ? COMM_D : 0, 0);
+	/* Set COMM_ICP to write without a readback.  Note, this will
+	 * produce one time slot, a down followed by an up with COMM_D
+	 * only determing the timing.
+	 */
+	err = ds_send_control(dev, COMM_BIT_IO | COMM_IM | COMM_ICP |
+		(bit ? COMM_D : 0), 0);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from david@fries.net are

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
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch

