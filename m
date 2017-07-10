From: akpm@linux-foundation.org
Subject: [patch 006/115] mm/zsmalloc.c: fix
 -Wunneeded-internal-declaration warning
Date: Mon, 10 Jul 2017 15:47:26 -0700
Message-ID: <20170710224726.-ECcItxa7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754420AbdGJWr1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org, nick.desaulniers@gmail.com, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

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
