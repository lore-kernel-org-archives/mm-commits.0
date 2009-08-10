From: akpm@linux-foundation.org
Subject: [merged] fbcon-fix-rotate-upside-down-crash.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:11 -0700
Message-ID: <200908101927.n7AJRBAG025450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbZHJT1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbcon: fix rotate upside down crash
has been removed from the -mm tree.  Its filename was
     fbcon-fix-rotate-upside-down-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ctags-usability-fix.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch

