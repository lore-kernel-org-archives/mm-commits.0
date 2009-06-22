From: akpm@linux-foundation.org
Subject: [merged] dtlk-off-by-one-in-readwrite_tts.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:28 -0700
Message-ID: <200906221700.n5MH0SgU009826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbZFVRJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:09:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jrv@vanzandt.mv.com, mm-commits@vger.kernel.org


The patch titled
     dtlk: off by one in {read,write}_tts()
has been removed from the -mm tree.  Its filename was
     dtlk-off-by-one-in-readwrite_tts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dtlk: off by one in {read,write}_tts()
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix increment retries is incremented beyond DTLK_MAX_RETRIES so
the error message is not displayed correctly.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James R. Van Zandt <jrv@vanzandt.mv.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/dtlk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/dtlk.c~dtlk-off-by-one-in-readwrite_tts drivers/char/dtlk.c
--- a/drivers/char/dtlk.c~dtlk-off-by-one-in-readwrite_tts
+++ a/drivers/char/dtlk.c
@@ -571,7 +571,7 @@ static char dtlk_read_tts(void)
 		portval = inb_p(dtlk_port_tts);
 	} while ((portval & TTS_READABLE) == 0 &&
 		 retries++ < DTLK_MAX_RETRIES);
-	if (retries == DTLK_MAX_RETRIES)
+	if (retries > DTLK_MAX_RETRIES)
 		printk(KERN_ERR "dtlk_read_tts() timeout\n");
 
 	ch = inb_p(dtlk_port_tts);	/* input from TTS port */
@@ -583,7 +583,7 @@ static char dtlk_read_tts(void)
 		portval = inb_p(dtlk_port_tts);
 	} while ((portval & TTS_READABLE) != 0 &&
 		 retries++ < DTLK_MAX_RETRIES);
-	if (retries == DTLK_MAX_RETRIES)
+	if (retries > DTLK_MAX_RETRIES)
 		printk(KERN_ERR "dtlk_read_tts() timeout\n");
 
 	TRACE_RET;
@@ -640,7 +640,7 @@ static char dtlk_write_tts(char ch)
 		while ((inb_p(dtlk_port_tts) & TTS_WRITABLE) == 0 &&
 		       retries++ < DTLK_MAX_RETRIES)	/* DT ready? */
 			;
-	if (retries == DTLK_MAX_RETRIES)
+	if (retries > DTLK_MAX_RETRIES)
 		printk(KERN_ERR "dtlk_write_tts() timeout\n");
 
 	outb_p(ch, dtlk_port_tts);	/* output to TTS port */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch

