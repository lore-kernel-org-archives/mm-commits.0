From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1390c-remove-empty-function.patch added to
 -mm tree
Date: Wed, 29 May 2013 13:20:33 -0700
Message-ID: <51a66311.kZZwrBs5tW/l+xC6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966780Ab3E2UUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 16:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mpfj@mimc.co.uk, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-ds1390c-remove-empty-function.patch added to -mm tree
To: sachin.kamat@linaro.org,mpfj@mimc.co.uk
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 13:20:33 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1390.c: remove empty function
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1390c-remove-empty-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds1390.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Mark Jackson <mpfj@mimc.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1390.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1390.c~drivers-rtc-rtc-ds1390c-remove-empty-function drivers/rtc/rtc-ds1390.c
--- a/drivers/rtc/rtc-ds1390.c~drivers-rtc-rtc-ds1390c-remove-empty-function
+++ a/drivers/rtc/rtc-ds1390.c
@@ -154,18 +154,12 @@ static int ds1390_probe(struct spi_devic
 	return res;
 }
 
-static int ds1390_remove(struct spi_device *spi)
-{
-	return 0;
-}
-
 static struct spi_driver ds1390_driver = {
 	.driver = {
 		.name	= "rtc-ds1390",
 		.owner	= THIS_MODULE,
 	},
 	.probe	= ds1390_probe,
-	.remove = ds1390_remove,
 };
 
 module_spi_driver(ds1390_driver);
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
video-smscufx-use-null-instead-of-0.patch
video-udlfb-use-null-instead-of-0.patch
video-udlfb-make-local-symbol-static.patch
video-imxfb-make-local-symbols-static.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
drivers-rtc-rtc-m48t86c-remove-empty-function.patch
drivers-rtc-rtc-tilec-remove-empty-function.patch
drivers-rtc-rtc-nuc900c-remove-empty-function.patch
drivers-rtc-rtc-msm6242c-remove-empty-function.patch
drivers-rtc-rtc-max8998c-remove-empty-function.patch
drivers-rtc-rtc-max8925c-remove-empty-function.patch
drivers-rtc-rtc-ls1xc-remove-empty-function.patch
drivers-rtc-rtc-lp8788c-remove-empty-function.patch
drivers-rtc-rtc-ds1302c-remove-empty-function.patch
drivers-rtc-rtc-dm355evmc-remove-empty-function.patch
drivers-rtc-rtc-da9055c-remove-empty-function.patch
drivers-rtc-rtc-da9052c-remove-empty-function.patch
drivers-rtc-rtc-bq4802c-remove-empty-function.patch
drivers-rtc-rtc-au1xxxc-remove-empty-function.patch
drivers-rtc-rtc-ab3100c-remove-empty-function.patch
drivers-rtc-rtc-bq32kc-remove-empty-function.patch
drivers-rtc-rtc-ds1216c-remove-empty-function.patch
drivers-rtc-rtc-ds1286c-remove-empty-function.patch
drivers-rtc-rtc-ds1672c-remove-empty-function.patch
drivers-rtc-rtc-ds3234c-remove-empty-function.patch
drivers-rtc-rtc-ds1390c-remove-empty-function.patch
drivers-rtc-rtc-efic-remove-empty-function.patch
drivers-rtc-rtc-em3027c-remove-empty-function.patch
drivers-rtc-rtc-fm3130c-remove-empty-function.patch
drivers-rtc-rtc-isl12022c-remove-empty-function.patch
drivers-rtc-rtc-m41t93c-remove-empty-function.patch
drivers-rtc-rtc-m48t35c-remove-empty-function.patch
drivers-rtc-rtc-genericc-remove-empty-function.patch
drivers-rtc-rtc-m41t94c-remove-empty-function.patch
drivers-rtc-rtc-max6902c-remove-empty-function.patch
drivers-rtc-rtc-max6900c-remove-empty-function.patch
drivers-rtc-rtc-max8907c-remove-empty-function.patch
drivers-rtc-rtc-max77686c-remove-empty-function.patch
drivers-rtc-rtc-max8997c-remove-empty-function.patch
drivers-rtc-rtc-pcf8523c-remove-empty-function.patch
drivers-rtc-rtc-pcf8563c-remove-empty-function.patch
drivers-rtc-rtc-pcf8583c-remove-empty-function.patch
drivers-rtc-rtc-ps3c-remove-empty-function.patch
drivers-rtc-rtc-rs5c313c-remove-empty-function.patch
drivers-rtc-rtc-rv3029c2c-remove-empty-function.patch
drivers-rtc-rtc-rx4581c-remove-empty-function.patch
drivers-rtc-rtc-rs5c348c-remove-empty-function.patch
drivers-rtc-rtc-rx8581c-remove-empty-function.patch
drivers-rtc-rtc-snvsc-remove-empty-function.patch
drivers-rtc-rtc-starfirec-remove-empty-function.patch
drivers-rtc-rtc-sun4vc-remove-empty-function.patch
drivers-rtc-rtc-tps80031c-remove-empty-function.patch
drivers-rtc-rtc-wm831xc-remove-empty-function.patch

