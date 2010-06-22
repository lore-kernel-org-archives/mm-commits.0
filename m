From: akpm@linux-foundation.org
Subject: + rtc-max6900-use-rtc_valid_tm-to-check-returning-tm.patch added to -mm tree
Date: Tue, 22 Jun 2010 14:18:30 -0700
Message-ID: <201006222118.o5MLIUAu002631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab0FVVSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 17:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it, dale@farnsworth.org


The patch titled
     rtc/max6900: use rtc_valid_tm() to check returning tm
has been added to the -mm tree.  Its filename is
     rtc-max6900-use-rtc_valid_tm-to-check-returning-tm.patch

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
Subject: rtc/max6900: use rtc_valid_tm() to check returning tm
From: Wan ZongShun <mcuos.com@gmail.com>

Use rtc_valid_tm() to check returning tm for max6900, it can avoid
returning wrong tm value.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Acked-by: Dale Farnsworth <dale@farnsworth.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6900.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-max6900.c~rtc-max6900-use-rtc_valid_tm-to-check-returning-tm drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~rtc-max6900-use-rtc_valid_tm-to-check-returning-tm
+++ a/drivers/rtc/rtc-max6900.c
@@ -159,7 +159,7 @@ static int max6900_i2c_read_time(struct 
 		      bcd2bin(regs[MAX6900_REG_CENTURY]) * 100 - 1900;
 	tm->tm_wday = bcd2bin(regs[MAX6900_REG_DW]);
 
-	return 0;
+	return rtc_valid_tm(tm);
 }
 
 static int max6900_i2c_clear_write_protect(struct i2c_client *client)
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

linux-next.patch
rtc-fix-ds1388-time-corruption.patch
maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
rtc-nuc900-fix-checking-of-args-during-time-setting.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch
rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-pxa-remove-unnecessary-private-ops-ioctl.patch
drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh.patch
rtc-driver-for-the-dryice-block-found-in-imx25-chips.patch
rtc-add-intersil-isl12022-rtc-driver.patch
rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-max6900-use-rtc_valid_tm-to-check-returning-tm.patch

