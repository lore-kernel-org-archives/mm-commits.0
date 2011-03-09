From: akpm@linux-foundation.org
Subject: + drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch added to -mm tree
Date: Wed, 09 Mar 2011 15:59:00 -0800
Message-ID: <201103092359.p29Nx043003305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237Ab1CIX7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 18:59:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alan@linux.intel.com, kalhan.trisal@intel.com


The patch titled
     drivers/misc/hmc6352.c: fix wrong return value checking for i2c_master_recv()
has been added to the -mm tree.  Its filename is
     drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch

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
Subject: drivers/misc/hmc6352.c: fix wrong return value checking for i2c_master_recv()
From: Axel Lin <axel.lin@gmail.com>

i2c_master_recv() returns negative errno, or else the number of bytes
read.  Thus i2c_master_recv(client, i2c_data, 2) returns 2 instead of 1 in
success case.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hmc6352.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/hmc6352.c~drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv drivers/misc/hmc6352.c
--- a/drivers/misc/hmc6352.c~drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv
+++ a/drivers/misc/hmc6352.c
@@ -86,7 +86,7 @@ static ssize_t compass_heading_data_show
 	msleep(10); /* sending 'A' cmd we need to wait for 7-10 millisecs */
 	ret = i2c_master_recv(client, i2c_data, 2);
 	mutex_unlock(&compass_mutex);
-	if (ret != 1) {
+	if (ret < 0) {
 		dev_warn(dev, "i2c read data cmd failed\n");
 		return ret;
 	}
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch

