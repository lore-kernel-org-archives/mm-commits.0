From: akpm@linux-foundation.org
Subject: + wm9712-return-0-rather-than-rc_penup-on-error.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:09:27 -0700
Message-ID: <200803312109.m2VL9RjN026189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbYCaVJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:09:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, gg@opensource.wolfsonmicro.com, liam.girdwood@wolfsonmicro.com, mike.arthur@wolfsonmicro.com


The patch titled
     wm9712: return 0 rather than RC_PENUP on error
has been added to the -mm tree.  Its filename is
     wm9712-return-0-rather-than-rc_penup-on-error.patch

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
Subject: wm9712: return 0 rather than RC_PENUP on error
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

This prevents spurious pen up events if the ADC failed to obtain a sample.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Cc: Graeme Gregory <gg@opensource.wolfsonmicro.com>
Cc: Mike Arthur <mike.arthur@wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm9712.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/wm9712.c~wm9712-return-0-rather-than-rc_penup-on-error drivers/input/touchscreen/wm9712.c
--- a/drivers/input/touchscreen/wm9712.c~wm9712-return-0-rather-than-rc_penup-on-error
+++ a/drivers/input/touchscreen/wm9712.c
@@ -368,7 +368,7 @@ static int wm9712_poll_coord(struct wm97
 	}
 	return RC_VALID;
 err:
-	return RC_PENUP;
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

git-alsa-tiwai.patch
git-arm.patch
input-core-driver-for-wm97xx-touchscreens.patch
input-add-chip-driver-for-wm9705-touchscreen.patch
input-add-chip-driver-for-wm9712-touchscreen.patch
input-add-chip-driver-for-wm9713-touchscreen.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch
wm9712-return-0-rather-than-rc_penup-on-error.patch
wm9713-return-0-rather-than-rc_penup-on-error.patch
wm9705-bump-version-number.patch
wm9712-bump-version-number.patch
wm9713-bump-version-number.patch

