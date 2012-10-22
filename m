From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lm3639_blc-return-proper-error-in-lm3639_bled_mode_store-error-paths.patch removed from -mm tree
Date: Mon, 22 Oct 2012 12:13:26 -0700
Message-ID: <20121022191327.699D4200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:54769 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2JVTN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:13:29 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so183365lah.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:13:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@ingics.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lm3639_bl.c: return proper error in lm3639_bled_mode_store() error paths
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lm3639_blc-return-proper-error-in-lm3639_bled_mode_store-error-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/video/backlight/lm3639_bl.c: return proper error in lm3639_bled_mode_store() error paths

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3639_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/lm3639_bl.c~drivers-video-backlight-lm3639_blc-return-proper-error-in-lm3639_bled_mode_store-error-paths drivers/video/backlight/lm3639_bl.c
--- a/drivers/video/backlight/lm3639_bl.c~drivers-video-backlight-lm3639_blc-return-proper-error-in-lm3639_bled_mode_store-error-paths
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

linux-next.patch

