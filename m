From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:56 -0800
Message-ID: <52af5acc.ZDAogdK3j4eUxPu3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3LPT4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:56:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, duanj.fnst@cn.fujitsu.com

Subject: + drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch added to -mm tree
To: duanj.fnst@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:56 -0800


The patch titled
     Subject: drivers/rtc/rtc-pcf2127.c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: drivers/rtc/rtc-pcf2127.c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Fix a coccinelle error regarding usage of IS_ERR and PTR_ERR instead of
PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2127.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-pcf2127.c~drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero drivers/rtc/rtc-pcf2127.c
--- a/drivers/rtc/rtc-pcf2127.c~drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero
+++ a/drivers/rtc/rtc-pcf2127.c
@@ -197,10 +197,7 @@ static int pcf2127_probe(struct i2c_clie
 				pcf2127_driver.driver.name,
 				&pcf2127_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf2127->rtc))
-		return PTR_ERR(pcf2127->rtc);
