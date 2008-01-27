From: akpm@linux-foundation.org
Subject: + w1-w1_thermc-standardize-units-to-millidegrees-c.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:13:44 -0800
Message-ID: <200801270513.m0R5Dfi2030945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbYA0FN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:13:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: w1_therm.c standardize units to millidegrees C
has been added to the -mm tree.  Its filename is
     w1-w1_thermc-standardize-units-to-millidegrees-c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: w1_therm.c standardize units to millidegrees C
From: David Fries <david@fries.net>

Standardize the temperature units to millidegrees C for the two sensor
conversion routines.  Previously the routines were,

w1_DS18B20_convert_temp degrees C
w1_DS18S20_convert_temp millidegrees C

Unfortunately this will break any program using the ds18b20 value as it
will now be 1000 times bigger.  Fortunately there can't be that many users
out there, or some of these bugs will have been fixed by now, such as the
negative C error (see previous patch) that makes me think the ds18b20 is
the better choice to change because of the current bugs.

Signed-off-by: David Fries <david@fries.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1-w1_thermc-standardize-units-to-millidegrees-c drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-w1_thermc-standardize-units-to-millidegrees-c
+++ a/drivers/w1/slaves/w1_therm.c
@@ -92,6 +92,7 @@ struct w1_therm_family_converter
 	int			(*convert)(u8 rom[9]);
 };
 
+/* The return value is millidegrees Centigrade. */
 static inline int w1_DS18B20_convert_temp(u8 rom[9]);
 static inline int w1_DS18S20_convert_temp(u8 rom[9]);
 
@@ -113,7 +114,7 @@ static struct w1_therm_family_converter 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
 	s16 t = (rom[1] << 8) | rom[0];
-	t /= 16;
+	t = t*1000/16;
 	return t;
 }
 
_

Patches currently in -mm which might be from david@fries.net are

w1-w1_thermc-ds18b20-decode-freezing-temperatures-correctly.patch
w1-w1_thermc-is-flagging-0c-etc-as-invalid.patch
system-timer-fix-crash-in-100hz-system-timer.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
w1-w1_thermc-standardize-units-to-millidegrees-c.patch
