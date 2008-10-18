From: akpm@linux-foundation.org
Subject: - w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:09 -0700
Message-ID: <200810182320.m9INK9qV029677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbYJRXUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: ds2490.c ds_write_bit, grouping error, disable readback
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: ds2490.c ds_write_bit, grouping error, disable readback
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

origin.patch

