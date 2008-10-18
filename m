From: akpm@linux-foundation.org
Subject: - w1-w1_ioc-reset-comments-and-msleep.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:04 -0700
Message-ID: <200810182320.m9INK45B029649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbYJRXUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: w1_io.c reset comments and msleep
has been removed from the -mm tree.  Its filename was
     w1-w1_ioc-reset-comments-and-msleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: w1_io.c reset comments and msleep
From: David Fries <david@fries.net>

w1_reset_bus, added some comments about the timing and switched to msleep
for the later delay.  I don't have the hardware to test the sleep after
reset change.  The one wire doesn't have a timing requirement between
commands so it is fine.  I do have the USB hardware and it would be in big
trouble with 10ms interrupt transfers to find that the reset completed.

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

origin.patch

