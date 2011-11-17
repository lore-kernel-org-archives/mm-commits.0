From: akpm@linux-foundation.org
Subject: + unlzo-fix-input-buffer-free.patch added to -mm tree
Date: Thu, 17 Nov 2011 14:11:09 -0800
Message-ID: <201111172211.pAHMB90s004649@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:51571 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1KQWLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 17:11:17 -0500
Received: by faap16 with SMTP id p16so79197faa.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 14:11:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, lasse.collin@tukaani.org


The patch titled
     Subject: unlzo: Fix input buffer free
has been added to the -mm tree.  Its filename is
     unlzo-fix-input-buffer-free.patch

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
From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: unlzo: Fix input buffer free

unlzo modifies the pointer to in_buf, so we have to free the original
buffer, not the modified pointer.  This only happens when a fill function
is passed, a case which is currently unused in the kernel.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/decompress_unlzo.c~unlzo-fix-input-buffer-free lib/decompress_unlzo.c
--- a/lib/decompress_unlzo.c~unlzo-fix-input-buffer-free
+++ a/lib/decompress_unlzo.c
@@ -279,7 +279,7 @@ STATIC inline int INIT unlzo(u8 *input, 
 	ret = 0;
 exit_2:
 	if (!input)
-		free(in_buf);
+		free(in_buf_save);
 exit_1:
 	if (!output)
 		free(out_buf);
_
Subject: Subject: unlzo: Fix input buffer free

Patches currently in -mm which might be from s.hauer@pengutronix.de are

origin.patch
linux-next.patch
unlzo-fix-input-buffer-free.patch

