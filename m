From: akpm@linux-foundation.org
Subject: + rtc-ds3234-doesnt-link-when-built-in.patch added to -mm tree
Date: Mon, 27 Oct 2008 20:33:39 -0700
Message-ID: <200810280333.m9S3Xd48030309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbYJ1DeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 23:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, a.zummo@towertech.it


The patch titled
     rtc: ds3234 doesn't link when built-in
has been added to the -mm tree.  Its filename is
     rtc-ds3234-doesnt-link-when-built-in.patch

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
Subject: rtc: ds3234 doesn't link when built-in
From: Geert Uytterhoeven <geert@linux-m68k.org>

When ds3234 is built-in, the final links fails with the following vague error
message:

`.exit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

ds3234_remove() cannot be marked __exit, as it's accessed via __devexit_p().
In addition, mark ds3234_probe() __devinit while we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds3234.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds3234.c~rtc-ds3234-doesnt-link-when-built-in drivers/rtc/rtc-ds3234.c
--- a/drivers/rtc/rtc-ds3234.c~rtc-ds3234-doesnt-link-when-built-in
+++ a/drivers/rtc/rtc-ds3234.c
@@ -189,7 +189,7 @@ static const struct rtc_class_ops ds3234
 	.set_time	= ds3234_set_time,
 };
 
-static int ds3234_probe(struct spi_device *spi)
+static int __devinit ds3234_probe(struct spi_device *spi)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
@@ -249,7 +249,7 @@ static int ds3234_probe(struct spi_devic
 	return 0;
 }
 
-static int __exit ds3234_remove(struct spi_device *spi)
+static int __devexit ds3234_remove(struct spi_device *spi)
 {
 	struct ds3234 *chip = platform_get_drvdata(spi);
 	struct rtc_device *rtc = chip->rtc;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
rtc-ds3234-doesnt-link-when-built-in.patch
linux-next.patch
fbdev-fix-typo-in-drivers-video-modedbc.patch

