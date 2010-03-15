From: akpm@linux-foundation.org
Subject: + fbdev-fix-kconfig-breakage-in-drivers-video.patch added to -mm tree
Date: Mon, 15 Mar 2010 13:50:45 -0700
Message-ID: <201003152050.o2FKojlI021772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932183Ab0COUur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 16:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, davem@davemloft.net


The patch titled
     fbdev: fix Kconfig breakage in drivers/video
has been added to the -mm tree.  Its filename is
     fbdev-fix-kconfig-breakage-in-drivers-video.patch

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
Subject: fbdev: fix Kconfig breakage in drivers/video
From: Krzysztof Helt <krzysztof.h1@wp.pl>

There are two new options inside the CONFIG_FB section which do not depend
on the CONFIG_FB.  This break Kconfig menu layout.

Fix it and reduce few conditions for sparc frame buffers as the FB_SBUS ==
((FB = y) && SPARC).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-fix-kconfig-breakage-in-drivers-video drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-fix-kconfig-breakage-in-drivers-video
+++ a/drivers/video/Kconfig
@@ -400,12 +400,9 @@ config FB_SA1100
 	  If you plan to use the LCD display with your SA-1100 system, say
 	  Y here.
 
-config HAVE_FB_IMX
-	bool
-
 config FB_IMX
 	tristate "Motorola i.MX LCD support"
-	depends on FB && (HAVE_FB_IMX || ARCH_MX1 || ARCH_MX2)
+	depends on FB && (ARCH_MX1 || ARCH_MX2)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -802,7 +799,7 @@ config FB_SBUS
 
 config FB_BW2
 	bool "BWtwo support"
-	depends on (FB = y) && (SPARC && FB_SBUS)
+	depends on FB_SBUS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -811,7 +808,7 @@ config FB_BW2
 
 config FB_CG3
 	bool "CGthree support"
-	depends on (FB = y) && (SPARC && FB_SBUS)
+	depends on FB_SBUS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -820,7 +817,7 @@ config FB_CG3
 
 config FB_CG6
 	bool "CGsix (GX,TurboGX) support"
-	depends on (FB = y) && (SPARC && FB_SBUS)
+	depends on FB_SBUS
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	help
@@ -914,7 +911,7 @@ config FB_XVR2500
 
 config FB_XVR1000
 	bool "Sun XVR-1000 support"
-	depends on SPARC64
+	depends on (FB = y) && SPARC64
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fbdev-fix-kconfig-breakage-in-drivers-video.patch
linux-next.patch

