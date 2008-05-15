From: akpm@linux-foundation.org
Subject: + wireless-airo-waitbusy-wont-delay.patch added to -mm tree
Date: Thu, 15 May 2008 14:16:28 -0700
Message-ID: <200805152116.m4FLGSre010952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbYEOVRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dcbw@redhat.com


The patch titled
     wireless, airo: waitbusy() won't delay
has been added to the -mm tree.  Its filename is
     wireless-airo-waitbusy-wont-delay.patch

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
Subject: wireless, airo: waitbusy() won't delay
From: Roel Kluin <roel.kluin@gmail.com>

There will be no delay even when COMMAND_BUSY (defined 0x8000) is set:
0x8000 & (delay < 10000) will evaluate to 0 - when delay is 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/airo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/airo.c~wireless-airo-waitbusy-wont-delay drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~wireless-airo-waitbusy-wont-delay
+++ a/drivers/net/wireless/airo.c
@@ -2904,7 +2904,7 @@ EXPORT_SYMBOL(init_airo_card);
 
 static int waitbusy (struct airo_info *ai) {
 	int delay = 0;
-	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) & (delay < 10000)) {
+	while ((IN4500 (ai, COMMAND) & COMMAND_BUSY) && (delay < 10000)) {
 		udelay (10);
 		if ((++delay % 20) == 0)
 			OUT4500(ai, EVACK, EV_CLEARCOMMANDBUSY);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

wireless-airo-waitbusy-wont-delay.patch

