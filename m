From: akpm@linux-foundation.org
Subject: + fbcon-fix-monochrome-color-value-calculation.patch added to -mm tree
Date: Wed, 10 Sep 2008 14:15:28 -0700
Message-ID: <200809102115.m8ALFSPJ026561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYIJVPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 17:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: q-newsgroup@qypea.com, adaplas@pol.net, harvey.harrison@gmail.com, krzysztof.h1@poczta.fm, stable@kernel.org


The patch titled
     fbcon: fix monochrome color value calculation
has been added to the -mm tree.  Its filename is
     fbcon-fix-monochrome-color-value-calculation.patch

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
Subject: fbcon: fix monochrome color value calculation
From: David Winn <q-newsgroup@qypea.com>

Commit 22af89aa0c0b4012a7431114a340efd3665a7617 ("fbcon: replace mono_col
macro with static inline") changed the order of operations for computing
monochrome color values.  This generates 0xffff000f instead of 0x0000000f
for a 4 bit monochrome color, leading to image corruption if it is passed
to cfb_imageblit or other similar functions.  Fix it up.

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.h~fbcon-fix-monochrome-color-value-calculation drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbcon-fix-monochrome-color-value-calculation
+++ a/drivers/video/console/fbcon.h
@@ -110,7 +110,7 @@ static inline int mono_col(const struct 
 	__u32 max_len;
 	max_len = max(info->var.green.length, info->var.red.length);
 	max_len = max(info->var.blue.length, max_len);
-	return ~(0xfff << (max_len & 0xff));
+	return (~(0xfff << max_len)) & 0xff;
 }
 
 static inline int attr_col_ec(int shift, struct vc_data *vc,
_

Patches currently in -mm which might be from q-newsgroup@qypea.com are

fbcon-fix-monochrome-color-value-calculation.patch

