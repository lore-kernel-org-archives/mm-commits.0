From: akpm@linux-foundation.org
Subject: + pm3fb-change-option-mode-to-mode_option.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:59:44 -0800
Message-ID: <200802142159.m1ELxiqE005075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792AbYBNV7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:59:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     pm3fb: change option mode to mode_option
has been added to the -mm tree.  Its filename is
     pm3fb-change-option-mode-to-mode_option.patch

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
Subject: pm3fb: change option mode to mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add the option "mode_option".

This is one step toward changing all fb drivers to have common "mode_option"
parameter.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/pm3fb.c~pm3fb-change-option-mode-to-mode_option drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-change-option-mode-to-mode_option
+++ a/drivers/video/pm3fb.c
@@ -1571,6 +1571,8 @@ module_exit(pm3fb_exit);
 #endif
 module_init(pm3fb_init);
 
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
 module_param(noaccel, bool, 0);
 MODULE_PARM_DESC(noaccel, "Disable acceleration");
 module_param(hwcursor, int, 0644);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
