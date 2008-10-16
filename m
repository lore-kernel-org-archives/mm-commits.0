From: akpm@linux-foundation.org
Subject: + scsi-fix-bad-use-of-udelay-in-atp870uc.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:51:42 -0700
Message-ID: <200810162251.m9GMpgse001239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754778AbYJPWwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tbm@cyrius.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: fix bad use of udelay in atp870u.c
has been added to the -mm tree.  Its filename is
     scsi-fix-bad-use-of-udelay-in-atp870uc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: fix bad use of udelay in atp870u.c
From: Martin Michlmayr <tbm@cyrius.com>

The ACARD driver calls udelay() with a value > 2000, which leads to
to the following compilation error on ARM:
  ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
  make[1]: *** [__modpost] Error 1
Fix this by using a combination of mdelay and udelay.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/atp870u.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/atp870u.c~scsi-fix-bad-use-of-udelay-in-atp870uc drivers/scsi/atp870u.c
--- a/drivers/scsi/atp870u.c~scsi-fix-bad-use-of-udelay-in-atp870uc
+++ a/drivers/scsi/atp870u.c
@@ -1171,7 +1171,8 @@ wait_io1:
 	outw(val, tmport);
 	outb(2, 0x80);
 TCM_SYNC:
-	udelay(0x800);
+	mdelay(2);
+	udelay(48);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
 		outw(0, tmport--);
 		outb(0, tmport);
_

Patches currently in -mm which might be from tbm@cyrius.com are

origin.patch
scsi-fix-bad-use-of-udelay-in-atp870uc.patch

