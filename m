From: akpm@linux-foundation.org
Subject: + zsmalloc-use-u-suffix-for-negative-literals-being-shifted.patch added to -mm tree
Date: Thu, 11 Jan 2018 16:39:25 -0800
Message-ID: <5a5803bd.qH39MDCByJJnbnik%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51778 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753877AbeALAj1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jan 2018 19:39:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick.desaulniers@gmail.com, andy.shevchenko@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use U suffix for negative literals being shifted
has been added to the -mm tree.  Its filename is
     zsmalloc-use-u-suffix-for-negative-literals-being-shifted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-use-u-suffix-for-negative-literals-being-shifted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-use-u-suffix-for-negative-literals-being-shifted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zsmalloc-use-u-suffix-for-negative-literals-being-shifted.patch

