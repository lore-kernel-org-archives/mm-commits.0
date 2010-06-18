From: akpm@linux-foundation.org
Subject: + rtc-fix-ds1388-time-corruption.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:43:24 -0700
Message-ID: <201006182343.o5INhOlU030062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356Ab0FRXnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Joakim.Tjernlund@transmode.se, a.zummo@towertech.it, mcuos.com@gmail.com, p_gortmaker@yahoo.com, stable@kernel.org


The patch titled
     rtc: fix ds1388 time corruption
has been added to the -mm tree.  Its filename is
     rtc-fix-ds1388-time-corruption.patch

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
Subject: rtc: fix ds1388 time corruption
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

The ds1307 driver misreads the ds1388 registers when checking for 12 or 24
hour mode.  Instead of checking the hour register it reads the minute
register.  Therefore the driver thinks minutes >= 40 has the 12HR bit set
and resets the minute register by zeroing the high bits.  This results in
minutes are reset to 0-9, jumping back in time 40 or 50 minutes.  The time
jump is also written back to the RTC.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-fix-ds1388-time-corruption drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-fix-ds1388-time-corruption
+++ a/drivers/rtc/rtc-ds1307.c
@@ -777,7 +777,7 @@ static int __devinit ds1307_probe(struct
 
 read_rtc:
 	/* read RTC registers */
-	tmp = ds1307->read_block_data(ds1307->client, 0, 8, buf);
+	tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
 	if (tmp != 8) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;
@@ -862,7 +862,7 @@ read_rtc:
 		if (ds1307->regs[DS1307_REG_HOUR] & DS1307_BIT_PM)
 			tmp += 12;
 		i2c_smbus_write_byte_data(client,
-				DS1307_REG_HOUR,
+				ds1307->offset + DS1307_REG_HOUR,
 				bin2bcd(tmp));
 	}
 
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

rtc-fix-ds1388-time-corruption.patch

