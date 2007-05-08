From: akpm@linux-foundation.org
Subject: - fix-ppp_deflate-issues-with-recent-zlib_inflate-changes.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:55 -0700
Message-ID: <200705080007.l4807tIB009329@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967454AbXEHAJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpurdie@rpsys.net, stable@kernel.org, stefan.wenk@gmx.at, mm-commits@vger.kernel.org


The patch titled
     Fix ppp_deflate issues with recent zlib_inflate changes
has been removed from the -mm tree.  Its filename was
     fix-ppp_deflate-issues-with-recent-zlib_inflate-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix ppp_deflate issues with recent zlib_inflate changes
From: Richard Purdie <rpurdie@rpsys.net>

The last zlib_inflate update broke certain corner cases for ppp_deflate
decompression handling.  This patch fixes some logic to make things work
properly again.  Users other than ppp_deflate (the only Z_PACKET_FLUSH
user) should be unaffected.

Fixes bug 8405 (confirmed by Stefan)

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
Cc: Stefan Wenk <stefan.wenk@gmx.at>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inflate.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/zlib_inflate/inflate.c~fix-ppp_deflate-issues-with-recent-zlib_inflate-changes lib/zlib_inflate/inflate.c
--- a/lib/zlib_inflate/inflate.c~fix-ppp_deflate-issues-with-recent-zlib_inflate-changes
+++ a/lib/zlib_inflate/inflate.c
@@ -743,12 +743,14 @@ int zlib_inflate(z_streamp strm, int flu
 
     strm->data_type = state->bits + (state->last ? 64 : 0) +
                       (state->mode == TYPE ? 128 : 0);
-    if (((in == 0 && out == 0) || flush == Z_FINISH) && ret == Z_OK)
-        ret = Z_BUF_ERROR;
 
     if (flush == Z_PACKET_FLUSH && ret == Z_OK &&
-            (strm->avail_out != 0 || strm->avail_in == 0))
+            strm->avail_out != 0 && strm->avail_in == 0)
 		return zlib_inflateSyncPacket(strm);
+
+    if (((in == 0 && out == 0) || flush == Z_FINISH) && ret == Z_OK)
+        ret = Z_BUF_ERROR;
+
     return ret;
 }
 
_

Patches currently in -mm which might be from rpurdie@rpsys.net are

origin.patch
git-leds.patch
