From: akpm@linux-foundation.org
Subject: + s3c2410fb-fix-incorrect-argument-type-in-resume-function.patch added to -mm tree
Date: Fri, 11 Jan 2008 13:45:41 -0800
Message-ID: <200801112145.m0BLjL9M029128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbYAKVp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 16:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     s3c2410fb: fix incorrect argument type in resume function
has been added to the -mm tree.  Its filename is
     s3c2410fb-fix-incorrect-argument-type-in-resume-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c2410fb: fix incorrect argument type in resume function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix wrong pointer type passed into the s3c2410fb_init_registers() function.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-fix-incorrect-argument-type-in-resume-function drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-fix-incorrect-argument-type-in-resume-function
+++ a/drivers/video/s3c2410fb.c
@@ -1026,7 +1026,7 @@ static int s3c2410fb_resume(struct platf
 	clk_enable(info->clk);
 	msleep(1);
 
-	s3c2410fb_init_registers(info);
+	s3c2410fb_init_registers(fbinfo);
 
 	return 0;
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

s3c2410fb-fix-incorrect-argument-type-in-resume-function.patch
git-alsa.patch
drivers-video-pm3fbc-section-fix.patch
