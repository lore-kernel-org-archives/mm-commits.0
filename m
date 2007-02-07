From: akpm@linux-foundation.org
Subject: + drivers-isdn-gigaset-reduce-kernel-message-spam.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:32:42 -0800
Message-ID: <200702072332.l17NWgYW031203@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161472AbXBGXfx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:35:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc


The patch titled
     drivers/isdn/gigaset: reduce kernel message spam
has been added to the -mm tree.  Its filename is
     drivers-isdn-gigaset-reduce-kernel-message-spam.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/gigaset: reduce kernel message spam
From: Tilman Schmidt <tilman@imap.cc>

Reduce the number of kernel messages the Gigaset drivers produce in case of an
excessively long device response, from one per character exceeding the limit
to one per overlong message.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/isocdata.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/gigaset/isocdata.c~drivers-isdn-gigaset-reduce-kernel-message-spam drivers/isdn/gigaset/isocdata.c
--- a/drivers/isdn/gigaset/isocdata.c~drivers-isdn-gigaset-reduce-kernel-message-spam
+++ a/drivers/isdn/gigaset/isocdata.c
@@ -921,6 +921,8 @@ static void cmd_loop(unsigned char *src,
 			/* end of line */
 			gig_dbg(DEBUG_TRANSCMD, "%s: End of Command (%d Bytes)",
 				__func__, cbytes);
+			if (cbytes >= MAX_RESP_SIZE - 1)
+				dev_warn(cs->dev, "response too large\n");
 			cs->cbytes = cbytes;
 			gigaset_handle_modem_response(cs);
 			cbytes = 0;
@@ -929,8 +931,6 @@ static void cmd_loop(unsigned char *src,
 			/* advance in line buffer, checking for overflow */
 			if (cbytes < MAX_RESP_SIZE - 1)
 				cbytes++;
-			else
-				dev_warn(cs->dev, "response too large\n");
 		}
 	}
 
_

Patches currently in -mm which might be from tilman@imap.cc are

char-tty_wakeup-cleanup.patch
consolidate-line-discipline-number-definitions-v2.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
fix-sparse-warnings-from-asmnet-checksumh.patch
drivers-isdn-gigaset-reduce-mutex-scope.patch
drivers-isdn-gigaset-reduce-kernel-message-spam.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
