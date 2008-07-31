From: akpm@linux-foundation.org
Subject: + fbcon-fix-scrolling-after-logo-is-cleared.patch added to -mm tree
Date: Thu, 31 Jul 2008 01:52:43 -0700
Message-ID: <200807310852.m6V8qhQR013825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbYGaIww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 04:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     fbcon: fix scrolling after logo is cleared
has been added to the -mm tree.  Its filename is
     fbcon-fix-scrolling-after-logo-is-cleared.patch

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
Subject: fbcon: fix scrolling after logo is cleared
From: Krzysztof Helt <krzysztof.h1@wp.pl>

If the 'clear' command is used on the frame buffer with a logo the upper
area is filled by few lines but not scrolled anymore.

Fix this by removing the protected area for the logo if any part of the
logo is cleared.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-scrolling-after-logo-is-cleared drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-scrolling-after-logo-is-cleared
+++ a/drivers/video/console/fbcon.c
@@ -1311,6 +1311,9 @@ static void fbcon_clear(struct vc_data *
 	if (!height || !width)
 		return;
 
+	if (sy < vc->vc_top && vc->vc_top == logo_lines)
+		vc->vc_top = 0;
+
 	/* Split blits that cross physical y_wrap boundary */
 
 	y_break = p->vrows - p->yscroll;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
fbcon-fix-scrolling-after-logo-is-cleared.patch

