From: akpm@linux-foundation.org
Subject: + video-s3c_fbc-fix-build-with-config_hotplug=n.patch added to -mm tree
Date: Sun, 20 Sep 2009 08:36:22 -0700
Message-ID: <200909201536.n8KFaMjn026925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbZITPhq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Sep 2009 11:37:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacmet@sunsite.dk, ben-linux@fluff.org, stable@kernel.org


The patch titled
     video: s3c_fb.c: fix build with CONFIG_HOTPLUG=n
has been added to the -mm tree.  Its filename is
     video-s3c_fbc-fix-build-with-config_hotplug=n.patch

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
Subject: video: s3c_fb.c: fix build with CONFIG_HOTPLUG=n
From: Peter Korsgaard <jacmet@sunsite.dk>

Fixes `s3c_fb_remove' referenced in section `.data' of
drivers/built-in.o: defined in discarded section `.devexit.text' of
drivers/built-in.o

With CONFIG_HOTPLUG=n, functions marked with __devexit gets removed,
so make sure we use __devexit_p when referencing pointers to them.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/s3c-fb.c~video-s3c_fbc-fix-build-with-config_hotplug=n drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~video-s3c_fbc-fix-build-with-config_hotplug=n
+++ a/drivers/video/s3c-fb.c
@@ -1036,7 +1036,7 @@ static int s3c_fb_resume(struct platform
 
 static struct platform_driver s3c_fb_driver = {
 	.probe		= s3c_fb_probe,
-	.remove		= s3c_fb_remove,
+	.remove		= __devexit_p(s3c_fb_remove),
 	.suspend	= s3c_fb_suspend,
 	.resume		= s3c_fb_resume,
 	.driver		= {
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

origin.patch
linux-next.patch
video-s3c_fbc-fix-build-with-config_hotplug=n.patch

