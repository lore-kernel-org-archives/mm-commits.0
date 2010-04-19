From: akpm@linux-foundation.org
Subject: + w1-w1-temp-fix-negative-termperature-calculation.patch added to -mm tree
Date: Mon, 19 Apr 2010 16:38:23 -0700
Message-ID: <201004192338.o3JNcN0v016448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645Ab0DSXjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 19:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian@beware.dropbear.id.au, johnpol@2ka.mipt.ru, kelfe@gmx.de, stable@kernel.org


The patch titled
     w1: w1 temp: fix negative termperature calculation
has been added to the -mm tree.  Its filename is
     w1-w1-temp-fix-negative-termperature-calculation.patch

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
Subject: w1: w1 temp: fix negative termperature calculation
From: Ian Dall <ian@beware.dropbear.id.au>

Fix regression caused by commit 507e2fbaaacb6f164b4125b87c5002f95143174b
("w1: w1 temp calculation overflow fix") whereby negative temperatures for
the DS18B20 are not converted properly.

When the temperature exceeds 32767 milli-degrees the temperature overflows
to -32768 millidegrees.  These are both well within the -55 - +125 degree
range for the sensor.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=12646

Signed-of-by: Ian Dall <ian@beware.dropbear.id.au>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Tested-by: Karsten Elfenbein <kelfe@gmx.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1-w1-temp-fix-negative-termperature-calculation drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-w1-temp-fix-negative-termperature-calculation
+++ a/drivers/w1/slaves/w1_therm.c
@@ -115,9 +115,8 @@ static struct w1_therm_family_converter 
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	int t = ((s16)rom[1] << 8) | rom[0];
-	t = t*1000/16;
-	return t;
+	s16 t = le16_to_cpup((__le16 *)rom);
+	return t*1000/16;
 }
 
 static inline int w1_DS18S20_convert_temp(u8 rom[9])
_

Patches currently in -mm which might be from ian@beware.dropbear.id.au are

w1-w1-temp-fix-negative-termperature-calculation.patch

