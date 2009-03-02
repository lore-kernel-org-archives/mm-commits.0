From: akpm@linux-foundation.org
Subject: [merged] w1_ds2433-clear-the-validcrc-flag-after-a-write.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:22:49 -0800
Message-ID: <200903021922.n22JMno1014343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757980AbZCBTXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:23:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gardner.ben@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1_ds2433: clear the validcrc flag after a write
has been removed from the -mm tree.  Its filename was
     w1_ds2433-clear-the-validcrc-flag-after-a-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1_ds2433: clear the validcrc flag after a write
From: Ben Gardner <gardner.ben@gmail.com>

The w1_ds2433 driver does not read from the hardware if the CRC was valid
on the last read.  The validcrc flag should be cleared after a write so
that the new value can be read.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2433.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_ds2433.c~w1_ds2433-clear-the-validcrc-flag-after-a-write drivers/w1/slaves/w1_ds2433.c
--- a/drivers/w1/slaves/w1_ds2433.c~w1_ds2433-clear-the-validcrc-flag-after-a-write
+++ a/drivers/w1/slaves/w1_ds2433.c
@@ -156,6 +156,9 @@ out_up:
  */
 static int w1_f23_write(struct w1_slave *sl, int addr, int len, const u8 *data)
 {
+#ifdef CONFIG_W1_SLAVE_DS2433_CRC
+	struct w1_f23_data *f23 = sl->family_data;
+#endif
 	u8 wrbuf[4];
 	u8 rdbuf[W1_PAGE_SIZE + 3];
 	u8 es = (addr + len - 1) & 0x1f;
@@ -196,7 +199,9 @@ static int w1_f23_write(struct w1_slave 
 
 	/* Reset the bus to wake up the EEPROM (this may not be needed) */
 	w1_reset_bus(sl->master);
