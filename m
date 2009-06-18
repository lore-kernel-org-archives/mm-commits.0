From: akpm@linux-foundation.org
Subject: + fbdev-does-not-allow-vesa-modes-without-compiled-in-drivers.patch added to -mm tree
Date: Thu, 18 Jun 2009 14:22:04 -0700
Message-ID: <200906182122.n5ILM4pn023786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbZFRVWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 17:22:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, spock@gentoo.org, wl@gnu.org


The patch titled
     fbdev: does not allow VESA modes without compiled-in drivers
has been added to the -mm tree.  Its filename is
     fbdev-does-not-allow-vesa-modes-without-compiled-in-drivers.patch

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
Subject: fbdev: does not allow VESA modes without compiled-in drivers
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Does not allow to accept VESA modes by the "vga=" kernel parameter if
there is no frame buffer driver compiled-in to handle it.

Also, there is a comment added to the Kconfig description after Werner
Lemberg's suggestion

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13249

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Reported-by: Werner Lemberg <wl@gnu.org>
Cc: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-does-not-allow-vesa-modes-without-compiled-in-drivers drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-does-not-allow-vesa-modes-without-compiled-in-drivers
+++ a/drivers/video/Kconfig
@@ -1122,12 +1122,14 @@ config FB_INTEL
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB_BOOT_VESA_SUPPORT
+	select FB_BOOT_VESA_SUPPORT if FB_INTEL = y
 	help
 	  This driver supports the on-board graphics built in to the Intel
           830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
           Say Y if you have and plan to use such a board.
 
+	  To make FB_INTELFB=Y work you need to say AGP_INTEL=y too.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called intelfb.
 
@@ -1460,7 +1462,7 @@ config FB_SIS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB_BOOT_VESA_SUPPORT
+	select FB_BOOT_VESA_SUPPORT if FB_SIS = y
 	help
 	  This is the frame buffer device driver for the SiS 300, 315, 330
 	  and 340 series as well as XGI V3XT, V5, V8, Z7 graphics chipsets.
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fbdev-does-not-allow-vesa-modes-without-compiled-in-drivers.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch

