From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-fix-wunneeded-internal-declaration-warning.patch
 added to -mm tree
Date: Wed, 31 May 2017 15:49:33 -0700
Message-ID: <592f487d.4S0QVX2lnFY3Pe6K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdEaWte (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 18:49:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick.desaulniers@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: fix -Wunneeded-internal-declaration warning
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-fix-wunneeded-internal-declaration-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-fix-wunneeded-internal-declaration-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-fix-wunneeded-internal-declaration-warning.patch

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

mm-vmscan-fix-unsequenced-modification-and-access-warning.patch
mm-zsmalloc-fix-wunneeded-internal-declaration-warning.patch

