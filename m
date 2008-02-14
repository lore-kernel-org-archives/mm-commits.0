From: akpm@linux-foundation.org
Subject: + media-tuner-xc2028-depends-on-fw_loader.patch added to -mm tree
Date: Wed, 13 Feb 2008 23:27:54 -0800
Message-ID: <200802140727.m1E7RsVu004803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbYBNH2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 02:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org


The patch titled
     media: tuner-xc2028 depends on FW_LOADER
has been added to the -mm tree.  Its filename is
     media-tuner-xc2028-depends-on-fw_loader.patch

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
Subject: media: tuner-xc2028 depends on FW_LOADER
From: Paul Mundt <lethal@linux-sh.org>

ERROR: "release_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!
ERROR: "request_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/Kconfig~media-tuner-xc2028-depends-on-fw_loader drivers/media/Kconfig
--- a/drivers/media/Kconfig~media-tuner-xc2028-depends-on-fw_loader
+++ a/drivers/media/Kconfig
@@ -102,7 +102,7 @@ if VIDEO_TUNER_CUSTOMIZE
 
 config TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
-	depends on I2C
+	depends on I2C && FW_LOADER
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
_

Patches currently in -mm which might be from lethal@linux-sh.org are

pcmcia-ipwireless-depends-on-netdevices.patch
media-tuner-xc2028-depends-on-fw_loader.patch
git-sh.patch
xtime_lock-vs-update_process_times.patch
taint-kernel-after-warn_oncondition.patch
sm501-add-uart-support.patch
asm-futexh-should-include-linux-uaccessh.patch
