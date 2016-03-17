From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zsmalloc-add-freeable-column-to-pool-stat-fix.patch removed from -mm
 tree
Date: Thu, 17 Mar 2016 13:59:35 -0700
Message-ID: <56eb1ab7.evaGBZR/8SorX64E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbcCQU7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:59:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zsmalloc-add-freeable-column-to-pool-stat-fix
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-freeable-column-to-pool-stat-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-add-freeable-column-to-pool-stat.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: mm-zsmalloc-add-freeable-column-to-pool-stat-fix

looks like I failed to squash patches on my side properly and
`total_freeable' is not exactly aligned with the `freeable'
column name (off by one char %7 -> %8).

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-add-freeable-column-to-pool-stat-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-add-freeable-column-to-pool-stat-fix
+++ a/mm/zsmalloc.c
@@ -547,7 +547,7 @@ static int zs_stats_size_show(struct seq
 	}
 
 	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s %11lu %12lu %13lu %10lu %10lu %16s %7lu\n",
+	seq_printf(s, " %5s %5s %11lu %12lu %13lu %10lu %10lu %16s %8lu\n",
 			"Total", "", total_class_almost_full,
 			total_class_almost_empty, total_objs,
 			total_used_objs, total_pages, "", total_freeable);
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

mm-zsmalloc-add-freeable-column-to-pool-stat.patch

