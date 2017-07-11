From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-fix-wunneeded-internal-declaration-warning.patch removed from
 -mm tree
Date: Tue, 11 Jul 2017 12:22:54 -0700
Message-ID: <20170711192254.NXdJUkNGK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTWz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, nick.desaulniers@gmail.com, sergey.senozhatsky@gmail.com


The patch titled
     Subject: mm/zsmalloc.c: fix -Wunneeded-internal-declaration warning
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-fix-wunneeded-internal-declaration-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: mm/zsmalloc.c: fix -Wunneeded-internal-declaration warning

is_first_page() is only called from the macro VM_BUG_ON_PAGE() which is
only compiled in as a runtime check when CONFIG_DEBUG_VM is set, otherwise
is checked at compile time and not actually compiled in.

Fixes the following warning, found with Clang:

mm/zsmalloc.c:472:12: warning: function 'is_first_page' is not needed and
will not be emitted [-Wunneeded-internal-declaration]
static int is_first_page(struct page *page)
           ^

Link: http://lkml.kernel.org/r/20170524053859.29059-1-nick.desaulniers@gmail.com
Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-fix-wunneeded-internal-declaration-warning mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-fix-wunneeded-internal-declaration-warning
+++ a/mm/zsmalloc.c
@@ -469,7 +469,7 @@ static bool is_zspage_isolated(struct zs
 	return zspage->isolated;
 }
 
-static int is_first_page(struct page *page)
+static __maybe_unused int is_first_page(struct page *page)
 {
 	return PagePrivate(page);
 }
_

Patches currently in -mm which might be from nick.desaulniers@gmail.com are


