From: akpm@linux-foundation.org
Subject: + w1_ds2433-clear-the-validcrc-flag-after-a-write.patch added to -mm tree
Date: Tue, 24 Feb 2009 13:13:05 -0800
Message-ID: <200902242113.n1OLD5gh011395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756943AbZBXVNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 16:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gardner.ben@gmail.com, johnpol@2ka.mipt.ru


The patch titled
     w1_ds2433: clear the validcrc flag after a write
has been added to the -mm tree.  Its filename is
     w1_ds2433-clear-the-validcrc-flag-after-a-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
