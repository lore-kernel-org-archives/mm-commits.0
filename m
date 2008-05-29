From: akpm@linux-foundation.org
Subject: + atmel_serial-filter-out-fp-during-baud-rate-detection.patch added to -mm tree
Date: Wed, 28 May 2008 17:28:03 -0700
Message-ID: <200805290028.m4T0S3Ud007941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbYE2A2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 20:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, linux@maxim.org.za


The patch titled
     atmel_serial: filter out FP during baud rate detection
has been added to the -mm tree.  Its filename is
     atmel_serial-filter-out-fp-during-baud-rate-detection.patch

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
Subject: atmel_serial: filter out FP during baud rate detection
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

I made a change to u-boot that used the FP (Fractional Part) field of BRGR
to achieve more accurate baud rate generation.  Unfortunately, the
atmel_serial driver looks at the whole BRGR register when trying to detect
the baud rate that the port is currently running at, so setting FP to a
nonzero value breaks the baud rate detection.

I'll sit on the u-boot patch for a while longer, but this is clearly a
bug in the atmel_serial driver which should be fixed.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-filter-out-fp-during-baud-rate-detection drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-filter-out-fp-during-baud-rate-detection
+++ a/drivers/serial/atmel_serial.c
@@ -1318,7 +1318,7 @@ static void __init atmel_console_get_opt
 	 * If the baud rate generator isn't running, the port wasn't
 	 * initialized by the boot loader.
 	 */
-	quot = UART_GET_BRGR(port);
+	quot = UART_GET_BRGR(port) & ATMEL_US_CD;
 	if (!quot)
 		return;
 
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

linux-next.patch
atmel_serial-filter-out-fp-during-baud-rate-detection.patch

