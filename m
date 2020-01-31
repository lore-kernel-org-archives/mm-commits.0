From: akpm@linux-foundation.org
Subject: [merged]
 lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:18:23 -0800
Message-ID: <20200131231823.oEAlTU_hV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXSY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, gustavo@embeddedor.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()
has been removed from the -mm tree.  Its filename was
     lib-test_kasanc-fix-memory-leak-in-kmalloc_oob_krealloc_more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
