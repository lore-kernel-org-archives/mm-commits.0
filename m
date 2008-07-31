From: akpm@linux-foundation.org
Subject: - w1-w1_ioc-reset-comments-and-msleep.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:02:05 -0700
Message-ID: <200807310302.m6V325KS000521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724AbYGaDD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:03:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: w1_io.c reset comments and msleep
has been removed from the -mm tree.  Its filename was
     w1-w1_ioc-reset-comments-and-msleep.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: w1_io.c reset comments and msleep
From: David Fries <david@fries.net>

w1_reset_bus, added some comments about the timing and switched to msleep
for the later delay.  I don't have the hardware to test the sleep after
reset change.  The one wire doesn't have a timing = requirement between
commands so it is fine.  I do have the USB = hardware and it would be in
big trouble with 10ms interrupt trans= fers to find that the reset
completed.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_io.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/w1/w1_io.c~w1-w1_ioc-reset-comments-and-msleep drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~w1-w1_ioc-reset-comments-and-msleep
+++ a/drivers/w1/w1_io.c
@@ -293,12 +293,24 @@ int w1_reset_bus(struct w1_master *dev)
 		result = dev->bus_master->reset_bus(dev->bus_master->data) & 0x1;
 	else {
 		dev->bus_master->write_bit(dev->bus_master->data, 0);
+		/* minimum 480, max ? us
+		 * be nice and sleep, except 18b20 spec lists 960us maximum,
+		 * so until we can sleep with microsecond accuracy, spin.
+		 * Feel free to come up with some other way to give up the
+		 * cpu for such a short amount of time AND get it back in
+		 * the maximum amount of time.
+		 */
 		w1_delay(480);
 		dev->bus_master->write_bit(dev->bus_master->data, 1);
 		w1_delay(70);
 
 		result = dev->bus_master->read_bit(dev->bus_master->data) & 0x1;
-		w1_delay(410);
+		/* minmum 70 (above) + 410 = 480 us
+		 * There aren't any timing requirements between a reset and
+		 * the following transactions.  Sleeping is safe here.
+		 */
+		/* w1_delay(410); min required time */
+		msleep(1);
 	}
 
 	return result;
_

Patches currently in -mm which might be from david@fries.net are

w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
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

