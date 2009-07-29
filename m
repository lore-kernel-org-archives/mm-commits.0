From: akpm@linux-foundation.org
Subject: + fbcon-fix-rotate-upside-down-crash.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:26:56 -0700
Message-ID: <200907292026.n6TKQucX022673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755930AbZG2U1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, krzysztof.h1@poczta.fm


The patch titled
     fbcon: fix rotate upside down crash
has been added to the -mm tree.  Its filename is
     fbcon-fix-rotate-upside-down-crash.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: fix rotate upside down crash
From: Stefani Seibold <stefani@seibold.net>

Fix the rotate_ud() function not to crash in case of a font which has not
a width of multiple by 8: The inner loop of the font pixel copy should not
access a bit outside the font memory area.  Subtract the shift offset from
the font width will prevent this.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon_rotate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon_rotate.h~fbcon-fix-rotate-upside-down-crash drivers/video/console/fbcon_rotate.h
--- a/drivers/video/console/fbcon_rotate.h~fbcon-fix-rotate-upside-down-crash
+++ a/drivers/video/console/fbcon_rotate.h
@@ -45,7 +45,7 @@ static inline void rotate_ud(const char 
 	width = (width + 7) & ~7;
 
 	for (i = 0; i < height; i++) {
-		for (j = 0; j < width; j++) {
+		for (j = 0; j < width - shift; j++) {
 			if (pattern_test_bit(j, i, width, in))
 				pattern_set_bit(width - (1 + j + shift),
 						height - (1 + i),
_

Patches currently in -mm which might be from stefani@seibold.net are

fbcon-fix-rotate-upside-down-crash.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch

