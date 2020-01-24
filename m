From: akpm@linux-foundation.org
Subject: +
 lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch added to
 -mm tree
Date: Thu, 23 Jan 2020 17:13:06 -0800
Message-ID: <20200124011306.7Bu7OgvYd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729752AbgAXBNH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jan 2020 20:13:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, gustavo@embeddedor.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()
has been added to the -mm tree.  Its filename is
     lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

In case memory resources for _ptr2_ were allocated, release them before
return.

Notice that in case _ptr1_ happens to be NULL, krealloc() behaves exactly
like kmalloc().

Addresses-Coverity-ID: 1490594 ("Resource leak")
Link: http://lkml.kernel.org/r/20200123160115.GA4202@embeddedor
Fixes: 3f15801cdc23 ("lib: add kasan test module")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_kasan.c~lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more
+++ a/lib/test_kasan.c
@@ -158,6 +158,7 @@ static noinline void __init kmalloc_oob_
 	if (!ptr1 || !ptr2) {
 		pr_err("Allocation failed\n");
 		kfree(ptr1);
+		kfree(ptr2);
 		return;
 	}
 
_

Patches currently in -mm which might be from gustavo@embeddedor.com are

lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch
