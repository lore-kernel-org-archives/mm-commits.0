From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-kconfig-fix-typo-mach_sam9ek-three-times.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:56:33 -0700
Message-ID: <20130312205633.796FB31C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:55934 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab3CLU4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:56:34 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so35509qen.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:56:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pebolle@tiscali.nl, FlorianSchandinat@gmx.de, jg1.han@samsung.com, nicolas.ferre@atmel.com


The patch titled
     Subject: drivers/video/backlight/Kconfig: fix typo "MACH_SAM9...EK" three times
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-kconfig-fix-typo-mach_sam9ek-three-times.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: drivers/video/backlight/Kconfig: fix typo "MACH_SAM9...EK" three times

Fix three typos (originally) introduced by a9a84c37d ("atmel_lcdfb:
backlight control").

Two of these typos were introduced in v2.6.25.  (The third was introduced
in 915190f7d4f08 ("[ARM] 5614/1: at91: atmel_lcdfb: add at91sam9g10
support to atmel LCD driver")).  Checking these commits reveals that the
default value of 'y' has never been set automatically in all releases
since v2.6.25!  Perhaps this line might as well be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/Kconfig~drivers-video-backlight-kconfig-fix-typo-mach_sam9ek-three-times drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~drivers-video-backlight-kconfig-fix-typo-mach_sam9ek-three-times
+++ a/drivers/video/backlight/Kconfig
@@ -161,7 +161,7 @@ if BACKLIGHT_CLASS_DEVICE
 config BACKLIGHT_ATMEL_LCDC
 	bool "Atmel LCDC Contrast-as-Backlight control"
 	depends on FB_ATMEL
-	default y if MACH_SAM9261EK || MACH_SAM9G10EK || MACH_SAM9263EK
+	default y if MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK
 	help
 	  This provides a backlight control internal to the Atmel LCDC
 	  driver.  If the LCD "contrast control" on your board is wired
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

origin.patch
linux-next.patch
decompressors-fix-typo-powerpc.patch
drivers-video-backlight-kconfig-fix-typo-mach_sam9ek-three-times.patch

