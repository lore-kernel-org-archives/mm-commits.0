From: akpm@linux-foundation.org
Subject: + drivers-scsi-atp870uc-fix-bad-use-of-udelay.patch added to -mm tree
Date: Tue, 24 Apr 2012 14:18:59 -0700
Message-ID: <20120424211859.BCCF2A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39359 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab2DXVTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Apr 2012 17:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tbm@cyrius.com, James.Bottomley@HansenPartnership.com, jrnieder@gmail.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/scsi/atp870u.c: fix bad use of udelay
has been added to the -mm tree.  Its filename is
     drivers-scsi-atp870uc-fix-bad-use-of-udelay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Michlmayr <tbm@cyrius.com>
Subject: drivers/scsi/atp870u.c: fix bad use of udelay

The ACARD driver calls udelay() with a value > 2000, which leads to
to the following compilation error on ARM:
  ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
  make[1]: *** [__modpost] Error 1

This is because udelay is defined on ARM, roughly speaking, as

	#define udelay(n) ((n) > 2000 ? __bad_udelay() : \
		__const_udelay((n) * ((2199023U*HZ)>>11)))

The argument to __const_udelay is the number of jiffies to wait divided by
4, but this does not work unless the multiplication does not overflow, and
that is what the build error is designed to prevent.  The intended
behavior can be achieved by using mdelay to call udelay multiple times in
a loop.

[jn: adding context]
Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/atp870u.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/atp870u.c~drivers-scsi-atp870uc-fix-bad-use-of-udelay drivers/scsi/atp870u.c
--- a/drivers/scsi/atp870u.c~drivers-scsi-atp870uc-fix-bad-use-of-udelay
+++ a/drivers/scsi/atp870u.c
@@ -1173,7 +1173,16 @@ wait_io1:
 	outw(val, tmport);
 	outb(2, 0x80);
 TCM_SYNC:
-	udelay(0x800);
+	/*
+	 * The funny division into multiple delays is to accomodate
+	 * arches like ARM where udelay() multiplies its argument by
+	 * a large number to initialize a loop counter.  To avoid
+	 * overflow, the maximum supported udelay is 2000 microseconds.
+	 *
+	 * XXX it would be more polite to find a way to use msleep()
+	 */
+	mdelay(2);
+	udelay(48);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
 		outw(0, tmport--);
 		outb(0, tmport);
_
Subject: Subject: drivers/scsi/atp870u.c: fix bad use of udelay

Patches currently in -mm which might be from tbm@cyrius.com are

drivers-scsi-atp870uc-fix-bad-use-of-udelay.patch

