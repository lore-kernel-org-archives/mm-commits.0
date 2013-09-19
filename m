From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch added to -mm tree
Date: Thu, 19 Sep 2013 15:10:10 -0700
Message-ID: <523b7642.YbHfO+1Y/1YoZQe9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISWKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, hvr@gnu.org, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch added to -mm tree
To: sachin.kamat@linaro.org,hvr@gnu.org,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:10:10 -0700


The patch titled
     Subject: drivers/rtc/rtc-isl1208.c: remove redundant checks
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch

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
Subject: drivers/rtc/rtc-isl1208.c: remove redundant checks

i2c_smbus_read_byte_data() returns negative errno on failure.  Return the
value obtained from it directly.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-remove-redundant-checks drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-remove-redundant-checks
+++ a/drivers/rtc/rtc-isl1208.c
@@ -144,11 +144,7 @@ isl1208_i2c_validate_client(struct i2c_c
 static int
 isl1208_i2c_get_sr(struct i2c_client *client)
 {
-	int sr = i2c_smbus_read_byte_data(client, ISL1208_REG_SR);
-	if (sr < 0)
-		return -EIO;
