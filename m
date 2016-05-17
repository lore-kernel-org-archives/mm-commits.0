From: akpm@linux-foundation.org
Subject: +
 mm-kasan-fix-to-call-kasan_free_pages-after-poisoning-page.patch added to
 -mm tree
Date: Tue, 17 May 2016 16:24:54 -0700
Message-ID: <573ba846.oKF8U+CAJCI+KOmc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbcEQXYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2016 19:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamyooon@gmail.com, a.ryabinin@samsung.com, labbott@fedoraproject.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: fix to call kasan_free_pages() after poisoning page
has been added to the -mm tree.  Its filename is
     mm-kasan-fix-to-call-kasan_free_pages-after-poisoning-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-fix-to-call-kasan_free_pages-after-poisoning-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-fix-to-call-kasan_free_pages-after-poisoning-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "seokhoon.yoon" <iamyooon@gmail.com>
Subject: mm, kasan: fix to call kasan_free_pages() after poisoning page

When CONFIG_PAGE_POISONING and CONFIG_KASAN is enabled,
free_pages_prepare()'s codeflow is below.

1)kmemcheck_free_shadow()
2)kasan_free_pages()
- set shadow byte of page is freed
3)kernel_poison_pages()
3.1) check access to page is valid or not using kasan
---> error occur, kasan think it is invalid access
3.2) poison page
4)kernel_map_pages()

So kasan_free_pages() should be called after poisoning the page.

Link: http://lkml.kernel.org/r/1463220405-7455-1-git-send-email-iamyooon@gmail.com
Signed-off-by: seokhoon.yoon <iamyooon@gmail.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Laura Abbott <labbott@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-kasan-fix-to-call-kasan_free_pages-after-poisoning-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-kasan-fix-to-call-kasan_free_pages-after-poisoning-page
+++ a/mm/page_alloc.c
@@ -993,7 +993,6 @@ static __always_inline bool free_pages_p
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
-	kasan_free_pages(page, order);
 
 	/*
 	 * Check tail pages before head page information is cleared to
@@ -1035,6 +1034,7 @@ static __always_inline bool free_pages_p
 	arch_free_page(page, order);
 	kernel_poison_pages(page, 1 << order, 0);
 	kernel_map_pages(page, 1 << order, 0);
+	kasan_free_pages(page, order);
 
 	return true;
 }
_

Patches currently in -mm which might be from iamyooon@gmail.com are

mm-kasan-fix-to-call-kasan_free_pages-after-poisoning-page.patch

