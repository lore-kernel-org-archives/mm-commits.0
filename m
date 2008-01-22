From: akpm@linux-foundation.org
Subject: + w1-w1_thermc-is-flagging-0c-etc-as-invalid.patch added to -mm tree
Date: Mon, 21 Jan 2008 18:37:37 -0800
Message-ID: <200801220237.m0M2bIUo032647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781AbYAVCol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 21:44:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: w1_therm.c is flagging 0C etc as invalid
has been added to the -mm tree.  Its filename is
     w1-w1_thermc-is-flagging-0c-etc-as-invalid.patch

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
Subject: W1: w1_therm.c is flagging 0C etc as invalid
From: David Fries <david@fries.net>

The extra rom[0] check is flagging valid temperatures as invalid when
there is already a CRC data transmission check.

w1_therm_read_bin()
	if (rom[8] == crc && rom[0])
		verdict = 1;

Requiring rom[0] to be non-zero will flag as invalid temperature
conversions when the low byte is zero, specifically the temperatures 0C,
16C, 32C, 48C, -16C, -32C, and -48C.

The CRC check is produced on the device for the previous 8 bytes and is
required to ensure the data integrity in transmission.  I don't see why the
extra check for rom[0] being non-zero is in there.  Evgeniy Polyakov didn't
know either.  Just for a check I unplugged the sensor, executed a
temperature conversion, and read the results.  The read was all ff's, which
also failed the CRC, so it doesn't need to protect against a disconnected
sensor.

I have more extensive patches in the work, but these two trivial ones will
do for today.  I would like to hear from people who use the ds2490 USB to
one wire dongle.  1 if you would be willing to test the patches as I
currently only have the one sensor on a short parisite powered wire, 2 if
there is any cheap sources for the ds2490.

Signed-off-by: David Fries <david@fries.net>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1-w1_thermc-is-flagging-0c-etc-as-invalid drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-w1_thermc-is-flagging-0c-etc-as-invalid
+++ a/drivers/w1/slaves/w1_therm.c
@@ -204,7 +204,7 @@ static ssize_t w1_therm_read_bin(struct 
 
 				crc = w1_calc_crc8(rom, 8);
 
-				if (rom[8] == crc && rom[0])
+				if (rom[8] == crc)
 					verdict = 1;
 			}
 		}
_

Patches currently in -mm which might be from david@fries.net are

w1-w1_thermc-ds18b20-decode-freezing-temperatures-correctly.patch
w1-w1_thermc-is-flagging-0c-etc-as-invalid.patch
system-timer-fix-crash-in-100hz-system-timer.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
