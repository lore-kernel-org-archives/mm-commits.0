From: akpm@linux-foundation.org
Subject: + rtc-ds1685-fix-sparse-warnings.patch added to -mm tree
Date: Tue, 03 Mar 2015 13:22:38 -0800
Message-ID: <54f6261e.Fc5ZOY4/49/AzpUv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbbCCVWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 16:22:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kumba@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1685.c: fix sparse warnings
has been added to the -mm tree.  Its filename is
     rtc-ds1685-fix-sparse-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1685-fix-sparse-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1685-fix-sparse-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joshua Kinard <kumba@gentoo.org>
Subject: drivers/rtc/rtc-ds1685.c: fix sparse warnings

Fix two minor sparse warnings:

  CHECK   drivers/rtc/rtc-ds1685.c
drivers/rtc/rtc-ds1685.c:2178:1: warning: function 'ds1685_rtc_poweroff'
with external linkage has definition
drivers/rtc/rtc-ds1685.c:802:23: warning: Using plain integer as NULL
pointer

Fixes: aaaf5fbf56f1 ("rtc: add driver for DS1685 family of real time clocks")
Signed-off-by: Joshua Kinard <kumba@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1685.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1685.c~rtc-ds1685-fix-sparse-warnings drivers/rtc/rtc-ds1685.c
--- a/drivers/rtc/rtc-ds1685.c~rtc-ds1685-fix-sparse-warnings
+++ a/drivers/rtc/rtc-ds1685.c
@@ -799,7 +799,7 @@ ds1685_rtc_proc(struct device *dev, stru
 	struct platform_device *pdev = to_platform_device(dev);
 	struct ds1685_priv *rtc = platform_get_drvdata(pdev);
 	u8 ctrla, ctrlb, ctrlc, ctrld, ctrl4a, ctrl4b, ssn[8];
-	char *model = '\0';
+	char *model;
 #ifdef CONFIG_RTC_DS1685_PROC_REGS
 	char bits[NUM_REGS][(NUM_BITS * NUM_SPACES) + NUM_BITS + 1];
 #endif
@@ -2174,7 +2174,7 @@ module_exit(ds1685_rtc_exit);
  * ds1685_rtc_poweroff - uses the RTC chip to power the system off.
  * @pdev: pointer to platform_device structure.
  */
-extern void __noreturn
+void __noreturn
 ds1685_rtc_poweroff(struct platform_device *pdev)
 {
 	u8 ctrla, ctrl4a, ctrl4b;
_

Patches currently in -mm which might be from kumba@gentoo.org are

rtc-ds1685-remove-owner-assignment-from-platform_driver.patch
mips-ip32-add-platform-data-hooks-to-use-ds1685-driver.patch
rtc-ds1685-fix-sparse-warnings.patch

