From: akpm@linux-foundation.org
Subject: + staging-rt2860-use-new-hex_to_bin-method.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:02:18 -0700
Message-ID: <201004301902.o3UJ2IME005917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762Ab0D3TCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, gregkh@suse.de


The patch titled
     staging: rt2860: use new hex_to_bin() method
has been added to the -mm tree.  Its filename is
     staging-rt2860-use-new-hex_to_bin-method.patch

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
Subject: staging: rt2860: use new hex_to_bin() method
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation involve hex_to_bin() function.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2860/common/rtmp_init.c |   15 ++-------------
 drivers/staging/rt2860/rtmp.h             |    2 --
 2 files changed, 2 insertions(+), 15 deletions(-)

diff -puN drivers/staging/rt2860/common/rtmp_init.c~staging-rt2860-use-new-hex_to_bin-method drivers/staging/rt2860/common/rtmp_init.c
--- a/drivers/staging/rt2860/common/rtmp_init.c~staging-rt2860-use-new-hex_to_bin-method
+++ a/drivers/staging/rt2860/common/rtmp_init.c
@@ -2810,17 +2810,6 @@ void UserCfgInit(struct rt_rtmp_adapter 
 }
 
 /* IRQL = PASSIVE_LEVEL */
-u8 BtoH(char ch)
-{
-	if (ch >= '0' && ch <= '9')
-		return (ch - '0');	/* Handle numerals */
-	if (ch >= 'A' && ch <= 'F')
-		return (ch - 'A' + 0xA);	/* Handle capitol hex digits */
-	if (ch >= 'a' && ch <= 'f')
-		return (ch - 'a' + 0xA);	/* Handle small hex digits */
-	return (255);
-}
-
 /* */
 /*  FUNCTION: AtoH(char *, u8 *, int) */
 /* */
@@ -2847,8 +2836,8 @@ void AtoH(char *src, u8 *dest, int destl
 	destTemp = (u8 *)dest;
 
 	while (destlen--) {
-		*destTemp = BtoH(*srcptr++) << 4;	/* Put 1st ascii byte in upper nibble. */
-		*destTemp += BtoH(*srcptr++);	/* Add 2nd ascii byte to above. */
+		*destTemp = hex_to_bin(*srcptr++) << 4;	/* Put 1st ascii byte in upper nibble. */
+		*destTemp += hex_to_bin(*srcptr++);	/* Add 2nd ascii byte to above. */
 		destTemp++;
 	}
 }
diff -puN drivers/staging/rt2860/rtmp.h~staging-rt2860-use-new-hex_to_bin-method drivers/staging/rt2860/rtmp.h
--- a/drivers/staging/rt2860/rtmp.h~staging-rt2860-use-new-hex_to_bin-method
+++ a/drivers/staging/rt2860/rtmp.h
@@ -2356,8 +2356,6 @@ void RTMPMoveMemory(void *pDest, void *p
 
 void AtoH(char *src, u8 *dest, int destlen);
 
-u8 BtoH(char ch);
