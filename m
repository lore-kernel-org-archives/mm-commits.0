From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch added
 to -mm tree
Date: Wed, 24 Jul 2013 16:10:24 -0700
Message-ID: <51f05ee0.oqTzr03dLkFwUgUs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3GXXKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 19:10:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony@atomide.com, khilman@linaro.org, grygorii.strashko@ti.com

Subject: + drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch added to -mm tree
To: grygorii.strashko@ti.com,khilman@linaro.org,tony@atomide.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 16:10:24 -0700


The patch titled
     Subject: drivers/rtc/rtc-twl.c: fix: rtcX/wakealarm attribute isn't created
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Return-Path: <grygorii.strashko@ti.com>
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id r6NBnmrh010894
	for <akpm@localhost>; Tue, 23 Jul 2013 04:49:48 -0700
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Tue, 23 Jul 2013 04:49:48 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTP id 2C2549A7
	for <akpm@mail.linuxfoundation.org>; Tue, 23 Jul 2013 11:50:19 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-oa0-f44.google.com (mail-oa0-f44.google.com [209.85.219.44])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 12A0C1F950
	for <akpm@mail.linuxfoundation.org>; Tue, 23 Jul 2013 11:50:17 +0000 (UTC)
Received: by mail-oa0-f44.google.com with SMTP id l10so10840218oag.17
        for <akpm@mail.linuxfoundation.org>; Tue, 23 Jul 2013 04:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:delivered-to:x-gm-message-state;
        bh=wBQCoFvsLuVPqp8urGoQRAySB/rIGkqYyiqNpUgf1Ks=;
        b=jbBJBJin/awdOxRsSEfpvbCs0YgNqa8hDem/q7ZdVSxDAZelrYbRTRVw11eKqaObNf
         HUVmCo9HgOfj16YEFR1C59CqPSAgdo4MiUucdf3BnGHYajZHj/9BLKwuzgWJUTWQREwf
         oYjX2OiUxzYaifUtYpubbjt9qQEXhdNNILJnpU665XDgvtM0dy6nKuQtf6ukO9nnvco7
         LsOuKfwGukyZ/mqhbf9TDOxyat6YZ+aAQFk1a+56m+JqS2ZNBMao5e3MVMUvUkF74plw
         EP3REJ+i+caat5KGohYM8uthpWHStsXiP6W431mxWBAs0mibZH46D4cSauIikkBX5Dqz
         1iyA==
X-Received: by 10.60.52.78 with SMTP id r14mr30922629oeo.9.1374580217379;
        Tue, 23 Jul 2013 04:50:17 -0700 (PDT)
X-Received: by 10.60.52.78 with SMTP id r14mr30922608oeo.9.1374580217084;
        Tue, 23 Jul 2013 04:50:17 -0700 (PDT)
Received: from bear.ext.ti.com (bear.ext.ti.com. [192.94.94.41])
        by mx.google.com with ESMTPS id dh9si10756940oeb.130.2013.07.23.04.50.16
        for <akpm@linux-foundation.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 23 Jul 2013 04:50:16 -0700 (PDT)
Received-SPF: pass (google.com: domain of grygorii.strashko@ti.com designates 192.94.94.41 as permitted sender) client-ip=192.94.94.41;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of grygorii.strashko@ti.com designates 192.94.94.41 as permitted sender) smtp.mail=grygorii.strashko@ti.com
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id r6NBoC4T030533;
	Tue, 23 Jul 2013 06:50:13 -0500
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id r6NBoC9T008249;
	Tue, 23 Jul 2013 06:50:12 -0500
Received: from dlelxv22.itg.ti.com (172.17.1.197) by DFLE72.ent.ti.com
 (128.247.5.109) with Microsoft SMTP Server id 14.2.342.3; Tue, 23 Jul 2013
 06:50:12 -0500
Received: from localhost (uglx0174654.ucm2.emeaucm.ext.ti.com
 [10.167.145.172])	by dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id
 r6NBoBvH004676;	Tue, 23 Jul 2013 06:50:12 -0500
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton
	<akpm@linux-foundation.org>
Cc: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Grygorii
 Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Tony
 Lindgren <tony@atomide.com>
Subject: drivers/rtc/rtc-twl.c: fix: rtcX/wakealarm attribute isn't created
Date: Tue, 23 Jul 2013 14:48:33 +0300
Message-ID: <1374580113-7474-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Delivered-To: akpm@linux-foundation.org
X-Gm-Message-State: ALoCoQmDbKVWCpNsGpcdaNtjd/n9B3EubpEHbKv9tkqDXE0yCsdBfdipYCnfAv5v4jbbNJlKIV3o7p7HlhGdvxDcHGXDCOXJs8K+ADG0Qfy6443fgx+bdiRZufk5cAMRnkfb/izW26DJxi0kw3hYlFiOvaLlOcT0iQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW
	autolearn=ham version=3.3.1
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
	smtp1.linux-foundation.org

The device_init_wakeup() should be called before rtc_device_register().
Otherwise, sysfs "sys/class/rtc/rtcX/wakealarm" attribute will not be
seen from User space.

Cc: Kevin Hilman <khilman@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/rtc/rtc-twl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 02faf3c..c2e80d7 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -524,6 +524,8 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out1;
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	rtc = rtc_device_register(pdev->name,
 				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -542,7 +544,6 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
-	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
-- 
1.7.9.5

Patches currently in -mm which might be from grygorii.strashko@ti.com are

drivers-rtc-rtc-twlc-fix-rtcx-wakealarm-attribute-isnt-created.patch
linux-next.patch

