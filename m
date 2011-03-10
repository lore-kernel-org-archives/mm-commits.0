From: akpm@linux-foundation.org
Subject: + gpio-use-__devexit-at-necessary-places.patch added to -mm tree
Date: Thu, 10 Mar 2011 14:15:24 -0800
Message-ID: <201103102215.p2AMFOh3031682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab1CJWPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Mar 2011 17:15:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, info@mocean-labs.com, miguel.gaio@efixo.com


The patch titled
     gpio: use  __devexit at necessary places
has been added to the -mm tree.  Its filename is
     gpio-use-__devexit-at-necessary-places.patch

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
Subject: gpio: use  __devexit at necessary places
From: Axel Lin <axel.lin@gmail.com>

gen_74x164_remove() and mc33880_remove() are used only wrapped by
__devexit_p so define them using __devexit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Miguel Gaio <miguel.gaio@efixo.com>
Cc: Mocean Laboratories <info@mocean-labs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/74x164.c  |    2 +-
 drivers/gpio/mc33880.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/74x164.c~gpio-use-__devexit-at-necessary-places drivers/gpio/74x164.c
--- a/drivers/gpio/74x164.c~gpio-use-__devexit-at-necessary-places
+++ a/drivers/gpio/74x164.c
@@ -133,7 +133,7 @@ exit_destroy:
 	return ret;
 }
 
-static int gen_74x164_remove(struct spi_device *spi)
+static int __devexit gen_74x164_remove(struct spi_device *spi)
 {
 	struct gen_74x164_chip *chip;
 	int ret;
diff -puN drivers/gpio/mc33880.c~gpio-use-__devexit-at-necessary-places drivers/gpio/mc33880.c
--- a/drivers/gpio/mc33880.c~gpio-use-__devexit-at-necessary-places
+++ a/drivers/gpio/mc33880.c
@@ -146,7 +146,7 @@ exit_destroy:
 	return ret;
 }
 
-static int mc33880_remove(struct spi_device *spi)
+static int __devexit mc33880_remove(struct spi_device *spi)
 {
 	struct mc33880 *mc;
 	int ret;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
gpio-use-__devexit-at-necessary-places.patch

