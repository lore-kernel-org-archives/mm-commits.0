From: akpm@linux-foundation.org
Subject: + drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll.patch added to -mm tree
Date: Wed, 13 Feb 2008 16:52:17 -0800
Message-ID: <200802140052.m1E0qIKq023219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762236AbYBNAwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 19:52:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergio@larces.uece.br, adaplas@pol.net, spock@gentoo.org


The patch titled
     drivers/video/uvesafb.c: fix section mismatch warning in param_set_scroll()
has been added to the -mm tree.  Its filename is
     drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll.patch

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
Subject: drivers/video/uvesafb.c: fix section mismatch warning in param_set_scroll()
From: Sergio Luis <sergio@larces.uece.br>

Fix following warnings:
WARNING: drivers/video/built-in.o(.text+0x7c64a): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/video/built-in.o(.text+0x7c65d): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/video/built-in.o(.text+0x7c679): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/video/built-in.o(.text+0x7c699): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/video/built-in.o(.text+0x7c69f): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa3676): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa3689): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa36a5): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa36c5): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: drivers/built-in.o(.text+0xa36cb): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a079a): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a07ad): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a07c9): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a07e9): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan
WARNING: vmlinux.o(.text+0x4a07ef): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:ypan

Remove __devinitdata annotation from the variable ypan.

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Cc: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/uvesafb.c~drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll
+++ a/drivers/video/uvesafb.c
@@ -44,7 +44,7 @@ static struct fb_fix_screeninfo uvesafb_
 
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */
 static int blank	= 1;		   /* enable blanking by default */
-static int ypan		__devinitdata = 1; /* 0: scroll, 1: ypan, 2: ywrap */
+static int ypan		= 1; 		 /* 0: scroll, 1: ypan, 2: ywrap */
 static int pmi_setpal	__devinitdata = 1; /* use PMI for palette changes */
 static int nocrtc	__devinitdata; /* ignore CRTC settings */
 static int noedid	__devinitdata; /* don't try DDC transfers */
_

Patches currently in -mm which might be from sergio@larces.uece.br are

drivers-video-uvesafbc-fix-section-mismatch-warning-in-param_set_scroll.patch
