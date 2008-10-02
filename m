From: akpm@linux-foundation.org
Subject: + vgacon-vgacon_scrolldelta-simplification.patch added to -mm tree
Date: Thu, 02 Oct 2008 15:28:11 -0700
Message-ID: <200810022228.m92MSBHq029809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754486AbYJBW2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 18:28:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, adaplas@gmail.com, krzysztof.h1@wp.pl


The patch titled
     vgacon: vgacon_scrolldelta simplification
has been added to the -mm tree.  Its filename is
     vgacon-vgacon_scrolldelta-simplification.patch

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
Subject: vgacon: vgacon_scrolldelta simplification
From: Marcin Slusarz <marcin.slusarz@gmail.com>

There's no point in checking diff == c->vc_rows, because it can be true
only when count == 0, but we already checked that.  Additionally move
variables used only in one block to this block.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN drivers/video/console/vgacon.c~vgacon-vgacon_scrolldelta-simplification drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vgacon-vgacon_scrolldelta-simplification
+++ a/drivers/video/console/vgacon.c
@@ -239,8 +239,7 @@ static void vgacon_restore_screen(struct
 
 static int vgacon_scrolldelta(struct vc_data *c, int lines)
 {
-	int start, end, count, soff, diff;
-	void *d, *s;
+	int start, end, count, soff;
 
 	if (!lines) {
 		c->vc_visible_origin = c->vc_origin;
@@ -287,13 +286,13 @@ static int vgacon_scrolldelta(struct vc_
 	if (count > c->vc_rows)
 		count = c->vc_rows;
 
-	diff = c->vc_rows - count;
-
-	d = (void *) c->vc_origin;
-	s = (void *) c->vc_screenbuf;
-
 	if (count) {
 		int copysize;
+
+		int diff = c->vc_rows - count;
+		void *d = (void *) c->vc_origin;
+		void *s = (void *) c->vc_screenbuf;
+
 		count *= c->vc_size_row;
 		/* how much memory to end of buffer left? */
 		copysize = min(count, vgacon_scrollback_size - soff);
@@ -305,14 +304,11 @@ static int vgacon_scrolldelta(struct vc_
 			scr_memcpyw(d, vgacon_scrollback, count);
 			d += count;
 		}
-	}
 
-	if (diff == c->vc_rows) {
-		vgacon_cursor(c, CM_MOVE);
-	} else {
 		if (diff)
 			scr_memcpyw(d, s, diff * c->vc_size_row);
-	}
+	} else
+		vgacon_cursor(c, CM_MOVE);
 
 	return 1;
 }
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch
git-x86.patch
vgacon-optimize-scrolling.patch
vgacon-vgacon_scrolldelta-simplification.patch

