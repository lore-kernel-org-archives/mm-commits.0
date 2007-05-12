From: akpm@linux-foundation.org
Subject: - ixp4xx-compile-error-was-re-2621-mm2.patch removed from -mm tree
Date: Fri, 11 May 2007 22:16:10 -0700
Message-ID: <200705120516.l4C5GAfU001806@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546AbXELFQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deweerdt@free.fr, dtor@mail.ru, frederik.deweerdt@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ixp4xx compile error
has been removed from the -mm tree.  Its filename was
     ixp4xx-compile-error-was-re-2621-mm2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ixp4xx compile error
From: Frederik Deweerdt <deweerdt@free.fr>

drivers/input/misc/ixp4xx-beeper.c: In function 'ixp4xx_spkr_event':
drivers/input/misc/ixp4xx-beeper.c:54: error: 'input_dev' undeclared (first use in this function)
drivers/input/misc/ixp4xx-beeper.c:54: error: (Each undeclared identifier is reported only once
drivers/input/misc/ixp4xx-beeper.c:54: error: for each function it appears in.)

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/ixp4xx-beeper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/misc/ixp4xx-beeper.c~ixp4xx-compile-error-was-re-2621-mm2 drivers/input/misc/ixp4xx-beeper.c
--- a/drivers/input/misc/ixp4xx-beeper.c~ixp4xx-compile-error-was-re-2621-mm2
+++ a/drivers/input/misc/ixp4xx-beeper.c
@@ -51,7 +51,7 @@ static void ixp4xx_spkr_control(unsigned
 
 static int ixp4xx_spkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
-	unsigned int pin = (unsigned int) input_get_drvdata(input_dev);
+	unsigned int pin = (unsigned int) input_get_drvdata(dev);
 	unsigned int count = 0;
 
 	if (type != EV_SND)
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from deweerdt@free.fr are

origin.patch
arm-export-csum_partial_copy_from_user.patch
revoke-core-code.patch
reiser4-sb_sync_inodes.patch
