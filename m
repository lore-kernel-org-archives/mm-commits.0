From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-adp880_blc-fix-resume.patch added to -mm tree
Date: Tue, 19 Feb 2013 13:31:18 -0800
Message-ID: <20130219213119.3DB525A435F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52016 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016Ab3BSVbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 16:31:20 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so436357ggi.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 13:31:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@metafoo.de, michael.hennerich@analog.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp88?0_bl.c: fix resume
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-adp880_blc-fix-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-video-backlight-adp880_blc-fix-resume.patch

