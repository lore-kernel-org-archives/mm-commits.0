From: akpm@linux-foundation.org
Subject: - fbcon-bgcolor-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:19 -0700
Message-ID: <200807242333.m6ONXJtA011918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756010AbYGXXd0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefano.stabellini@eu.citrix.com, adaplas@pol.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbcon: bgcolor fix
has been removed from the -mm tree.  Its filename was
     fbcon-bgcolor-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

