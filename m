From: akpm@linux-foundation.org
Subject: [patch 049/162] mm, kasan: fix to call kasan_free_pages() after
 poisoning page
Date: Fri, 20 May 2016 16:58:47 -0700
Message-ID: <573fa4b7.KHKg1EB/un4t/tAX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcETX6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:58:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamyooon@gmail.com, a.ryabinin@samsung.com, labbott@fedoraproject.org

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
