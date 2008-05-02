From: akpm@linux-foundation.org
Subject: + tridentfb-remove-misplaced-enable_mmio.patch added to -mm tree
Date: Fri, 02 May 2008 05:30:58 -0700
Message-ID: <200805021230.m42CUwY6026246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761810AbYEBMbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 08:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: remove misplaced enable_mmio()
has been added to the -mm tree.  Its filename is
     tridentfb-remove-misplaced-enable_mmio.patch

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
Subject: tridentfb: remove misplaced enable_mmio()
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove redundant enable_mmio() call as the mmio mode is enabled in the probe
function earlier.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/tridentfb.c~tridentfb-remove-misplaced-enable_mmio drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-remove-misplaced-enable_mmio
+++ a/drivers/video/tridentfb.c
@@ -905,7 +905,6 @@ static int tridentfb_set_par(struct fb_i
 	vblankstart = var->yres;
 	vblankend = vtotal + 2;
 
-	enable_mmio();
 	crtc_unlock();
 	write3CE(CyberControl, 8);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
tridentfb-remove-misplaced-enable_mmio.patch
tridentfb-improve-clock-setting-accuracy.patch

