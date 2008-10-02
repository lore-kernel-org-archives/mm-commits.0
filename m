From: akpm@linux-foundation.org
Subject: + vgacon-optimize-scrolling.patch added to -mm tree
Date: Thu, 02 Oct 2008 15:28:09 -0700
Message-ID: <200810022228.m92MS9Um029806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbYJBW2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 18:28:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, adaplas@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     vgacon: optimize scrolling
has been added to the -mm tree.  Its filename is
     vgacon-optimize-scrolling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vgacon: optimize scrolling
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Join multiple scr_memcpyw into 1-3 calls (usually 2).  (benchmarked
average speedup: 1%)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN drivers/video/console/vgacon.c~vgacon-optimize-scrolling drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vgacon-optimize-scrolling
+++ a/drivers/video/console/vgacon.c
@@ -292,23 +292,26 @@ static int vgacon_scrolldelta(struct vc_
 	d = (void *) c->vc_origin;
 	s = (void *) c->vc_screenbuf;
 
-	while (count--) {
-		scr_memcpyw(d, vgacon_scrollback + soff, c->vc_size_row);
-		d += c->vc_size_row;
-		soff += c->vc_size_row;
-
-		if (soff >= vgacon_scrollback_size)
-			soff = 0;
+	if (count) {
+		int copysize;
+		count *= c->vc_size_row;
+		/* how much memory to end of buffer left? */
+		copysize = min(count, vgacon_scrollback_size - soff);
+		scr_memcpyw(d, vgacon_scrollback + soff, copysize);
+		d += copysize;
+		count -= copysize;
+
+		if (count) {
+			scr_memcpyw(d, vgacon_scrollback, count);
+			d += count;
+		}
 	}
 
 	if (diff == c->vc_rows) {
 		vgacon_cursor(c, CM_MOVE);
 	} else {
-		while (diff--) {
-			scr_memcpyw(d, s, c->vc_size_row);
-			d += c->vc_size_row;
-			s += c->vc_size_row;
-		}
+		if (diff)
+			scr_memcpyw(d, s, diff * c->vc_size_row);
 	}
 
 	return 1;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch
git-x86.patch
vgacon-optimize-scrolling.patch
vgacon-vgacon_scrolldelta-simplification.patch

