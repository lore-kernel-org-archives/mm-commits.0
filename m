From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-lm3639_blc-return-proper-error-in-lm3639_bled_mode_store-error-paths.patch added to -mm tree
Date: Thu, 11 Oct 2012 14:09:17 -0700
Message-ID: <20121011210917.9A17A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:54567 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759367Ab2JKVJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 17:09:18 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so271943ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 14:09:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@ingics.com


The patch titled
     Subject: drivers/video/backlight/lm3639_bl.c: return proper error in lm3639_bled_mode_store() error paths
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lm3639_blc-return-proper-error-in-lm3639_bled_mode_store-error-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/video/backlight/lm3639_bl.c: return proper error in lm3639_bled_mode_store() error paths

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3639_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/lm3639_bl.c~backlight-lm3639-return-proper-error-in-lm3639_bled_mode_store-error-paths drivers/video/backlight/lm3639_bl.c
--- a/drivers/video/backlight/lm3639_bl.c~backlight-lm3639-return-proper-error-in-lm3639_bled_mode_store-error-paths
+++ a/drivers/video/backlight/lm3639_bl.c
@@ -206,11 +206,11 @@ static ssize_t lm3639_bled_mode_store(st
 
 out:
 	dev_err(pchip->dev, "%s:i2c access fail to register\n", __func__);
-	return size;
+	return ret;
 
 out_input:
 	dev_err(pchip->dev, "%s:input conversion fail\n", __func__);
-	return size;
+	return ret;
 
 }
 
_

Patches currently in -mm which might be from axel.lin@ingics.com are

origin.patch
drivers-video-backlight-lm3639_blc-return-proper-error-in-lm3639_bled_mode_store-error-paths.patch

