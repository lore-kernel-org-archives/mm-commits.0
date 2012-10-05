From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-atp870uc-fix-bad-use-of-udelay.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:05 -0700
Message-ID: <20121005201205.BFFD5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35797 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2JEUMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:08 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236267vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tbm@cyrius.com, James.Bottomley@HansenPartnership.com, jrnieder@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/atp870u.c: fix bad use of udelay
has been removed from the -mm tree.  Its filename was
     drivers-scsi-atp870uc-fix-bad-use-of-udelay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[jrnieder@gmail.com: adding context]
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

Patches currently in -mm which might be from tbm@cyrius.com are

origin.patch

