Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBC0C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E03A622CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781496;
	bh=S2sPp8yJAEJgj7Ne6dgb7GSFRIi6Wr18HI7/MjMEu18=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=m2HJsDW6xBUyv6KgAqO3OdF/Tk1iq01bY5A0ARTMixx/K6eHQYvltBxnxDuzSY4Vu
	 Gr5Pf4Wvf3XyZPKGfbZteOEF2g4/U2Qh8KW5QkIbGWu+4pNIC9p7xhuH2OFM8MZruj
	 cwgeoLT5OF9Vm7r8ngjPhPqJ9kZnE7WaDFzBxzEw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgHGGY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGY4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:24:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A7122CAE;
        Fri,  7 Aug 2020 06:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781495;
        bh=S2sPp8yJAEJgj7Ne6dgb7GSFRIi6Wr18HI7/MjMEu18=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XGTCHtjVyM7/RctviFooSY6RgFdv/IZC6f0iHj2rdY/Giu43E7ccrOonYOU8tjVqT
         he8JY8gvVp0t8xpfW6+/lGXmhaDSg9AJrOmVK5wWveouULmAdplKVzBdhNvIgcZWB2
         EdyBYWCPVEHMWC4MPTc+NvvrfBdZJJ7hd1LJCz7Q=
Date:   Thu, 06 Aug 2020 23:24:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        linux-mm@kvack.org, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        walter-zh.wu@mediatek.com
Subject:  [patch 135/163] lib/test_kasan.c: fix KASAN unit tests
 for tag-based KASAN
Message-ID: <20200807062454.Z0mbAzTVt%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: lib/test_kasan.c: fix KASAN unit tests for tag-based KASAN

We use tag-based KASAN, then KASAN unit tests don't detect out-of-bounds
memory access. They need to be fixed.

With tag-based KASAN, the state of each 16 aligned bytes of memory is
encoded in one shadow byte and the shadow value is tag of pointer, so
we need to read next shadow byte, the shadow value is not equal to tag
value of pointer, so that tag-based KASAN will detect out-of-bounds
memory access.

[walter-zh.wu@mediatek.com: use KASAN_SHADOW_SCALE_SIZE instead of 13]
  Link: http://lkml.kernel.org/r/20200708132524.11688-1-walter-zh.wu@mediatek.com
Link: http://lkml.kernel.org/r/20200706115039.16750-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   49 +++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

--- a/lib/test_kasan.c~kasan-fix-kasan-unit-tests-for-tag-based-kasan
+++ a/lib/test_kasan.c
@@ -23,6 +23,10 @@
 
 #include <asm/page.h>
 
+#include "../mm/kasan/kasan.h"
+
+#define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_SHADOW_SCALE_SIZE)
+
 /*
  * We assign some test results to these globals to make sure the tests
  * are not eliminated as dead code.
@@ -48,7 +52,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	ptr[size] = 'x';
+	ptr[size + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr);
 }
 
@@ -100,7 +105,8 @@ static noinline void __init kmalloc_page
 		return;
 	}
 
-	ptr[size] = 0;
+	ptr[size + OOB_TAG_OFF] = 0;
+
 	kfree(ptr);
 }
 
@@ -170,7 +176,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	ptr2[size2] = 'x';
+	ptr2[size2 + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr2);
 }
 
@@ -188,7 +195,9 @@ static noinline void __init kmalloc_oob_
 		kfree(ptr1);
 		return;
 	}
-	ptr2[size2] = 'x';
+
+	ptr2[size2 + OOB_TAG_OFF] = 'x';
+
 	kfree(ptr2);
 }
 
@@ -224,7 +233,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+7, 0, 2);
+	memset(ptr + 7 + OOB_TAG_OFF, 0, 2);
+
 	kfree(ptr);
 }
 
@@ -240,7 +250,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+5, 0, 4);
+	memset(ptr + 5 + OOB_TAG_OFF, 0, 4);
+
 	kfree(ptr);
 }
 
@@ -257,7 +268,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+1, 0, 8);
+	memset(ptr + 1 + OOB_TAG_OFF, 0, 8);
+
 	kfree(ptr);
 }
 
@@ -273,7 +285,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr+1, 0, 16);
+	memset(ptr + 1 + OOB_TAG_OFF, 0, 16);
+
 	kfree(ptr);
 }
 
@@ -289,7 +302,8 @@ static noinline void __init kmalloc_oob_
 		return;
 	}
 
-	memset(ptr, 0, size+5);
+	memset(ptr, 0, size + 5 + OOB_TAG_OFF);
+
 	kfree(ptr);
 }
 
@@ -423,7 +437,8 @@ static noinline void __init kmem_cache_o
 		return;
 	}
 
-	*p = p[size];
+	*p = p[size + OOB_TAG_OFF];
+
 	kmem_cache_free(cache, p);
 	kmem_cache_destroy(cache);
 }
@@ -520,25 +535,25 @@ static noinline void __init copy_user_te
 	}
 
 	pr_info("out-of-bounds in copy_from_user()\n");
-	unused = copy_from_user(kmem, usermem, size + 1);
+	unused = copy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in copy_to_user()\n");
-	unused = copy_to_user(usermem, kmem, size + 1);
+	unused = copy_to_user(usermem, kmem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in __copy_from_user()\n");
-	unused = __copy_from_user(kmem, usermem, size + 1);
+	unused = __copy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in __copy_to_user()\n");
-	unused = __copy_to_user(usermem, kmem, size + 1);
+	unused = __copy_to_user(usermem, kmem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in __copy_from_user_inatomic()\n");
-	unused = __copy_from_user_inatomic(kmem, usermem, size + 1);
+	unused = __copy_from_user_inatomic(kmem, usermem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in __copy_to_user_inatomic()\n");
-	unused = __copy_to_user_inatomic(usermem, kmem, size + 1);
+	unused = __copy_to_user_inatomic(usermem, kmem, size + 1 + OOB_TAG_OFF);
 
 	pr_info("out-of-bounds in strncpy_from_user()\n");
-	unused = strncpy_from_user(kmem, usermem, size + 1);
+	unused = strncpy_from_user(kmem, usermem, size + 1 + OOB_TAG_OFF);
 
 	vm_munmap((unsigned long)usermem, PAGE_SIZE);
 	kfree(kmem);
_
