From: akpm@linux-foundation.org
Subject: + tridentfb-fix-memory-size-detection.patch added to -mm tree
Date: Wed, 05 Mar 2008 13:51:39 -0800
Message-ID: <200803052151.m25Lpddo022768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537AbYCEVwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 16:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: fix memory size detection
has been added to the -mm tree.  Its filename is
     tridentfb-fix-memory-size-detection.patch

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
Subject: tridentfb: fix memory size detection
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix memory size multiplier during detection.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-memory-size-detection drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-memory-size-detection
+++ a/drivers/video/tridentfb.c
@@ -745,7 +745,7 @@ static unsigned int __devinit get_memsiz
 			switch (tmp) {
 
 			case 0x01:
-				k = 512;
+				k = 512 * Kb;
 				break;
 			case 0x02:
 				k = 6 * Mb;	/* XP */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-register-should-be-left-in-non-locked-state.patch
tridentfb-fix-memory-size-detection.patch
pm2fb-correct-error-values-returned-from-probe-function.patch
pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
arkfb-add-option-mode_option.patch
s3fb-add-option-mode_option.patch
fbdev-add-removed-option-mode-to-keep-compatibility.patch

