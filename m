From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 050/118] lib/test_kasan.c: fix memory leak in
 kmalloc_oob_krealloc_more()
Date: Thu, 30 Jan 2020 22:13:51 -0800
Message-ID: <20200131061351.6LNl0SkTH%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGNw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:13:52 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, gustavo@embeddedor.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org

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
