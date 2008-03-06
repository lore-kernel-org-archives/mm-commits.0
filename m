From: akpm@linux-foundation.org
Subject: + fbmem-fix-con2fbmap-limit-check.patch added to -mm tree
Date: Wed, 05 Mar 2008 22:26:50 -0800
Message-ID: <200803060626.m266QoCr012578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383AbYCFG1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 01:27:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@p12n.org, adaplas@pol.net, geert@linux-m68k.org


The patch titled
     fbmem: fix con2fbmap limit check
has been added to the -mm tree.  Its filename is
     fbmem-fix-con2fbmap-limit-check.patch

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
Subject: fbmem: fix con2fbmap limit check
From: Peter Samuelson <peter@p12n.org>

Fix limit check in FBIOPUT_CON2FBMAP ioctl.

Signed-off-by: Peter Samuelson <peter@p12n.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbmem.c~fbmem-fix-con2fbmap-limit-check drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbmem-fix-con2fbmap-limit-check
+++ a/drivers/video/fbmem.c
@@ -1057,7 +1057,7 @@ fb_ioctl(struct inode *inode, struct fil
 	case FBIOPUT_CON2FBMAP:
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
 			return - EFAULT;
-		if (con2fb.console < 0 || con2fb.console > MAX_NR_CONSOLES)
+		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
 		    return -EINVAL;
 		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
 		    return -EINVAL;
_

Patches currently in -mm which might be from peter@p12n.org are

fbmem-fix-con2fbmap-limit-check.patch

