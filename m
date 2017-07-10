From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch removed from -mm
 tree
Date: Mon, 10 Jul 2017 15:34:29 -0700
Message-ID: <596400f5.DpoLTofahjJUkdsL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754848AbdGJWea (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmarchan@redhat.com, minchan@kernel.org, opensource.ganesh@gmail.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch

This patch was dropped because it was folded into mm-zsmalloc-simplify-zs_max_alloc_size-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix

use min_t

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix
+++ a/mm/zsmalloc.c
@@ -548,7 +548,7 @@ static int get_size_class_index(int size
 		idx = DIV_ROUND_UP(size - ZS_MIN_ALLOC_SIZE,
 				ZS_SIZE_CLASS_DELTA);
 
-	return min((int)ZS_SIZE_CLASSES - 1, idx);
+	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
 static inline void zs_stat_inc(struct size_class *class,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-zsmalloc-simplify-zs_max_alloc_size-handling.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch

