From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:00:39 -0800
Message-ID: <569e95e7.8Se4F+sFhWc+2FX9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbcASUAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: reorganize struct size_class to pack 4 bytes hole
has been removed from the -mm tree.  Its filename was
     zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: zsmalloc: reorganize struct size_class to pack 4 bytes hole

Reoder the pages_per_zspage field in struct size_class which can eliminate
the 4 bytes hole between it and stats field.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-reorganize-struct-size_class-to-pack-4-bytes-hole
+++ a/mm/zsmalloc.c
@@ -213,10 +213,10 @@ struct size_class {
 	int size;
 	unsigned int index;
 
-	/* Number of PAGE_SIZE sized pages to combine to form a 'zspage' */
-	int pages_per_zspage;
 	struct zs_size_stat stats;
 
+	/* Number of PAGE_SIZE sized pages to combine to form a 'zspage' */
+	int pages_per_zspage;
 	/* huge object: pages_per_zspage == 1 && maxobj_per_zspage == 1 */
 	bool huge;
 };
_

Patches currently in -mm which might be from weijie.yang@samsung.com are


