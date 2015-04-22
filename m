From: akpm@linux-foundation.org
Subject: +
 kasan-remove-duplicate-definition-of-the-macro-kasan_free_page.patch added
 to -mm tree
Date: Wed, 22 Apr 2015 14:18:13 -0700
Message-ID: <55381015.vwNc9ESPjXakGUNx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbbDVVSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 17:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove duplicate definition of the macro KASAN_FREE_PAGE
has been added to the -mm tree.  Its filename is
     kasan-remove-duplicate-definition-of-the-macro-kasan_free_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-remove-duplicate-definition-of-the-macro-kasan_free_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-remove-duplicate-definition-of-the-macro-kasan_free_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Long <long.wanglong@huawei.com>
Subject: kasan: remove duplicate definition of the macro KASAN_FREE_PAGE

Remove duplicate definition of the macro KASAN_FREE_PAGE in
mm/kasan/kasan.h

Signed-off-by: Wang Long <long.wanglong@huawei.com>
Acked-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/kasan/kasan.h~kasan-remove-duplicate-definition-of-the-macro-kasan_free_page mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-remove-duplicate-definition-of-the-macro-kasan_free_page
+++ a/mm/kasan/kasan.h
@@ -7,7 +7,6 @@
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
 #define KASAN_FREE_PAGE         0xFF  /* page was freed */
-#define KASAN_FREE_PAGE         0xFF  /* page was freed */
 #define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
 #define KASAN_KMALLOC_REDZONE   0xFC  /* redzone inside slub object */
 #define KASAN_KMALLOC_FREE      0xFB  /* object was freed (kmem_cache_free/kfree) */
_

Patches currently in -mm which might be from long.wanglong@huawei.com are

origin.patch
kasan-remove-duplicate-definition-of-the-macro-kasan_free_page.patch

