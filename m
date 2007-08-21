From: akpm@linux-foundation.org
Subject: + check-for-ppc32-in-imsttfb.patch added to -mm tree
Date: Mon, 20 Aug 2007 21:52:27 -0700
Message-ID: <200708210452.l7L4qR2O007455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbXHUEws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 00:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, adaplas@pol.net, paulus@samba.org


The patch titled
     Check for PPC32 in imsttfb
has been added to the -mm tree.  Its filename is
     check-for-ppc32-in-imsttfb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Check for PPC32 in imsttfb
From: Stephen Rothwell <sfr@canb.auug.org.au>

This is the correct fix according to Paul Mackerras and allows an
allyesconfig on PPC64 to build.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imsttfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/imsttfb.c~check-for-ppc32-in-imsttfb drivers/video/imsttfb.c
--- a/drivers/video/imsttfb.c~check-for-ppc32-in-imsttfb
+++ a/drivers/video/imsttfb.c
@@ -1391,7 +1391,7 @@ init_imstt(struct fb_info *info)
 		}
 	}
 
-#if USE_NV_MODES && defined(CONFIG_PPC)
+#if USE_NV_MODES && defined(CONFIG_PPC32)
 	{
 		int vmode = init_vmode, cmode = init_cmode;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

check-for-ppc32-in-imsttfb.patch
git-alsa.patch
git-powerpc.patch
allow-disabling-dnotify-without-embedded.patch
