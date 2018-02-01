From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-use-u-suffix-for-negative-literals-being-shifted.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:34:13 -0800
Message-ID: <20180201193413.zekbCoQsd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754648AbeBATeP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy.shevchenko@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org, nick.desaulniers@gmail.com, sergey.senozhatsky@gmail.com, willy@infradead.org


The patch titled
     Subject: zsmalloc: use U suffix for negative literals being shifted
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-u-suffix-for-negative-literals-being-shifted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: zsmalloc: use U suffix for negative literals being shifted

Fix warning about shifting unsigned literals being undefined behavior.

Link: http://lkml.kernel.org/r/1515642078-4259-1-git-send-email-nick.desaulniers@gmail.com
Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nick Desaulniers <nick.desaulniers@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-u-suffix-for-negative-literals-being-shifted mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-u-suffix-for-negative-literals-being-shifted
+++ a/mm/zsmalloc.c
@@ -1047,7 +1047,7 @@ static void init_zspage(struct size_clas
 			 * Reset OBJ_TAG_BITS bit to last link to tell
 			 * whether it's allocated object or not.
 			 */
-			link->next = -1 << OBJ_TAG_BITS;
+			link->next = -1UL << OBJ_TAG_BITS;
 		}
 		kunmap_atomic(vaddr);
 		page = next_page;
_

Patches currently in -mm which might be from nick.desaulniers@gmail.com are


