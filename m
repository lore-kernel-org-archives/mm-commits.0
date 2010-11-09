From: akpm@linux-foundation.org
Subject: [merged] drivers-char-pcmcia-cm4000_csc-fix-error-code.patch removed from -mm tree
Date: Tue, 09 Nov 2010 10:53:55 -0800
Message-ID: <201011091856.oA9IuA4P000963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344Ab0KIS44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 13:56:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nikai@nikai.net, laforge@gnumonks.org, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     drivers/char/pcmcia/cm4000_cs.c: fix error code
has been removed from the -mm tree.  Its filename was
     drivers-char-pcmcia-cm4000_csc-fix-error-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
drivers-media-video-gspca-cpia1c-fix-error-check.patch

