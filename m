From: akpm@linux-foundation.org
Subject: + drivers-char-pcmcia-cm4000_csc-fix-error-code.patch added to -mm tree
Date: Mon, 25 Oct 2010 16:53:38 -0700
Message-ID: <201010252353.o9PNrc2L023565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757929Ab0JYXxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 19:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikai@nikai.net, laforge@gnumonks.org, linux@dominikbrodowski.net


The patch titled
     drivers/char/pcmcia/cm4000_cs.c: fix error code
has been added to the -mm tree.  Its filename is
     drivers-char-pcmcia-cm4000_csc-fix-error-code.patch

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
Subject: drivers/char/pcmcia/cm4000_cs.c: fix error code
From: Nicolas Kaiser <nikai@nikai.net>

Don't overwrite the -ENODEV to -EIO.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/cm4000_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/pcmcia/cm4000_cs.c~drivers-char-pcmcia-cm4000_csc-fix-error-code drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~drivers-char-pcmcia-cm4000_csc-fix-error-code
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -979,8 +979,9 @@ static ssize_t cmm_read(struct file *fil
 		if (dev->flags0 & 1) {
 			set_bit(IS_CMM_ABSENT, &dev->flags);
 			rc = -ENODEV;
+		} else {
+			rc = -EIO;
 		}
-		rc = -EIO;
 		goto release_io;
 	}
 
_

Patches currently in -mm which might be from nikai@nikai.net are

origin.patch
linux-next.patch
drivers-char-pcmcia-cm4000_csc-fix-error-code.patch
drivers-media-video-gspca-cpia1c-fix-error-check.patch
drivers-block-drbd-drbd_mainc-fix-error-path.patch
drivers-crypto-dubious-error-check.patch
video-omap-suspected-typo-in-assignment.patch

