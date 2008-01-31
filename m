From: akpm@linux-foundation.org
Subject: + spi_bfin-use-more-useful-gpio-labels.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:26:57 -0800
Message-ID: <200801312126.m0VLQvCZ012144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbYAaV1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:27:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi_bfin: use more useful GPIO labels
has been added to the -mm tree.  Its filename is
     spi_bfin-use-more-useful-gpio-labels.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_bfin: use more useful GPIO labels
From: Bryan Wu <bryan.wu@analog.com>

Use the SPI driver's name when requesting gpio lines.  When there are gpio
conflicts, this helps to narrow down the problems; "bfin-spi" is not
informative.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin-use-more-useful-gpio-labels drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin-use-more-useful-gpio-labels
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1176,7 +1176,7 @@ static int setup(struct spi_device *spi)
 	if ((chip->chip_select_num > 0)
 		&& (chip->chip_select_num <= spi->master->num_chipselect))
 		peripheral_request(ssel[spi->master->bus_num]
-			[chip->chip_select_num-1], DRV_NAME);
+			[chip->chip_select_num-1], spi->modalias);
 
 	cs_deactive(drv_data, chip);
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-mm_ptovvtop.patch
spi_bfin-remove-useless-fault-path.patch
spi_bfin-use-more-useful-gpio-labels.patch
spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch
spi_bfin-wait-for-tx-to-complete-on-full-duplex-paths.patch
spi_bfin-wait-for-tx-to-complete-on-write-paths.patch
spi_bfin-headers-are-not-for-changelogs.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
procfs-constify-function-pointer-tables.patch
