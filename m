From: akpm@linux-foundation.org
Subject: + w1-export-w1_read_8-function.patch added to -mm tree
Date: Mon, 20 Oct 2008 16:06:34 -0700
Message-ID: <200810202306.m9KN6Y0b006288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYJTXGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 19:06:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: madhu.cr@ti.com, johnpol@2ka.mipt.ru


The patch titled
     w1: export w1_read_8 function
has been added to the -mm tree.  Its filename is
     w1-export-w1_read_8-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: export w1_read_8 function
From: Madhusudhan Chikkature <madhu.cr@ti.com>

Export the w1_read_8 function for use of drivers.  The OMAP HDQ
driver(drivers/w1/masters/omap_hdq.c) uses this function.

Signed-off-by: Madhusudhan Chikkature<madhu.cr@ti.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.h    |    1 +
 drivers/w1/w1_io.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/w1/w1.h~w1-export-w1_read_8-function drivers/w1/w1.h
--- a/drivers/w1/w1.h~w1-export-w1_read_8-function
+++ a/drivers/w1/w1.h
@@ -206,6 +206,7 @@ void w1_slave_detach(struct w1_slave *sl
 
 u8 w1_triplet(struct w1_master *dev, int bdir);
 void w1_write_8(struct w1_master *, u8);
+u8 w1_read_8(struct w1_master *);
 int w1_reset_bus(struct w1_master *);
 u8 w1_calc_crc8(u8 *, int);
 void w1_write_block(struct w1_master *, const u8 *, int);
diff -puN drivers/w1/w1_io.c~w1-export-w1_read_8-function drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~w1-export-w1_read_8-function
+++ a/drivers/w1/w1_io.c
@@ -217,7 +217,7 @@ u8 w1_triplet(struct w1_master *dev, int
  * @param dev     the master device
  * @return        the byte read
  */
-static u8 w1_read_8(struct w1_master * dev)
+u8 w1_read_8(struct w1_master * dev)
 {
 	int i;
 	u8 res = 0;
@@ -230,6 +230,7 @@ static u8 w1_read_8(struct w1_master * d
 
 	return res;
 }
+EXPORT_SYMBOL_GPL(w1_read_8);
 
 /**
  * Writes a series of bytes.
_

Patches currently in -mm which might be from madhu.cr@ti.com are

w1-export-w1_read_8-function.patch
hdq-driver-for-omap2430-3430.patch
hdq-bq27000-hdq-slave-interface-driver.patch
hdq-documentation-for-omap-hdq.patch

