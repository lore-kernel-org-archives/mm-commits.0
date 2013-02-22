From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-adp880_blc-fix-resume.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:21 -0800
Message-ID: <20130222204221.AFC1A31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:43752 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:22 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103864ggi.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, michael.hennerich@analog.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp88?0_bl.c: fix resume
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-adp880_blc-fix-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lars-Peter Clausen <lars@metafoo.de>
Subject: drivers/video/backlight/adp88?0_bl.c: fix resume

Clearing the NSTBY bit in the control register also automatically clears
the BLEN bit.  So we need to make sure to set it again during resume,
otherwise the backlight will stay off.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    2 +-
 drivers/video/backlight/adp8870_bl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp880_blc-fix-resume drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp880_blc-fix-resume
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -783,7 +783,7 @@ static int adp8860_i2c_suspend(struct i2
 
 static int adp8860_i2c_resume(struct i2c_client *client)
 {
-	adp8860_set_bits(client, ADP8860_MDCR, NSTBY);
+	adp8860_set_bits(client, ADP8860_MDCR, NSTBY | BLEN);
 
 	return 0;
 }
diff -puN drivers/video/backlight/adp8870_bl.c~drivers-video-backlight-adp880_blc-fix-resume drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~drivers-video-backlight-adp880_blc-fix-resume
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -957,7 +957,7 @@ static int adp8870_i2c_suspend(struct i2
 
 static int adp8870_i2c_resume(struct i2c_client *client)
 {
-	adp8870_set_bits(client, ADP8870_MDCR, NSTBY);
+	adp8870_set_bits(client, ADP8870_MDCR, NSTBY | BLEN);
 
 	return 0;
 }
_

Patches currently in -mm which might be from lars@metafoo.de are

origin.patch
linux-next.patch

