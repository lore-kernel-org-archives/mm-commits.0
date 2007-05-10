From: akpm@linux-foundation.org
Subject: + ixp4xx-compile-error-was-re-2621-mm2.patch added to -mm tree
Date: Thu, 10 May 2007 11:46:42 -0700
Message-ID: <200705101846.l4AIkgCo027506@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbXEJSq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 14:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, dtor@mail.ru, frederik.deweerdt@gmail.com


The patch titled
     ixp4xx compile error
has been added to the -mm tree.  Its filename is
     ixp4xx-compile-error-was-re-2621-mm2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ixp4xx-compile-error-was-re-2621-mm2.patch
revoke-core-code.patch
reiser4-sb_sync_inodes.patch
