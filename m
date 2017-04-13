From: akpm@linux-foundation.org
Subject: [patch 10/11] zsmalloc: expand class bit
Date: Thu, 13 Apr 2017 14:56:40 -0700
Message-ID: <58eff418.BgU6Nx+Fa8i5mvTZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdDMV4l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: expand class bit

Now 64K page system, zsamlloc has 257 classes so 8 class bit is not
enough.  With that, it corrupts the system when zsmalloc stores 65536byte
data(ie, index number 256) so that this patch increases class bit for
simple fix for stable backport.  We should clean up this mess soon.

index	size
0	32
1	288
..
..
204	52256
256	65536

Fixes: 3783689a1 ("zsmalloc: introduce zspage structure")
Link: http://lkml.kernel.org/r/1492042622-12074-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-expand-class-bit mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-expand-class-bit
+++ a/mm/zsmalloc.c
@@ -276,7 +276,7 @@ struct zs_pool {
 struct zspage {
 	struct {
 		unsigned int fullness:FULLNESS_BITS;
-		unsigned int class:CLASS_BITS;
+		unsigned int class:CLASS_BITS + 1;
 		unsigned int isolated:ISOLATED_BITS;
 		unsigned int magic:MAGIC_VAL_BITS;
 	};
_
