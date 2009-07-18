From: akpm@linux-foundation.org
Subject: + eeprom-at25-bugfix-not-ready-timeout-after-write.patch added to -mm tree
Date: Fri, 17 Jul 2009 17:35:51 -0700
Message-ID: <200907180035.n6I0Zp5Y011338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbZGRAgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 20:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heutling@who-ing.de, dbrownell@users.sourceforge.net


The patch titled
     eeprom/at25:  bugfix "not ready" timeout after write
has been added to the -mm tree.  Its filename is
     eeprom-at25-bugfix-not-ready-timeout-after-write.patch

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
Subject: eeprom/at25:  bugfix "not ready" timeout after write
From: Sebastian Heutling <heutling@who-ing.de>

Under certain circumstances msleep(1) within the loop, which waits for the
EEPROM to be finished, might take longer than the timeout.  On the next
loop the status register might now return to be ready and therefore the
loop finishes.  The following check now tests if a timeout occurred and if
so returns an error although the device reported it was ready.

This fix replaces testing the occurrence of the timeout by testing the
"not ready" bit in the status register.

Signed-off-by: Sebastian Heutling <heutling@who-ing.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/at25.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/eeprom/at25.c~eeprom-at25-bugfix-not-ready-timeout-after-write drivers/misc/eeprom/at25.c
--- a/drivers/misc/eeprom/at25.c~eeprom-at25-bugfix-not-ready-timeout-after-write
+++ a/drivers/misc/eeprom/at25.c
@@ -173,6 +173,7 @@ at25_ee_write(struct at25_data *at25, co
 		unsigned	segment;
 		unsigned	offset = (unsigned) off;
 		u8		*cp = bounce + 1;
+		int		sr;
 
 		*cp = AT25_WREN;
 		status = spi_write(at25->spi, cp, 1);
@@ -214,7 +215,6 @@ at25_ee_write(struct at25_data *at25, co
 		timeout = jiffies + msecs_to_jiffies(EE_TIMEOUT);
 		retries = 0;
 		do {
-			int	sr;
 
 			sr = spi_w8r8(at25->spi, AT25_RDSR);
 			if (sr < 0 || (sr & AT25_SR_nRDY)) {
@@ -228,7 +228,7 @@ at25_ee_write(struct at25_data *at25, co
 				break;
 		} while (retries++ < 3 || time_before_eq(jiffies, timeout));
 
-		if (time_after(jiffies, timeout)) {
+		if ((sr < 0) || (sr & AT25_SR_nRDY)) {
 			dev_err(&at25->spi->dev,
 				"write %d bytes offset %d, "
 				"timeout after %u msecs\n",
_

Patches currently in -mm which might be from heutling@who-ing.de are

eeprom-at25-bugfix-not-ready-timeout-after-write.patch

