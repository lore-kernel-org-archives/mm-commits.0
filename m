From: akpm@linux-foundation.org
Subject: + fbcon-bgcolor-fix.patch added to -mm tree
Date: Thu, 10 Jul 2008 01:24:48 -0700
Message-ID: <200807100830.m6A8UGTY016941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbYGJIaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jul 2008 04:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefano.stabellini@eu.citrix.com, adaplas@pol.net, krzysztof.h1@poczta.fm


The patch titled
     fbcon: bgcolor fix
has been added to the -mm tree.  Its filename is
     fbcon-bgcolor-fix.patch

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
Subject: fbcon: bgcolor fix
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

The fourth bit of the background color is the blink property bit, not the
intensity bit, as for the foreground color.  Therefore it shouldn't be
included in the background color.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.h~fbcon-bgcolor-fix drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbcon-bgcolor-fix
+++ a/drivers/video/console/fbcon.h
@@ -92,7 +92,7 @@ struct fbcon_ops {
 #define attr_fgcol(fgshift,s)    \
 	(((s) >> (fgshift)) & 0x0f)
 #define attr_bgcol(bgshift,s)    \
-	(((s) >> (bgshift)) & 0x0f)
+	(((s) >> (bgshift)) & 0x07)
 
 /* Monochrome */
 #define attr_bold(s) \
_

Patches currently in -mm which might be from stefano.stabellini@eu.citrix.com are

fbcon-bgcolor-fix.patch

