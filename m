From: akpm@linux-foundation.org
Subject: + dtlk-off-by-one-in-readwrite_tts.patch added to -mm tree
Date: Wed, 13 May 2009 13:00:15 -0700
Message-ID: <200905132000.n4DK0F5D013273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbZEMUAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 16:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, jrv@vanzandt.mv.com


The patch titled
     dtlk: off by one in {read,write}_tts()
has been added to the -mm tree.  Its filename is
     dtlk-off-by-one-in-readwrite_tts.patch

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
asm-generic-fix-local_add_unless-macro.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch
nes-off-by-one-in-reset_adapter_ne020-and-init_serdes.patch
riptide-postfix-increment-and-off-by-one.patch

