From: akpm@linux-foundation.org
Subject: [nacked]
 mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage.patch
 removed from -mm tree
Date: Fri, 06 May 2016 16:20:37 -0700
Message-ID: <572d26c5.ua/BDS5UX6xIO+8w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784AbcEFXUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 19:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: avoid unnecessary iteration in get_pages_per_zspage()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: avoid unnecessary iteration in get_pages_per_zspage()

If we find a zspage with usage == 100%, there is no need to try other
zspages.

Link: http://lkml.kernel.org/r/1462425447-13385-1-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/zsmalloc.c~mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-avoid-unnecessary-iteration-in-get_pages_per_zspage
+++ a/mm/zsmalloc.c
@@ -770,6 +770,9 @@ static int get_pages_per_zspage(int clas
 		if (usedpc > max_usedpc) {
 			max_usedpc = usedpc;
 			max_usedpc_order = i;
+
+			if (max_usedpc == 100)
+				break;
 		}
 	}
 
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are


