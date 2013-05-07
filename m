From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch added to -mm tree
Date: Tue, 07 May 2013 15:39:30 -0700
Message-ID: <20130507223930.CF45C5A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:45580 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3EGWjb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:39:31 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so121233vbg.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:39:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-pcf8583.c: move assignment outside if condition
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch

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
Subject: drivers/rtc/rtc-pcf8583.c: move assignment outside if condition

Fixes the following checkpatch error:
ERROR: do not use assignment in if condition

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8583.c~drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -188,7 +188,8 @@ static int pcf8583_rtc_read_time(struct
 		dev_warn(dev, "resetting control %02x -> %02x\n",
 			ctrl, new_ctrl);
 
-		if ((err = pcf8583_set_ctrl(client, &new_ctrl)) < 0)
+		err = pcf8583_set_ctrl(client, &new_ctrl);
+		if (err < 0)
 			return err;
 	}
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
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
drivers-rtc-rtc-pxac-use-devm_-apis.patch

