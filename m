From: akpm@linux-foundation.org
Subject: + w1-w1_thermc-ds18b20-decode-freezing-temperatures-correctly.patch added to -mm tree
Date: Mon, 21 Jan 2008 18:37:34 -0800
Message-ID: <200801220237.m0M2bEx9032644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbYAVCq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 21:46:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: w1_therm.c ds18b20 decode freezing temperatures correctly
has been added to the -mm tree.  Its filename is
     w1-w1_thermc-ds18b20-decode-freezing-temperatures-correctly.patch

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
Subject: W1: w1_therm.c ds18b20 decode freezing temperatures correctly
From: David Fries <david@fries.net>

Correct the decoding of negative C temperatures.  The code did a binary OR
of two bytes to make a 16 bit value, but assignd it to an integer.  This
caused the value to not be sign extended and to loose that it was a
negative number in the assignment.

Before the patch (in my freezer),
w1_slave
ed fe 4b 46 7f ff 03 10 e4 : crc=e4 YES
ed fe 4b 46 7f ff 03 10 e4 t=4078
With the patch,
e3 fe 4b 46 7f ff 0d 10 81 : crc=81 YES
e3 fe 4b 46 7f ff 0d 10 81 t=-17

Signed-off-by: David Fries <david@fries.net>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1-w1_thermc-ds18b20-decode-freezing-temperatures-correctly drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-w1_thermc-ds18b20-decode-freezing-temperatures-correctly
+++ a/drivers/w1/slaves/w1_therm.c
@@ -112,7 +112,7 @@ static struct w1_therm_family_converter 
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	int t = (rom[1] << 8) | rom[0];
+	s16 t = (rom[1] << 8) | rom[0];
 	t /= 16;
 	return t;
 }
_

Patches currently in -mm which might be from david@fries.net are

w1-w1_thermc-ds18b20-decode-freezing-temperatures-correctly.patch
w1-w1_thermc-is-flagging-0c-etc-as-invalid.patch
system-timer-fix-crash-in-100hz-system-timer.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
