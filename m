From: akpm@linux-foundation.org
Subject: [merged] unlzo-fix-input-buffer-free.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:37:41 -0800
Message-ID: <20120113203741.9850710004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:59009 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:37:42 -0500
Received: by ggnk3 with SMTP id k3so356010ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:37:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, lasse.collin@tukaani.org, namhyung@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: unlzo: fix input buffer free
has been removed from the -mm tree.  Its filename was
     unlzo-fix-input-buffer-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: unlzo: fix input buffer free

unlzo modifies the pointer to in_buf, so we have to free the original
buffer, not the modified pointer.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Cc: Namhyung Kim <namhyung@gmail.com>
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

Patches currently in -mm which might be from s.hauer@pengutronix.de are

origin.patch
linux-next.patch

